--[[----------------------------------------------------------------------------

Crop and Roll Tree Exporter Plugin Initialization

This module handles plugin initialization and setup.

------------------------------------------------------------------------------]]

-- Import Lightroom SDK modules
local LrLogger = import 'LrLogger'

-- Create logger for this plugin
local logger = LrLogger('CropAndRollTreeExporter')

-- Enable logger
logger:enable("logfile")

-- Log plugin initialization
logger:info("Crop and Roll Tree Exporter plugin initializing...")

-- Plugin info
local pluginInfo = {
	name = "Crop and Roll Tree Exporter",
	version = "2.0.0",
	author = "Crop and Roll Development Team",
}

logger:info("Crop and Roll Tree Exporter plugin initialized successfully - Version " .. pluginInfo.version)