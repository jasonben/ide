#!/bin/sh
# test/smoke.sh IMAGE -- the core tools in the ide image start. Run by CI
# (.github/workflows/ide.yml) on each architecture before anything is pushed,
# and locally by `rake smoke`.
#
# The checks run in an interactive zsh, which loads .zshrc (mise activate,
# PATH) like a real session.
set -eu

image=${1:?usage: test/smoke.sh IMAGE}

script=$(cat <<'EOF'
fail=0
check() {
  printf '%-9s ' "$1"
  if out=$(eval "$2" 2>&1); then
    echo "$out" | head -1
  else
    echo "FAILED: $out" | head -1
    fail=1
  fi
}
check nvim     'nvim --version'
check tmux     'tmux -V'
check git      'git --version'
check lazygit  'lazygit --version'
check fzf      'fzf --version'
check fzf-tmux 'command -v fzf-tmux'
check rg       'rg --version'
check duckdb   'duckdb --version'
check duckdb1  'duckdb1 --version'
# 2.x needs x86-64-v3; on older x86 CPUs only duckdb1 can run
check duckdb2  'if [ "$(uname -m)" != x86_64 ] || grep -qw avx2 /proc/cpuinfo; then duckdb2 --version; else echo "skipped: CPU lacks AVX2"; fi'
check mise     'mise --version'
check ruby     'ruby --version'
check node     'node --version'
check python   'python --version'
check pynvim   'python -c "import greenlet, pynvim; print(\"greenlet\", greenlet.__version__)"'
check go       'go version'
exit $fail
EOF
)

echo "Smoke testing $image"
docker run --rm "$image" zsh -ic "$script" || {
  echo "Smoke test failed for $image" >&2
  exit 1
}
