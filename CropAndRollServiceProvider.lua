--[[----------------------------------------------------------------------------

Lightroom Tree Exporter - Export Service Provider

A Lightroom Classic plugin that preserves folder structure during export.
This module handles the main export logic, UI generation, and photo processing.

Author: Wouter Vellekoop
License: MIT
Repository: https://github.com/woutervellekoop/lightroom-tree-exporter

Features:
- Folder structure preservation
- Real-time path preview
- File naming template support  
- Subfolder creation with date placeholders
- Smart conflict handling

------------------------------------------------------------------------------]]

-- Import Lightroom SDK modules
local LrView = import 'LrView'
local LrBinding = import 'LrBinding'
local LrDialogs = import 'LrDialogs'
local LrPathUtils = import 'LrPathUtils'
local LrFileUtils = import 'LrFileUtils'
local LrErrors = import 'LrErrors'
local LrLogger = import 'LrLogger'

-- Import our utilities
local CropAndRollPathUtils = require 'CropAndRollPathUtils'

-- Create logger for debugging and monitoring
local logger = LrLogger('TreeExporter')
logger:enable("logfile")

-- Define the export service provider
local CropAndRollServiceProvider = {}

-- Export service provider properties
CropAndRollServiceProvider.exportPresetFields = {
	{ key = 'destinationPath', default = '' },
	{ key = 'subfolder', default = '' },
	{ key = 'preserveStructure', default = true },
	{ key = 'createSubfolders', default = true },
	{ key = 'skipDuplicates', default = false },
	{ key = 'pathPreview', default = 'Select a destination folder to see preview' },
}

CropAndRollServiceProvider.hideSections = { 'exportLocation' }
CropAndRollServiceProvider.allowFileFormats = nil
CropAndRollServiceProvider.allowColorSpaces = nil
CropAndRollServiceProvider.canExportVideo = false

-- This is the key difference - for Export Service Providers
CropAndRollServiceProvider.supportsIncrementalPublish = false

-- Function to validate export settings
function CropAndRollServiceProvider.canExportToTemporaryLocation()
	return true  -- Let Lightroom handle rendering, we'll move files after
end

-- Export dialog sections
function CropAndRollServiceProvider.sectionsForTopOfDialog(viewFactory, propertyTable)
	
	-- Set up property observers to update preview
	local function updatePreview()
		propertyTable.pathPreview = CropAndRollServiceProvider.generateSimplePathPreview(propertyTable)
	end
	
	-- Initialize preview
	updatePreview()
	
	-- Add observers for property changes
	propertyTable:addObserver('destinationPath', updatePreview)
	propertyTable:addObserver('subfolder', updatePreview)
	propertyTable:addObserver('preserveStructure', updatePreview)
	
	-- Also listen to Lightroom's file naming changes
	propertyTable:addObserver('LR_tokens', updatePreview)
	propertyTable:addObserver('LR_tokenCustomString', updatePreview)
	propertyTable:addObserver('LR_renamingTokensOn', updatePreview)
	
	return {
		{
			title = "Tree Exporter Settings",
			synopsis = "Configure folder structure preservation and export options",
			
			viewFactory:column {
				spacing = viewFactory:control_spacing(),
				
				-- Destination path selection
				viewFactory:row {
					spacing = 5,  -- Fixed spacing instead of related_control_spacing()
					
					viewFactory:static_text {
						title = "Export to:",
						alignment = 'right',
						width = 100  -- Fixed width instead of LrView.share
					},
					
					viewFactory:edit_field {
						value = LrView.bind 'destinationPath',
						width = 300,  -- Fixed width instead of LrView.share
						immediate = true,
					},
					
					viewFactory:push_button {
						title = "Choose...",
						action = function()
							local result = LrDialogs.runOpenPanel {
								title = "Select Export Destination",
								canChooseFiles = false,
								canChooseDirectories = true,
								allowsMultipleSelection = false,
							}
							
							if result then
								propertyTable.destinationPath = result[1]
							end
						end,
					},
				},
				
				-- Subfolder option
				viewFactory:row {
					spacing = 5,
					
					viewFactory:static_text {
						title = "Subfolder:",
						alignment = 'right',
						width = 100
					},
					
					viewFactory:edit_field {
						value = LrView.bind 'subfolder',
						width = 300,
						immediate = true,
						tooltip = "Optional subfolder name (e.g., 'Exports' or '{date}')",
					},
				},
				
				-- Structure preservation options
				viewFactory:separator { fill_horizontal = 1 },
				
				viewFactory:checkbox {
					title = "Preserve original folder structure",
					value = LrView.bind 'preserveStructure',
					checked_value = true,
				},
				
				viewFactory:checkbox {
					title = "Create subfolders if they don't exist",
					value = LrView.bind 'createSubfolders',
					checked_value = true,
				},
				
				viewFactory:checkbox {
					title = "Skip files that already exist",
					value = LrView.bind 'skipDuplicates',
					checked_value = false,
				},
				
				-- Path preview
				viewFactory:separator { fill_horizontal = 1 },
				
				viewFactory:static_text {
					title = "Preview:",
					font = "<system/bold>",
					size = "small"
				},
				
				viewFactory:static_text {
					title = "Example export path:",
					font = "<system/small>",
					size = "small"
				},
				
				viewFactory:static_text {
					title = LrView.bind 'pathPreview',
					font = "<system/small>",
					text_color = import('LrColor')(0.2, 0.6, 0.2),
					width = 500,
					height_in_lines = 3,
					tooltip = "Example of how the export path will look for the first photo"
				},
			}
		}
	}
