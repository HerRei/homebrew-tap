cask "localsr" do
  version "0.4.0-beta"
  sha256 "8e584f4fbb556dd7c57a861a86e43cd9c9151842b2b62eb49d06b89d2eb5fc18"

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
