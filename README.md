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
and offers the new version. Homebrew knows that (`auto_updates true`) and compares
the version inside the installed app with the cask's. A plain `brew upgrade`
installs the cask's version only when the app's number is lower, for example
0.3.0 against 0.4.0-beta, so it never undoes an in-app update. The app carries
only the number, without "-beta", so a step such as 0.3.0-beta to 0.3.0-beta.1
comes through the in-app update alone.

`brew upgrade --greedy` skips that comparison: whenever the cask differs from the
version Homebrew installed, it installs the cask's version, even over an app that
has already updated itself.

## Uninstall

```bash
brew uninstall --cask localsr
```

This removes the app and keeps your settings, models and queue. To remove those
too, including the optional Finder action:

```bash
brew uninstall --cask --zap localsr
```

`--zap` moves `~/Library/Application Support/LocalSR` to the Trash, together with
any models you added there. Enhanced pictures and videos go to the Desktop unless
you chose another folder, and stay there; only a folder you picked inside
`~/Library/Application Support/LocalSR` would go to the Trash with it. If you
installed the optional `localsr-next` command, delete the link
`~/.local/bin/localsr-next` yourself.

## How the cask stays current

`.github/workflows/bump.yml` reads the update feed
(`https://herrei.github.io/localsr/updates/beta.json`) every six hours. When the
feed names a new version, the workflow takes the DMG checksum from the GitHub
release, refuses it unless the release's `.sha256` file says the same, installs
the cask on a clean macOS runner, checks the code signature and notarization,
starts the installed app's headless self-test, and commits. The LocalSR release
script also starts this workflow right after each release, so the cask usually
follows within minutes.

`check.yml` runs the same install test on every push and pull request.
`audit_exceptions/github_prerelease_allowlist.json` lets `brew audit` accept
LocalSR's pre-releases.
