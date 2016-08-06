--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016  Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("script.lib.util")
local struct = require("script.lib.struct-base")

--[[
Note: This is NOT a configuration file! Data in this file is used to define prototypes during the loading sequence.
This data is referenced throughout the mod by use of the proto.get_field (during runtime) and proto.get (while loading) functions.
]]

--[[--
Prototypes module, stores most if not all of the prototype data and is used during data loading phase to construct prototype defintions.
In addition, prototype information can be obtained during runtime with the <code>proto.get\_field(\_path\_to\_field, \_field)</code> function.

@module proto
]]
proto = {}

local _prototypes = {} -- Prototype data
local _ref = {} -- Mod reference data
local _gfxbase = "__Surfaces__/graphics/"
local _gfxpath = {icon = _gfxbase .. "icons/", group = _gfxbase .. "item-group/", terrain = _gfxbase .. "terrain/", entity = _gfxbase .. "entity/"}
local _sorting_prefix = "a[surfaces]"
local _sorting_transport, _sorting_component = _sorting_prefix .. "-a[transport]", _sorting_prefix .. "-b[component]"

local function copy_data(_data, _recursive)
	local _result
	if type(_data) == "table" and _recursive then
		_result = {}
		for k, v in pairs(_data) do
			_result[k] = copy_data(v, _recursive)
		end
	else
		return _data
	end
	return _result
end

_prototypes.item_group = { -- Item Groups
	common = {type = "item-group"},
	surfaces = {name = "surfaces", icon = _gfxpath.group .. "surfaces.png", inventory_order = "surfaces", order = "surfaces"}
}

_prototypes.item_subgroup = { -- Item Subgroups
	common = {type = "item-subgroup"},
	surfaces = {
		common = {group = _prototypes.item_group.surfaces.name},
		component = {name = "surfaces-component", inventory_order = _sorting_component, order = _sorting_component},
		transport = {
			player = {name = "surfaces-transport-player", inventory_order = _sorting_transport .. "-a[player]", order = _sorting_transport .. "-a[player]"},
			power = {name = "surfaces-transport-power", inventory_order = _sorting_transport .. "-b[power]", order = _sorting_transport .. "-b[power]"},
			chest = {name = "surfaces-transport-chest", inventory_order = _sorting_transport .. "-c[chest]", order = _sorting_transport .. "-c[chest]"},
			other = {name = "surfaces-transport-other", inventory_order = _sorting_transport .. "-d[other]", order = _sorting_transport .. "-d[other]"}
		},
		tile = {name = "surfaces-tile", inventory_order = _sorting_prefix .. "c[tile]", order = _sorting_prefix .. "c[tile]"}
	}
}

_prototypes.corpse = { -- Corpses
	common = {type = "corpse"},
	invisible = {
		name = "invisible-corpse",
		icon = "__base__/graphics/terrain/blank.png",
		flags = {"placeable-neutral", "placeable-off-grid", "not-on-map"},
		animation = {},
		time_before_removed = 60,
		order = "c[corpse]-a[biter]-b[invisible]"
	}
}

