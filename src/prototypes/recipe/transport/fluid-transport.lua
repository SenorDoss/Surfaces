require("script.proto")

local fluid_transport_upper = proto.get({"recipe", "fluid_transport", "standard"}, "upper", true)
local fluid_transport_lower = proto.get({"recipe", "fluid_transport", "standard"}, "lower", true)

data:extend({fluid_transport_upper, fluid_transport_lower})