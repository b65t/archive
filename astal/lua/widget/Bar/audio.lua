local astal = require("astal")
local Widget = require("astal.gtk3.widget")
local Variable = astal.Variable
local bind = astal.bind
local Wp = astal.require("AstalWp")

local function Audio()
	local speaker = Wp.get_default().audio.default_speaker
	local scroll_revealed = Variable()

	return Widget.Box({
	Widget.Button({
		class_name = "Audio",
		on_click_release = function()
			speaker.mute = not speaker.mute
		end,
		Widget.Icon({
			icon = bind(speaker, "volume-icon"),
		}),
	     }),
	})
end

return Audio
