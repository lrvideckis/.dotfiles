# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import re
import socket
import subprocess

from libqtile import bar, layout, widget, qtile
from libqtile.config import Click, Drag, Group, Key, Match, Screen, KeyChord
from libqtile.lazy import lazy
from os.path import expanduser

mod = "mod1"
terminal = "alacritty"
terminal_floating = terminal + " --class floating_terminal --command"
network_interface = "wlp1s0"
start_network = "nmcli device connect " + network_interface
stop_network = "nmcli device disconnect " + network_interface
show_keybindings_aliases = terminal + " --command zsh -c \"sed -n '/^\# START DISPLAY$/,/^\# END DISPLAY$/p' " + expanduser("~/.zshrc") + " " + expanduser("~/.config/qtile/config.py") + " | bat --wrap=never --style=plain --paging=always --file-name='.zshrc'\""

# START DISPLAY
keys = [
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "f", lazy.spawn("firefox")),
    Key([mod], "d", lazy.spawn("discord")),
    KeyChord([mod], "o", [ # open
        Key([], "p", lazy.spawn(terminal + " --command zsh -c \"bat " + expanduser("~/github_repos/programming_team_code/library/") + "**/*.hpp\"")), #ptc, cat-ed
        Key([], "e", lazy.spawn("evince")), #document viewer
        Key([], "k", lazy.spawn(show_keybindings_aliases)), #keybindings
        Key([], "q", lazy.spawn(terminal + " --command tail -f " + expanduser("~/.local/share/qtile/qtile.log"))), #qtile log
        Key([], "a", lazy.spawn("./android-studio/bin/studio.sh")), #android studio
        Key([], "m", lazy.spawn("flatpak run io.mrarm.mcpelauncher")), #minecraft
        Key([], "v", lazy.spawn(terminal + " --command alsamixer")), #volume
    ]),
    Key([mod], "h", lazy.layout.left(), desc="Move focus left"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus right"),
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window left"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window right"),
    Key([mod], "g", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating status of selected window"),
    Key([mod], "s", lazy.spawn(expanduser("~/.config/qtile/grim.sh")), desc="take screenshot"),
    Key([mod], "x", lazy.hide_show_bar(position="top"), desc="Toggle top bar"),
    Key([mod], "c", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod, "shift"], "Return", lazy.spawn("dmenu_run"), desc='Run Dmenu Launcher'),
]
# END DISPLAY

groups = [
    Group("1", spawn="firefox"),
    Group("2"),
    Group("3"),
]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
        ]
    )

# color1 = '#253253'
# color2 = '#4169E1'
# font_shadow_color = '#002e63'
# graph_color_hex = '#C41E3A'
# border_focus_color = '#04C1E2'

color1 = '#CE1713'
color2 = '#0F7833'
font_shadow_color = '#000000'
graph_color_hex = color1
border_focus_color = '#00FF00'

layouts = [
    layout.MonadTall(
        new_client_position='bottom',
        border_focus=border_focus_color,
        border_width=1,
    ),
    layout.Max(),
]

widget_defaults = dict(
    font="Source Code Pro", # use monospace font for bar so that widgets have a constant width
    fontsize=13,
    fontshadow=font_shadow_color
)
extension_defaults = widget_defaults.copy()

