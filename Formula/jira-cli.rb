class JiraCli < Formula
  desc "Feature-rich Interactive Jira Command Line"
  homepage "https://github.com/ankitpokhrel/jira-cli"
  version "1.5.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ankitpokhrel/jira-cli/releases/download/v#{version}/jira_#{version}_macOS_arm64.tar.gz"
      sha256 "4a6a5a670bf8e81bf091b12e23f932f7133609bdf5c9f993c6c0a45df2510358"
    else
      url "https://github.com/ankitpokhrel/jira-cli/releases/download/v#{version}/jira_#{version}_macOS_x86_64.tar.gz"
      sha256 "b8d4a9ff7b9d8117c4e6eba4f00df8506344431c784c3f83d486777c66593091"
    end
  end

  def install
    bin.install "jira"
    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/jira completion bash")
    (bash_completion/"jira").write output
    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/jira completion zsh")
    (zsh_completion/"_jira").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jira version")
  end
end