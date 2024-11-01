class Superhtml < Formula
  desc "High-performance HTML template engine"
  homepage "https://github.com/kristoff-it/superhtml"
  version "0.5.3"

  on_macos do
    if Hardware::CPU.arm?
    sha256 "b8b2327f666ff316422061284e107add5c413ebdfdb91774c0c3702a66e65ec9"
      # You'll need to add the actual SHA256 hash of the file here
      sha256 "c3f899d14c6c698e0f514f3cf4c7fd30192ea1f29d2e29567c04513276443bc2"
    sha256 "48d0d755867a0a7081d4ab9c658a66fcdcd32315fc6d4ea734e5ee34e49b0468"
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
