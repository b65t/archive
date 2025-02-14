local astal = require("astal")
local Widget = require("astal.gtk3.widget")
local GLib = astal.require("GLib")
local bind = astal.bind
local Variable = astal.Variable

local Workspaces = require("lua.widget.Bar.workspaces")
local Audio = require("lua.widget.Bar.audio")
local Wifi = require("lua.widget.Bar.wifi")
local SysTray = require("lua.widget.Bar.tray")
local Time = require("lua.widget.Bar.clock")
local Buttons = require("lua.widget.Bar.buttons")

local Logo = Buttons.Logo()
local Picker = Buttons.Picker()


return function(gdkmonitor)
	local Anchor = astal.require("Astal").WindowAnchor

	return Widget.Window({
		class_name = "Bar",
		gdkmonitor = gdkmonitor,
		anchor = Anchor.TOP + Anchor.LEFT + Anchor.RIGHT,
		exclusivity = "EXCLUSIVE",
		Widget.CenterBox({
			Widget.Box({
				halign = "START",
				Logo,
				Picker,
			}),
			Widget.Box({
				Workspaces(),
			}),
			Widget.Box({
				halign = "END",
				SysTray(),
				Audio(),
				Wifi(),
				Time("%H:%M 󰧞 %A,%d/%m"),
			}),
		}),
	})
end
