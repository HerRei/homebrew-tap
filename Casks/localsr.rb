cask "localsr" do
  version "0.3.0-beta"
  sha256 "67a587e7941d52cc5503729b085604c8fa2ae4c87e99fd5e2074e47852059957"

  url "https://github.com/HerRei/local-upscale/releases/download/v#{version}/LocalSR-v#{version}-macOS-arm64.dmg"
  name "LocalSR"
  desc "Upscale, denoise and restore photos and video on your own computer"
  homepage "https://herrei.github.io/localsr/"

  # The app's own update feed: every LocalSR release is a GitHub pre-release,
  # which the GitHub strategies skip.
  livecheck do
    url "https://herrei.github.io/localsr/updates/beta.json"
    strategy :json do |json|
      json["version"]
    end
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "LocalSR.app"

  zap trash: [
    "~/.local/bin/localsr-next",
    "~/Library/Application Support/LocalSR",
    "~/Library/Caches/com.localsr.desktop.next",
    "~/Library/Caches/LocalSR",
    "~/Library/Caches/localsr-next",
    "~/Library/Caches/localsr-worker",
    "~/Library/Preferences/com.localsr.desktop.next.plist",
    "~/Library/Preferences/com.localsr.desktop.plist",
    "~/Library/Preferences/com.localsr.LocalSR.plist",
    "~/Library/Saved Application State/com.localsr.desktop.next.savedState",
    "~/Library/Services/Enhance with LocalSR Next Preview.workflow",
    "~/Library/Services/Enhance with LocalSR.workflow",
    "~/Library/WebKit/com.localsr.desktop.next",
    "~/Library/WebKit/localsr-next",
  ]
end