_prototypes.item = { -- Items
	common = {type = "item", place_result = "", order = _sorting_prefix .. "z", stack_size = 50, group = _prototypes.item_group.surfaces.name},
	connector = {
		common = {flags = {"goes-to-main-inventory"}, stack_size = 200, subgroup = _prototypes.item_subgroup.surfaces.component.name},
		crude = {name = "crude-connector", icon = _gfxpath.icon .. "crude-connector.png", order = _sorting_component .. "-b[connector]-a[crude]"},
		basic = {name = "basic-connector", icon = _gfxpath.icon .. "basic-connector.png", order = _sorting_component .. "-b[connector]-b[basic]"},
		standard = {name = "standard-connector", icon = "__base__/graphics/icons/electronic-circuit.png", order = _sorting_component .. "-b[connector]-c[standard]"},
		improved = {name = "improved-connector", icon = "__base__/graphics/icons/advanced-circuit.png", order = _sorting_component .. "-b[connector]-d[improved]"},
		advanced = {name = "advanced-connector", icon = "__base__/graphics/icons/processing-unit.png", order = _sorting_component .. "-b[connector]-e[advanced]"}
	},
	servo = {
		common = {flags = {"goes-to-main-inventory"}, stack_size = 50, subgroup = _prototypes.item_subgroup.surfaces.component.name,
			order = _sorting_component .. "-a[servo]-z"},
		crude = {name = "crude-servo", icon = "__base__/graphics/icons/engine-unit.png", order = _sorting_component .. "-a[servo]-a[crude]"},
		standard = {name = "standard-servo", icon = "__base__/graphics/icons/engine-unit.png", order = _sorting_component .. "-a[servo]-b[standard]"},
		improved = {name = "improved-servo", icon = "__base__/graphics/icons/electric-engine-unit.png", order = _sorting_component .. "-a[servo]-c[improved]"}
	},
	electric_pole = {
		common = {flags = {"goes-to-quickbar"}, subgroup = _prototypes.item_subgroup.surfaces.transport.power.name, order = _sorting_transport .. "-b[power]-z",
			override = true},
		small = {
			common = {order = _sorting_transport .. "-b[power]-a[small]", fuel_value = "4MJ"},
			lower = {name = "small-electric-pole-lower", icon = _gfxpath.icon .. "small-electric-pole-lower.png"},
			upper = {name = "small-electric-pole-upper", icon = _gfxpath.icon .. "small-electric-pole-upper.png"}
		},
		medium = {
			common = {order = _sorting_transport .. "-b[power]-b[medium]"},
			upper = {name = "medium-electric-pole-upper", icon = _gfxpath.icon .. "medium-electric-pole-upper.png"},
			lower = {name = "medium-electric-pole-lower", icon = _gfxpath.icon .. "medium-electric-pole-lower.png"}
		},
		medium_2 = {
			common = {order = _sorting_transport .. "-b[power]-b[medium-2]"},
			upper = {name = "medium-electric-pole-2-upper", icon = _gfxpath.icon .. "medium-electric-pole-2-upper.png"},
			lower = {name = "medium-electric-pole-2-lower", icon = _gfxpath.icon .. "medium-electric-pole-2-lower.png"}
		},
		medium_3 = {
			common = {order = _sorting_transport .. "-b[power]-b[medium-3]"},
			upper = {name = "medium-electric-pole-3-upper", icon = _gfxpath.icon .. "medium-electric-pole-3-upper.png"},
			lower = {name = "medium-electric-pole-3-lower", icon = _gfxpath.icon .. "medium-electric-pole-3-lower.png"}
		},
		medium_4 = {
			common = {order = _sorting_transport .. "-b[power]-b[medium-4]"},
			upper = {name = "medium-electric-pole-4-upper", icon = _gfxpath.icon .. "medium-electric-pole-4-upper.png"},
			lower = {name = "medium-electric-pole-4-lower", icon = _gfxpath.icon .. "medium-electric-pole-4-lower.png"}
		},
		big = {
			common = {order = _sorting_transport .. "-b[power]-c[big]"},
			upper = {name = "big-electric-pole-upper", icon = _gfxpath.icon .. "big-electric-pole-upper.png"},
			lower = {name = "big-electric-pole-lower", icon = _gfxpath.icon .. "big-electric-pole-lower.png"}
		},
		big_2 = {
			common = {order = _sorting_transport .. "-b[power]-c[big-2]"},
			upper = {name = "big-electric-pole-2-upper", icon = _gfxpath.icon .. "big-electric-pole-2-upper.png"},
			lower = {name = "big-electric-pole-2-lower", icon = _gfxpath.icon .. "big-electric-pole-2-lower.png"}
		},
		big_3 = {
			common = {order = _sorting_transport .. "-b[power]-c[big-3]"},
			upper = {name = "big-electric-pole-3-upper", icon = _gfxpath.icon .. "big-electric-pole-3-upper.png"},
			lower = {name = "big-electric-pole-3-lower", icon = _gfxpath.icon .. "big-electric-pole-3-lower.png"}
		},
		big_4 = {
			common = {order = _sorting_transport .. "-b[power]-c[big-4]"},
			upper = {name = "big-electric-pole-4-upper", icon = _gfxpath.icon .. "big-electric-pole-4-upper.png"},
			lower = {name = "big-electric-pole-4-lower", icon = _gfxpath.icon .. "big-electric-pole-4-lower.png"}
		},
		substation = {
			common = {order = _sorting_transport .. "-b[power]-d[substation]"},
			upper = {name = "substation-upper", icon = _gfxpath.icon .. "substation-upper.png"},
			lower = {name = "substation-lower", icon = _gfxpath.icon .. "substation-lower.png"}
		},
		substation_2 = {
			common = {order = _sorting_transport .. "-b[power]-d[substation-2]"},
			upper = {name = "substation-2-upper", icon = _gfxpath.icon .. "substation-2-upper.png"},
			lower = {name = "substation-2-lower", icon = _gfxpath.icon .. "substation-2-lower.png"}
		},
		substation_3 = {
			common = {order = _sorting_transport .. "-b[power]-d[substation-3]"},
			upper = {name = "substation-3-upper", icon = _gfxpath.icon .. "substation-3-upper.png"},
			lower = {name = "substation-3-lower", icon = _gfxpath.icon .. "substation-3-lower.png"}
		},
		substation_4 = {
			common = {order = _sorting_transport .. "-b[power]-d[substation-4]"},
			upper = {name = "substation-4-upper", icon = _gfxpath.icon .. "substation-4-upper.png"},
			lower = {name = "substation-4-lower", icon = _gfxpath.icon .. "substation-4-lower.png"}
		}
	},
	access_shaft = {
		common = {flags = {"goes-to-quickbar"}, stack_size = 1, order = _sorting_transport .. "-a[player]", fuel_value = "12MJ",
			subgroup = _prototypes.item_subgroup.surfaces.transport.player.name, override = true},
		sky_entrance = {name = "sky-entrance", icon = _gfxpath.icon .. "sky-entrance.png"},
		sky_exit = {name = "sky-exit", icon = _gfxpath.icon .. "sky-exit.png"},
		underground_entrance = {name = "underground-entrance", icon = _gfxpath.icon .. "underground-entrance.png"},
		underground_exit = {name = "underground-exit", icon = _gfxpath.icon .. "underground-exit.png"}
	},
	rail_transport = {
		common = {flags = {"goes-to-quickbar"}, stack_size = 10, order = _sorting_transport .. "-d[other]-b[rail-transport]-z",
			subgroup = _prototypes.item_subgroup.surfaces.transport.other.name, override = true},
		standard = {
			upper = {name = "train-stop-upper", icon = _gfxpath.icon .. "train-stop-upper.png"},
			lower = {name = "train-stop-lower", icon = _gfxpath.icon .. "train-stop-lower.png"}
		}
	},
	fluid_transport = {
		common = {flags = {"goes-to-quickbar"}, order = _sorting_transport .. "-d[other]-a[fluid-transport]-z", 
			subgroup = _prototypes.item_subgroup.surfaces.transport.other.name, override = true},
		standard = {
			common = {order = _sorting_transport .. "-d[other]-a[fluid-transport]-a[standard]"},
			upper = {name = "fluid-transport-upper", icon = _gfxpath.icon .. "fluid-transport-upper.png"},
			lower = {name = "fluid-transport-lower", icon = _gfxpath.icon .. "fluid-transport-lower.png"}
		},
		standard_2 = {
			common = {order = _sorting_transport .. "-d[other]-a[fluid-transport]-a[standard-2]"},
			upper = {name = "fluid-transport-2-upper", icon = _gfxpath.icon .. "fluid-transport-2-upper.png"},
			lower = {name = "fluid-transport-2-lower", icon = _gfxpath.icon .. "fluid-transport-2-lower.png"}		
		},
		standard_3 = {
			common = {order = _sorting_transport .. "-d[other]-a[fluid-transport]-a[standard-3]"},
			upper = {name = "fluid-transport-3-upper", icon = _gfxpath.icon .. "fluid-transport-3-upper.png"},
			lower = {name = "fluid-transport-3-lower", icon = _gfxpath.icon .. "fluid-transport-3-lower.png"}		
		},
		standard_4 = {
			common = {order = _sorting_transport .. "-d[other]-a[fluid-transport]-a[standard-4]"},
			upper = {name = "fluid-transport-4-upper", icon = _gfxpath.icon .. "fluid-transport-4-upper.png"},
			lower = {name = "fluid-transport-4-lower", icon = _gfxpath.icon .. "fluid-transport-4-lower.png"}		
		}
	},
	transport_chest = {
		common = {flags = {"goes-to-quickbar"}, order = _sorting_transport .. "-c[chest]-z", subgroup = _prototypes.item_subgroup.surfaces.transport.chest.name,
			override = true},
		wood = {
			common = {order = _sorting_transport .. "-c[chest]-a[wood]", fuel_value = "6MJ"},
			up = {name = "wooden-transport-chest-up", icon = _gfxpath.icon .. "wooden-transport-chest-up.png"},
			down = {name = "wooden-transport-chest-down", icon = _gfxpath.icon .. "wooden-transport-chest-down.png"}
		},
		iron = {
			common = {order = _sorting_transport .. "-c[chest]-b[iron]"},
			up = {name = "iron-transport-chest-up", icon = _gfxpath.icon .. "iron-transport-chest-up.png"},
			down = {name = "iron-transport-chest-down", icon = _gfxpath.icon .. "iron-transport-chest-down.png"}
		},
		steel = {
			common = {order = _sorting_transport .. "-c[chest]-c[steel]"},
			up = {name = "steel-transport-chest-up", icon = _gfxpath.icon .. "steel-transport-chest-up.png"},
			down = {name = "steel-transport-chest-down", icon = _gfxpath.icon .. "steel-transport-chest-down.png"}
		},
		logistic = {
			common = {order = _sorting_transport .. "-c[chest]-d[logistic]"},
			up = {name = "logistic-transport-chest-up", icon = _gfxpath.icon .. "logistic-transport-chest-up.png"},
			down = {name = "logistic-transport-chest-down", icon = _gfxpath.icon .. "logistic-transport-chest-down.png"}
		},
		logistic_2 = {
			common = {order = _sorting_transport .. "-c[chest]-d[logistic-2]"},
			up = {name = "logistic-transport-chest-2-up", icon = _gfxpath.icon .. "logistic-transport-chest-2-up.png"},
			down = {name = "logistic-transport-chest-2-down", icon = _gfxpath.icon .. "logistic-transport-chest-2-down.png"}
		},
		storehouse = {
			common = {order = _sorting_transport .. "-c[chest]-e[warehousing]-a[storehouse]"},
			up = {name = "transport-storehouse-up", icon = _gfxpath.icon .. "transport-storehouse-up.png"},
			down = {name = "transport-storehouse-down", icon = _gfxpath.icon .. "transport-storehouse-down.png"}
		},
		logistic_storehouse = {
			common = {order = _sorting_transport .. "-c[chest]-e[warehousing]-a[storehouse-logistic]"},
			up = {name = "logistic-transport-storehouse-up", icon = _gfxpath.icon .. "logistic-transport-storehouse-up.png"},
			down = {name = "logistic-transport-storehouse-down", icon = _gfxpath.icon .. "logistic-transport-storehouse-down.png"}
		},
		warehouse = {
			common = {order = _sorting_transport .. "-c[chest]-e[warehousing]-b[warehouse]"},
			up = {name = "transport-warehouse-up", icon = _gfxpath.icon .. "transport-warehouse-up.png"},
			down = {name = "transport-warehouse-down", icon = _gfxpath.icon .. "transport-warehouse-down.png"}
		},
		logistic_warehouse = {
			common = {order = _sorting_transport .. "-c[chest]-e[warehousing]-b[warehouse-logistic]"},
			up = {name = "logistic-transport-warehouse-up", icon = _gfxpath.icon .. "logistic-transport-warehouse-up.png"},
			down = {name = "logistic-transport-warehouse-down", icon = _gfxpath.icon .. "logistic-transport-warehouse-down.png"}
		}
	},
	floor = {
		common = {flags = {"goes-to-main-inventory"}, place_as_tile = {condition_size = 4, condition = {"water-tile"}}, stack_size = 100, order = _sorting_prefix .. "c[tile]", subgroup = _prototypes.item_subgroup.surfaces.tile.name},
		wood = {name = "wooden-floor", icon = _gfxpath.icon .. "wooden-floor.png", fuel_value = "8MJ"}
	}
}

