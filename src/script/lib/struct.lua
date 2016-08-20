--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016  Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("config")
require("script.const")
local struct_base = require("script.lib.struct-base")
require("script.lib.util-base")

--[[--
Structures module, used to construct and validate data for use with the LuaAPI and surfaces mod.
Functions defined by this module may only be used after the data loading phase.

@module struct
]]
struct = {}

--- valid MapGenSize arguments, see the Lua-API concepts page for more information
local MapGenSize = {valid = table.reverse({"none", "very-low", "very-small", "very-poor", "low", "small", "poor", "normal", "medium", "regular", "high", "big", "good", "very-high", "very-big", "very-good"}), default = "normal"}

--- map-through for <code>struct\_base.Position(\_x, \_y)</code>
function struct.Position(_x, _y) return struct_base.Position(_x, _y) end
--- map-through for <code>struct\_base.BoundingBox(\_x1, \_y1, \_x2, \_y2)</code>
function struct.BoundingBox(_x1, _y1, _x2, _y2) return struct_base.BoundingBox(_x1,_y1,_x2,_y2) end
--- map-through for <code>struct\_base.BoundingBox\_from\_Position(\_x, \_y, \_radius\_x, \_radius\_y)</code>
function struct.BoundingBox_from_Position(_x, _y, _radius_x, _radius_y) return struct_base.BoundingBox_from_Position(_x,_y,_radius_x,_radius_y) end
--- map-through for <code>struct\_base.SimpleItemStack(\_name, \_count, \_health)</code>
function struct.SimpleItemStack(_name, _count, _health) return struct_base.SimpleItemStack(_name, _count, _health) end
--- map-through for <code>struct\_base.is\_Position(\_position)</code>
function struct.is_Position(_position) return struct_base.is_Position(_position) end
--- map-through for <code>struct\_base.is\_BoundingBox(\_boundingbox)</code>
function struct.is_BoundingBox(_boundingbox) return struct_base.is_BoundingBox(_boundingbox) end
--- map-through for <code>struct\_base.is\_SimpleItemStack(\_itemstack)</code>
function struct.is_SimpleItemStack(_itemstack) return struct_base.is_SimpleItemStack(_itemstack) end

--[[--
Constructs MapGenSettings using pre-existing MapGenSettings as a template, overriding with the fields provided

@param _mapgensettings [Required] - a valid MapGenSettings table, can be obtained through <code>game.surfaces["surface"].mapgensettings</code>
@param _remove_autoplace [Optional] - a boolean value, if true will copy all AutoplaceControls from <code>_mapgensettings</code> and set Size to "none", <code>_autoplace_controls</code> will therefore be ignored.
@param _random_seed [Optional] - a boolean value, if true a random seed will be generated and the <code>_seed</code> parameter will be ignored
@param _terrain_segmentation [Optional] - a valid MapGenSize, may not be "none"
@param _water [Optional] - a valid MapGenSize
@param _autoplace_controls [Optional] - a valid AutoplaceControls table
@param _seed [Optional] - a number value, must be no greater than 4,294,967,295, the maximum value for unsigned integers
@param _shift [Optional] - a Position, used to shift the center of the map
@param _width [Optional] - a number value, if specified, limits the width of the surface
@param _height [Optional] - a number value, if specified, limits the height of the surface
@param _starting_area [Optional] - a valid MapGenSize, specifies the size of the starting area
@param _peaceful_mode [Optional] - a boolean value, if set true this surface's enemies will not attack first
@return MapGenSettings
]]
function struct.MapGenSettings_copy(_mapgensettings, _remove_autoplace, _random_seed, _terrain_segmentation, _water, _autoplace_controls, _seed, _shift, _width, _height, _starting_area, _peaceful_mode)
	if struct.is_MapGenSettings(_mapgensettings) == true then
		local __terrain_segmentation = ((struct.is_MapGenSize(_terrain_segmentation) and _terrain_segmentation ~= "none") and _terrain_segmentation or _mapgensettings.terrain_segmentation)
		local __water = ((struct.is_MapGenSize(_water)) and _water or _mapgensettings.water)
		local __autoplace_controls = ((_remove_autoplace ~= true) and ((struct.is_AutoplaceControls(_autoplace_controls)) and _autoplace_controls or _mapgensettings.autoplace_controls) or struct.AutoplaceControls_copy(_mapgensettings.autoplace_controls, nil, "none"))
		local __seed = ((_random_seed ~= true) and (type(_seed) == "number" and math.round(_seed) or _mapgensettings.seed) or nil)
		local __shift = _shift or _mapgensettings.shift
		local __width = _width or _mapgensettings.width
		local __height = _height or _mapgensettings.height
		local __starting_area = _starting_area or _mapgensettings.starting_area
		local __peaceful_mode = ((type(_peaceful_mode) == "boolean") and _peaceful_mode or _mapgensettings.peaceful_mode)
		return struct.MapGenSettings(__terrain_segmentation, __water, __autoplace_controls, __seed, __shift, __width, __height, __starting_area, __peaceful_mode)
	end
end

--[[--
Constructs AutoplaceControls using pre-existing AutoplaceControls as a template, overriding with the fields provided

@param _autoplace_controls [Required] - a valid AutoplaceControls table
@param _frequency [Optional] - a valid MapGenSize, specifies the frequency
@param _size [Optional] - a valid MapGenSize, specifies the size
@param _richness [Optional] - a valid MapGenSize, specifies the richness
@return AutoplaceControls
]]
function struct.AutoplaceControls_copy(_autoplace_controls, _frequency, _size, _richness)
	if struct.is_AutoplaceControls(_autoplace_controls) then
		local _result = {}
		for k, v in pairs(_autoplace_controls) do
			_result[k] = struct.AutoplaceControl(struct.is_MapGenSize(_frequency) and _frequency or v.frequency, struct.is_MapGenSize(_size) and _size or v.size,
				struct.is_MapGenSize(_richness) and _richness or v.richness)
		end
		return _result
	end
