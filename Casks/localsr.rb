cask "localsr" do
  version "0.0.5-alpha"
  sha256 "2ae033062df99089ab4f025f59569865b51aff7f6913ef585c5bbacb5634dd35"

  url "https://github.com/HerRei/local-upscale/releases/download/v#{version}/LocalSR-macOS-arm64-v0.0.5.tar.gz"
  name "LocalSR"
  desc "Local image and video super-resolution desktop app"
  homepage "https://github.com/HerRei/local-upscale"

  app "LocalSR.app"
  binary "#{appdir}/LocalSR.app/Contents/MacOS/LocalSR", target: "localsr"

  zap trash: [
    "~/Library/Application Support/LocalSR",
    "~/Library/Caches/LocalSR",
    "~/Library/Preferences/com.localsr.desktop.plist",
  ]
end
