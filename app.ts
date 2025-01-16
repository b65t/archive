import { App } from "astal/gtk3"
import style from "./styles/style.scss"
import Bar from "./modules/bar/Bar"
import NotificationPopups from "./modules/notification/NotificationPopups"
import Applauncher from "./modules/applauncher/Applauncher"
import MprisPlayers from "./modules/widget/MediaPlayer"

App.start({
    css: style,
    main() {
        App.get_monitors().map(Bar)
	App.get_monitors().map(NotificationPopups)
	new Widget.Window({}, MprisPlayers())
	Applauncher
    },
})
