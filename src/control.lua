--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016  Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("prototypes.prototype")
require("script.const")
require("script.events")
require("script.lib.compat-data")
require("script.lib.pair-data")
require("util")

-- stores event IDs
local _event_uid = {}

-- generates event IDs and stores in table
local function generate_event_ids(_events)
	for k, v in pairs(_events) do
		if not(_event_uid[v]) then
			_event_uid[v] = script.generate_event_name()
		end
	end
end


-- Create shorthand references to constants and prototype data
local rl_above, rl_below = const.surface.rel_loc.above, const.surface.rel_loc.below
local st_und, st_sky, st_all = const.surface.type.underground.id, const.surface.type.sky.id, const.surface.type.all.id
local t_crude, t_basic, t_std, t_imp, t_adv = const.tier.crude, const.tier.basic, const.tier.standard, const.tier.improved, const.tier.advanced

-- register entity pair classes used by paired entities in this mod.
local entity_pair_class_data = {"access-shaft", "energy-transport", "fluid-transport", "item-transport", "rail-transport"}
pairclass.insert_array(entity_pair_class_data)

-- create a shorthand reference to the ID of each entity pair-class registered by this mod.
local pc_acc_shaft = pairclass.get("access-shaft")
local pc_energy_trans = pairclass.get("energy-transport")
local pc_fluid_trans = pairclass.get("fluid-transport")
local pc_item_trans = pairclass.get("item-transport")
local pc_rail_trans = pairclass.get("rail-transport")

-- generate event IDs
generate_event_ids({"post_chunk_generated"})

--[[
see <code>pairdata.insert(_entity_name, _paired_entity_name, _relative_location, _pair_class, _placeable_on_nauvis, _custom_data, _clear_tile_radius, _placeable_surface_type)</code> for more information.
]]
local entity_pair_data = {
	{"platform-access-shaft-lower", "platform-access-shaft-upper", rl_above, pc_acc_shaft, true, nil, 1, st_sky},
	{"platform-access-shaft-upper", "platform-access-shaft-lower", rl_below, pc_acc_shaft, false, nil, 1, st_sky},
	{"cavern-access-shaft-upper", "cavern-access-shaft-lower", rl_below, pc_acc_shaft, true, nil, 1, st_und},
	{"cavern-access-shaft-lower", "cavern-access-shaft-upper", rl_above, pc_acc_shaft, false, nil, 1, st_und},
	{"wooden-transport-chest-up", "wooden-receiver-chest-upper", rl_above, pc_item_trans, true, {tier = t_crude}},
	{"wooden-transport-chest-down", "wooden-receiver-chest-lower", rl_below, pc_item_trans, true, {tier = t_crude}},
	{"iron-transport-chest-up", "iron-receiver-chest-upper", rl_above, pc_item_trans, true, {tier = t_std}},
	{"iron-transport-chest-down", "iron-receiver-chest-lower", rl_below, pc_item_trans, true, {tier = t_std}},
	{"steel-transport-chest-up", "steel-receiver-chest-upper", rl_above, pc_item_trans, true, {tier = t_imp}},
	{"steel-transport-chest-down", "steel-receiver-chest-lower", rl_below, pc_item_trans, true, {tier = t_imp}},
	{"logistic-transport-chest-up", "logistic-receiver-chest-upper", rl_above, pc_item_trans, true, {tier = t_adv}},
	{"logistic-transport-chest-down", "logistic-receiver-chest-lower", rl_below, pc_item_trans, true, {tier = t_adv}},
	{"energy-transport-upper", "energy-transport-lower", rl_below, pc_energy_trans, true, nil, 0.5},
	{"energy-transport-lower", "energy-transport-upper", rl_above, pc_energy_trans, true, nil, 0.5},
	{"fluid-transport-upper", "fluid-transport-lower", rl_below, pc_fluid_trans, true, nil, 1},
	{"fluid-transport-lower", "fluid-transport-upper", rl_above, pc_fluid_trans, true, nil, 1},
--	{"train-stop-upper", "train-stop-lower", rl_below, pc_rail_trans, true, nil, 0.5},
--	{"train-stop-lower", "train-stop-upper", rl_above, pc_rail_trans, true, nil, 0.5}
}
pairdata.insert_array(entity_pair_data)

-- insert tiles for sky surfaces to ignore during chunk generation (pairdata.insert will insert the sky tile if it does not already exist in the skytiles array, therefore in most cases this is not necessary)
local whitelist_sky_tiles = {"wooden-floor"}	-- "wooden-floor", the prototype name
skytiles.insert_array(whitelist_sky_tiles)

-- initialise global variables
local init_globals = function()
	global.task_queue = global.task_queue or {}
	global.item_transport = global.item_transport or {}
	global.fluid_transport = global.fluid_transport or {}
	global.energy_transport = global.energy_transport or {}
	global.frozen_surfaces = global.frozen_surfaces or {}
	global.migrate_surfaces = global.migrate_surfaces or {}
	global.raise_events = global.raise_events or {}
	global.event_uid = _event_uid
end