_prototypes.entity = {
	common = {max_health = 100, corpse = "small-remnants", order = _sorting_prefix .. "z"},
	underground_wall = {
		name = "underground-wall",
		type = "tree",
		icon = _gfxpath.icon .. "underground-wall.png",
		flags = {"placeable-neutral"},
		order = _sorting_prefix .. "a[underground-wall]",
		collision_box = {{-0.499, -0.499}, {0.499, 0.499}},
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
		minable = {hardness = 2, mining_time = 2, mining_particle = "stone-particle", results = {{type = "item", name = "stone", probability = 1, amount_min = 1, amount_max = 4}}},
		pictures = {
			struct.Picture(_gfxpath.terrain .. "underground-wall-main.png", "medium", 32, 32),
			struct.Picture(_gfxpath.terrain .. "underground-wall-main-2.png", "medium", 32, 32),
			struct.Picture(_gfxpath.terrain .. "underground-wall-main-3.png", "medium", 32, 32),
			struct.Picture(_gfxpath.terrain .. "underground-wall-main-4.png", "medium", 32, 32)
		},
		mined_sound = struct.Sound("__base__/sound/deconstruct-bricks.ogg"),
		resistances = struct.Resistances({{"impact", 80, 5}, {"fire", 100}, {"explosion", 5, 2}}),
		corpse = _prototypes.corpse.invisible.name,
		vehicle_impact_sound = struct.Sound("__base__/sound/car-stone-impact.ogg", 1.0),
		map_color = util.RGB(60, 52, 36),
	},
	access_shaft = {
		common = {
			type = "simple-entity", 
			flags = {},
			collision_mask = {"object-layer", "player-layer"},
			order = _prototypes.item.access_shaft.common.order,
			subgroup = _prototypes.item.access_shaft.common.subgroup,
			collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
			selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
			resistances = struct.Resistances({{"impact", 20, 2}, {"fire", 10, 3}}),
			minable = {hardness = 1, mining_time = 8},
			render_layer = "object",
			map_color = util.RGB(127, 88, 43, 50),
			override = true
		},
		underground_entrance = {name = _prototypes.item.access_shaft.underground_entrance.name, icon = _prototypes.item.access_shaft.underground_entrance.icon,
			pictures = struct.Picture(_gfxpath.entity .. _prototypes.item.access_shaft.underground_exit.name .. ".png", "medium", 96, 96)
		},
		underground_exit = {name = _prototypes.item.access_shaft.underground_exit.name, icon = _prototypes.item.access_shaft.underground_exit.icon,
			pictures = struct.Picture(_gfxpath.entity .. _prototypes.item.access_shaft.underground_exit.name .. ".png", "medium", 96, 96)
		},
		sky_entrance = {name = _prototypes.item.access_shaft.sky_entrance.name, icon = _prototypes.item.access_shaft.sky_entrance.icon,
			pictures = struct.Picture(_gfxpath.entity .. _prototypes.item.access_shaft.underground_exit.name .. ".png", "medium", 96, 96)
		},
		sky_exit = {name = _prototypes.item.access_shaft.sky_exit.name, icon = _prototypes.item.access_shaft.sky_exit.icon,
			pictures = struct.Picture(_gfxpath.entity .. _prototypes.item.access_shaft.underground_exit.name .. ".png", "medium", 96, 96)
		}
	},
	fluid_transport = {
		common = {type = "storage-tank", order = _prototypes.item.fluid_transport.common.order, override = true},
		standard = {
			common = {order = _prototypes.item.fluid_transport.standard.order},
			upper = {name = _prototypes.item.fluid_transport.standard.upper.name, icon = _prototypes.item.fluid_transport.standard.upper.icon},
			lower = {name = _prototypes.item.fluid_transport.standard.lower.name, icon = _prototypes.item.fluid_transport.standard.lower.icon}
		},
		standard_2 = {
			common = {order = _prototypes.item.fluid_transport.standard_2.order},
			upper = {name = _prototypes.item.fluid_transport.standard_2.upper.name, icon = _prototypes.item.fluid_transport.standard_2.upper.icon},
			lower = {name = _prototypes.item.fluid_transport.standard_2.lower.name, icon = _prototypes.item.fluid_transport.standard_2.lower.icon}
		},
		standard_3 = {
			common = {order = _prototypes.item.fluid_transport.standard_3.order},
			upper = {name = _prototypes.item.fluid_transport.standard_3.upper.name, icon = _prototypes.item.fluid_transport.standard_3.upper.icon},
			lower = {name = _prototypes.item.fluid_transport.standard_3.lower.name, icon = _prototypes.item.fluid_transport.standard_3.lower.icon}
		},
		standard_4 = {
			common = {order = _prototypes.item.fluid_transport.standard_4.order},
			upper = {name = _prototypes.item.fluid_transport.standard_4.upper.name, icon = _prototypes.item.fluid_transport.standard_4.upper.icon},
			lower = {name = _prototypes.item.fluid_transport.standard_4.lower.name, icon = _prototypes.item.fluid_transport.standard_4.lower.icon}
		}
	},
	electric_pole = {
		common = {order = _prototypes.item.electric_pole.common.order, subgroup = _prototypes.item.electric_pole.common.subgroup, override = true},
		small = {
			common = {order = _prototypes.item.electric_pole.small.common.order},
			upper = {name = _prototypes.item.electric_pole.small.upper.name, icon = _prototypes.item.electric_pole.small.upper.icon},
			lower = {name = _prototypes.item.electric_pole.small.lower.name, icon = _prototypes.item.electric_pole.small.lower.icon}
		},
		medium = {
			common = {order = _prototypes.item.electric_pole.medium.common.order},
			upper = {name = _prototypes.item.electric_pole.medium.upper.name, icon = _prototypes.item.electric_pole.medium.upper.icon},
			lower = {name = _prototypes.item.electric_pole.medium.lower.name, icon = _prototypes.item.electric_pole.medium.lower.icon}
		},
		medium_2 = {
			common = {order = _prototypes.item.electric_pole.medium_2.common.order},
			upper = {name = _prototypes.item.electric_pole.medium_2.upper.name, icon = _prototypes.item.electric_pole.medium_2.upper.icon},
			lower = {name = _prototypes.item.electric_pole.medium_2.lower.name, icon = _prototypes.item.electric_pole.medium_2.lower.icon}
		},
		medium_3 = {
			common = {order = _prototypes.item.electric_pole.medium_3.common.order},
			upper = {name = _prototypes.item.electric_pole.medium_3.upper.name, icon = _prototypes.item.electric_pole.medium_3.upper.icon},
			lower = {name = _prototypes.item.electric_pole.medium_3.lower.name, icon = _prototypes.item.electric_pole.medium_3.lower.icon}
		},
		medium_4 = {
			common = {order = _prototypes.item.electric_pole.medium_4.common.order},
			upper = {name = _prototypes.item.electric_pole.medium_4.upper.name, icon = _prototypes.item.electric_pole.medium_4.upper.icon},
			lower = {name = _prototypes.item.electric_pole.medium_4.lower.name, icon = _prototypes.item.electric_pole.medium_4.lower.icon}
		},
		big = {
			common = {order = _prototypes.item.electric_pole.big.common.order},
			upper = {name = _prototypes.item.electric_pole.big.upper.name, icon = _prototypes.item.electric_pole.big.upper.icon},
			lower = {name = _prototypes.item.electric_pole.big.lower.name, icon = _prototypes.item.electric_pole.big.lower.icon}
		},
		big_2 = {
			common = {order = _prototypes.item.electric_pole.big_2.common.order},
			upper = {name = _prototypes.item.electric_pole.big_2.upper.name, icon = _prototypes.item.electric_pole.big_2.upper.icon},
			lower = {name = _prototypes.item.electric_pole.big_2.lower.name, icon = _prototypes.item.electric_pole.big_2.lower.icon}
		},
		big_3 = {
			common = {order = _prototypes.item.electric_pole.big_3.common.order},
			upper = {name = _prototypes.item.electric_pole.big_3.upper.name, icon = _prototypes.item.electric_pole.big_3.upper.icon},
			lower = {name = _prototypes.item.electric_pole.big_3.lower.name, icon = _prototypes.item.electric_pole.big_3.lower.icon}
		},
		big_4 = {
			common = {order = _prototypes.item.electric_pole.big_4.common.order},
			upper = {name = _prototypes.item.electric_pole.big_4.upper.name, icon = _prototypes.item.electric_pole.big_4.upper.icon},
			lower = {name = _prototypes.item.electric_pole.big_4.lower.name, icon = _prototypes.item.electric_pole.big_4.lower.icon}
		},
		substation = {
			common = {order = _prototypes.item.electric_pole.substation.common.order},
			upper = {name = _prototypes.item.electric_pole.substation.upper.name, icon = _prototypes.item.electric_pole.substation.upper.icon},
			lower = {name = _prototypes.item.electric_pole.substation.lower.name, icon = _prototypes.item.electric_pole.substation.lower.icon}
		},
		substation_2 = {
			common = {order = _prototypes.item.electric_pole.substation_2.common.order},
			upper = {name = _prototypes.item.electric_pole.substation_2.upper.name, icon = _prototypes.item.electric_pole.substation_2.upper.icon},
			lower = {name = _prototypes.item.electric_pole.substation_2.lower.name, icon = _prototypes.item.electric_pole.substation_2.lower.icon}
		},
		substation_3 = {
			common = {order = _prototypes.item.electric_pole.substation_3.common.order},
			upper = {name = _prototypes.item.electric_pole.substation_3.upper.name, icon = _prototypes.item.electric_pole.substation_3.upper.icon},
			lower = {name = _prototypes.item.electric_pole.substation_3.lower.name, icon = _prototypes.item.electric_pole.substation_3.lower.icon}
		},
		substation_4 = {
			common = {order = _prototypes.item.electric_pole.substation_4.common.order},
			upper = {name = _prototypes.item.electric_pole.substation_4.upper.name, icon = _prototypes.item.electric_pole.substation_4.upper.icon},
			lower = {name = _prototypes.item.electric_pole.substation_4.lower.name, icon = _prototypes.item.electric_pole.substation_4.lower.icon}
		},
	},
	rail_transport = {
		common = {order = _prototypes.item.rail_transport.common.order, subgroup = _prototypes.item.rail_transport.common.subgroup, override = true},
		standard = {
			upper = {name = _prototypes.item.rail_transport.standard.upper.name, icon = _prototypes.item.rail_transport.standard.upper.icon},
			lower = {name = _prototypes.item.rail_transport.standard.lower.name, icon = _prototypes.item.rail_transport.standard.lower.icon}
		}
	},
	transport_chest = {
		common = {order = _prototypes.item.transport_chest.common.order, subgroup = _prototypes.item.transport_chest.common.subgroup, override = true},
		wood = {
			common = {order = _prototypes.item.transport_chest.wood.common.order},
			down = {name = _prototypes.item.transport_chest.wood.down.name, icon = _prototypes.item.transport_chest.wood.down.icon},
			up = {name = _prototypes.item.transport_chest.wood.up.name, icon = _prototypes.item.transport_chest.wood.up.icon}
		},
		iron = {
			common = {order = _prototypes.item.transport_chest.iron.common.order},
			down = {name = _prototypes.item.transport_chest.iron.down.name, icon = _prototypes.item.transport_chest.iron.down.icon},
			up = {name = _prototypes.item.transport_chest.iron.up.name, icon = _prototypes.item.transport_chest.iron.up.icon}
		},
		steel = {
			common = {order = _prototypes.item.transport_chest.steel.common.order},
			down = {name = _prototypes.item.transport_chest.steel.down.name, icon = _prototypes.item.transport_chest.steel.down.icon},
			up = {name = _prototypes.item.transport_chest.steel.up.name, icon = _prototypes.item.transport_chest.steel.up.icon}
		},
		logistic = {
			common = {order = _prototypes.item.transport_chest.logistic.common.order},
			down = {name = _prototypes.item.transport_chest.logistic.down.name, icon = _prototypes.item.transport_chest.logistic.down.icon},
			up = {name = _prototypes.item.transport_chest.logistic.up.name, icon = _prototypes.item.transport_chest.logistic.up.icon}
		},
		logistic_2 = {
			common = {order = _prototypes.item.transport_chest.logistic_2.common.order},
			down = {name = _prototypes.item.transport_chest.logistic_2.down.name, icon = _prototypes.item.transport_chest.logistic_2.down.icon},
			up = {name = _prototypes.item.transport_chest.logistic_2.up.name, icon = _prototypes.item.transport_chest.logistic_2.up.icon}
		},
		storehouse = {
			common = {order = _prototypes.item.transport_chest.storehouse.common.order},
			down = {name = _prototypes.item.transport_chest.storehouse.down.name, icon = _prototypes.item.transport_chest.storehouse.down.icon},
			up = {name = _prototypes.item.transport_chest.storehouse.up.name, icon = _prototypes.item.transport_chest.storehouse.up.icon}
		},
		logistic_storehouse = {
			common = {order = _prototypes.item.transport_chest.logistic_storehouse.common.order},
			down = {name = _prototypes.item.transport_chest.logistic_storehouse.down.name, icon = _prototypes.item.transport_chest.logistic_storehouse.down.icon},
			up = {name = _prototypes.item.transport_chest.logistic_storehouse.up.name, icon = _prototypes.item.transport_chest.logistic_storehouse.up.icon}
		},
		warehouse = {
			common = {order = _prototypes.item.transport_chest.warehouse.common.order},
			down = {name = _prototypes.item.transport_chest.warehouse.down.name, icon = _prototypes.item.transport_chest.warehouse.down.icon},
			up = {name = _prototypes.item.transport_chest.warehouse.up.name, icon = _prototypes.item.transport_chest.warehouse.up.icon}
		},
		logistic_warehouse = {
			common = {order = _prototypes.item.transport_chest.logistic_warehouse.common.order},
			down = {name = _prototypes.item.transport_chest.logistic_warehouse.down.name, icon = _prototypes.item.transport_chest.logistic_warehouse.down.icon},
			up = {name = _prototypes.item.transport_chest.logistic_warehouse.up.name, icon = _prototypes.item.transport_chest.logistic_warehouse.up.icon}
		},
	},
	receiver_chest = {
		common = {flags = {}, override = true},
		wood = {
			lower = {name = "wooden-receiver-chest-lower", override_result = _prototypes.item.transport_chest.wood.down.name},
			upper = {name = "wooden-receiver-chest-upper", override_result = _prototypes.item.transport_chest.wood.up.name}
		},
		iron = {
			lower = {name = "iron-receiver-chest-lower", override_result = _prototypes.item.transport_chest.iron.down.name},
			upper = {name = "iron-receiver-chest-upper", override_result = _prototypes.item.transport_chest.iron.up.name}
		},
		steel = {
			lower = {name = "steel-receiver-chest-lower", override_result = _prototypes.item.transport_chest.steel.down.name},
			upper = {name = "steel-receiver-chest-upper", override_result = _prototypes.item.transport_chest.steel.up.name}
		},
		logistic = {
			lower = {name = "logistic-receiver-chest-lower", override_result = _prototypes.item.transport_chest.logistic.down.name},
			upper = {name = "logistic-receiver-chest-upper", override_result = _prototypes.item.transport_chest.logistic.up.name}
		},
		logistic_2 = {
			lower = {name = "logistic-receiver-chest-2-lower", override_result = _prototypes.item.transport_chest.logistic_2.down.name},
			upper = {name = "logistic-receiver-chest-2-upper", override_result = _prototypes.item.transport_chest.logistic_2.up.name}
		},
		storehouse = {
			lower = {name = "receiver-storehouse-lower", override_result = _prototypes.item.transport_chest.storehouse.down.name},
			upper = {name = "receiver-storehouse-upper", override_result = _prototypes.item.transport_chest.storehouse.up.name}
		},
		logistic_storehouse = {
			lower = {name = "logistic-receiver-storehouse-lower", override_result = _prototypes.item.transport_chest.logistic_storehouse.down.name},
			upper = {name = "logistic-receiver-storehouse-upper", override_result = _prototypes.item.transport_chest.logistic_storehouse.up.name}
		},
		warehouse = {
			lower = {name = "receiver-warehouse-lower", override_result = _prototypes.item.transport_chest.warehouse.down.name},
			upper = {name = "receiver-warehouse-upper", override_result = _prototypes.item.transport_chest.warehouse.up.name}
		},
		logistic_warehouse = {
			lower = {name = "logistic-receiver-warehouse-lower", override_result = _prototypes.item.transport_chest.logistic_warehouse.down.name},
			upper = {name = "logistic-receiver-warehouse-upper", override_result = _prototypes.item.transport_chest.logistic_warehouse.up.name}
		}
	}
}

