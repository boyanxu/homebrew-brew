class Superhtml < Formula
  desc "High-performance HTML template engine"
  homepage "https://github.com/kristoff-it/superhtml"
  version "0.5.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kristoff-it/superhtml/releases/download/v#{version}/aarch64-macos.tar.gz"
      # You'll need to add the actual SHA256 hash of the file here
      sha256 "c3f899d14c6c698e0f514f3cf4c7fd30192ea1f29d2e29567c04513276443bc2"
    else
      url "https://github.com/kristoff-it/superhtml/releases/download/v#{version}/x86_64-macos.tar.gz"
      # You'll need to add the actual SHA256 hash of the file here
      sha256 "e171f080e7464afe0717bbe45894e8558702d054421d21e0fa5e5c4ee95e85c3"
    end
  end

  def install
    bin.install "superhtml"
  end

  test do
    system "#{bin}/superhtml", "--version"
  end
end
