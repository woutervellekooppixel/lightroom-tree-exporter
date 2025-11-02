--[[----------------------------------------------------------------------------

Crop and Roll Tree Exporter Plugin Info Provider

This module provides plugin information for the Crop and Roll Tree Exporter plugin.

------------------------------------------------------------------------------]]

local LrView = import 'LrView'
local LrDialogs = import 'LrDialogs'

local CropAndRollInfoProvider = {}

function CropAndRollInfoProvider.startDialog()
	return {
		title = "Crop and Roll Tree Exporter",
		contents = "Crop and Roll Tree Exporter preserves your folder structure when exporting photos from Lightroom with style.",
	}
end

function CropAndRollInfoProvider.sectionsForTopOfDialog(viewFactory, propertyTable)
	return {}
end

function CropAndRollInfoProvider.sectionsForBottomOfDialog(viewFactory, propertyTable)
	return {
		{
			title = "About Crop and Roll Tree Exporter",
			
			synopsis = "A stylish plugin to preserve folder structure during export",
			
			viewFactory:row {
				spacing = viewFactory:label_spacing(),
				
				viewFactory:static_text {
					title = "Crop and Roll Tree Exporter maintains your original folder structure when exporting photos with style and flair.",
					fill_horizontal = 1,
				},
			},
		},
	}
end

return CropAndRollInfoProvider