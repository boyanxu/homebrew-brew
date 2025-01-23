class GitpodCli < Formula
  desc "Command-line interface for Gitpod"
  homepage "https://www.gitpod.io"
  version "20250122.472"
  
  on_macos do
    if Hardware::CPU.arm?
      url "https://releases.gitpod.io/cli/releases/#{version}/gitpod-darwin-arm64"
      sha256 "b414bf30cbf17a69b6927ff4062066effd392b1c339e7bf00c7cdd4da5b118ad" # darwin-arm64
    else
      url "https://releases.gitpod.io/cli/releases/#{version}/gitpod-darwin-amd64"
      sha256 "11345e2841070c5be6a57232451e38c0818854dcfebfcd7ef9b7cfdd61908b1b" # darwin-amd64
    end
  end
  
  def install
    binary_name = "gitpod-darwin-#{Hardware::CPU.arm? ? 'arm64' : 'amd64'}"
    bin.install binary_name => "gitpod"
    chmod 0755, bin/"gitpod"
  end

  test do
    assert_match(/Gitpod CLI version \d+\.\d+/, shell_output("#{bin}/gitpod version"))
  end
end
