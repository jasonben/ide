```console
#MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMjasonben/                     dddddddd
#MMNOxddddddddddddddddddddddddddddxONMMM    iiii              d::::::d
#Wk;;cllllllllllllllllllllllllllllc;;kWM   i::::i             d::::::d
#K,,0MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0,,KM    iiii              d::::::d
#O':NMMMWNWMMMMMMMMMMMMMMMMMMMMMMMMN:'OM                      d:::::d
#O':XMMMKc:kWMMMMMMMMMMMMMMMMMMMMMMX:'OM  iiiiiii     ddddddddd:::::d     eeeeeeeeeeee
#O':XMMMWKl,:kNMMMMMMMMMMMMMMMMMMMMX:'OM  i:::::i   dd::::::::::::::d   ee::::::::::::ee
#O':XMMMMMW0l,:ONMMMMMMMMMMMMMMMMMMX:'OM   i::::i  d::::::::::::::::d  e::::::eeeee:::::ee
#O':XMMMMMMMW0;.lNMMMMMMMMMMMMMMMMMX:'OM   i::::i d:::::::ddddd:::::d e::::::e     e:::::e
#O':XMMMMMMW0l,:OWMMMMMMMMMMMMMMMMMX:'OM   i::::i d::::::d    d:::::d e:::::::eeeee::::::e
#O':NMMMMWKl,:ONMMMMMMMMMMMMMMMMMMMN:'OM   i::::i d:::::d     d:::::d e:::::::::::::::::e
#O':XMMMXo,:ONMMMMXkddddddddddkXMMMX:'OM   i::::i d:::::d     d:::::d e::::::eeeeeeeeeee
#O':XMMMKxONMMMMMMKdlllllllllldKMMMX:'OM   i::::i d:::::d     d:::::d e:::::::e
#0':XMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMX:'0M  i::::::id::::::ddddd::::::dde::::::::e
#Xc.o0KKKKKKKKKKKKKKKKKKKKKKKKKKKK0o.cXM  i::::::i d:::::::::::::::::d e::::::::eeeeeeee
#MXxc:cccccccccccccccccccccccccccc:cxXMM  i::::::i  d:::::::::ddd::::d  ee:::::::::::::e
#MMMWWNNNNNNNNNNNNNNNNNNNNNNNNNNNNWWMMMM  iiiiiiii   ddddddddd   ddddd    eeeeeeeeeeeeee
```

# Install

```console
curl https://jasonben.com/ide -fsSL | sh
```

# Run

```console
ide
```

# Who it's for

A terminal-first environment (Neovim, tmux, zsh) for developers who work
across backend, infrastructure and data, often in several languages. The same
image runs on Linux and macOS, amd64 and arm64, so every machine feels the same.

- **Backend and web** — Rails, Node/TypeScript, Python, Go, Spring Boot,
  Kotlin, .NET, Elixir/Phoenix; native libraries for common gems and packages
  (Postgres, MySQL, SQLite, libvips) are already installed.
- **DevOps and platform** — Docker, Terraform, AWS, Google Cloud,
  DigitalOcean and Hetzner CLIs, Tailscale, GitHub CLI, shellcheck/shfmt.
- **Data** — DuckDB, usql (40+ databases), psql, R, Python, miller, pandoc.
- **Systems and polyglot** — Rust, Zig, C/C++, OCaml, Clojure, for tools,
  learning and cross-ecosystem work.
- **Remote and multi-machine** — one image with the editor, shell and tools
  configured, for SSH sessions and new machines.

Less suited to GUI-IDE users, mobile (no Android SDK or Xcode), GPU/ML,
game, Windows desktop or embedded work, which need GPUs, vendor SDKs or
platform toolchains this container doesn't provide.

# Languages

- Assembly (nasm)
- C / C++ (gcc, clang)
- C# / F# (.NET)
- Clojure
- Elixir / Erlang
- Go
- Groovy
- Java (Maven, Gradle)
- JavaScript / TypeScript (Node)
- Kotlin
- Lua / LuaJIT
- OCaml (opam)
- Perl
- Python
- R
- Ruby
- Rust
- Scala
- Shell (bash, zsh)
- SQL (psql, usql, DuckDB)
- Zig

# Databases (via usql)

- Aliyun MaxCompute
- Aliyun Tablestore
- Amazon Athena
- Amazon DynamoDB
- Amazon Redshift
- Apache Avatica / Phoenix
- Apache Cassandra / ScyllaDB (CQL)
- Apache Hive
- Apache Ignite / GridGain
- Apache Impala
- Arrow Flight SQL
- Azure Cosmos DB
- ChaiSQL (Genji)
- ClickHouse
- CockroachDB
- Couchbase (N1QL)
- CSV / TSV / JSON files (csvq)
- Databend
- Databricks
- Exasol
- Firebird
- Google BigQuery
- Google Cloud Spanner
- H2
- IBM Netezza
- MySQL / MariaDB / Aurora / Percona
- ODBC (any ODBC data source)
- Oracle
- PostgreSQL
- Presto
- ql
- RamSQL
- SAP ASE (Sybase)
- SAP HANA
- SingleStore (MemSQL)
- Snowflake
- SQL Server / Azure SQL
- SQLite
- TiDB
- Trino
- Vertica
- Vitess
- VoltDB
- YDB

# Preferred font - JetBrainsMono Nerd Font Mono

[Download](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip)

# Prerequisites

## Install curl and docker

### Linux
```sh
curl -sSL https://get.docker.com | sh
```

#### Fedora
```sh
sudo dnf -y install curl dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y docker-ce
sudo systemctl enable docker
sudo systemctl start docker
```
### macOS
```sh
brew install --cask docker-desktop
```

# Build locally

```sh
rake build        # build jasonben/ide, reusing CI's layer cache
rake smoke        # check the core tools run inside the image
rake lint         # hadolint + shellcheck, as CI runs them
rake -T           # all tasks (build:fresh, build:arm64, clean)
scripts/bump-refs --dry-run   # list pinned dependencies with newer versions
```

Settings can go in an optional `.env`; see [.env.sample](./.env.sample).

# Releases

Every push to `main` publishes `jasonben/ide:latest`. When the commits since
the last `v*` tag include a `feat`, `fix`, `perf`, `refactor`, `build`,
`revert` or breaking change ([Conventional Commits](https://www.conventionalcommits.org)),
CI also tags the image with the next semver (`jasonben/ide:1.2.3`) and
publishes a GitHub release with notes built from those commits.
`sh release.sh version` shows the version `HEAD` would release as.

# Documentation

[docs](./docs)

# Troubleshooting macOS problems

```sh
# on macOS install tmux-256 color term info file so things work as expected
"$(brew --prefix ncurses)/bin/infocmp" -x tmux-256color > tmux-256color.src
sudo /usr/bin/tic -x tmux-256color.src

# install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$(whoami)/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```