_prototypes.technology = { -- Technology

}

_prototypes.tile = { -- Tiles
	common = {type = "tile", decorative_removal_probability = 1, collision_mask = {"ground-tile"}, needs_correction = false, 
		ageing = 0, group = _prototypes.item_group.surfaces.name
	},
	underground_dirt = {
		name = "underground-dirt",
		icon = _gfxpath.icon .. "underground-dirt.png",
		layer = 45,
		variants = struct.Variants(_gfxpath.terrain, "underground-dirt", {4,0,0,0,0,0}, {1}),
		walking_speed_modifier = 0.8,
		map_color = util.RGB(107, 44, 4)
	},
	sky_void = {
		name = "sky-void",
		icon = _gfxpath.icon .. "sky-void.png",
		layer = 45,
		collision_mask = {"ground-tile", "resource-layer", "floor-layer", "item-layer", "object-layer", "player-layer", "doodad-layer"},
		variants = struct.Variants(_gfxpath.terrain, "sky-void", {2,1,1,1,1,1}, {1}),
		map_color = util.RGB(145, 212, 252)
	},
	underground_wall = {
		name = "underground-wall",
		icon = _gfxpath.icon .. "underground-wall.png",
		layer = 46,
		collision_mask = {"floor-layer", "item-layer", "doodad-layer"},
		variants = struct.Variants(_gfxpath.terrain, "underground-wall", {0,1,1,1,1,1}, {0}),
		map_color = util.RGB(60, 52, 36)
	},
	floor = {
		common = {minable = {hardness = 0.2, mining_time = 0.5}, walking_speed_modifier = 1, subgroup = _prototypes.item_subgroup.surfaces.tile.name},
		wood = {
			name = _prototypes.item.floor.wood.name,
			layer = 59,
			variants = struct.Variants(_gfxpath.terrain, _prototypes.item.floor.wood.name, {1,1,1,1,1,1}, {1}),
			map_color = util.RGB(153, 123, 86)
		}
	}
}

