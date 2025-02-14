local astal = require("astal")
local Hyprland = astal.require("AstalHyprland")
local map = require("lib").map
local Widget = require("astal.gtk3.widget")
local GLib = astal.require("GLib")
local Variable = astal.Variable
local bind = astal.bind

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

return Workspaces
