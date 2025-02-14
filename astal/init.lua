local astal = require("astal")
local App = require("astal.gtk3.app")

local Bar = require("lua.widget.Bar.init")
local NotificationPopups = require("lua.widget.Notifications.NotificationPopups")
local AppLauncher = require("lua.widget.applauncher.applauncher")
local src = require("lib").src

local scss = src("./styles/style.scss")
local css = "/tmp/style.css"

astal.exec("sass " .. scss .. " " .. css)

App:start({
	instance_name = "lua",
	css = css,
	request_handler = function(msg, res)
		print(msg)
		res("ok")
	end,
	main = function()
		for _, mon in pairs(App.monitors) do
			Bar(mon)
			NotificationPopups(mon)
		end
	end,
})
