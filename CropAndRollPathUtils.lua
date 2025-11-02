--[[----------------------------------------------------------------------------

Crop and Roll Tree Exporter Path Utils

Utility functions for handling path operations and folder structure analysis.

------------------------------------------------------------------------------]]

-- Import Lightroom SDK modules
local LrPathUtils = import 'LrPathUtils'
local LrLogger = import 'LrLogger'

-- Create logger
local logger = LrLogger('CropAndRollPathUtils')

local CropAndRollPathUtils = {}

-- Function to find common root path among a set of photos
function CropAndRollPathUtils.findCommonRoot(photos)
	if not photos or #photos == 0 then
		return nil
	end
	
	-- Get all photo paths
	local paths = {}
	for _, photo in ipairs(photos) do
		local path = photo:getRawMetadata('path')
		if path then
			-- Get the directory containing the photo
			local dir = LrPathUtils.parent(path)
			table.insert(paths, dir)
		end
	end
	
	if #paths == 0 then
		return nil
	end
	
	if #paths == 1 then
		return paths[1]
	end
	
	-- Find common root by comparing path components
	local commonParts = {}
	local firstPath = paths[1]
	
	-- Split first path into components
	local firstParts = CropAndRollPathUtils.splitPath(firstPath)
	
	-- Check each component level
	for i, part in ipairs(firstParts) do
		local allMatch = true
		
		-- Check if this part matches in all other paths
		for j = 2, #paths do
			local otherParts = CropAndRollPathUtils.splitPath(paths[j])
			if not otherParts[i] or otherParts[i] ~= part then
				allMatch = false
				break
			end
		end
		
		if allMatch then
			table.insert(commonParts, part)
		else
			break
		end
	end
	
	-- Reconstruct common root path
	if #commonParts > 0 then
		return CropAndRollPathUtils.joinPath(commonParts)
	else
		return nil
	end
end

-- Function to split a path into components
function CropAndRollPathUtils.splitPath(path)
	if not path then return {} end
	
	local parts = {}
	local remaining = path
	
	while remaining and remaining ~= '' do
		local parent = LrPathUtils.parent(remaining)
		local leaf = LrPathUtils.leafName(remaining)
		
		if leaf and leaf ~= '' then
			table.insert(parts, 1, leaf)
		end
		
		if parent == remaining then
			-- We've reached the root
			break
		end
		
		remaining = parent
	end
	
	return parts
end

-- Function to join path components
function CropAndRollPathUtils.joinPath(parts)
	if not parts or #parts == 0 then
		return ''
	end
	
	local result = parts[1]
	for i = 2, #parts do
		result = LrPathUtils.child(result, parts[i])
	end
	
	return result
end

-- Function to get relative path from a base to a target
function CropAndRollPathUtils.getRelativePath(basePath, targetPath)
	if not basePath or not targetPath then
		return targetPath
	end
	
	local baseParts = CropAndRollPathUtils.splitPath(basePath)
	local targetParts = CropAndRollPathUtils.splitPath(targetPath)
	
	-- Find where paths diverge
	local commonLength = 0
	for i = 1, math.min(#baseParts, #targetParts) do
		if baseParts[i] == targetParts[i] then
			commonLength = i
		else
			break
		end
	end
	
	-- Build relative path
	local relativeParts = {}
	for i = commonLength + 1, #targetParts do
		table.insert(relativeParts, targetParts[i])
	end
	
	return CropAndRollPathUtils.joinPath(relativeParts)
end

-- Function to get a meaningful folder structure (last N levels)
function CropAndRollPathUtils.getLastNLevels(path, levels)
	levels = levels or 3
	
	if not path then
		return ''
	end
	
	local parts = CropAndRollPathUtils.splitPath(path)
	
	-- Take the last N parts
	local startIndex = math.max(1, #parts - levels + 1)
	local selectedParts = {}
	
	for i = startIndex, #parts do
		table.insert(selectedParts, parts[i])
	end
	
	return CropAndRollPathUtils.joinPath(selectedParts)
end

-- Function to find common root path among a set of file paths (not photo objects)
function CropAndRollPathUtils.findCommonRootFromPaths(paths)
	if not paths or #paths == 0 then
		return nil
	end
	
	-- Get directory paths (remove filename if present)
	local dirPaths = {}
	for _, path in ipairs(paths) do
		if path then
			local dir = LrPathUtils.parent(path)
			table.insert(dirPaths, dir)
		end
	end
	
	if #dirPaths == 0 then
		return nil
	end
	
	if #dirPaths == 1 then
		return dirPaths[1]
	end
	
	-- Find common root by comparing path components
	local commonParts = {}
	local firstPath = dirPaths[1]
	
	-- Split first path into components
	local firstParts = CropAndRollPathUtils.splitPath(firstPath)
	
	-- Check each component level
	for i, part in ipairs(firstParts) do
		local allMatch = true
		
		-- Check if this component exists in all other paths
		for j = 2, #dirPaths do
			local otherParts = CropAndRollPathUtils.splitPath(dirPaths[j])
			if not otherParts[i] or otherParts[i] ~= part then
				allMatch = false
				break
			end
		end
		
		if allMatch then
			table.insert(commonParts, part)
		else
			break
		end
	end
	
	if #commonParts == 0 then
		return nil
	end
	
	return CropAndRollPathUtils.joinPath(commonParts)
end

return CropAndRollPathUtils