_ref.warehousing = { -- Warehousing mod
	item = {
		active_provider_warehouse = "warehouse-active-provider",
		passive_provider_warehouse = "warehouse-passive-provider",
		storage_warehouse = "warehouse-storage",
		requester_warehouse = "warehouse-requester",
		warehouse = "warehouse-basic",
		active_provider_storehouse = "storehouse-active-provider",
		passive_provider_storehouse = "storehouse-passive-provider",
		storage_storehouse = "storehouse-storage",
		requester_storehouse = "storehouse-requester",
		storehouse = "storehouse-basic"
	},
	technology = {
		logistics = {name = "warehouse-logistics-research"},
		warehouse = {name = "warehouse-research"}
	}
}
_ref.warehousing.entity = _ref.warehousing.item -- entity names and item names are identical, no point defining duplicate data
_ref.bobpower = { -- Bob's Power mod
	item = {
		medium_electric_pole_2 = "medium-electric-pole-2",
		medium_electric_pole_3 = "medium-electric-pole-3",
		medium_electric_pole_4 = "medium-electric-pole-4",
		big_electric_pole_2 = "big-electric-pole-2",
		big_electric_pole_3 = "big-electric-pole-3",
		big_electric_pole_4 = "big-electric-pole-4",
		substation_2 = "substation-2",
		substation_3 = "substation-3",
		substation_4 = "substation-4"
	}
}
_ref.bobpower.entity = _ref.bobpower.item -- entity names and item names are identical, no point defining duplicate data
_ref.boblogistics = { -- Bob's Logistics mod
	item = {
		passive_provider_chest_2 = "logistic-chest-passive-provider-2",
		active_provider_chest_2 = "logistic-chest-active-provider-2",
		requester_chest_2 = "logistic-chest-requester-2",
		storage_chest_2 = "logistic-chest-storage-2",
		storage_tank_2 = "storage-tank-2",
		storage_tank_3 = "storage-tank-3",
		storage_tank_4 = "storage-tank-4"		
	}
}
_ref.boblogistics.entity = _ref.boblogistics.item -- entity names and item names are identical, no point defining duplicate data

