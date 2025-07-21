#!/bin/bash

# Daisy Seed VSCode Template Setup Script
# This script helps initialize a new project from the template by updating
# project names and file references throughout the codebase.

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -n, --name PROJECT_NAME    Set the project name (required)"
    echo "  -t, --target TARGET_NAME   Set the CMake target name (optional, defaults to lowercase project name)"
    echo "  -h, --help                 Show this help message"
    echo ""
    echo "Example:"
    echo "  $0 --name MyAudioProject --target myaudioproject"
    echo "  $0 -n \"My Audio Project\" -t my_audio_project"
}

# Default values
PROJECT_NAME=""
TARGET_NAME=""
INTERACTIVE=true

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -n|--name)
            PROJECT_NAME="$2"
            INTERACTIVE=false
            shift 2
            ;;
        -t|--target)
            TARGET_NAME="$2"
            shift 2
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Interactive mode if no project name provided
if [[ -z "$PROJECT_NAME" ]] && [[ "$INTERACTIVE" == true ]]; then
    echo ""
    echo "🚀 Daisy Seed Project Setup"
    echo "=========================="
    echo ""
    
    # Get project name
    while [[ -z "$PROJECT_NAME" ]]; do
        read -p "Enter your project name: " PROJECT_NAME
        if [[ -z "$PROJECT_NAME" ]]; then
            print_warning "Project name cannot be empty!"
        fi
    done
    
    # Get target name (optional)
    if [[ -z "$TARGET_NAME" ]]; then
        # Generate default target name (lowercase, replace spaces with underscores)
        DEFAULT_TARGET=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/ /_/g' | sed 's/[^a-z0-9_]//g')
        read -p "Enter CMake target name (default: $DEFAULT_TARGET): " TARGET_NAME
        if [[ -z "$TARGET_NAME" ]]; then
            TARGET_NAME="$DEFAULT_TARGET"
        fi
    fi
elif [[ -z "$PROJECT_NAME" ]]; then
    print_error "Project name is required!"
    show_usage
    exit 1
fi

# Generate target name if not provided
if [[ -z "$TARGET_NAME" ]]; then
    TARGET_NAME=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/ /_/g' | sed 's/[^a-z0-9_]//g')
fi

# Validate inputs
if [[ ! "$TARGET_NAME" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
    print_error "Target name must be a valid C identifier (letters, numbers, underscores, cannot start with number)"
    exit 1
fi

print_info "Project Name: $PROJECT_NAME"
print_info "Target Name: $TARGET_NAME"
echo ""

# Confirm changes
if [[ "$INTERACTIVE" == true ]]; then
    read -p "Proceed with these settings? (y/N): " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        print_info "Setup cancelled."
        exit 0
    fi
fi

# Check if we're in the right directory
if [[ ! -f "CMakeLists.txt" ]] || [[ ! -d "src" ]] || [[ ! -d ".vscode" ]]; then
    print_error "This doesn't appear to be a Daisy Seed template directory!"
    print_error "Please run this script from the root of your template project."
    exit 1
fi

print_info "Starting project setup..."

# Backup original files
print_info "Creating backup of original files..."
BACKUP_DIR=".template-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
cp CMakeLists.txt "$BACKUP_DIR/"
cp src/CMakeLists.txt "$BACKUP_DIR/"
cp README.md "$BACKUP_DIR/"
cp .vscode/launch.json "$BACKUP_DIR/"

# Update CMakeLists.txt (root)
print_info "Updating root CMakeLists.txt..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS sed
    sed -i '' "s/project(daisyseed-vscode-template/project($PROJECT_NAME/" CMakeLists.txt
else
    # Linux sed
    sed -i "s/project(daisyseed-vscode-template/project($PROJECT_NAME/" CMakeLists.txt
fi

# Update src/CMakeLists.txt
print_info "Updating src/CMakeLists.txt..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS sed
    sed -i '' "s/set(TARGET daisyvscodetemplate)/set(TARGET $TARGET_NAME)/" src/CMakeLists.txt
else
    # Linux sed
    sed -i "s/set(TARGET daisyvscodetemplate)/set(TARGET $TARGET_NAME)/" src/CMakeLists.txt
fi

# Update launch.json
print_info "Updating .vscode/launch.json..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS sed
    sed -i '' "s/daisyvscodetemplate.elf/$TARGET_NAME.elf/" .vscode/launch.json
else
    # Linux sed
    sed -i "s/daisyvscodetemplate.elf/$TARGET_NAME.elf/" .vscode/launch.json
fi

# Update README.md
print_info "Updating README.md..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS sed
    sed -i '' "s/# daisyseed-vscode-template/# $PROJECT_NAME/" README.md
    sed -i '' "s/DaisyVSCodeTemplate Initialized/$PROJECT_NAME Initialized/" README.md
else
    # Linux sed
    sed -i "s/# daisyseed-vscode-template/# $PROJECT_NAME/" README.md
    sed -i "s/DaisyVSCodeTemplate Initialized/$PROJECT_NAME Initialized/" README.md
fi

# Update main.cpp
print_info "Updating src/main.cpp..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS sed
    sed -i '' "s/DaisyVSCodeTemplate Initialized/$PROJECT_NAME Initialized/" src/main.cpp
else
    # Linux sed
    sed -i "s/DaisyVSCodeTemplate Initialized/$PROJECT_NAME Initialized/" src/main.cpp
fi

# Remove template-specific content from README
print_info "Cleaning up template-specific content..."
# Create a new README with project-specific content
cat > README.md << EOF
# $PROJECT_NAME

A Daisy Seed audio project built with C++ and CMake.

## Description

[Add your project description here]

## Hardware Requirements

- Electrosmith Daisy Seed
- [Add any additional hardware requirements]

## Build Setup

Create and configure the build directory:

\`\`\`bash
mkdir build
cd build
cmake ..
\`\`\`

For debug builds with debugging symbols:

\`\`\`bash
cmake -DCMAKE_BUILD_TYPE=Debug ..
\`\`\`

## Building

\`\`\`bash
make
\`\`\`

Or use VSCode tasks (Ctrl+Shift+P → "Tasks: Run Build Task").

## Device Programming

### USB Programming (DFU)
\`\`\`bash
make program-dfu
\`\`\`

### JTAG Programming (OpenOCD)
\`\`\`bash
make program-ocd
\`\`\`

## Development

This project includes:
- CMake build system
- VSCode integration with IntelliSense
- Debug configurations for on-device and unit test debugging
- Unit testing framework (DocTest)

### Unit Tests

Set up and run unit tests:

\`\`\`bash
cd test
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Debug ..
make
./bin/tests
\`\`\`

Or use VSCode tasks (Ctrl+Shift+P → "Tasks: Run Test Task").

## Dependencies

- libDaisy: Hardware abstraction library for Daisy Seed
- DaisySP: DSP library for audio processing
- DocTest: Unit testing framework (for host-side tests)

## License

[Add your license information here]
EOF

# Clean up template setup script and documentation
print_info "Removing template setup files..."
rm -f scripts/setup-project.sh

print_success "Project setup complete!"
print_info "Backup of original files saved in: $BACKUP_DIR"
echo ""
print_info "Next steps:"
echo "  1. Update the project description in README.md"
echo "  2. Add your audio processing code to src/main.cpp"
echo "  3. Configure any additional dependencies in CMakeLists.txt"
echo "  4. Build and test your project: make"
echo ""
print_success "Happy coding! 🎵"
