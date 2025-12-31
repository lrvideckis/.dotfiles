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

def unfloat_and_next_layout(qtile):
    for window in qtile.current_group.windows:
        window.floating = False
    qtile.next_layout()

# START DISPLAY
keys = [
    Key([mod], "a", lazy.spawn("./android-studio/bin/studio")),
    Key([mod], "b", lazy.spawn("librewolf")), # mnemonic: browser
    Key([mod], "e", lazy.spawn("evince")), # document viewer

    Key([mod], "Return", lazy.spawn(terminal)),
    Key([mod], "f", lazy.function(unfloat_and_next_layout)), # mnemonic: fullscreen
    Key([mod], "s", lazy.spawn("bash -c \"slurp | xargs -I{} grim -g {} ~/Pictures/screenshots/$(date -Iseconds).png\"")),
    Key([mod], "c", lazy.window.kill()),
    Key([mod], "r", lazy.reload_config()),
    Key([mod], "q", lazy.shutdown()),

    Key([mod], "h", lazy.layout.left()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "k", lazy.layout.up()),
    Key([mod], "l", lazy.layout.right()),
    Key([mod, "shift"], "h", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right()),
]
# END DISPLAY

groups = [
    Group("1"),
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

#color1 = '#253253'
#color2 = '#4169E1'
#font_shadow_color = '#002e63'
#graph_color1 = '#C41E3A'
#graph_color2 = '#C41E3A'
#border_focus_color = '#04C1E2'

color1 = '#CE1713'
color2 = '#0F7833'
font_shadow_color = '#000000'
graph_color1 = color1
graph_color2 = color2
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
                widget.GroupBox(
                    background=color1,
                    this_current_screen_border=color2,
                ),
                get_arrow_widget(True, True),
                widget.NetGraph(
                    interface=network_interface,
                    graph_color=graph_color1,
                    fill_color=graph_color1,
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
                    graph_color=graph_color1,
                    fill_color=graph_color1,
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
                    graph_color=graph_color2,
                    fill_color=graph_color2,
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
                    metric=False,
                    threshold=158, # 70 degrees celsius
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
                    graph_color=graph_color1,
                    fill_color=graph_color1,
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
                        'Button3': lambda: qtile.cmd_spawn(terminal + ' --command paru'),
                    },
                    background=color1
                ),
                widget.Spacer(
                    background=color1
                ), # widgets after this are right justified
                get_arrow_widget(False, False),
                widget.Clock(
                    format="%a, %b %-d, %Y, %-I:%M %p %Z",
                    mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(terminal_floating + " zsh -c \"cal --color=always --months 9 | bat --wrap=never --style=plain --paging=always\"") },
                    background=color2
                ),
               get_arrow_widget(False, True),
               widget.Volume(
                    fmt='Volume {}',
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
                    fmt='Brightness {}',
                    mouse_callbacks = {
                        'Button1': lambda: qtile.cmd_spawn('brightnessctl set +10%'),
                        'Button3': lambda: qtile.cmd_spawn('brightnessctl set 10%-'),
                    },
                    background=color2
                ),
            ],
            23,
        ),
        wallpaper='~/Pictures/the_bois.jpg',
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
