--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016  Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

config = {
	teleportation_check_range = 0.5,			-- [default: 0.5]		distance (in tiles) that players must be from the center of an access shaft for it to transport them
	teleportation_time_waiting = 20,			-- [default: 20]		time (in ticks, 60 ticks = 1 second) that players must stand still before teleportation will occur

	item_transport = {
		base_count = 4,							-- [default: 4]			base count of items moved during one transport cycle
		multiplier = {							-- multipliers for each different tier of transport chest
			crude = 0.25,						-- [default: 0.25]		crude (wooden chests)
			basic = 0.5,						-- [default: 0.5]		basic (iron chests)
			standard = 0.75,					-- [default: 0.75]		standard
			improved = 1,						-- [default: 1]			improved (steel chests)
			advanced = 1.25						-- [default: 1.25]		advanced (logistic chests)
		}
	}
}