end

--[[--
Constructs MapGenSettings from provided parameters

@param _terrain_segmentation [Optional] - a valid MapGenSize, may not be "none"
@param _water [Optional] - a valid MapGenSize, if invalid or not provided the default MapGenSize will be inserted.
@param _autoplace_controls [Optional] - a valid AutoplaceControls table, if not provided or invalid, an empty table will be inserted.
@param _seed [Optional] - a number value, must be no greater than 4,294,967,295. If not provided, a random seed will be generated.
@param _shift [Optional] - a Position, used to shift the center of the map
@param _width [Optional] - a number value, if specified, limits the width of the surface
@param _height [Optional] - a number value, if specified, limits the height of the surface
@param _starting_area [Optional] - a valid MapGenSize, specifies the size of the starting area. If invalid or not provided the default MapGenSize will be inserted.
@param _peaceful_mode [Optional] - a boolean value, if set true this surface's enemies will not attack first. If invalid or not provided, will default to false.
@return MapGenSettings
]]
function struct.MapGenSettings(_terrain_segmentation, _water, _autoplace_controls, _seed, _shift, _width, _height, _starting_area, _peaceful_mode)
	local result = {}
	result.terrain_segmentation = (struct.is_MapGenSize(_terrain_segmentation) and _terrain_segmentation ~= "none") and _terrain_segmentation or MapGenSize.default
	result.water = (struct.is_MapGenSize(_water)) and _water or MapGenSize.default
	result.autoplace_controls = (struct.is_AutoplaceControls(_autoplace_controls)) and _autoplace_controls or {}
	result.seed = (type(_seed) == "number") and ((_seed < const.max_uint) and math.round(_seed) or const.max_uint) or math.round(math.random() * const.max_uint)
	result.shift = (struct.is_Position(_shift)) and _shift or nil
	result.width = (type(_width) == "number") and math.round(_width) or 0
	result.height = (type(_height) == "number") and math.round(_height) or 0
	result.starting_area = (struct.is_MapGenSize(_starting_area)) and _starting_area or MapGenSize.default
	result.peaceful_mode = (type(_peaceful_mode) == "boolean") and _peaceful_mode or false
	return result
end

--[[--
Constructs AutoplaceControl from provided parameters

@param _frequency [Optional] - a valid MapGenSize, specifies the frequency
@param _size [Optional] - a valid MapGenSize, specifies the size
@param _richness [Optional] - a valid MapGenSize, specifies the richness
@return AutoplaceControl
]]
function struct.AutoplaceControl(_frequency, _size, _richness)
	return {frequency = struct.is_MapGenSize(_frequency) and _frequency or MapGenSize.default, size = struct.is_MapGenSize(_size) and _size or MapGenSize.default,
		richness = struct.is_MapGenSize(_richness) and _richness or MapGenSize.default}
end

--[[--
is this a valid Direction?

@param _direction [Required] - a Direction.
@return <code>true</code> or <code>false</code>
]]
function struct.is_Direction(_direction)
	return (_direction == defines.direction.north or _direction == defines.direction.northeast or _direction == defines.direction.east or 
		_direction == defines.direction.southeast or _direction == defines.direction.south or _direction == defines.direction.southwest or 
		_direction == defines.direction.west or _direction == defines.direction.northwest)
end

--[[--
is this a valid AutoplaceControls table?

@param _autoplace_controls [Required] - a table of AutoplaceControls.
@return <code>true</code> or <code>false</code>
]]
function struct.is_AutoplaceControls(_autoplace_controls)
	if type(_autoplace_controls) == "table" then
		for k, v in pairs(_autoplace_controls) do
			if struct.is_AutoplaceControl(v) == false then
				return false
			end
		end
		return true
	end
	return false
end

--[[--
is this a valid MapGenSize?

@param _size [Required] - MapGenSize to test.
@return <code>true</code> or <code>false</code>
]]
function struct.is_MapGenSize(_size)
	return (type(_size) == "string" and MapGenSize.valid[_size])
end

--[[--
is this a valid MapGenSettings table?

@param _mapgensettings [Required] - MapGenSettings to test.
@return <code>true</code> or <code>false</code>
]]
function struct.is_MapGenSettings(_mapgensettings)
	return (type(_mapgensettings) == "table" and type(_mapgensettings.terrain_segmentation) == "string" and type(_mapgensettings.water) == "string" and type(_mapgensettings.autoplace_controls) == "table" and type(_mapgensettings.seed) == "number" and type(_mapgensettings.width) == "number" and type(_mapgensettings.height) == "number" and type(_mapgensettings.peaceful_mode) == "boolean") and ((struct.is_MapGenSize(_mapgensettings.terrain_segmentation) == true and _mapgensettings.terrain_segmentation ~= "none") and (struct.is_MapGenSize(_mapgensettings.water) == true) and (struct.is_AutoplaceControls(_mapgensettings.autoplace_controls) == true)) or false
end

--[[--
is this a valid AutoplaceControl?

@param _autoplace_control [Required] - AutoplaceControl to test.
@return <code>true</code> or <code>false</code>
]]
function struct.is_AutoplaceControl(_autoplace_control)
	return (_autoplace_control and struct.is_MapGenSize(_autoplace_control.frequency) and struct.is_MapGenSize(_autoplace_control.size) and struct.is_MapGenSize(_autoplace_control.richness))
end

return struct
