#!/bin/sh
# release.sh -- the ide image's version and release notes, from the git
# history.
#
#   sh release.sh version   the version HEAD is: the last release, bumped when
#                           there is something to release
#   sh release.sh bump      what HEAD bumps: none, patch, minor, major
#   sh release.sh last      the last released version (0.0.0: none)
#   sh release.sh notes     the release notes for HEAD, in markdown
#
# Releases are the git tags vMAJOR.MINOR.PATCH. The commits since the last one
# are read as conventional commits (conventionalcommits.org):
#
#   type!: ... or a BREAKING CHANGE: footer   major (minor while MAJOR is 0)
#   feat                                      minor
#   fix, perf, refactor, build, revert        patch
#   anything else (docs, test, ci, chore, style, non-conventional)  none
#
# With no release tag yet, HEAD is the first release: 1.0.0 (bump: major),
# its notes the whole history's conventional commits.
#
# CI runs it on every push (.github/workflows/ide.yml): on main, a `bump`
# other than none pushes the image as $IMAGE:<version> and publishes the
# GitHub release v<version> with `notes`. Needs the tags: a full clone
# (actions/checkout with fetch-depth: 0).
#
# Uses git, sed and awk only. Run from anywhere in the repo.
set -eu

PREFIX=v
die() { printf 'release.sh: %s\n' "$*" >&2; exit 1; }

cd "$(git rev-parse --show-toplevel)" || die "not in a git repository"

# The last release tag, or nothing. Tags that aren't versions are ignored.
last_tag() {
  git tag -l "$PREFIX*" | awk -v p="$PREFIX" '
    {
      v = substr($0, length(p) + 1)
      if (v !~ /^[0-9]+\.[0-9]+\.[0-9]+$/) next
      split(v, a, ".")
      key = sprintf("%09d%09d%09d", a[1], a[2], a[3])
      if (key > best) { best = key; tag = $0 }
    }
    END { if (tag != "") print tag }'
}

last_version() {
  t=$(last_tag)
  [ -n "$t" ] || { echo 0.0.0; return; }
  echo "${t#"$PREFIX"}"
}

# One record per commit since the last release:
# hash US subject US body RS (US = \037, RS = \036).
commits() {
  t=$(last_tag)
  range=HEAD
  [ -z "$t" ] || range="$t..HEAD"
  git log --no-merges --format='%h%x1f%s%x1f%b%x1e' "$range"
}

# The commits as lines: KIND US hash US scope US description, KIND one of
# breaking feat fix perf refactor build revert docs other.
classify() {
  commits | awk 'BEGIN { RS = "\036"; FS = "\037" }
    {
      sub(/^\n+/, "")
      if ($1 == "") next
      hash = $1; subj = $2; body = $3
      type = ""; scope = ""; bang = 0; desc = subj
      if (match(subj, /^[A-Za-z]+(\([^)]*\))?!?: /)) {
        head = substr(subj, 1, RLENGTH - 2)
        desc = substr(subj, RLENGTH + 1)
        if (head ~ /!$/) { bang = 1; head = substr(head, 1, length(head) - 1) }
        if (match(head, /\(.*\)$/)) {
          scope = substr(head, RSTART + 1, RLENGTH - 2)
          head = substr(head, 1, RSTART - 1)
        }
        type = tolower(head)
      }
      kind = type
      if (kind !~ /^(feat|fix|perf|refactor|build|revert|docs)$/) kind = "other"
      if (bang || body ~ /(^|\n)BREAKING[ -]CHANGE: /) kind = "breaking"
      printf "%s\037%s\037%s\037%s\n", kind, hash, scope, desc
    }'
}

bump() {
  [ -n "$(last_tag)" ] || { echo major; return; }
  classify | awk -F '\037' '
    $1 == "breaking" { b = 3 }
    $1 == "feat" && b < 2 { b = 2 }
    $1 ~ /^(fix|perf|refactor|build|revert)$/ && b < 1 { b = 1 }
    END { split("none patch minor major", n, " "); print n[b + 1] }'
}

version() {
  [ -n "$(last_tag)" ] || { echo 1.0.0; return; }
  v=$(last_version)
  major=${v%%.*}; rest=${v#*.}; minor=${rest%%.*}; patch=${rest#*.}
  b=$(bump)
  [ "$b" = major ] && [ "$major" -eq 0 ] && b=minor
  case $b in
    major) echo "$((major + 1)).0.0" ;;
    minor) echo "$major.$((minor + 1)).0" ;;
    patch) echo "$major.$minor.$((patch + 1))" ;;
    *) echo "$v" ;;
  esac
}

# Markdown: a section per kind that has commits. docs is included, other
# (ci, chore, test, style, ...) isn't. Links the commits and the comparison
# when GITHUB_SERVER_URL and GITHUB_REPOSITORY are set (they are in CI).
notes() {
  t=$(last_tag)
  url=
  [ -z "${GITHUB_REPOSITORY:-}" ] || url=${GITHUB_SERVER_URL:-https://github.com}/$GITHUB_REPOSITORY
  classify | awk -F '\037' -v url="$url" -v from="$t" -v to="$PREFIX$(version)" '
    {
      line = "- " ($3 != "" ? "**" $3 ":** " : "") $4
      line = line " (" (url != "" ? "[" $2 "](" url "/commit/" $2 ")" : $2) ")"
      items[$1] = items[$1] line "\n"
    }
    END {
      split("breaking feat fix perf refactor build revert docs", order, " ")
      title["breaking"] = "Breaking changes"; title["feat"] = "Features"
      title["fix"] = "Fixes"; title["perf"] = "Performance"
      title["refactor"] = "Refactoring"; title["build"] = "Build"
      title["revert"] = "Reverts"; title["docs"] = "Documentation"
      if (from == "") { print "First release."; sep = "\n" }
      for (i = 1; i <= 8; i++) {
        k = order[i]
        if (k in items) { printf "%s### %s\n\n%s", sep, title[k], items[k]; sep = "\n" }
      }
      if (sep == "") print "No changes."
      if (from != "" && url != "")
        printf "\n**Full changelog:** [%s...%s](%s/compare/%s...%s)\n", from, to, url, from, to
    }'
}

case ${1:-} in
  version) version ;;
  bump) bump ;;
  last) last_version ;;
  notes) notes ;;
  *) die "usage: release.sh version|bump|last|notes" ;;
esac
