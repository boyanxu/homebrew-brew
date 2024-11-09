class Superhtml < Formula
  desc "High-performance HTML template engine"
  homepage "https://github.com/kristoff-it/superhtml"
  version "0.5.3"

  on_macos do
    if Hardware::CPU.arm?
      sha256 "b8b2327f666ff316422061284e107add5c413ebdfdb91774c0c3702a66e65ec9"
      url "https://github.com/kristoff-it/superhtml/releases/download/v#{version}/arm64-macos.tar.gz"
    else
      sha256 "e171f080e7464afe0717bbe45894e8558702d054421d21e0fa5e5c4ee95e85c3"
      url "https://github.com/kristoff-it/superhtml/releases/download/v#{version}/x86_64-macos.tar.gz"
    end
  end

  def install
    bin.install "superhtml"
  end

  test do
    system "#{bin}/superhtml", "--version"
  end
end
