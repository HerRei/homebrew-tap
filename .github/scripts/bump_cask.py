#!/usr/bin/env python3
"""Point Casks/localsr.rb at the release that LocalSR's update feed announces.

The feed is the same file the installed app reads, so the cask follows exactly
what in-app updates offer (including a rollback to an older build). The DMG
checksum must agree between two sources before the cask changes: GitHub's own
asset digest and the .sha256 file published with the release.

Exit codes: 0 = cask unchanged or updated, 1 = something did not match.
Writes changed=true|false and version=<v> to $GITHUB_OUTPUT when set.
"""

from __future__ import annotations

import json
import os
import re
import sys
import urllib.error
import urllib.request
from pathlib import Path

FEED_URL = "https://herrei.github.io/localsr/updates/beta.json"
RELEASES_API = "https://api.github.com/repos/HerRei/local-upscale/releases/tags/v{version}"
DMG_NAME = "LocalSR-v{version}-macOS-arm64.dmg"
CASK = Path(__file__).resolve().parents[2] / "Casks" / "localsr.rb"

VERSION_RE = re.compile(r"\d+\.\d+\.\d+(?:-[0-9A-Za-z.]+)?")
SHA256_RE = re.compile(r"[0-9a-f]{64}")
CASK_VERSION_RE = re.compile(r'^(  version ")([^"]+)(")$', re.MULTILINE)
CASK_SHA256_RE = re.compile(r'^(  sha256 ")([0-9a-f]{64})(")$', re.MULTILINE)


class BumpError(Exception):
    pass


def fetch(url: str, *, api: bool = False) -> bytes:
    headers = {"User-Agent": "HerRei-homebrew-tap-bump"}
    if api:
        headers["Accept"] = "application/vnd.github+json"
        token = os.environ.get("GH_TOKEN") or os.environ.get("GITHUB_TOKEN")
        if token:
            headers["Authorization"] = f"Bearer {token}"
    request = urllib.request.Request(url, headers=headers)
    with urllib.request.urlopen(request, timeout=60) as response:
        return response.read()


def feed_version() -> str:
    version = json.loads(fetch(FEED_URL)).get("version")
    if not isinstance(version, str) or not VERSION_RE.fullmatch(version):
        raise BumpError(f"feed version {version!r} is not a version string")
    return version


def release_sha256(version: str) -> str:
    try:
        release = json.loads(fetch(RELEASES_API.format(version=version), api=True))
    except urllib.error.HTTPError as error:
        raise BumpError(f"no GitHub release v{version} ({error.code})") from error
    if release.get("draft"):
        raise BumpError(f"release v{version} is still a draft")

    assets = {asset["name"]: asset for asset in release.get("assets", [])}
    dmg = DMG_NAME.format(version=version)
    if dmg not in assets:
        raise BumpError(f"release v{version} has no {dmg}")
    if dmg + ".sha256" not in assets:
        raise BumpError(f"release v{version} has no {dmg}.sha256")

    digest = assets[dmg].get("digest") or ""
    if not digest.startswith("sha256:") or not SHA256_RE.fullmatch(digest[7:]):
        raise BumpError(f"GitHub reports no sha256 digest for {dmg}: {digest!r}")
    github_sum = digest[7:]

    sums_file = fetch(assets[dmg + ".sha256"]["browser_download_url"]).decode()
    fields = sums_file.split()
    if len(fields) != 2 or fields[1] != dmg or not SHA256_RE.fullmatch(fields[0]):
        raise BumpError(f"{dmg}.sha256 does not read '<sha256>  {dmg}': {sums_file!r}")
    if fields[0] != github_sum:
        raise BumpError(f"{dmg}: .sha256 file says {fields[0]}, GitHub says {github_sum}")
    return github_sum


def replace_one(pattern: re.Pattern[str], text: str, value: str, what: str) -> str:
    new_text, count = pattern.subn(lambda m: m.group(1) + value + m.group(3), text)
    if count != 1:
        raise BumpError(f"expected one {what} line in {CASK.name}, found {count}")
    return new_text


def write_output(**values: str) -> None:
    path = os.environ.get("GITHUB_OUTPUT")
    if path:
        with open(path, "a", encoding="utf-8") as output:
            for key, value in values.items():
                output.write(f"{key}={value}\n")


def main() -> int:
    text = CASK.read_text(encoding="utf-8")
    current = CASK_VERSION_RE.search(text)
    if current is None:
        raise BumpError(f"no version line in {CASK.name}")
    current_version = current.group(2)

    version = feed_version()
    if version == current_version:
        print(f"Cask already at {version}, the version the feed announces.")
        write_output(changed="false", version=version)
        return 0

    sha256 = release_sha256(version)
    text = replace_one(CASK_VERSION_RE, text, version, "version")
    text = replace_one(CASK_SHA256_RE, text, sha256, "sha256")
    CASK.write_text(text, encoding="utf-8")
    print(f"Cask {current_version} -> {version} (sha256 {sha256})")
    write_output(changed="true", version=version)
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (BumpError, OSError, ValueError) as error:
        print(f"error: {error}", file=sys.stderr)
        sys.exit(1)
