local mod = "SUPER"
local term = "kitty"
local fileManager = "dolphin"
local menu = "fuzzel"
local noctalia = "qs -c noctalia-shell ipc call "

-- Noctalia
hl.bind(mod .. " + L",         hl.dsp.exec_cmd(noctalia .. "lockScreen lock"))
hl.bind(mod .. " + PERIOD",    hl.dsp.exec_cmd("bemoji -t")) -- emoji picker (fuzzel UI, types via wtype)
hl.bind(mod .. " + ESCAPE",    hl.dsp.exec_cmd(noctalia .. "sessionMenu toggle"))
hl.bind(mod .. " + P",         hl.dsp.exec_cmd("hyprpicker -a"))

-- Screenshot: slurp overlay to select a region -> satty editor -> save + clipboard
local screenshot = "mkdir -p ~/Pictures/Screenshots && "
	.. 'grim -g "$(slurp)" - | satty --filename - '
	.. "--output-filename ~/Pictures/Screenshots/satty-$(date +%Y%m%d-%H%M%S).png "
	.. "--early-exit --fullscreen --copy-command wl-copy"
hl.bind("Print", hl.dsp.exec_cmd(screenshot))

-- Hyprland
hl.bind(mod .. " + Q", hl.dsp.exec_cmd(term))
hl.bind(mod .. " + C", hl.dsp.window.close())
hl.bind(
	mod .. " + M",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)
hl.bind(mod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only

-- Move focus with mainMod + arrow keys
hl.bind(mod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
-- hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
-- hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Toggle between Vesktop and wherever you were before
-- ponytail: "previous" goes back by workspace, so it assumes Vesktop lives on
-- its own workspace. If Vesktop shares your current workspace, track the prior
-- focused window instead.
hl.bind(mod .. " + S", function()
	local active = hl.get_active_window()
	if active and active.class == "vesktop" then
		hl.dispatch(hl.dsp.focus({ workspace = "previous" }))
	else
		hl.dispatch(hl.dsp.focus({ window = "class:^(vesktop)$" }))
	end
end)

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