_prototypes.recipe = { -- Recipes
	common = {type = "recipe", result_count = 1, enabled = true, override = true},
	connector = {
		common = {energy_required = 1, subgroup = _prototypes.item_subgroup.surfaces.component.name},
		crude = {name = _prototypes.item.connector.crude.name, ingredients = {{_prototypes.item.servo.crude.name, 1}, {"wood", 4}}},
		basic = {name = _prototypes.item.connector.basic.name, ingredients = {{_prototypes.item.servo.crude.name, 2}, {"copper-cable", 2},
			{"electronic-circuit", 1}}},
		standard = {name = _prototypes.item.connector.standard.name, ingredients = {{_prototypes.item.servo.standard.name, 1}, {"copper-cable", 4},
			{"electronic-circuit", 2}}},
		improved = {name = _prototypes.item.connector.improved.name, ingredients = {{_prototypes.item.servo.standard.name, 2}, {"copper-cable", 2},
			{"advanced-circuit", 1}}},
		advanced = {name = _prototypes.item.connector.advanced.name, ingredients = {{_prototypes.item.servo.improved.name, 2}, {"copper-cable", 2},
			{"green-wire", 2}, {"red-wire", 2}, {"advanced-circuit", 2}}}
	},
	servo = {
		common = {subgroup = _prototypes.item_subgroup.surfaces.component.name},
		crude = {name = _prototypes.item.servo.crude.name, ingredients = {{"copper-plate", 4}, {"iron-gear-wheel", 2}, {"iron-stick", 2}}, energy_required = 2},
		standard = {name = _prototypes.item.servo.standard.name, ingredients = {{_prototypes.item.servo.crude.name, 1}, {"iron-gear-wheel", 2}, {"steel-plate", 2}},
			energy_required = 4},
		improved = {name = _prototypes.item.servo.improved.name, category = "crafting-with-fluid", ingredients = {{_prototypes.item.servo.standard.name, 1},
			{type = "fluid", name = "lubricant", amount = 4}, {"steel-plate", 4}}, energy_required = 8}
	},
	access_shaft = {
		common = {ingredients = {{"raw-wood", 20}, {"steel-plate", 8}}, energy_required = 15, subgroup = _prototypes.item_subgroup.surfaces.transport.player.name},
		sky_entrance = {name = _prototypes.item.access_shaft.sky_entrance},
		sky_exit = {name = _prototypes.item.access_shaft.sky_exit},
		underground_entrance = {name = _prototypes.item.access_shaft.underground_entrance},
		underground_exit = {name = _prototypes.item.access_shaft.underground_exit}
	},
	electric_pole = {
		common = {subgroup = _prototypes.item_subgroup.surfaces.transport.power.name},
		big = {
			common = {ingredients = {{"big-electric-pole", 2}, {_prototypes.item.connector.standard.name, 2}}},
			upper = {name = _prototypes.item.electric_pole.big.upper.name},
			lower = {name = _prototypes.item.electric_pole.big.lower.name}
		},
		big_2 = {
			common = {ingredients = {{_ref.bobpower.item.big_electric_pole_2, 2}, {_prototypes.item.connector.standard.name, 2}}},
			upper = {name = _prototypes.item.electric_pole.big_2.upper.name},
			lower = {name = _prototypes.item.electric_pole.big_2.lower.name}
		},
		big_3 = {
			common = {ingredients = {{_ref.bobpower.item.big_electric_pole_3, 2}, {_prototypes.item.connector.standard.name, 2}}},
			upper = {name = _prototypes.item.electric_pole.big_3.upper.name},
			lower = {name = _prototypes.item.electric_pole.big_3.lower.name}
		},
		big_4 = {
			common = {ingredients = {{_ref.bobpower.item.big_electric_pole_4, 2}, {_prototypes.item.connector.improved.name, 2}}},
			upper = {name = _prototypes.item.electric_pole.big_4.upper.name},
			lower = {name = _prototypes.item.electric_pole.big_4.lower.name}
		},
		medium = {
			common = {ingredients = {{"medium-electric-pole", 2}, {_prototypes.item.connector.basic.name, 2}}},
			upper = {name = _prototypes.item.electric_pole.medium.upper.name},
			lower = {name = _prototypes.item.electric_pole.medium.lower.name}
		},
		medium_2 = {
			common = {ingredients = {{_ref.bobpower.item.medium_electric_pole_2, 2}, {_prototypes.item.connector.basic.name, 2}}},
			upper = {name = _prototypes.item.electric_pole.medium_2.upper.name},
			lower = {name = _prototypes.item.electric_pole.medium_2.lower.name}
		},
		medium_3 = {
			common = {ingredients = {{_ref.bobpower.item.medium_electric_pole_3, 2}, {_prototypes.item.connector.standard.name, 2}}},
			upper = {name = _prototypes.item.electric_pole.medium_3.upper.name},
			lower = {name = _prototypes.item.electric_pole.medium_3.lower.name}
		},
		medium_4 = {
			common = {ingredients = {{_ref.bobpower.item.medium_electric_pole_4, 2}, {_prototypes.item.connector.standard.name, 2}}},
			upper = {name = _prototypes.item.electric_pole.medium_4.upper.name},
			lower = {name = _prototypes.item.electric_pole.medium_4.lower.name}
		},
		small = {
			common = {ingredients = {{"small-electric-pole", 2}, {_prototypes.item.connector.crude.name, 2}}},
			upper = {name = _prototypes.item.electric_pole.substation.upper.name},
			lower = {name = _prototypes.item.electric_pole.substation.lower.name}
		},
		substation = {
			common = {ingredients = {{"substation", 2}, {_prototypes.item.connector.improved.name, 2}}},
			upper = {name = _prototypes.item.electric_pole.substation.upper.name},
			lower = {name = _prototypes.item.electric_pole.substation.lower.name}
		},
		substation_2 = {
			common = {ingredients = {{_ref.bobpower.item.substation_2, 2}, {_prototypes.item.connector.improved.name, 2}}},
			upper = {name = _prototypes.item.electric_pole.substation_2.upper.name},
			lower = {name = _prototypes.item.electric_pole.substation_2.lower.name}
		},
		substation_3 = {
			common = {ingredients = {{_ref.bobpower.item.substation_3, 2}, {_prototypes.item.connector.improved.name, 2}}},
			upper = {name = _prototypes.item.electric_pole.substation_3.upper.name},
			lower = {name = _prototypes.item.electric_pole.substation_3.lower.name}
		},
		substation_4 = {
			common = {ingredients = {{_ref.bobpower.item.substation_4, 2}, {_prototypes.item.connector.advanced.name, 2}}},
			upper = {name = _prototypes.item.electric_pole.substation_4.upper.name},
			lower = {name = _prototypes.item.electric_pole.substation_4.lower.name}
		}
	},
	fluid_transport = {
		common = {subgroup = _prototypes.item_subgroup.surfaces.transport.other.name},
		standard = {
			common = {ingredients = {{"storage-tank", 2}, {_prototypes.item.connector.standard.name, 2}}},
			upper = {name = "fluid-transport-upper"},
			lower = {name = "fluid-transport-lower"}
		}
	},
	transport_chest = {
		common = {subgroup = _prototypes.item_subgroup.surfaces.transport.chest.name},
		wood = {
			common = {ingredients = {{"wooden-chest", 2}, {_prototypes.item.connector.crude.name, 1}}},
			up = {name = "wooden-transport-chest-up"},
			down = {name = "wooden-transport-chest-down"}
		},
		iron = {
			common = {ingredients = {{"iron-chest", 2}, {_prototypes.item.connector.basic.name, 1}}},
			up = {name = "iron-transport-chest-up"},
			down = {name = "iron-transport-chest-down"}
		},
		steel = {
			common = {ingredients = {{"steel-chest", 2}, {_prototypes.item.connector.standard.name, 1}}},
			up = {name = "steel-transport-chest-up"},
			down = {name = "steel-transport-chest-down"}
		},
		logistic = {
			common = {ingredients = {{"logistic-chest-requester", 1}, {"logistic-chest-passive-provider", 1}, {_prototypes.item.connector.advanced.name, 1}}},
			up = {name = "logistic-transport-chest-up"},
			down = {name = "logistic-transport-chest-down"}
		},
		storehouse = {
			common = {ingredients = {{_ref.warehousing.item.storehouse, 2}, {_prototypes.item.connector.standard.name, 2}}},
			up = {name = "transport-storehouse-up", icon = _gfxpath.icon .. "transport-storehouse-up.png"},
			down = {name = "transport-storehouse-down", icon = _gfxpath.icon .. "transport-storehouse-down.png"}
		},
		logistic_storehouse = {
			common = {ingredients = {{_ref.warehousing.item.requester_storehouse, 1}, {_ref.warehousing.item.passive_provider_storehouse, 1}, {_prototypes.item.connector.advanced.name, 3}}},
			up = {name = "logistic-transport-storehouse-up", icon = _gfxpath.icon .. "logistic-transport-storehouse-up.png"},
			down = {name = "logistic-transport-storehouse-down", icon = _gfxpath.icon .. "logistic-transport-storehouse-down.png"}
		},
		warehouse = {
			common = {ingredients = {{_ref.warehousing.item.warehouse, 2}, {_prototypes.item.connector.improved.name, 2}}},
			up = {name = "transport-warehouse-up", icon = _gfxpath.icon .. "transport-warehouse-up.png"},
			down = {name = "transport-warehouse-down", icon = _gfxpath.icon .. "transport-warehouse-down.png"}
		},
		logistic_warehouse = {
			common = {ingredients = {{_ref.warehousing.item.requester_warehouse, 1}, {_ref.warehousing.item.passive_provider_warehouse, 1}, {_prototypes.item.connector.advanced.name, 3}}},
			up = {name = "logistic-transport-warehouse-up", icon = _gfxpath.icon .. "logistic-transport-warehouse-up.png"},
			down = {name = "logistic-transport-warehouse-down", icon = _gfxpath.icon .. "logistic-transport-warehouse-down.png"}
		},
	},
	rail_transport = {
		common = {subgroup = _prototypes.item_subgroup.surfaces.transport.other.name},
		standard = {
			common = {ingredients = {{"train-stop", 2}, {_prototypes.item.connector.advanced.name, 2}}},
			upper = {name = "train-stop-upper"},
			lower = {name = "train-stop-lower"}
		}
	},
	floor = {
		common = {subgroup = _prototypes.item_subgroup.surfaces.tile.name},
		wood = {name = "wooden-floor", ingredients = {{"wood", 5}}}
	}
}

