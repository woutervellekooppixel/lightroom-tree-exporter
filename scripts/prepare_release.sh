#!/bin/bash

# Release preparation script for Lightroom Tree Exporter
# This script creates a clean distribution package

set -e

PLUGIN_NAME="LightroomTreeExporter"
VERSION="1.0.0"
RELEASE_DIR="releases"
PACKAGE_NAME="${PLUGIN_NAME}_v${VERSION}"

echo "🚀 Preparing release package for ${PLUGIN_NAME} v${VERSION}"

# Create release directory
mkdir -p "${RELEASE_DIR}"

# Create temporary directory for clean package
TEMP_DIR=$(mktemp -d)
PACKAGE_DIR="${TEMP_DIR}/${PLUGIN_NAME}.lrplugin"

echo "📦 Creating clean package..."

# Copy plugin files (excluding development files)
mkdir -p "${PACKAGE_DIR}"
cp *.lua "${PACKAGE_DIR}/"
cp LICENSE "${PACKAGE_DIR}/"
cp README.md "${PACKAGE_DIR}/"
cp CHANGELOG.md "${PACKAGE_DIR}/"

# Remove development/backup files
rm -f "${PACKAGE_DIR}"/*_old.lua
rm -f "${PACKAGE_DIR}"/*_backup*.lua
rm -f "${PACKAGE_DIR}"/SimpleTest.lua

echo "🧹 Cleaning up development files..."

# Create zip archive
cd "${TEMP_DIR}"
zip -r "${PACKAGE_NAME}.zip" "${PLUGIN_NAME}.lrplugin"

# Move to releases directory
mv "${PACKAGE_NAME}.zip" "${OLDPWD}/${RELEASE_DIR}/"

# Cleanup
rm -rf "${TEMP_DIR}"

echo "✅ Release package created: ${RELEASE_DIR}/${PACKAGE_NAME}.zip"
echo ""
echo "📋 Release checklist:"
echo "  - [ ] Test installation in fresh Lightroom"
echo "  - [ ] Verify all features work correctly"
echo "  - [ ] Update GitHub release notes"
echo "  - [ ] Tag version in git: git tag v${VERSION}"
echo "  - [ ] Upload to GitHub releases"
echo ""
echo "🎉 Ready for release!"