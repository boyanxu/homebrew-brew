class GitpodCli < Formula
  desc "Command-line interface for Gitpod"
  homepage "https://www.gitpod.io"
  version "20250502.1340"
  
  on_macos do
    if Hardware::CPU.arm?
      url "https://releases.gitpod.io/cli/releases/#{version}/gitpod-darwin-arm64"
      sha256 "059bee8005dfbdbe93f7d6f1ab99a1880fc737eebdc7b749e3e3d3d4a287560d" # darwin-arm64
    else
      url "https://releases.gitpod.io/cli/releases/#{version}/gitpod-darwin-amd64"
      sha256 "2153e999debdbcf0ee12a4052bfa8b404cf234b7f1e2c5a7ca8717da118c7f36" # darwin-amd64
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