end

-- Function to generate simple path preview that works reliably
function CropAndRollServiceProvider.generateSimplePathPreview(propertyTable)
	if not propertyTable then
		return "Loading preview..."
	end
	
	if not propertyTable.destinationPath or propertyTable.destinationPath == '' then
		return "Select a destination folder first"
	end
	
	-- Start with base path
	local basePath = propertyTable.destinationPath
	
	-- Add subfolder if specified
	if propertyTable.subfolder and propertyTable.subfolder ~= '' then
		local subfolder = propertyTable.subfolder
		if string.find(subfolder, "{date}") then
			subfolder = string.gsub(subfolder, "{date}", os.date("%Y-%m-%d"))
		end
		basePath = basePath .. "/" .. subfolder
	end
	
	-- Try to get real photo info, but don't fail if it doesn't work
	local LrApplication = import 'LrApplication'
	if not LrApplication then
		return basePath .. "/example.jpg"
	end
	
	local catalog = LrApplication.activeCatalog()
	if not catalog then
		return basePath .. "/example.jpg"
	end
	
	local photos = catalog:getTargetPhotos()
	if not photos or #photos == 0 then
		return basePath .. "/[Select photos to see real preview]"
	end
	
	local photo = photos[1]
	if not photo then
		return basePath .. "/example.jpg"
	end
	
	local photoPath = photo:getRawMetadata('path')
	if not photoPath then
		return basePath .. "/example.jpg"
	end
	
	local filename = LrPathUtils.leafName(photoPath)
	
	-- Try to get the renamed filename if file renaming is enabled
	if propertyTable.LR_renamingTokensOn then
		-- Try to generate the new filename based on Lightroom's naming template
		if propertyTable.LR_tokens then
			-- Simple approach: replace common tokens with example values
			local tokens = propertyTable.LR_tokens
			if tokens and tokens ~= '' then
				local exampleName = tokens
				local originalName = LrPathUtils.removeExtension(filename)
				
				-- Replace Lightroom tokens with example values
				exampleName = string.gsub(exampleName, "{{image_filename}}", originalName)
				exampleName = string.gsub(exampleName, "{{image_filename_number_suffix}}", "001")
				exampleName = string.gsub(exampleName, "{{custom_token}}", propertyTable.LR_tokenCustomString or "custom")
				exampleName = string.gsub(exampleName, "{{sequence}}", "001")
				exampleName = string.gsub(exampleName, "{{date_yyyy}}", "2024")
				exampleName = string.gsub(exampleName, "{{date_mm}}", "11")
				exampleName = string.gsub(exampleName, "{{date_dd}}", "01")
				
				-- Also handle the older format tokens
				exampleName = string.gsub(exampleName, "{Filename}", originalName)
				exampleName = string.gsub(exampleName, "{Original Filename}", originalName)
				exampleName = string.gsub(exampleName, "{Sequence}", "001")
				exampleName = string.gsub(exampleName, "{Custom Text}", propertyTable.LR_tokenCustomString or "custom")
				
				-- Add back the extension (note: this will show export format extension)
				local extension = LrPathUtils.extension(filename)
				filename = exampleName .. "." .. extension
			end
		end
	end
	
	-- If not preserving structure, just add filename
	if not propertyTable.preserveStructure then
		return basePath .. "/" .. filename
	end
	
	-- If preserving structure, try to calculate the relative path
	local photoDir = LrPathUtils.parent(photoPath)
	
	-- Simple approach: get last few directory levels
	local pathParts = {}
	local currentPath = photoDir
	for i = 1, 3 do
		local parent = LrPathUtils.parent(currentPath)
		if parent == currentPath then break end
		table.insert(pathParts, 1, LrPathUtils.leafName(currentPath))
		currentPath = parent
	end
	
	if #pathParts > 0 then
		local relativePath = table.concat(pathParts, "/")
		return basePath .. "/" .. relativePath .. "/" .. filename
	else
		return basePath .. "/" .. filename
	end
