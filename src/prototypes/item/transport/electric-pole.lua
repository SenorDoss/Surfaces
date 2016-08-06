require("script.proto")

local small_lower = proto.get({"item", "electric_pole", "small"}, "lower", true)
local small_upper = proto.get({"item", "electric_pole", "small"}, "upper", true)
local medium_lower = proto.get({"item", "electric_pole", "medium"}, "lower", true)
local medium_upper = proto.get({"item", "electric_pole", "medium"}, "upper", true)
local big_lower = proto.get({"item", "electric_pole", "big"}, "lower", true)
local big_upper = proto.get({"item", "electric_pole", "big"}, "upper", true)
local substation_lower = proto.get({"item", "electric_pole", "substation"}, "lower", true)
local substation_upper = proto.get({"item", "electric_pole", "substation"}, "upper", true)

data:extend({small_lower, small_upper, medium_lower, medium_upper, big_lower, big_upper, substation_lower, substation_upper})
