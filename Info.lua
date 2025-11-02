--[[----------------------------------------------------------------------------

Crop & Roll Tree Exporter - Open Source Plugin

A Lightroom Classic plugin that preserves folder structure during export,
allowing photographers to maintain their organizational hierarchy when
exporting photos to external destinations.

Author: Wouter Vellekoop
Version: 1.0.0
License: MIT
Repository: https://github.com/woutervellekooppixel/lightroom-tree-exporter

------------------------------------------------------------------------------]]

return {
	
	LrSdkVersion = 11.0,
	LrSdkMinimumVersion = 10.0,
	
	-- Plugin Identification
	LrToolkitIdentifier = "com.cropandroll.lightroom.treeexporter",
	LrPluginName = "Crop & Roll Tree Exporter",
	LrPluginInfoProvider = "CropAndRollInfoProvider.lua",
	
	-- Plugin Version
	VERSION = { major = 1, minor = 0, revision = 0, build = 20251102 },
	
	-- Localization and Initialization
	LrInitPlugin = "CropAndRollInit.lua",
	
	-- Export Service
	LrExportServiceProvider = {
		title = "Crop & Roll Tree Exporter",
		file = "CropAndRollServiceProvider.lua",
	},
	
	-- Metadata
	LrPluginInfoUrl = "https://github.com/woutervellekooppixel/lightroom-tree-exporter",
	
	-- Help Menu
	LrHelpMenuItems = {
		{
			title = "Crop & Roll Tree Exporter Help",
			file = "CropAndRollHelp.lua",
		},
	},
	
	-- Plugin Info
	LrPluginInfo = {
		title = "Crop & Roll Tree Exporter",
		summary = "Preserve folder structure when exporting photos",
		description = "An open source plugin that maintains your original folder hierarchy during photo exports, with real-time preview and flexible subfolder options.",
		author = "Wouter Vellekoop",
		version = "1.0.0",
		license = "MIT",
		homepage = "https://github.com/woutervellekooppixel/lightroom-tree-exporter"
	},
	
}