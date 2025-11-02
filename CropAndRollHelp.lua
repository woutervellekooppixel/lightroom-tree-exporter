--[[----------------------------------------------------------------------------

Crop and Roll Tree Exporter Help

This module provides help information for the Crop and Roll Tree Exporter plugin.

------------------------------------------------------------------------------]]

-- Import Lightroom SDK modules
local LrView = import 'LrView'
local LrDialogs = import 'LrDialogs'

local CropAndRollHelp = {}

function CropAndRollHelp.showHelp()
	
	LrDialogs.message("Crop and Roll Tree Exporter Help", 
		"Crop and Roll Tree Exporter preserves your original folder structure when exporting photos from Lightroom with style.\n\n" ..
		"Features:\n" ..
		"• Maintains the last few levels of your folder hierarchy\n" ..
		"• Creates destination folders automatically\n" ..
		"• Option to skip duplicate files\n" ..
		"• Simple and lightweight with style\n" ..
		"• Designed with photographers in mind\n\n" ..
		"To use:\n" ..
		"1. Select photos to export\n" ..
		"2. Choose File > Export with Preset > Crop and Roll Tree Exporter\n" ..
		"3. Select your destination folder\n" ..
		"4. Configure options as needed\n" ..
		"5. Click Export\n\n" ..
		"The plugin will recreate your folder structure in the destination location with care and precision.",
		"info")
end

return CropAndRollHelp