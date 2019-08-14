/*
* Copyright (c) 2014-2019 Writer Developers
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

public class Writer.Widgets.TableToolBar : Gtk.Grid {
    public TextEditor editor { get; construct; }

    public TableToolBar (TextEditor editor) {
        Object (
            editor: editor
        );
    }

    construct {
        get_style_context ().add_class ("writer-toolbar");
        get_style_context ().add_class ("frame");

        var table_properties_button = new Gtk.Button.with_label (_("Table Properties"));
        table_properties_button.margin = 12;
        table_properties_button.margin_end = 6;

        var font_button = new Gtk.FontButton ();
        font_button.margin = 12;
        font_button.margin_start = 6;
        font_button.margin_end = 6;
        font_button.use_font = true;
        font_button.use_size = true;
        font_button.tooltip_text = _("Choose font family and font size");

        var font_color_button = new Gtk.ColorButton ();
        font_color_button.margin = 12;
        font_color_button.margin_start = 6;
        font_color_button.margin_end = 6;
        font_color_button.use_alpha = false;
        font_color_button.tooltip_text = _("Choose font color");

        var bold_button = new Gtk.ToggleButton ();
        bold_button.add (new Gtk.Image.from_icon_name ("format-text-bold-symbolic", Gtk.IconSize.BUTTON));
        bold_button.focus_on_click = false;
        bold_button.tooltip_markup = Granite.markup_accel_tooltip ({"<Ctrl>B"}, _("Toggle bold"));

        var italic_button = new Gtk.ToggleButton ();
        italic_button.add (new Gtk.Image.from_icon_name ("format-text-italic-symbolic", Gtk.IconSize.BUTTON));
        italic_button.focus_on_click = false;
        italic_button.tooltip_markup = Granite.markup_accel_tooltip ({"<Ctrl>I"}, _("Toggle italic"));

        var underline_button = new Gtk.ToggleButton ();
        underline_button.add (new Gtk.Image.from_icon_name ("format-text-underline-symbolic", Gtk.IconSize.BUTTON));
        underline_button.focus_on_click = false;
        underline_button.tooltip_markup = Granite.markup_accel_tooltip ({"<Ctrl>U"}, _("Toggle underline"));

        var strikethrough_button = new Gtk.ToggleButton ();
        strikethrough_button.add (new Gtk.Image.from_icon_name ("format-text-strikethrough-symbolic", Gtk.IconSize.BUTTON));
        strikethrough_button.focus_on_click = false;
        strikethrough_button.tooltip_markup = Granite.markup_accel_tooltip ({"<Ctrl>H"}, _("Toggle strikethrough"));

        var styles_buttons = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        styles_buttons.margin = 12;
        styles_buttons.margin_start = 6;
        styles_buttons.margin_end = 6;
        styles_buttons.get_style_context ().add_class (Gtk.STYLE_CLASS_LINKED);
        styles_buttons.pack_start (bold_button);
        styles_buttons.pack_start (italic_button);
        styles_buttons.pack_start (underline_button);
        styles_buttons.pack_start (strikethrough_button);

        var align_button = new Granite.Widgets.ModeButton ();
        align_button.margin = 12;
        align_button.margin_start = 6;
        align_button.margin_end = 6;
        align_button.append (new Gtk.Image.from_icon_name ("format-justify-left-symbolic", Gtk.IconSize.BUTTON));
        align_button.append (new Gtk.Image.from_icon_name ("format-justify-center-symbolic", Gtk.IconSize.BUTTON));
        align_button.append (new Gtk.Image.from_icon_name ("format-justify-right-symbolic", Gtk.IconSize.BUTTON));
        align_button.append (new Gtk.Image.from_icon_name ("format-justify-fill-symbolic", Gtk.IconSize.BUTTON));

        var add_table_button = new Gtk.Button.with_label (_("Add"));
        add_table_button.margin = 12;
        add_table_button.margin_start = 6;
        add_table_button.margin_end = 6;
        add_table_button.tooltip_text = _("Add a new table");

        var delete_table_button = new Gtk.Button.with_label (_("Delete"));
        delete_table_button.margin = 12;
        delete_table_button.margin_start = 6;
        delete_table_button.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);
        delete_table_button.tooltip_text = _("Delete selected table");

        attach (table_properties_button, 0, 0, 1, 1);
        attach (font_button, 1, 0, 1, 1);
        attach (font_color_button, 2, 0, 1, 1);
        attach (styles_buttons, 3, 0, 1, 1);
        attach (align_button, 4, 0, 1, 1);
        attach (add_table_button, 5, 0, 1, 1);
        attach (delete_table_button, 6, 0, 1, 1);

        font_button.font_set.connect (() => {
            string name = font_button.font;
            stdout.printf ("Selected font: %s\n", name);
        });

        align_button.mode_changed.connect (() => {
            change_align (align_button.selected);
        });

        bold_button.button_press_event.connect ((event) => {
            if (event.type == Gdk.EventType.BUTTON_PRESS) {
                editor.toggle_style ("bold");
            }

            return false;
        });

        italic_button.button_press_event.connect ((event) => {
            if (event.type == Gdk.EventType.BUTTON_PRESS) {
                editor.toggle_style ("italic");
            }

            return false;
        });

        underline_button.button_press_event.connect ((event) => {
            if (event.type == Gdk.EventType.BUTTON_PRESS) {
                editor.toggle_style ("underline");
            }

            return false;
        });

        strikethrough_button.button_press_event.connect ((event) => {
            if (event.type == Gdk.EventType.BUTTON_PRESS) {
                editor.toggle_style ("strikethrough");
            }

            return false;
        });
    }

    private void change_align (int index) {
        switch (index) {
            case 1:
                editor.set_justification ("center");
                break;
            case 2:
                editor.set_justification ("right");
                break;
            case 3:
                editor.set_justification ("fill");
                break;
            default:
                editor.set_justification ("left");
                break;
        }
    }
}
