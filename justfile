# Set formula name as a variable that can be overridden
formula := "formula"
workspace := justfile_directory()

# Test the formula
test formula:
    #!/usr/bin/env bash
    if [ "{{formula}}" = "formula" ]; then
        echo "No formula specified. Use: just test <formula_name>"
        exit 1
    fi
    if [ ! -f "{{workspace}}/Formula/{{formula}}.rb" ]; then
        echo "Formula {{formula}}.rb not found in {{workspace}}/Formula/"
        exit 1
    fi
    brew test {{workspace}}/Formula/{{formula}}.rb

install formula:
    #!/usr/bin/env bash
    if [ "{{formula}}" = "formula" ]; then
        echo "No formula specified. Use: just install <formula_name>"
        exit 1
    fi
    if [ ! -f "{{workspace}}/Formula/{{formula}}.rb" ]; then
        echo "Formula {{formula}}.rb not found in {{workspace}}/Formula/"
        exit 1
    fi
    brew install {{workspace}}/Formula/{{formula}}.rb

# Show workspace path
path:
    @echo "Workspace path: {{workspace}}"