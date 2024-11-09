#!/bin/bash

update_superhtml(){
    # Get the latest version of superhtml
    last_version=$(curl -Ls "https://api.github.com/repos/kristoff-it/superhtml/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | sed 's/v//g')

    # Download both architecture binaries
    wget -O superhtml_macos_arm64.tar.gz "https://github.com/kristoff-it/superhtml/releases/download/v${last_version}/aarch64-macos.tar.gz"
    wget -O superhtml_macos_amd64.tar.gz "https://github.com/kristoff-it/superhtml/releases/download/v${last_version}/x86_64-macos.tar.gz"

    # Calculate the SHA256 hashes for both binaries
    arm64_sha256=$(sha256sum superhtml_macos_arm64.tar.gz | cut -d ' ' -f 1)
    amd64_sha256=$(sha256sum superhtml_macos_amd64.tar.gz | cut -d ' ' -f 1)

    # Update the version number in the formula
    sed -i "s/version \".*/version \"${last_version}\"/g" Formula/superhtml.rb

    # Update the SHA256 hashes in the formula
    sed -i "8s/.*/    sha256 \"${arm64_sha256}\"/" Formula/superhtml.rb
    sed -i "11s/.*/    sha256 \"${amd64_sha256}\"/" Formula/superhtml.rb

    # Delete the downloaded archives
    rm -f superhtml_macos_*.tar.gz
}

update_jira_cli(){
    # Get latest release info from GitHub API
    latest_release=$(curl -s https://api.github.com/repos/ankitpokhrel/jira-cli/releases/latest)

    # Extract version without 'v' prefix
    last_version=$(echo "$latest_release" | jq -r '.tag_name' | sed 's/^v//')

    # Get SHA256 hashes from the release assets
    darwin_arm64_sha256=$(curl -sL https://github.com/ankitpokhrel/jira-cli/releases/download/v${last_version}/jira_${last_version}_macOS_arm64.tar.gz.sha256sum | awk '{print $1}')
    darwin_amd64_sha256=$(curl -sL https://github.com/ankitpokhrel/jira-cli/releases/download/v${last_version}/jira_${last_version}_macOS_x86_64.tar.gz.sha256sum | awk '{print $1}')

    # Update version and SHA256 in the formula
    sed -i "s/version \".*/version \"${last_version}\"/g" Formula/jira-cli.rb
    sed -i "s/sha256 \"[a-f0-9]*\".*macOS_arm64/sha256 \"${darwin_arm64_sha256}\"  # macOS_arm64/" Formula/jira-cli.rb
    sed -i "s/sha256 \"[a-f0-9]*\".*macOS_x86_64/sha256 \"${darwin_amd64_sha256}\"  # macOS_x86_64/" Formula/jira-cli.rb
}

update_gitpod_cli(){
    # Get the manifest data
    manifest=$(curl -s https://releases.gitpod.io/cli/stable/manifest.json)
    
    # Extract the latest version
    last_version=$(echo "$manifest" | jq -r '.version')
    
    # Extract SHA256 hashes for each platform
    darwin_arm64_sha256=$(echo "$manifest" | jq -r '.downloads."darwin-arm64".digest' | sed 's/sha256://')
    darwin_amd64_sha256=$(echo "$manifest" | jq -r '.downloads."darwin-amd64".digest' | sed 's/sha256://')
    linux_arm64_sha256=$(echo "$manifest" | jq -r '.downloads."linux-arm64".digest' | sed 's/sha256://')
    linux_amd64_sha256=$(echo "$manifest" | jq -r '.downloads."linux-amd64".digest' | sed 's/sha256://')
    
    # Update the version number in the formula
    sed -i "s/version \".*/version \"${last_version}\"/g" Formula/gitpod-cli.rb
    
    # Update the SHA256 hashes in the formula
    sed -i "s/sha256 \"[a-f0-9]*\" # darwin-arm64/sha256 \"${darwin_arm64_sha256}\" # darwin-arm64/" Formula/gitpod-cli.rb
    sed -i "s/sha256 \"[a-f0-9]*\" # darwin-amd64/sha256 \"${darwin_amd64_sha256}\" # darwin-amd64/" Formula/gitpod-cli.rb
    sed -i "s/sha256 \"[a-f0-9]*\" # linux-arm64/sha256 \"${linux_arm64_sha256}\" # linux-arm64/" Formula/gitpod-cli.rb
    sed -i "s/sha256 \"[a-f0-9]*\" # linux-amd64/sha256 \"${linux_amd64_sha256}\" # linux-amd64/" Formula/gitpod-cli.rb
}

# Check command line arguments
if [ $# -eq 0 ]; then
    # No arguments, update all packages
    update_superhtml
    update_gitpod_cli
else
    # Update specific packages
    for package in "$@"; do
        case $package in
            "superhtml")
                update_superhtml
                ;;
            "gitpod-cli")
                update_gitpod_cli
                ;;
            "jira-cli")
                update_jira_cli
                ;;
            *)
                echo "Unknown package: $package"
                ;;
        esac
    done
fi