def get_arrow_widget(points_right: bool, parody: bool) -> widget.TextBox:
    return widget.TextBox(
            text = '' if points_right else '',
            foreground = color1 if parody else color2,
            background = color2 if parody else color1,
            padding = 0,
            fontsize = 20
    )

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(background=color1),
                get_arrow_widget(True, True),
                widget.NetGraph(
                    interface=network_interface,
                    graph_color=graph_color_hex,
                    fill_color=graph_color_hex,
                    bandwidth_type='up',
                    border_width=0,
                    margin_x=0,
                    margin_y=0,
                    samples=20,
                    width=20,
                    background=color2,
                    mouse_callbacks = {
                        'Button1': lambda: qtile.cmd_spawn(start_network),
                        'Button3': lambda: qtile.cmd_spawn(stop_network),
                    },
                ),
                widget.Net(
                    interface=network_interface,
                    format='{up:5.2f}{up_suffix} ↑↓ {down:5.2f}{down_suffix}',
                    padding=5,
                    prefix='M',
                    background=color2,
                    mouse_callbacks = {
                        'Button1': lambda: qtile.cmd_spawn(start_network),
                        'Button3': lambda: qtile.cmd_spawn(stop_network),
                    },
                ),
                widget.NetGraph(
                    interface=network_interface,
                    graph_color=graph_color_hex,
                    fill_color=graph_color_hex,
                    border_width=0,
                    margin_x=0,
                    margin_y=0,
                    samples=20,
                    width=20,
                    background=color2,
                    mouse_callbacks = {
                        'Button1': lambda: qtile.cmd_spawn(start_network),
                        'Button3': lambda: qtile.cmd_spawn(stop_network),
                    },
                ),
                get_arrow_widget(True, False),
                widget.TextBox(
                    text="CPU",
                    mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(terminal_floating + ' htop --sort-key=PERCENT_CPU')},
                    padding=10,
                    background=color1
                ),
                widget.CPU(
                    format="{load_percent:4.1f}%",
                    mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(terminal_floating + ' htop --sort-key=PERCENT_CPU')},
                    background=color1
                ),
                widget.CPUGraph(
                    graph_color=graph_color_hex,
                    fill_color=graph_color_hex,
                    border_width=0,
                    margin_x=0,
                    margin_y=0,
                    samples=20,
                    width=20,
                    mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(terminal_floating + ' htop --sort-key=PERCENT_CPU')},
                    background=color1,
                ),
                widget.ThermalSensor(
                    tag_sensor="CPU",
                    mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(terminal_floating + ' htop --sort-key=PERCENT_CPU')},
                    background=color1
                ),
                get_arrow_widget(True, True),
                widget.Memory(
                    format="RAM {MemUsed:4.0f}{mm}/{MemTotal:4.0f}{mm}",
                    mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(terminal_floating + ' htop --sort-key=PERCENT_MEM')},
                    background=color2
                ),
                widget.MemoryGraph(
                    graph_color=graph_color_hex,
                    fill_color=graph_color_hex,
                    border_width=0,
                    margin_x=0,
                    margin_y=0,
                    samples=20,
                    width=20,
                    background=color2,
                    mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(terminal_floating + ' htop --sort-key=PERCENT_MEM')},
                ),
                get_arrow_widget(True, False),
                widget.Spacer(
                    background=color1
                ), # widgets before this are left justified
                widget.CheckUpdates(
                    # requires an internet connection (good)
                    # other options (pacman -Qu; pacman -Sup) show stale info unless you first manually run pacman -Sy (so bad)
                    # https://www.reddit.com/r/qtile/comments/ur8mz3/comment/i90sa7d/
                    distro="Arch_checkupdates",
                    display_format="ᗧ·· {updates}",
                    no_update_string="ᗧ·· 0",
                    update_interval = 1800, # 30 minutes
                    mouse_callbacks = {
                        'Button1': lambda: qtile.cmd_spawn(terminal + ' --command sudo pacman -Syu'),
                        'Button3': lambda: qtile.cmd_spawn(terminal + ' --command paru -Syu'),
                    },
                    background=color1
                ),
                widget.Spacer(
                    background=color1
                ), # widgets after this are right justified
                get_arrow_widget(False, False),
                widget.TextBox(
                    fmt='Keybindings',
                    mouse_callbacks = {
                        'Button1': lambda: qtile.cmd_spawn(show_keybindings_aliases),
                    },
                    background=color2
                ),
                get_arrow_widget(False, True),
                widget.Clock(
                    format="%d-%m-%Y %a %H:%M",
                    mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(terminal_floating + " zsh -c \"cal --color=always --months 9 | bat --wrap=never --style=plain --paging=always\"") },
                    background=color1
                ),
                get_arrow_widget(False, False),
                widget.Battery(
                    format="Battery {char} {percent:2.0%}",
                    charge_char = '↑',
                    discharge_char = '↓',
                    full_char = '',
                    show_short_text = False,
                    background=color2
                ),
                get_arrow_widget(False, True),
                widget.Volume(
                    fmt='Vol {}',
                    mouse_callbacks = {
                        'Button1': lambda: qtile.cmd_spawn('amixer set Master 9+'),
                        'Button2': lambda: qtile.cmd_spawn('pavucontrol'),
                        'Button3': lambda: qtile.cmd_spawn('amixer set Master 9-'),
                    },
                    padding = 10,
                    background=color1
                ),
                get_arrow_widget(False, False),
                widget.Backlight(
                    backlight_name='intel_backlight',
                    fmt='Backlight {}',
                    mouse_callbacks = {
                        'Button1': lambda: qtile.cmd_spawn('brightnessctl set +10%'),
                        'Button3': lambda: qtile.cmd_spawn('brightnessctl set 10%-'),
                    },
                    background=color2
                ),
            ],
            22,
        ),
        wallpaper='~/Pictures/wallpaper_fam_DC.jpg',
        wallpaper_mode='fill',
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="floating_terminal"), # window to show keybindings
    ],
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
