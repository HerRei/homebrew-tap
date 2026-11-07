#!/bin/bash
# Lint the cask, install it the way a user would, check what lands in
# /Applications, then uninstall. Runs on a clean GitHub macOS runner only:
# on a real Mac it would replace an installed LocalSR.
set -euo pipefail

if [[ "${GITHUB_ACTIONS:-}" != "true" || "${RUNNER_ENVIRONMENT:-}" != "github-hosted" ]]; then
  echo "test_cask.sh installs into /Applications; run it on a GitHub-hosted runner only." >&2
  exit 2
fi
if [[ -e /Applications/LocalSR.app ]] || brew list --cask localsr >/dev/null 2>&1; then
  echo "LocalSR is already installed here; this test only runs on a clean machine." >&2
  exit 2
fi

repo="$(cd "$(dirname "$0")/../.." && pwd)"
taps="$(brew --repository)/Library/Taps"
mkdir -p "$taps/herrei"
ln -sfn "$repo" "$taps/herrei/homebrew-tap"

brew trust --cask herrei/tap/localsr
brew style herrei/tap
brew audit --cask --strict --online herrei/tap/localsr

brew install --cask herrei/tap/localsr

app=/Applications/LocalSR.app
cask_version="$(sed -n 's/^  version "\(.*\)"$/\1/p' "$repo/Casks/localsr.rb")"
app_version="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$app/Contents/Info.plist")"
echo "cask $cask_version, app $app_version"
# The bundle carries 0.3.0 for the cask's 0.3.0-beta.
if [[ "$cask_version" != "$app_version" && "$cask_version" != "$app_version"-* ]]; then
  echo "The DMG holds LocalSR $app_version, not $cask_version." >&2
  exit 1
fi

codesign --verify --deep --strict "$app"
xcrun stapler validate "$app"
gatekeeper="$(spctl --status)"
if [[ "$gatekeeper" == *"assessments enabled"* ]]; then
  assessment="$(spctl --assess --type execute -vv "$app" 2>&1)"
  echo "$assessment"
  grep -q "source=Notarized Developer ID" <<<"$assessment"
fi

# Starts the installed host, which hands a protocol handshake to the bundled engine.
smoke="$("$app/Contents/MacOS/localsr-next" --headless-smoke-test)"
echo "$smoke"
python3 -c 'import json, sys; sys.exit(0 if json.loads(sys.argv[1]).get("passed") is True else 1)' "$smoke"

brew uninstall --cask herrei/tap/localsr
test ! -e "$app"
