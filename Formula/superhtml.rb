class Superhtml < Formula
  desc "High-performance HTML template engine"
  homepage "https://github.com/kristoff-it/superhtml"
  version "0.5.1"

  on_macos do
    if Hardware::CPU.arm?
    sha256 "8ebfe082f37a2caeaeedf7fd2431f31cc96f9b893f50cc3e22c2bc6de591a1e1"
      # You'll need to add the actual SHA256 hash of the file here
      sha256 "c3f899d14c6c698e0f514f3cf4c7fd30192ea1f29d2e29567c04513276443bc2"
    sha256 "2b8a6e9e32de79f06ba5b483fa1738780701a8b4d60f220a2c56eb84b460aeee"
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
