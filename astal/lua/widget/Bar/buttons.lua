local astal = require("astal")
local Widget = require("astal.gtk3.widget")
local AppLauncher = require("lua.widget.applauncher.applauncher")

local function Logo()
    return Widget.Button({
        class_name = "LogoB",
        on_clicked = function()
            os.execute("/home/islam/.config/scripts/powermenu.sh")
        end,
        label = "󰣇"
    })
end


local function Search()
    return Widget.Button({
        class_name = "SearchB",
        on_clicked = function() AppLauncher() end,
        label = "󰣇"
    })
end


local function Picker()
    return Widget.Button({
        class_name = "PickerB",
        on_clicked = function()
            os.execute("/home/islam/.config/scripts/hyprpicker.sh")
        end,
        label = ""
    })
end

local function Exit()
    return Widget.Button({
        class_name = "ExitB",
        on_clicked = function()
            os.execute("/home/islam/.config/scripts/hyprpicker.sh &")
        end,
        label = "󰣇"
    })
end

return {
    Logo = Logo,
    Search = Search,
    Picker = Picker,
    Exit = Exit
}
