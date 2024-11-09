class JiraCli < Formula
    desc "Feature-rich Interactive Jira Command Line"
    homepage "https://github.com/ankitpokhrel/jira-cli"
    version "1.5.2"
  
    on_macos do
      arch = Hardware::CPU.arm? ? "arm64" : "x86_64"
      binary_name = "jira_#{version}_macOS_#{arch}"
  
      url "https://github.com/ankitpokhrel/jira-cli/releases/download/v#{version}/#{binary_name}.tar.gz"
      if Hardware::CPU.arm?
        url "https://github.com/ankitpokhrel/jira-cli/releases/download/v#{version}/jira_#{version}_macOS_arm64.tar.gz"
        sha256 "47654bd51faad87a7679a90f627824b95faa16b116dc2ea074cd4f1640bfdbbc"
      else
        url "https://github.com/ankitpokhrel/jira-cli/releases/download/v#{version}/jira_#{version}_macOS_x86_64.tar.gz"
        sha256 "d1158338225b263c40fb4c60835e9241c135af1049e9dc35061f5a19db9c03f4"
      end
    end
  
    def install
      system "ls -la"
      system "find", ".", "-type", "f"
      bin.install "bin/jira"
    end
  
    test do
      assert_match version.to_s, shell_output("#{bin}/jira version")
    end
  end