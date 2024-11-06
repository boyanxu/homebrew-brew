class GitpodCli < Formula
  desc "Command-line interface for Gitpod"
  homepage "https://www.gitpod.io"
  version "20241025.688"  # This line will be updated by the script
  
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.gitpod.io/cli/releases/#{version}/gitpod-darwin-arm64"
      sha256 "1d92fd027878e44617d683e7e498521bd004aef6becea0fbd94a14359ecc84d4" # darwin-arm64
    else
      url "https://releases.gitpod.io/cli/releases/#{version}/gitpod-darwin-amd64"
      sha256 "f3f0289b557c2cd41828d327a6f9b43c795c8fac3675a3eb0046c7410646fae2" # darwin-amd64
    end
  else
    if Hardware::CPU.arm?
      url "https://releases.gitpod.io/cli/releases/#{version}/gitpod-linux-arm64"
      sha256 "b10e55519847233eda774b0e09f304d620779a881151e6a703eeab8ee04929ed" # linux-arm64
    else
      url "https://releases.gitpod.io/cli/releases/#{version}/gitpod-linux-amd64"
      sha256 "a9f9b29a36b0d1e70997a9b630c8fcb2b1bb481a2c856bb3f16e3cb2fc615504" # linux-amd64
    end
  end
  
  def install
    binary_name = "gitpod-#{OS.mac? ? 'darwin' : 'linux'}-#{Hardware::CPU.arm? ? 'arm64' : 'amd64'}"
    bin.install binary_name => "gitpod"
    chmod 0755, bin/"gitpod"
  end

  test do
    assert_match(/Gitpod CLI version \d+\.\d+/, shell_output("#{bin}/gitpod version"))
  end
end