end

-- Function to check if we can export
function CropAndRollServiceProvider.canExportToDestination(exportSession, exportContext)
	local propertyTable = exportContext.propertyTable
	
	if not propertyTable.destinationPath or propertyTable.destinationPath == '' then
		return false, "Please select a destination folder"
	end
	
	if not LrFileUtils.exists(propertyTable.destinationPath) then
		return false, "Destination folder does not exist"
	end
	
	return true
end

-- Helper function to get base path with subfolder
function CropAndRollServiceProvider.getBasePath(exportContext)
	local propertyTable = exportContext.propertyTable
	local basePath = propertyTable.destinationPath
	
	-- Add subfolder if specified
	if propertyTable.subfolder and propertyTable.subfolder ~= '' then
		-- Replace {date} with current date if present
		local subfolder = propertyTable.subfolder
		if string.find(subfolder, "{date}") then
			subfolder = string.gsub(subfolder, "{date}", os.date("%Y-%m-%d"))
		end
		basePath = LrPathUtils.child(basePath, subfolder)
	end
	
	return basePath
end

-- Function to get export destination path for a photo
function CropAndRollServiceProvider.getDestinationPath(photo, exportContext, commonRoot)
	local basePath = CropAndRollServiceProvider.getBasePath(exportContext)
	local propertyTable = exportContext.propertyTable
	
	if not propertyTable.preserveStructure then
		return basePath
	end
	
	-- Get the photo's original path
	local photoPath = photo:getRawMetadata('path')
	if not photoPath then
		return basePath
	end
	
	-- Get just the directory part
	local photoDir = LrPathUtils.parent(photoPath)
	
	-- If we have a common root, use relative path from that
	local relativePath
	if commonRoot then
		relativePath = CropAndRollPathUtils.getRelativePath(commonRoot, photoDir)
	else
		-- Fall back to last few levels
		relativePath = CropAndRollPathUtils.getLastNLevels(photoDir, 3)
	end
	
	-- Combine base path with relative structure
	if relativePath and relativePath ~= '' then
		return LrPathUtils.child(basePath, relativePath)
	else
		return basePath
	end
end

