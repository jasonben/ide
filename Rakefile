# Local build tasks for the ide image. Run `rake -T` to list them.
#
# Settings come from the environment, then .env (optional, see .env.sample):
#   IDE_DOCKER_IMAGE  image to build and tag      (default: jasonben/ide)
#   IDE_CACHE_REF     registry cache CI pushes to (default: jasonben/ide:buildcache)
#                     set to "none" to build without it

def load_dotenv(path = ".env")
  return unless File.exist?(path)

  File.foreach(path) do |line|
    line = line.strip.sub(/\Aexport\s+/, "")
    next if line.empty? || line.start_with?("#")

    key, value = line.split("=", 2)
    next if value.nil?

    value = value.strip
    value = value[1..-2] if value.match?(/\A(["']).*\1\z/)
    value = value.sub(/\s+#.*\z/, "")
    ENV[key.strip] ||= value # the shell wins over .env
  end
end

load_dotenv

IMAGE = ENV.fetch("IDE_DOCKER_IMAGE", "").then { |v| v.empty? ? "jasonben/ide" : v }
CACHE_REF = ENV.fetch("IDE_CACHE_REF", "").then { |v| v.empty? ? "jasonben/ide:buildcache" : v }
LEGACY_BUILDER = "localbuilder"

# "jasonben/ide" -> "jasonben/ide:arm64", "jasonben/ide:dev" -> "jasonben/ide:dev-arm64"
def tag_with_suffix(image, suffix)
  name, tag = image.match(%r{\A(.+?)(?::([^:/]+))?\z}).captures
  "#{name}:#{tag ? "#{tag}-#{suffix}" : suffix}"
end

ARM64_IMAGE = tag_with_suffix(IMAGE, "arm64")

# The default builder writes straight into the daemon's (containerd) image
# store, so there is no export/--load copy of the multi-GB image.
def buildx(*args, tag:, pull: false, platform: nil)
  cmd = %w[docker buildx build --builder default]
  cmd += ["--platform", platform] if platform
  cmd << "--pull" if pull
  cmd += ["--cache-from", "type=registry,ref=#{CACHE_REF}"] unless CACHE_REF == "none"
  cmd += ["-t", tag, *args, "."]
  sh(*cmd)
end

def default_builder_platforms
  `docker buildx inspect default 2>/dev/null`[/^Platforms:\s*(.*)$/, 1].to_s
end

desc "Build #{IMAGE} for this machine, reusing cached base images and CI's layer cache"
task :build do
  buildx(tag: IMAGE)
end

namespace :build do
  desc "Like build, but pull fresh alpine and jasonben/{go,rust}-apps first"
  task :fresh do
    buildx(tag: IMAGE, pull: true)
  end

  desc "Build #{ARM64_IMAGE} under QEMU, as CI does for arm64 (slow)"
  task :arm64 do
    unless default_builder_platforms.include?("linux/arm64")
      abort <<~MSG
        The default builder can't run arm64 yet. Install QEMU binfmt handlers on
        the Docker host (a host-level change, so it's not done automatically):

          docker run --privileged --rm tonistiigi/binfmt --install arm64
      MSG
    end
    buildx(tag: ARM64_IMAGE, platform: "linux/arm64")
  end
end

SMOKE_CHECKS = {
  "nvim" => "nvim --version",
  "tmux" => "tmux -V",
  "git" => "git --version",
  "lazygit" => "lazygit --version",
  "fzf" => "fzf --version",
  "fzf-tmux" => "command -v fzf-tmux",
  "rg" => "rg --version",
  "duckdb" => "duckdb --version",
  "mise" => "mise --version",
  "ruby" => "ruby --version",
  "node" => "node --version",
  "python" => "python --version",
  "pynvim" => "python -c 'import greenlet, pynvim; print(\"greenlet\", greenlet.__version__)'",
  "go" => "go version",
}.freeze

desc "Start #{IMAGE} and check that the core tools run"
task :smoke do
  script = +"fail=0\n"
  SMOKE_CHECKS.each do |name, check|
    script << %(printf '%-9s ' #{name}; if out=$(#{check} 2>&1); ) +
              %(then echo "$out" | head -1; else echo "FAILED: $out" | head -1; fail=1; fi\n)
  end
  script << "exit $fail\n"
  # -i: an interactive zsh loads .zshrc (mise activate, PATH) like a real session
  puts "Smoke testing #{IMAGE}"
  system("docker", "run", "--rm", IMAGE, "zsh", "-ic", script) or
    abort "Smoke test failed for #{IMAGE}"
end

SHELL_SCRIPTS = FileList["dotfiles/host/bin/ide", "dotfiles/host/bin/*.sh", "scripts/*"]
HADOLINT_IMAGE = "hadolint/hadolint:v2.12.0-alpine"

desc "Run hadolint and shellcheck, as CI does"
task :lint do
  # Stream the files in rather than bind-mounting, so this also works when
  # DOCKER_HOST points at a remote daemon (as it does inside the ide).
  sh "tar -c Dockerfile .hadolint.yaml | " \
     "docker run --rm -i --entrypoint sh #{HADOLINT_IMAGE} " \
     "-c 'mkdir /w && cd /w && tar -x && hadolint Dockerfile'"
  sh "shellcheck", *SHELL_SCRIPTS
end

desc "Remove the old '#{LEGACY_BUILDER}' buildx builder and its build cache"
task :clean do
  if system("docker", "buildx", "inspect", LEGACY_BUILDER, out: File::NULL, err: File::NULL)
    sh "docker", "buildx", "rm", LEGACY_BUILDER
  else
    puts "No '#{LEGACY_BUILDER}' builder, nothing to remove."
  end
end

task default: :build
