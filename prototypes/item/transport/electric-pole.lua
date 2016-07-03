local iconpath, filetype = "__Surfaces__/graphics/icons/transport/", ".png"

local big_electric_pole_upper = table.deepcopy(data.raw["item"]["big-electric-pole"])
big_electric_pole_upper.name = "big-electric-pole-upper"
big_electric_pole_upper.icon = iconpath .. big_electric_pole_upper.name .. filetype
big_electric_pole_upper.place_result = big_electric_pole_upper.name
big_electric_pole_upper.flags = {"goes-to-quickbar"}
data:extend({big_electric_pole_upper})

local big_electric_pole_lower = table.deepcopy(data.raw["item"]["big-electric-pole"])
big_electric_pole_lower.name = "big-electric-pole-lower"
big_electric_pole_lower.icon = iconpath .. big_electric_pole_lower.name .. filetype
big_electric_pole_lower.place_result = big_electric_pole_lower.name
big_electric_pole_lower.flags = {"goes-to-quickbar"}
data:extend({big_electric_pole_lower})

local medium_electric_pole_upper = table.deepcopy(data.raw["item"]["medium-electric-pole"])
medium_electric_pole_upper.name = "medium-electric-pole-upper"
medium_electric_pole_upper.icon = iconpath .. medium_electric_pole_upper.name .. filetype
medium_electric_pole_upper.place_result = medium_electric_pole_upper.name
medium_electric_pole_upper.flags = {"goes-to-quickbar"}
data:extend({medium_electric_pole_upper})

local medium_electric_pole_lower = table.deepcopy(data.raw["item"]["medium-electric-pole"])
medium_electric_pole_lower.name = "medium-electric-pole-lower"
medium_electric_pole_lower.icon = iconpath .. medium_electric_pole_lower.name .. filetype
medium_electric_pole_lower.place_result = medium_electric_pole_lower.name
medium_electric_pole_lower.flags = {"goes-to-quickbar"}
data:extend({medium_electric_pole_lower})

local small_electric_pole_upper = table.deepcopy(data.raw["item"]["small-electric-pole"])
small_electric_pole_upper.name = "small-electric-pole-upper"
small_electric_pole_upper.icon = iconpath .. small_electric_pole_upper.name .. filetype
small_electric_pole_upper.place_result = small_electric_pole_upper.name
small_electric_pole_upper.flags = {"goes-to-quickbar"}
data:extend({small_electric_pole_upper})

local small_electric_pole_lower = table.deepcopy(data.raw["item"]["small-electric-pole"])
small_electric_pole_lower.name = "small-electric-pole-lower"
small_electric_pole_lower.icon = iconpath .. small_electric_pole_lower.name .. filetype
small_electric_pole_lower.place_result = small_electric_pole_lower.name
small_electric_pole_lower.flags = {"goes-to-quickbar"}
data:extend({small_electric_pole_lower})

local substation_upper = table.deepcopy(data.raw["item"]["substation"])
substation_upper.name = "substation-upper"
substation_upper.icon = iconpath .. substation_upper.name .. filetype
substation_upper.place_result = substation_upper.name
substation_upper.flags = {"goes-to-quickbar"}
data:extend({substation_upper})

local substation_lower = table.deepcopy(data.raw["item"]["substation"])
substation_lower.name = "substation-lower"
substation_lower.icon = iconpath .. substation_lower.name .. filetype
substation_lower.place_result = substation_lower.name
substation_lower.flags = {"goes-to-quickbar"}
data:extend({substation_lower})