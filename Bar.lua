local astal = require("astal")
local Widget = require("astal.gtk3.widget")
local Variable = astal.Variable
local GLib = astal.require("GLib")
local bind = astal.bind
local Mpris = astal.require("AstalMpris")
local Battery = astal.require("AstalBattery")
local Wp = astal.require("AstalWp")
local Network = astal.require("AstalNetwork")
local Tray = astal.require("AstalTray")
local Hyprland = astal.require("AstalHyprland")
local map = require("lib").map

local function SysTray()
	local tray = Tray.get_default()

	return Widget.Box({
		class_name = "SysTray",
		bind(tray, "items"):as(function(items)
			return map(items, function(item)
				return Widget.MenuButton({
					tooltip_markup = bind(item, "tooltip_markup"),
					use_popover = false,
					menu_model = bind(item, "menu-model"),
					action_group = bind(item, "action-group"):as(
						function(ag) return { "dbusmenu", ag } end
					),
					Widget.Icon({
						gicon = bind(item, "gicon"),
					}),
				})
			end)
		end),
	})
end

local function FocusedClient()
	local hypr = Hyprland.get_default()
	local focused = bind(hypr, "focused-client")

	return Widget.Box({
		class_name = "Focused",
		visible = focused,
		focused:as(
			function(client)
				return client
					and Widget.Label({
						label = bind(client, "title"):as(tostring),
					})
			end
		),
	})
end

local function Wifi()
	local network = Network.get_default()
	local wifi = bind(network, "wifi")

	return Widget.Box({
		visible = wifi:as(function(v) return v ~= nil end),
		wifi:as(
			function(w)
				return Widget.Icon({
					tooltip_text = bind(w, "ssid"):as(tostring),
					class_name = "Wifi",
					icon = bind(w, "icon-name"),
				})
			end
		),
	})
end

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

local function BatteryLevel()
	local bat = Battery.get_default()

	return Widget.Box({
		class_name = "Battery",
		visible = bind(bat, "is-present"),
		Widget.Icon({
			icon = bind(bat, "battery-icon-name"),
		}),
		Widget.Label({
			label = bind(bat, "percentage"):as(
				function(p) return tostring(math.floor(p * 100)) .. " %" end
			),
		}),
	})
end

local function Media()
	local player = Mpris.Player.new("spotify")

	return Widget.Box({
		class_name = "Media",
		visible = bind(player, "available"),
		Widget.Box({
			class_name = "Cover",
			valign = "CENTER",
			css = bind(player, "cover-art"):as(
				function(cover)
					return "background-image: url('" .. (cover or "") .. "');"
				end
			),
		}),
		Widget.Label({
			label = bind(player, "metadata"):as(
				function()
					return (player.title or "")
						.. " - "
						.. (player.artist or "")
				end
			),
		}),
	})
end

local function Workspaces()
	local hypr = Hyprland.get_default()

	return Widget.Box({
		class_name = "Workspaces",
		bind(hypr, "workspaces"):as(function(wss)
			-- Create a map with existing workspaces
			local workspace_map = {}
			for _, ws in ipairs(wss) do
				workspace_map[ws.id] = ws
			end

			-- Generate workspace buttons for 1 to 9
			local buttons = {}
			for i = 1, 9 do
				local ws = workspace_map[i] -- Check if workspace exists
				table.insert(buttons, Widget.Button({
					class_name = bind(hypr, "focused-workspace"):as(
						function(fw) return ws and fw == ws and "focused" or "" end
					),
					on_clicked = function() 
						if ws then 
							ws:focus() 
						else 
							hypr:dispatch("workspace", tostring(i)) -- Ensure it switches even if inactive
						end
					end,
					label = tostring(i),
				}))
			end

			return buttons
		end),
	})
end

local function Time(format)
	local time = Variable(""):poll(
		1000,
		function() return GLib.DateTime.new_now_local():format(format) end
	)

	return Widget.Label({
		class_name = "Time",
		on_destroy = function() time:drop() end,
		label = time(),
	})
end

local function Logo()
    return Widget.Button({
        class_name = "Logo",
        on_clicked = function()
            os.execute("/home/islam/.config/scripts/powermenu.sh")
        end,
        label = "󰣇"
    })
end

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
				Logo(),
			}),
			Widget.Box({
				Workspaces(),
			}),
			Widget.Box({
				halign = "END",
				SysTray(),
				Audio(),
				Wifi(),
				Time("%H:%M - %A %e."),
			}),
		}),
	})
end
