# Lightroom Tree Exporter# Crop and Roll Tree Exporter - Lightroom Plugin



A free, open-source Adobe Lightroom Classic plugin that preserves your folder structure when exporting photos. Perfect for photographers who want to maintain their organizational hierarchy across different export destinations.🎯 **A stylish and efficient Adobe Lightroom plugin that preserves your original folder structure when exporting photos with flair.**



## ✨ Features## ✨ Features



- **🌳 Folder Structure Preservation**: Maintains your original folder hierarchy during export- **📁 Preserve Folder Structure**: Maintains the original hierarchy of your photo folders with precision

- **📁 Flexible Subfolder Options**: Add custom subfolders with date placeholders (`{date}`)- **🧠 Smart Path Detection**: Automatically finds common root paths among selected photos

- **👀 Real-time Preview**: See exactly where your photos will be exported before you start- **⚙️ Flexible Configuration**: Choose to preserve structure or export all to one folder

- **🏷️ File Naming Support**: Works with Lightroom's built-in file renaming templates- **🔄 Duplicate Handling**: Option to skip files that already exist

- **⚙️ Smart Conflict Handling**: Options to skip existing files or create subfolders automatically- **📂 Automatic Folder Creation**: Creates destination folders as needed

- **🚀 Export Service Provider**: Integrates seamlessly with Lightroom's export dialog- **🎨 Clean & Stylish**: Lightweight plugin designed with photographers in mind



## 📸 Perfect For## 🚀 Installation



- **Event Photographers**: Maintain client folder structures when delivering photos1. Download the `CropAndRollTreeExporter.lrplugin` folder

- **Wedding Photographers**: Preserve ceremony/reception/portraits organization2. In Lightroom, go to **File > Plug-in Manager**

- **Stock Photographers**: Keep category-based folder hierarchies3. Click **"Add"** and select the plugin folder

- **Travel Photographers**: Maintain location-based folder structures4. Enable the plugin

- **Any Photographer**: Who values organized photo libraries5. You're ready to **Crop and Roll**! 🎬



## 🚀 Installation## 📋 Usage



1. **Download** the latest release from [GitHub Releases](https://github.com/woutervellekoop/lightroom-tree-exporter/releases)1. **Select photos** you want to export in Lightroom

2. **Extract** the `.zip` file to get the `.lrplugin` folder2. Go to **File > Export**

3. **Open Adobe Lightroom Classic**3. In the export dialog, select **"Crop and Roll Tree Exporter"** from the export destination dropdown

4. Go to **File > Plug-in Manager**4. **Choose your destination folder**

5. Click **Add** and select the `.lrplugin` folder5. **Configure options**:

6. Click **Done**   - ✅ **Preserve original folder structure**: Keep the folder hierarchy

   - ✅ **Create subfolders as needed**: Automatically create folders

## 📖 Usage   - ✅ **Skip files that already exist**: Avoid overwriting existing files

6. Click **Export** and watch the magic happen! ✨

1. **Select Photos** in Lightroom that you want to export

2. Go to **File > Export** or press `Cmd+Shift+E` (Mac) / `Ctrl+Shift+E` (Windows)## 🎬 How It Works

3. In the export dialog, change the **Export To** dropdown to **"Tree Exporter"**

4. **Configure Settings**:Crop and Roll Tree Exporter analyzes the folder structure of your selected photos and:

   - **Export to**: Choose your destination folder

   - **Subfolder**: Optional subfolder (supports `{date}` placeholder)1. **🔍 Finds the common root path** among all selected images

   - **Preserve original folder structure**: ✅ Keep this checked2. **📋 Preserves the relative folder structure** from that root

   - **Create subfolders if they don't exist**: ✅ Recommended3. **🏗️ Recreates the folder hierarchy** in your chosen destination

5. **Preview**: Check the "Example export path" to see where your first photo will go4. **📸 Exports photos** to their corresponding folders with style

6. **Configure** other Lightroom export settings (format, quality, etc.) as usual

7. Click **Export**### Example Structure:

```

## 💡 Example Use Cases📁 Original:

/Photos/2024/January/Vacation/image1.jpg

### Event Photography/Photos/2024/January/Work/image2.jpg

```/Photos/2024/February/Family/image3.jpg

Original Structure:           Export Result:

📁 Wedding_Smith_2024        📁 Delivery/Wedding_Smith_2024📁 Exported to /Exports/:

  📁 Ceremony          →       📁 Ceremony/Exports/January/Vacation/image1.jpg

  📁 Reception               📁 Reception/Exports/January/Work/image2.jpg

  📁 Portraits               📁 Portraits/Exports/February/Family/image3.jpg

``````



### Travel PhotographyThe plugin preserves the structure that matters while keeping things organized and stylish! 🎯

```

Original Structure:           Export Result:## 💻 Requirements

📁 Europe_Trip_2024          📁 Backup/2024-11-02/Europe_Trip_2024

  📁 Paris             →       📁 Paris- Adobe Lightroom Classic 6.0 or later

  📁 Rome                      📁 Rome- Lightroom SDK 3.0 or later

  📁 Amsterdam                 📁 Amsterdam

```## 📦 Version



## ⚙️ Configuration Options**Current Version: 2.0.0** - Crop and Roll Edition



| Setting | Description | Example |## 🎭 About "Crop and Roll"

|---------|-------------|---------|

| **Export to** | Base destination folder | `/Users/john/Desktop/Export` |Just like the classic film direction "Cut and Roll!", our **Crop and Roll Tree Exporter** brings that same energy and precision to your photo exports. We believe in maintaining your creative workflow while preserving the organization that keeps your photography projects rolling smoothly.

| **Subfolder** | Optional subfolder with date support | `{date}` → `2024-11-02` |

| **Preserve structure** | Maintains original folder hierarchy | ✅ Recommended |## 🆘 Support

| **Create subfolders** | Automatically creates missing folders | ✅ Recommended |

| **Skip duplicates** | Skip files that already exist | Your choice |This is a modern, rewritten version of the Tree Exporter plugin, designed with style, simplicity, and photographer workflows in mind. 



## 🔧 Technical Details*Happy cropping and rolling!* 🎬📸

- **Compatibility**: Adobe Lightroom Classic 10.0+
- **Platforms**: macOS and Windows
- **File Formats**: Supports all Lightroom export formats (JPEG, TIFF, DNG, etc.)
- **Performance**: Efficient handling of large photo collections
- **Memory**: Optimized for minimal memory usage during export

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. **🐛 Report Bugs**: Open an issue with details about the problem
2. **💡 Suggest Features**: Share your ideas for improvements
3. **🔧 Submit Code**: Fork the repo and submit a pull request
4. **📚 Improve Documentation**: Help make the docs better
5. **🌟 Spread the Word**: Tell other photographers about this plugin

### Development Setup

```bash
git clone https://github.com/woutervellekoop/lightroom-tree-exporter.git
cd lightroom-tree-exporter
# Open the .lrplugin folder in your code editor
# Install in Lightroom Classic for testing
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with the Adobe Lightroom SDK
- Inspired by the need for better folder structure preservation in Lightroom
- Thanks to the photography community for feedback and testing

## 📞 Support

- **GitHub Issues**: [Report bugs or request features](https://github.com/woutervellekoop/lightroom-tree-exporter/issues)
- **Discussions**: [Community discussions and questions](https://github.com/woutervellekoop/lightroom-tree-exporter/discussions)

---

**Made with ❤️ for the photography community**

*If this plugin saves you time, consider giving it a ⭐ on GitHub!*