# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-11-02

### Added
- Initial release of Lightroom Tree Exporter
- Folder structure preservation during export
- Real-time path preview with file naming support
- Subfolder creation with date placeholders (`{date}`)
- Smart conflict handling (skip existing files)
- Automatic folder creation
- Integration with Lightroom's file naming templates
- Support for all Lightroom export formats
- Cross-platform compatibility (macOS and Windows)
- MIT License for open source distribution

### Features
- Export Service Provider integration
- Common root path detection for optimal folder hierarchy
- Real-time preview updates when settings change
- Support for Lightroom's built-in file naming tokens
- Memory-optimized export processing
- Comprehensive error handling and logging

### Technical
- Compatible with Adobe Lightroom Classic 10.0+
- Built with Lightroom SDK 11.0
- Supports all standard export formats (JPEG, TIFF, DNG, etc.)
- Efficient batch processing for large photo collections

## [Unreleased]

### Planned Features
- Preset save/load functionality
- Additional file naming tokens (camera, lens, ISO, etc.)
- Progress bar with detailed export status
- Batch renaming options
- Watermark integration
- Export queue management
- Recent folders dropdown
- Advanced conflict resolution options

---

For more information about upcoming features and to request new functionality, 
please visit our [GitHub Issues](https://github.com/woutervellekoop/lightroom-tree-exporter/issues) page.