# HerRei/homebrew-tap

Homebrew cask for [LocalSR](https://herrei.github.io/localsr/), which upscales,
denoises and restores photos and video on your own Mac.

```bash
brew install --cask herrei/tap/localsr
```

The cask installs the signed and notarized DMG from the
[LocalSR releases](https://github.com/HerRei/local-upscale/releases). It needs a
Mac with Apple silicon and macOS 14 or later; on an Intel Mac, Homebrew stops
before downloading anything.

Homebrew 7 only loads casks from third-party taps that you trust, and installing
by the full name as above trusts this one. The short name
(`brew install --cask localsr`) works after `brew tap herrei/tap` and
`brew trust herrei/tap`.

## Updates

LocalSR updates itself: at launch it checks the same feed that this cask follows
and offers the new version. Homebrew knows that (`auto_updates true`), so after an
in-app update `brew upgrade` leaves LocalSR alone. If the app is older than the
cask, for example because you declined the update, a plain `brew upgrade`
installs the cask's version.

`brew upgrade --greedy` always reinstalls the cask's version, even over an app
that is already as new. That costs one download and changes nothing else.

## Uninstall

```bash
brew uninstall --cask localsr
```

This removes the app and keeps your settings, models and queue. To remove those
too, including the optional Finder action and the `localsr-next` command:

```bash
brew uninstall --cask --zap localsr
```

`--zap` moves `~/Library/Application Support/LocalSR` to the Trash, together with
any models you added there. Pictures and videos you enhanced stay where LocalSR
saved them.

## How the cask stays current

`.github/workflows/bump.yml` reads the update feed
(`https://herrei.github.io/localsr/updates/beta.json`) every six hours. When the
feed names a new version, the workflow takes the DMG checksum from the GitHub
release, refuses it unless the release's `.sha256` file says the same, installs
the cask on a clean macOS runner, checks the code signature and notarization,
and commits. The LocalSR release script also starts this workflow right after
each release, so the cask usually follows within minutes.

`check.yml` runs the same install test on every push and pull request.
`audit_exceptions/github_prerelease_allowlist.json` lets `brew audit` accept
LocalSR's pre-releases.
