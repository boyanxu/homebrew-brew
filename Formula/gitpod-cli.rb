class GitpodCli < Formula
  desc "Command-line interface for Gitpod"
  homepage "https://www.gitpod.io"
  version "20250204.587"
  
  on_macos do
    if Hardware::CPU.arm?
      url "https://releases.gitpod.io/cli/releases/#{version}/gitpod-darwin-arm64"
      sha256 "d1490da018bdbf0222318052a8a9d7a4def4f7a5e26136f73b7cfa422c4d09bc" # darwin-arm64
    else
      url "https://releases.gitpod.io/cli/releases/#{version}/gitpod-darwin-amd64"
      sha256 "67f9275fb632d975ec2f70cee172bc76fa676fa80ce2f47926c9a8d9c7a871c5" # darwin-amd64
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
