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
    bin.install_symlink "#{prefix}/LocalSR" => "localsr"
    bin.install_symlink "#{prefix}/LocalSRWorker" => "localsr-worker"
  end

  test do
    system "#{bin}/localsr", "--version"
  end
end
