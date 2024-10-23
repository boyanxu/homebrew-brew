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

update_superhtml