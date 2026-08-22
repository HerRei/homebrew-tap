class Localsr < Formula
  desc "Local image super-resolution using PyTorch/Spandrel with Slint UI"
  homepage "https://github.com/HerRei/local-upscale"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/HerRei/local-upscale/releases/download/#{version}/LocalSR-macos-arm64.tar.gz"
      sha256 "TODO: Add checksum after first release"
    end
    on_intel do
      url "https://github.com/HerRei/local-upscale/releases/download/#{version}/LocalSR-macos-x86_64.tar.gz"
      sha256 "TODO: Add checksum after first release"
    end
  end

  def install
    prefix.install Dir["*"]

    app_bundle = prefix.glob("*.app").first
    raise "No .app bundle found" if app_bundle.nil?

    (bin/"localsr").write <<~EOS
      #!/bin/bash
      open -a "#{app_bundle}" --args "$@"
    EOS
    chmod 0555, bin/"localsr"
  end

  caveats do
    <<~TEXT
      LocalSR has been installed.

      To run the GUI application:
        open -a LocalSR

      Or use:
        localsr image.png

      For CLI mode:
        open -a LocalSR --args --help
    TEXT
  end

  test do
    # Quick sanity check that the app bundle exists
    assert_predicate prefix.glob("*.app").first, :exist?
  end
end
