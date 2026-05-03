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

from datetime import datetime

from libqtile import bar, layout, widget, qtile
from libqtile.config import Click, Drag, Group, Key, Match, Screen, KeyChord
from libqtile.lazy import lazy
from os.path import expanduser

mod = "mod1"
terminal = "alacritty"
terminal_floating = terminal + " --class floating_terminal --command"
network_interface = "wlp1s0"

def unfloat_and_next_layout(qtile):
    for window in qtile.current_group.windows:
        window.floating = False
    qtile.next_layout()

keys = [
    Key([mod], "b", lazy.spawn("librewolf")), # mnemonic: browser
    Key([mod], "e", lazy.spawn("evince")), # document viewer

    Key([mod], "Return", lazy.spawn(terminal)),
    Key([mod], "f", lazy.function(unfloat_and_next_layout)), # mnemonic: fullscreen
    Key([mod], "s", lazy.spawn("bash -c \"slurp | xargs -I{} grim -g {} ~/Pictures/screenshots/$(date -Iseconds).png\"")),
    Key([mod], "c", lazy.window.kill()),
    Key([mod], "r", lazy.reload_config()),
    Key([mod], "q", lazy.shutdown()),

    Key([mod], "h", lazy.layout.left().when(layout=['monadtall']), lazy.layout.previous().when(layout=['max'])),
    Key([mod], "j", lazy.layout.down().when(layout=['monadtall'])),
    Key([mod], "k", lazy.layout.up().when(layout=['monadtall'])),
    Key([mod], "l", lazy.layout.right().when(layout=['monadtall']), lazy.layout.next().when(layout=['max'])),
    Key([mod, "shift"], "h", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right()),
]

groups = [
    Group("1"),
    Group("2"),
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

color_themes = [
    ['#253253', '#4169E1'],
    ['#1B1B1B', '#FFD700'],
    ['#2D5A27', '#A7C957'],
    ['#4B0082', '#E0B0FF'],
    ['#800000', '#FF6347'],
    ['#004B49', '#20B2AA'],
    ['#2F4F4F', '#FFA500'],
]
color1, color2 = color_themes[datetime.now().weekday()]
font_shadow_color = '#002e63'
border_focus_color = '#04C1E2'

#color1 = '#CE1713'
#color2 = '#0F7833'
#font_shadow_color = '#000000'
#border_focus_color = '#00FF00'

layouts = [
    layout.Max(),
    layout.MonadTall(
        new_client_position='bottom',
        border_focus=border_focus_color,
        border_width=2,
        change_ratio=0.02,
        min_ratio=0.1,
        max_ratio=0.9,
    ),
]

widget_defaults = dict(
    font="Source Code Pro", # use monospace font for bar so that widgets have a constant width
    fontsize=13,
    fontshadow=font_shadow_color
)
extension_defaults = widget_defaults.copy()

def get_arrow_widget(color_parody: bool) -> widget.TextBox:
    return widget.TextBox(
            text = '',
            foreground = color1 if color_parody else color2,
            background = color2 if color_parody else color1,
            padding = 0,
            fontsize = 20
    )

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(
                    padding_x=3,
                    padding_y=3,
                    background=color1,
                    this_current_screen_border=color2,
                ),
                widget.TaskList(
                    padding_x=3,
                    padding_y=1,
                    background=color1,
                    borderwidth=3,
                    border=color2,
                    max_title_width=100,
                ),
                widget.CheckUpdates(
                    distro="Arch_checkupdates",
                    display_format="ᗧ·· {updates}",
                    no_update_string="ᗧ·· 0",
                    update_interval = 1800, # 30 minutes
                    background=color1
                ),
                get_arrow_widget(False),
                widget.Net(
                    interface=network_interface,
                    format='{up:5.2f}{up_suffix} ↑↓ {down:5.2f}{down_suffix}',
                    padding=5,
                    prefix='M',
                    background=color2,
                    mouse_callbacks = {
                        'Button1': lambda: qtile.spawn(terminal_floating + ' nmtui')
                    },
                ),
                get_arrow_widget(True),
                widget.TextBox(
                    text="CPU",
                    mouse_callbacks = {'Button1': lambda: qtile.spawn(terminal_floating + ' htop --sort-key=PERCENT_CPU')},
                    padding=10,
                    background=color1
                ),
                widget.CPU(
                    format="{load_percent:4.1f}%",
                    mouse_callbacks = {'Button1': lambda: qtile.spawn(terminal_floating + ' htop --sort-key=PERCENT_CPU')},
                    background=color1
                ),
                get_arrow_widget(False),
                widget.Memory(
                    format="RAM {MemUsed:4.0f}{mm}/{MemTotal:4.0f}{mm}",
                    mouse_callbacks = {'Button1': lambda: qtile.spawn(terminal_floating + ' htop --sort-key=PERCENT_MEM')},
                    background=color2
                ),
                get_arrow_widget(True),
                widget.Clock(
                    format="%a, %b %-d, %Y, %-I:%M %p %Z",
                    mouse_callbacks = {'Button1': lambda: qtile.spawn(terminal_floating + " zsh -c \"cal --color=always --months 9 | bat --wrap=never --style=plain --paging=always\"") },
                    background=color1
                ),
               get_arrow_widget(False),
               widget.Volume(
                    fmt='Volume {}',
                    mouse_callbacks = {
                        'Button1': lambda: qtile.spawn('amixer set Master 9+'),
                        'Button2': lambda: qtile.spawn('pavucontrol'),
                        'Button3': lambda: qtile.spawn('amixer set Master 9-'),
                    },
                    padding = 10,
                    background=color2
                ),
                get_arrow_widget(True),
                widget.Backlight(
                    backlight_name='intel_backlight',
                    fmt='Brightness {}',
                    mouse_callbacks = {
                        'Button1': lambda: qtile.spawn('brightnessctl set +10%'),
                        'Button3': lambda: qtile.spawn('brightnessctl set 10%-'),
                    },
                    background=color1
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
    # scroll to resize split
    Click([mod], "Button6", lazy.layout.shrink_main()),
    Click([mod], "Button7", lazy.layout.grow_main()),
    Click([mod, "shift"], "Button4", lazy.layout.shrink_main()),
    Click([mod, "shift"], "Button5", lazy.layout.grow_main()),
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
