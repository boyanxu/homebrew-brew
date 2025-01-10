class GitpodCli < Formula
  desc "Command-line interface for Gitpod"
  homepage "https://www.gitpod.io"
  version "20250109.524"
  
  on_macos do
    if Hardware::CPU.arm?
      url "https://releases.gitpod.io/cli/releases/#{version}/gitpod-darwin-arm64"
      sha256 "45f1dc3abfeecf38cea2d1fcaf0f75d081fc49d2fd49cdb9a8e684399da8db51" # darwin-arm64
    else
      url "https://releases.gitpod.io/cli/releases/#{version}/gitpod-darwin-amd64"
      sha256 "b66353d5a68e7be72910aebf881f42f87ca6006f66a6e1bcbe9e07e60cdb2cd0" # darwin-amd64
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
