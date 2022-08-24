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

import os
import re
import socket
import subprocess


from libqtile import bar, layout, widget, qtile
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

mod = "mod1"
terminal = "alacritty"
network_interface = "wlp1s0"

keys = [
    Key([mod], "h", lazy.layout.left(), desc="Move focus left"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus right"),
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window left"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window right"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "b", lazy.spawn("brave"), desc="Launch brave"),
    Key([mod], "d", lazy.spawn("discord"), desc="Launch discord"),
    Key([mod], "g", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "c", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod, "shift"], "Return", lazy.spawn("dmenu_run"), desc='Run Dmenu Launcher'),
]

groups = [Group(i) for i in "1234"]

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
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

layouts = [
    # layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    layout.MonadTall(
        new_client_position='top',
        margin=8,
    ),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="Source Code Pro", # use monospace font for bar so that widgets have a constant width
    fontsize=13,
    fontshadow='#002e63'
)
extension_defaults = widget_defaults.copy()

color1 = '#253253'
color2 = '#4169E1'

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
                widget.Wlan(
                    interface=network_interface,
                    format='{essid}',
                    max_chars=10,
                    background=color2
                ),
                widget.Net(
                    interface=network_interface,
                    format='{up:7} ↑↓ {down:7}',
                    padding=5,
                    background=color2
                ),
                get_arrow_widget(True, False),
                widget.TextBox(
                    text="CPU:",
                    mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(terminal + ' --command htop --sort-key=PERCENT_CPU')},
                    padding=10,
                    background=color1
                ),
                widget.CPU(
                    format="{load_percent:4.1f}%",
                    mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(terminal + ' --command htop --sort-key=PERCENT_CPU')},
                    background=color1
                ),
                widget.ThermalSensor(
                    tag_sensor="CPU",
                    mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(terminal + ' --command htop --sort-key=PERCENT_CPU')},
                    background=color1
                ),
                get_arrow_widget(True, True),
                widget.Memory(
                    format="RAM: {MemUsed:4.0f}{mm}/{MemTotal:4.0f}{mm}",
                    mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(terminal + ' --command htop --sort-key=PERCENT_MEM')},
                    background=color2
                ),
                get_arrow_widget(True, False),
                widget.Volume(
                    fmt='Volume: {}',
                    mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(terminal + ' --command alsamixer')},
                    padding = 10,
                    background=color1
                ),
                get_arrow_widget(True, True),
                widget.CheckUpdates(
                    # requires an internet connection (good)
                    # other options (pacman -Qu; pacman -Sup) show stale info unless you first manually run pacman -Sy (so bad)
                    # https://www.reddit.com/r/qtile/comments/ur8mz3/comment/i90sa7d/
                    distro="Arch_checkupdates",
                    no_update_string="Updates: 0",
                    background=color2
                ),
                get_arrow_widget(True, False),
                widget.Spacer(
                    background=color1
                ), # widgets before this are left justified; widgets after: right justified
                get_arrow_widget(False, False),
                widget.Battery(
                    format="Battery: {char} {percent:2.0%}",
                    charge_char = '↑',
                    discharge_char = '↓',
                    update_interval = 600, # 10 minutes
                    background=color2
                ),
                get_arrow_widget(False, True),
                widget.Clock(
                    format="%Y-%m-%d %a %H:%M",
                    background=color1
                ),
            ],
            22,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(wm_class="pinentry-gtk-2"), # pass: master-password entry window
        Match(wm_class="coreshot"), # coreshot: "capture selection" window
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        Match(title="Bluetooth Devices"),  # bluetooth
    ]
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
