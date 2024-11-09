#!/bin/bash
set -euo pipefail

# Function to handle errors
handle_error() {
    echo "::error::Error occurred in script at line: $1"
    exit 1
}

trap 'handle_error $LINENO' ERR

# Configure GitHub API requests
GITHUB_API_HEADER=""
if [ -n "${GITHUB_TOKEN:-}" ]; then
    GITHUB_API_HEADER="Authorization: token $GITHUB_TOKEN"
fi

curl_gh_api() {
    if [ -n "$GITHUB_API_HEADER" ]; then
        curl -H "$GITHUB_API_HEADER" -Ls "$@"
    else
        curl -Ls "$@"
    fi
}

update_superhtml(){
    echo "::group::Updating superhtml"
    
    # Get current version
    current_version=$(grep -m1 'version "' Formula/superhtml.rb | cut -d'"' -f2)
    
    # Get the latest version of superhtml
    last_version=$(curl_gh_api "https://api.github.com/repos/kristoff-it/superhtml/releases/latest" | 
                  grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | sed 's/v//g')
    
    if [ "$current_version" = "$last_version" ]; then
        echo "superhtml is already at latest version ${current_version}"
        echo "::endgroup::"
        return 0
    fi

    if [ "${DRY_RUN:-false}" = "true" ]; then
        echo "Dry run - would update superhtml to version ${last_version}"
        echo "::endgroup::"
        return 0
    fi

    # Download both architecture binaries
    wget -O superhtml_macos_arm64.tar.gz "https://github.com/kristoff-it/superhtml/releases/download/v${last_version}/aarch64-macos.tar.gz"
    wget -O superhtml_macos_amd64.tar.gz "https://github.com/kristoff-it/superhtml/releases/download/v${last_version}/x86_64-macos.tar.gz"

    # Calculate the SHA256 hashes for both binaries
    arm64_sha256=$(sha256sum superhtml_macos_arm64.tar.gz | cut -d ' ' -f 1)
    amd64_sha256=$(sha256sum superhtml_macos_amd64.tar.gz | cut -d ' ' -f 1)

    # Create a temporary file
    tmp_file=$(mktemp)

    # Update the formula
    while IFS= read -r line; do
        if [[ $line =~ ^[[:space:]]*version ]]; then
            echo "  version \"${last_version}\"" >> "$tmp_file"
        elif [[ $line =~ aarch64-macos\.tar\.gz ]]; then
            echo "      sha256 \"${arm64_sha256}\"" >> "$tmp_file"
        elif [[ $line =~ x86_64-macos\.tar\.gz ]]; then
            echo "      sha256 \"${amd64_sha256}\"" >> "$tmp_file"
        else
            echo "$line" >> "$tmp_file"
        fi
    done < Formula/superhtml.rb

    # Replace the original file
    mv "$tmp_file" Formula/superhtml.rb

    # Delete the downloaded archives
    rm -f superhtml_macos_*.tar.gz
    
    echo "::endgroup::"
}

update_jira_cli(){
    echo "::group::Updating jira-cli"
    
    current_version=$(grep -m1 'version "' Formula/jira-cli.rb | cut -d'"' -f2)
    
    # Get latest release info from GitHub API
    latest_release=$(curl_gh_api "https://api.github.com/repos/ankitpokhrel/jira-cli/releases/latest")

    # Extract version without 'v' prefix
    last_version=$(echo "$latest_release" | jq -r '.tag_name' | sed 's/^v//')

    if [ "$current_version" = "$last_version" ]; then
        echo "jira-cli is already at latest version ${current_version}"
        echo "::endgroup::"
        return 0
    }

    if [ "${DRY_RUN:-false}" = "true" ]; then
        echo "Dry run - would update jira-cli to version ${last_version}"
        echo "::endgroup::"
        return 0
    }

    # Get SHA256 hashes from the release assets
    darwin_arm64_sha256=$(curl -sL "https://github.com/ankitpokhrel/jira-cli/releases/download/v${last_version}/jira_${last_version}_macOS_arm64.tar.gz.sha256sum" | awk '{print $1}')
    darwin_amd64_sha256=$(curl -sL "https://github.com/ankitpokhrel/jira-cli/releases/download/v${last_version}/jira_${last_version}_macOS_x86_64.tar.gz.sha256sum" | awk '{print $1}')

    # Update version and SHA256 in the formula
    sed -i "s/version \".*/version \"${last_version}\"/g" Formula/jira-cli.rb
    sed -i "s/sha256 \"[a-f0-9]*\".*macOS_arm64/sha256 \"${darwin_arm64_sha256}\"  # macOS_arm64/" Formula/jira-cli.rb
    sed -i "s/sha256 \"[a-f0-9]*\".*macOS_x86_64/sha256 \"${darwin_amd64_sha256}\"  # macOS_x86_64/" Formula/jira-cli.rb
    
    echo "::endgroup::"
}

update_gitpod_cli(){
    echo "::group::Updating gitpod-cli"
    
    current_version=$(grep -m1 'version "' Formula/gitpod-cli.rb | cut -d'"' -f2)
    
    # Get the manifest data
    manifest=$(curl -s https://releases.gitpod.io/cli/stable/manifest.json)
    
    # Extract the latest version
    last_version=$(echo "$manifest" | jq -r '.version')

    if [ "$current_version" = "$last_version" ]; then
        echo "gitpod-cli is already at latest version ${current_version}"
        echo "::endgroup::"
        return 0
    }

    if [ "${DRY_RUN:-false}" = "true" ]; then
        echo "Dry run - would update gitpod-cli to version ${last_version}"
        echo "::endgroup::"
        return 0
    }
    
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
    
    echo "::endgroup::"
}

# Main execution
if [ $# -eq 0 ]; then
    # No arguments, update all packages
    update_superhtml
    update_jira_cli
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
                echo "::warning::Unknown package: $package"
                ;;
        esac
    done
fi