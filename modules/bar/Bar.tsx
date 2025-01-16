import { App } from "astal/gtk3"
import { Variable, GLib, bind } from "astal"
import { Astal, Gtk, Gdk } from "astal/gtk3"
import Hyprland from "gi://AstalHyprland"
import Mpris from "gi://AstalMpris"
import Wp from "gi://AstalWp"
import Network from "gi://AstalNetwork"
import Tray from "gi://AstalTray"
import AppLauncher from "../.././modules/applauncher/Applauncher"
import { CalendarSheet } from "../.././modules/widget/Calendar"
import Notification from "./modules/notification/Notification"

function SysTray() {
    const tray = Tray.get_default()

    return <box className="SysTray">
        {bind(tray, "items").as(items => items.map(item => (
            <menubutton
                tooltipMarkup={bind(item, "tooltipMarkup")}
                usePopover={false}
                actionGroup={bind(item, "action-group").as(ag => ["dbusmenu", ag])}
                menuModel={bind(item, "menu-model")}>
                <icon gicon={bind(item, "gicon")} />
            </menubutton>
        )))}
    </box>
}

function Wifi() {
    const network = Network.get_default()
    const wifi = bind(network, "wifi")

    return <box visible={wifi.as(Boolean)}>
        {wifi.as(wifi => wifi && (
            <icon
                tooltipText={bind(wifi, "ssid").as(String)}
                className="Wifi"
                icon={bind(wifi, "iconName")}
            />
        ))}
    </box>

}

function AudioSlider() {
    const speaker = Wp.get_default()?.audio.defaultSpeaker!

    return <box className="AudioSlider" css="min-width: 140px">
        <icon icon={bind(speaker, "volumeIcon")} />
        <slider
            hexpand
            onDragged={({ value }) => speaker.volume = value}
            value={bind(speaker, "volume")}
        />
    </box>
}

function Media() {
    const mpris = Mpris.get_default()

    return <box className="Media">
        {bind(mpris, "players").as(ps => ps[0] ? (
            <box>
                <box
                    className="Cover"
                    valign={Gtk.Align.CENTER}
                    css={bind(ps[0], "coverArt").as(cover =>
                        `background-image: url('${cover}');`
                    )}
                />
                <label
                    label={bind(ps[0], "title").as(() =>
                        `${ps[0].title} - ${ps[0].artist}`
                    )}
                />
            </box>
        ) : (
            "Nothing Playing"
        ))}
    </box>
}

/* function Workspaces() { 
    const hypr = Hyprland.get_default()
        const ws: number = 6
	const focusWorkspace = (workspaceId: number) =>
              hypr.dispatch("workspace", workspaceId.toString());

    return <box className="Workspaces">
        {bind(hypr, "workspaces").as(wss => wss
            .filter(ws => !(ws.id >= -99 && ws.id <= -2)) // filter out special workspaces
            .sort((a, b) => a.id - b.id)
             .map(ws => (
                <button
                   className={bind(hypr, "focusedWorkspace").as(fw =>
                        ws === fw ? "focused" : "")}
                    onClicked={() => ws.focus()}>
                    {ws.id}
                </button>
            ))
        )}
    </box>
} */

function Workspaces() {
    const hypr = Hyprland.get_default();
    const focusWorkspace = (workspaceId: number) =>
        hypr.dispatch("workspace", workspaceId.toString());

    const minWorkspaces = 6;

    return (
        <box className="Workspaces">
            {bind(hypr, "workspaces").as(wss => {
                const existingWorkspaceIds = wss.map(ws => ws.id);

                const workspaceIds = Array.from(
                    new Set([...Array.from({ length: minWorkspaces }, (_, i) => i + 1), ...existingWorkspaceIds])
                ).sort((a, b) => a - b);

                return workspaceIds.map(workspaceId => (
                    <button
                        key={workspaceId}
                        className={bind(hypr, "focusedWorkspace").as(fw =>
                            fw?.id === workspaceId ? "focused" : "")}
                        onClicked={() => focusWorkspace(workspaceId)}
                    >
                        {workspaceId}
                    </button>
                ));
            })}
        </box>
    );
}


function FocusedClient() {
    const hypr = Hyprland.get_default()
    const focused = bind(hypr, "focusedClient")

    return <box
        className="Focused"
        visible={focused.as(Boolean)}>
        {focused.as(client => (
            client && <label label={bind(client, "title").as(String)} />
        ))}
    </box>
}

function Time({ format = "%H/%M" }) {
    const time = Variable<string>("").poll(1000, () =>
        GLib.DateTime.new_now_local().format(format)!)

    return <button
        className="Time"
        onClick={() => CalendarSheet()}>
    <label
        onDestroy={() => time.drop()}
        label={time()}
    />
        </button>
}

function Logo() {
    return <button
         className="Logo"
        onClick={() => AppLauncher()} >
        <label label="󰣇 " />
    </button>
}
function Picker() {
    return <button
         className="Picker"
        onClick="/home/islam/.config/scripts/hyprpicker.sh">
        <label label="" />
    </button>
}
function Notification() {
    return <button
         className="Notification"
	onClick={() => Notification()} >
        <label label="󰂚" />
    </button>
}

export default function Bar(monitor: Gdk.Monitor) {
    const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

    return <window
        className="Bar"
        gdkmonitor={monitor}
        exclusivity={Astal.Exclusivity.EXCLUSIVE}
        anchor={TOP | LEFT | RIGHT}>
        <centerbox>
            <box hexpand halign={Gtk.Align.START}>
	        <Logo />
		<Picker />
            </box>
            <box>
		<Workspaces />
            </box>
            <box hexpand halign={Gtk.Align.END} >
                <SysTray />
                <Wifi />
                <AudioSlider />
                <Time />
		<Notification />
            </box>
        </centerbox>
    </window>
}