-- Main export function - this is called by Lightroom for Export Service Providers
function CropAndRollServiceProvider.processRenderedPhotos(functionContext, exportContext)
	local exportSession = exportContext.exportSession
	local propertyTable = exportContext.propertyTable
	
	logger:info("Starting Crop and Roll Tree Exporter export process")
	
	-- Check if we have a destination path
	if not propertyTable.destinationPath or propertyTable.destinationPath == '' then
		logger:error("No destination path set")
		return
	end
	
	-- Set up progress
	local progressScope = exportContext:configureProgress {
		title = "Exporting with Crop and Roll Tree Exporter",
	}
	
	-- Get rendition count
	local renditionCount = exportSession:countRenditions()
	logger:info("Processing " .. renditionCount .. " photos")
	
	-- We'll calculate the common root on-the-fly from the selected photos in Lightroom
	-- This avoids the "call twice" issue
	local commonRoot = nil
	if propertyTable.preserveStructure then
		-- Get the common root from currently selected photos in Lightroom
		local LrApplication = import 'LrApplication'
		local catalog = LrApplication.activeCatalog()
		local photos = catalog:getTargetPhotos()
		
		if #photos > 0 then
			local photoPaths = {}
			for _, photo in ipairs(photos) do
				local photoPath = photo:getRawMetadata('path')
				if photoPath then
					table.insert(photoPaths, photoPath)
				end
			end
			
			if #photoPaths > 0 then
				commonRoot = CropAndRollPathUtils.findCommonRootFromPaths(photoPaths)
				if commonRoot then
					logger:info("Found common root: " .. commonRoot)
				else
					logger:info("No common root found, using individual paths")
				end
			end
		end
	end
	
	local processedCount = 0
	
	for i, rendition in exportContext:renditions() do
		
		-- Check for cancellation
		if progressScope:isCanceled() then 
			logger:info("Export cancelled by user")
			break 
		end
		
		-- Update progress
		progressScope:setPortionComplete(i - 1, renditionCount)
		
		-- Wait for Lightroom to render this photo to temporary location
		local success, pathOrMessage = rendition:waitForRender()
		
		if success then
			-- Get destination path for this photo (now with folder structure)
			local destPath
			if propertyTable.preserveStructure then
				destPath = CropAndRollServiceProvider.getDestinationPath(rendition.photo, exportContext, commonRoot)
			else
				destPath = CropAndRollServiceProvider.getBasePath(exportContext)
			end
			
			-- Ensure destination directory exists
			if propertyTable.createSubfolders and destPath ~= CropAndRollServiceProvider.getBasePath(exportContext) then
				LrFileUtils.createAllDirectories(destPath)
			end
			
			-- Get the rendered filename (respects Lightroom export format settings)
			local renderedFileName = LrPathUtils.leafName(pathOrMessage)
			
			-- Create final destination path using the rendered filename
			local finalPath = LrPathUtils.child(destPath, renderedFileName)
			
			-- Check for duplicates
			if LrFileUtils.exists(finalPath) and propertyTable.skipDuplicates then
				logger:info("Skipping duplicate file: " .. finalPath)
				processedCount = processedCount + 1
			else
				-- Copy the rendered file to our destination
				local copySuccess, copyError = LrFileUtils.copy(pathOrMessage, finalPath)
				if copySuccess then
					logger:info("Exported: " .. finalPath)
					processedCount = processedCount + 1
				else
					logger:error("Failed to copy file: " .. (copyError or "Unknown error"))
					if rendition and rendition.recordError then
						rendition:recordError("Failed to copy file: " .. (copyError or "Unknown error"))
					end
				end
			end
		else
			-- Render failed
			logger:error("Render failed: " .. (pathOrMessage or "Unknown error"))
			if rendition and rendition.recordError then
				rendition:recordError(pathOrMessage or "Unknown error")
			end
		end
	end
	
	progressScope:done()
	logger:info("Crop and Roll Tree Exporter export completed - processed " .. processedCount .. " files")
end

return CropAndRollServiceProvider