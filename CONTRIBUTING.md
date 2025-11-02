# Contributing to Lightroom Tree Exporter

Thank you for your interest in contributing to Lightroom Tree Exporter! This document provides guidelines and information for contributors.

## 🤝 Ways to Contribute

### 🐛 Reporting Bugs
- Use the [GitHub Issues](https://github.com/woutervellekoop/lightroom-tree-exporter/issues) page
- Check if the issue already exists before creating a new one
- Include detailed steps to reproduce the bug
- Provide information about your system (Lightroom version, OS, etc.)
- Include screenshots or error messages if applicable

### 💡 Suggesting Features
- Open a feature request on GitHub Issues
- Describe the problem you're trying to solve
- Explain how the feature would work
- Consider how it fits with existing functionality
- Be open to discussion and refinement

### 🔧 Code Contributions
- Fork the repository
- Create a feature branch from `main`
- Make your changes
- Test thoroughly with Lightroom Classic
- Submit a pull request with a clear description

## 🛠️ Development Setup

### Prerequisites
- Adobe Lightroom Classic 10.0 or higher
- Text editor or IDE (VS Code recommended)
- Basic understanding of Lua programming
- Familiarity with Lightroom SDK

### Getting Started
1. Fork and clone the repository
```bash
git clone https://github.com/yourusername/lightroom-tree-exporter.git
cd lightroom-tree-exporter
```

2. Install the plugin in Lightroom
   - Open Lightroom Classic
   - Go to File > Plug-in Manager
   - Click "Add" and select the `.lrplugin` folder
   - Enable the plugin

3. Make your changes
   - Edit the `.lua` files in your preferred editor
   - Main files to know:
     - `CropAndRollServiceProvider.lua` - Core export logic
     - `CropAndRollPathUtils.lua` - Path utility functions
     - `Info.lua` - Plugin metadata and configuration

4. Test in Lightroom
   - Reload the plugin in Plug-in Manager after changes
   - Test with various folder structures and export settings
   - Verify the preview updates correctly

## 📝 Code Guidelines

### Lua Style
- Use 4 spaces for indentation (no tabs)
- Follow existing naming conventions
- Add comments for complex logic
- Keep functions focused and single-purpose

### Error Handling
- Use `pcall()` for operations that might fail
- Provide meaningful error messages
- Log errors appropriately
- Graceful degradation when possible

### Example Code Style
```lua
-- Good: Clear function name and documentation
function CropAndRollServiceProvider.getDestinationPath(photo, exportContext, commonRoot)
    -- Get the base export path with subfolder
    local basePath = CropAndRollServiceProvider.getBasePath(exportContext)
    local propertyTable = exportContext.propertyTable
    
    -- Handle structure preservation logic
    if not propertyTable.preserveStructure then
        return basePath
    end
    
    -- Continue with implementation...
end
```

### Testing
- Test with different folder structures
- Verify with various Lightroom export settings
- Test file naming templates
- Check edge cases (empty folders, special characters)
- Test on both macOS and Windows if possible

## 🚀 Pull Request Process

1. **Create a descriptive title**
   - "Add support for camera model in file naming"
   - "Fix preview not updating when changing subfolders"

2. **Write a clear description**
   - What problem does this solve?
   - How did you test the changes?
   - Any breaking changes?

3. **Keep changes focused**
   - One feature or fix per pull request
   - Avoid mixing unrelated changes

4. **Update documentation**
   - Update README.md if adding features
   - Add entries to CHANGELOG.md
   - Update code comments as needed

## 🔍 Review Process

- All pull requests will be reviewed before merging
- Feedback may be provided for improvements
- Changes may be requested for code style or functionality
- Be patient and responsive to feedback

## 📚 Resources

### Lightroom SDK Documentation
- [Adobe Lightroom SDK Guide](https://developer.adobe.com/lightroom/classic/)
- [Lua Programming Guide](https://www.lua.org/manual/5.1/)
- [Lightroom Plugin Examples](https://developer.adobe.com/lightroom/classic/sdk/)

### Community
- [Lightroom Plugin Development Forum](https://community.adobe.com/t5/lightroom-classic/bd-p/lightroom-classic)
- [Photography Software Development](https://www.reddit.com/r/photography/)

## 🏷️ Issue Labels

We use these labels to organize issues:

- `bug` - Something isn't working
- `enhancement` - New feature request
- `documentation` - Improvements to docs
- `good first issue` - Good for newcomers
- `help wanted` - Extra attention needed
- `question` - Further information requested

## 📄 License

By contributing to this project, you agree that your contributions will be licensed under the MIT License.

## 🙏 Recognition

Contributors will be recognized in the project README and release notes. Thank you for helping make this plugin better for the photography community!

---

Questions? Feel free to open an issue or start a discussion on GitHub!