-- mod addon data, will be loaded only if the index of the entry is present in active mods
local addon_data = {
	boblogistics = {
		{"logistic-transport-chest-2-up", "logistic-receiver-chest-2-upper", rl_above, pc_item_trans, true, {tier = t_adv, modifier = 1.5}},
		{"logistic-transport-chest-2-down", "logistic-receiver-chest-2-lower", rl_below, pc_item_trans, true, {tier = t_adv, modifier = 1.5}},
		{"fluid-transport-2-upper", "fluid-transport-2-lower", rl_below, pc_fluid_trans, true, nil, 1},
		{"fluid-transport-2-lower", "fluid-transport-2-upper", rl_above, pc_fluid_trans, true, nil, 1},
		{"fluid-transport-3-upper", "fluid-transport-3-lower", rl_below, pc_fluid_trans, true, nil, 1},
		{"fluid-transport-3-lower", "fluid-transport-3-upper", rl_above, pc_fluid_trans, true, nil, 1},
		{"fluid-transport-4-upper", "fluid-transport-4-lower", rl_below, pc_fluid_trans, true, nil, 1},
		{"fluid-transport-4-lower", "fluid-transport-4-upper", rl_above, pc_fluid_trans, true, nil, 1}
	},
	bobpower = {
		{"energy-transport-2-upper", "energy-transport-2-lower", rl_below, pc_energy_trans, true, nil, 0.5},
		{"energy-transport-2-lower", "energy-transport-2-upper", rl_above, pc_energy_trans, true, nil, 0.5},
		{"energy-transport-3-upper", "energy-transport-3-lower", rl_below, pc_energy_trans, true, nil, 0.5},
		{"energy-transport-3-lower", "energy-transport-3-upper", rl_above, pc_energy_trans, true, nil, 0.5},
		{"energy-transport-4-upper", "energy-transport-4-lower", rl_below, pc_energy_trans, true, nil, 0.5},
		{"energy-transport-4-lower", "energy-transport-4-upper", rl_above, pc_energy_trans, true, nil, 0.5}
	},
	warehousing = { -- Warehousing mod
		{"transport-storehouse-up", "receiver-storehouse-upper", rl_above, pc_item_trans, true, {tier = t_std, modifier = 8}, 1},
		{"transport-storehouse-down", "receiver-storehouse-lower", rl_below, pc_item_trans, true, {tier = t_std, modifier = 8}, 1},
		{"logistic-transport-storehouse-up", "logistic-receiver-storehouse-upper", rl_above, pc_item_trans, true, {tier = t_adv, modifier = 8}, 1},
		{"logistic-transport-storehouse-down", "logistic-receiver-storehouse-lower", rl_below, pc_item_trans, true, {tier = t_adv, modifier = 8}, 1},
		{"transport-warehouse-up", "receiver-warehouse-upper", rl_above, pc_item_trans, true, {tier = t_imp, modifier = 20}, 2},
		{"transport-warehouse-down", "receiver-warehouse-lower", rl_below, pc_item_trans, true, {tier = t_imp, modifier = 20}, 2},
		{"logistic-transport-warehouse-up", "logistic-receiver-warehouse-upper", rl_above, pc_item_trans, true, {tier = t_adv, modifier = 20}, 2},
		{"logistic-transport-warehouse-down", "logistic-receiver-warehouse-lower", rl_below, pc_item_trans, true, {tier = t_adv, modifier = 20}, 2}
	}
}
events.set_addon_data(addon_data)

-- control functions (on_init, on_load, on_config_changed)
local function on_init()
	init_globals()
end

local function on_load()

end

local function on_configuration_changed(_config_data)
	init_globals()
	local mod_changes = _config_data["mod_changes"]
	if mod_changes and mod_changes["Surfaces"] and mod_changes["Surfaces"]["old_version"] then
		local ver = _config_data["mod_changes"]["Surfaces"]["old_version"]
		local ver_parts = string.gmatch(ver, "%d+")
		local ver_rel, ver_mjr, ver_mnr = tonumber(ver_parts()), tonumber(ver_parts()), tonumber(ver_parts())
		if ver_rel == 0 and ver_mjr == 0 and ver_mnr <= 6 then
			util.broadcast("This map was saved with Surfaces version 0.0.6 or prior and requires migration, please wait until migration has been completed.")
			remote.call("Surfaces", "migrate", "_")
		end
	end
end

-- Register event handlers
script.on_init(function() on_init() end)
script.on_load(function() on_load() end)
script.on_configuration_changed(function(_config_data) on_configuration_changed(_config_data) end)

-- iterate over every event uid in defines.events and map it to it's function in events module
for k, v in pairs(defines.events) do
	if type(events[k]) == "function" then
		script.on_event(v, function(event) events[k](event) end)
	end
end
-- iterate over every event uid in _events_uid and map it to it's function in events module
for k, v in pairs(_event_uid) do
	if type(events[k]) == "function" then
		script.on_event(v, function(event) events[k](event) end)
	end
end

remote.add_interface("Surfaces", {
	["migrate"] = function(_separator)
		for k, v in pairs(api.game.surfaces()) do
			surfaces.migrate_surface(v, _separator)
		end
	end
})
