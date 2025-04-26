class GitpodCli < Formula
  desc "Command-line interface for Gitpod"
  homepage "https://www.gitpod.io"
  version "20250424.1251"
  
  on_macos do
    if Hardware::CPU.arm?
      url "https://releases.gitpod.io/cli/releases/#{version}/gitpod-darwin-arm64"
      sha256 "33fe1b91ba83a0a3d480adc7ef447d0ebcd092303385fa01ff90db73d3af1914" # darwin-arm64
    else
      url "https://releases.gitpod.io/cli/releases/#{version}/gitpod-darwin-amd64"
      sha256 "0b9cd4728b4ef72ab5c07def31970603a87cd75522b9f8e4b8fef4eb6c4ccbb6" # darwin-amd64
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