function proto.get(_path_to_field, _field, _common, _inherit)
	if game == nil then -- Only allow this function to be used before game is loaded
		local _data = (type(_inherit) == "table") and table.deepcopy(_inherit) or {}
		local _path = _prototypes
		if type(_path_to_field) ~= "table" or type(_field) ~= "string" then
			error("Unable to fetch prototype definition, path to field is not a table or field is not a string value. (called: proto.get("..tostring(_path_to_field)..", "..tostring(_field)..", "..tostring(_common)..", "..tostring(_inherit).."))")
		else
			for k, v in pairs(_path_to_field) do
				if type(v) == "string" and _path[string.lower(v)] then
					_path = _path[string.lower(v)]
					if _common and type(_path["common"]) == "table" then
						for k, v in pairs(_path["common"]) do
							_data[k] = copy_data(v, true)
						end
					end
				else
					local _path_string = "_prototypes"
					for k, v in pairs(_path_to_field) do
						_path_string = _path_string .. "." .. string.lower(tostring(v))
					end
					_path_string = _path_string .. "." .. _field
					error("Unable to fetch prototype definition, path to field leads through one or more undefined table values. (called: proto.get("..table.tostring(_path_to_field, true)..", "..tostring(_field)..", "..tostring(_common)..", "..tostring(_inherit).."))")
					return nil
				end
			end
			if type(_path[string.lower(_field)]) == "table" then
				for k, v in pairs(_path[string.lower(_field)]) do
					_data[k] = copy_data(v, true)
				end
			end
			local _type = _path_to_field[1]
			if _type == "entity" and _data.override then
				if not(_data.minable) then _data.minable = {} end
				_data.minable.result = nil
				_data.minable.results = nil
				if _data.override_result then _data.minable.result = _data.override_result
				elseif _data.override_results then _data.minable.results = _data.override_results
				else _data.minable.result = _data.name end
			elseif _type == "recipe" and (type(_data.result) ~= "string" or _data.override) then
				if _data.override_result then _data.result = _data.override_result
				else _data.result = _data.name end
			elseif _type == "item" and _data.override then
				if _data.place_as_tile then _data.place_as_tile.result = _data.override_result or _data.name 
				else _data.place_result = _data.override_result or _data.name end
			end
			_data.override_result = nil
			_data.override_results = nil
			_data.override = nil
			proto.globdebugger = proto.globdebugger .. "\n " .. table.tostring(_data, true)
			return _data
		end
	end
end

-- prevent modification to local table by returning a duplicate table, I'd recommend against using this after data loading phase
function proto.reference()
	return copy_data(_ref, true)
end

function proto.get_field(_path_to_field, _field)
	local _path = _prototypes
	if type(_path_to_field) == "table" and type(_field) == "string" then
		for k, v in pairs(_path_to_field) do
			if type(v) == "string" and _path[string.lower(v)] then
				_path = _path[string.lower(v)]
			else
				return nil
			end
		end
		if _path[string.lower(_field)] then
			return copy_data(_path[string.lower(_field)], true)
		end
	end
end

return proto