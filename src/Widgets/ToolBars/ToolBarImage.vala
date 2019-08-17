/*
* Copyright (c) 2019 Writer Developers
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

public class Writer.Widgets.ToolBarImage : Gtk.Image {
    public string tooltip { get; construct; }
    public string markup_key { get; construct; }

    public ToolBarImage (string icon_name, string tooltip, string? markup_key = null) {
        Object (
            icon_name: icon_name,
            tooltip: tooltip,
            markup_key: markup_key,
            icon_size: Gtk.IconSize.BUTTON
        );
    }

    construct {
        if (markup_key != null) {
            tooltip_markup = Granite.markup_accel_tooltip ({markup_key}, tooltip);
        } else {
            tooltip_text = tooltip;
        }
    }
}
