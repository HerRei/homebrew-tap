class Localsr < Formula
  desc "Local image and video super-resolution using PyTorch and Spandrel"
  homepage "https://github.com/HerRei/local-upscale"
  version "0.0.5-alpha"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/HerRei/local-upscale/releases/download/v#{version}/LocalSR-macOS-arm64-v0.0.5.tar.gz"
      sha256 "2ae033062df99089ab4f025f59569865b51aff7f6913ef585c5bbacb5634dd35"
    end
    on_intel do
      url "https://github.com/HerRei/local-upscale/releases/download/v#{version}/LocalSR-macOS-arm64-v0.0.5.tar.gz"
      sha256 "2ae033062df99089ab4f025f59569865b51aff7f6913ef585c5bbacb5634dd35"
    end
  end

  def install
    prefix.install "LocalSR.app"

    (bin/"localsr").write <<~EOS
      #!/bin/bash
      open -a "#{prefix}/LocalSR.app" --args "$@"
    EOS
    chmod 0755, bin/"localsr"
  end

  def caveats
    <<~EOS
      LocalSR.app has been installed.

      To launch the GUI:
        localsr
      or:
        open "#{prefix}/LocalSR.app"
    EOS
  end

  test do
    assert_predicate prefix/"LocalSR.app", :exist?
  end
end
