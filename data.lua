--[[
	Surfaces (Factorio Mod)
    Copyright (C) 2016  Simon Crawley

    This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]
require("data-compat")

-- Item Groups
require("prototypes.item.item-groups")

-- Items
require("prototypes.item.items")
require("prototypes.item.transport.access-shaft")
require("prototypes.item.transport.transport-chest")
require("prototypes.item.transport.electric-pole")
--require("prototypes.item.transport.rail-transport")
require("prototypes.item.transport.fluid-transport")

-- Entities
require("prototypes.entity.entities")
require("prototypes.entity.transport.access-shaft")
require("prototypes.entity.transport.transport-chest")
require("prototypes.entity.transport.electric-pole")
--require("prototypes.entity.transport.rail-transport")
require("prototypes.entity.transport.fluid-transport")

-- Technology
--require("prototypes.tech.*")

-- Tiles
require("prototypes.tile.tiles")

-- Categories
--require("prototypes.category.recipe-categories")]]

-- Recipes
require("prototypes.recipe.recipes")
require("prototypes.recipe.transport.access-shaft")
require("prototypes.recipe.transport.transport-chest")
require("prototypes.recipe.transport.electric-pole")
--require("prototypes.recipe.transport.rail-transport")
require("prototypes.recipe.transport.fluid-transport")

-- Other prototypes which are only loaded when optional mods are installed

if compat.active("warehousing") == true then
	require("prototypes.item.addons.warehousing")
	require("prototypes.entity.addons.warehousing")
	require("prototypes.recipe.addons.warehousing")
end