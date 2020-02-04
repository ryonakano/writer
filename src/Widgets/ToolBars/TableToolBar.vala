/*
* Copyright 2014-2020 Writer Developers
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
        table_properties_button.tooltip_text = _("Set properties of selected table");

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
        bold_button.add (new ToolBarImage ("format-text-bold-symbolic", _("Toggle bold"), "<Ctrl>B"));
        bold_button.focus_on_click = false;

        var italic_button = new Gtk.ToggleButton ();
        italic_button.add (new ToolBarImage ("format-text-italic-symbolic", _("Toggle italic"), "<Ctrl>I"));
        italic_button.focus_on_click = false;

        var underline_button = new Gtk.ToggleButton ();
        underline_button.add (new ToolBarImage ("format-text-underline-symbolic", _("Toggle underline"), "<Ctrl>U"));
        underline_button.focus_on_click = false;

        var strikethrough_button = new Gtk.ToggleButton ();
        strikethrough_button.add (new ToolBarImage ("format-text-strikethrough-symbolic", _("Toggle strikethrough"), "<Ctrl>H"));
        strikethrough_button.focus_on_click = false;

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
        align_button.append (new ToolBarImage ("format-justify-left-symbolic", _("Align table left")));
        align_button.append (new ToolBarImage ("format-justify-center-symbolic", _("Center table")));
        align_button.append (new ToolBarImage ("format-justify-right-symbolic", _("Align table right")));
        align_button.append (new ToolBarImage ("format-justify-fill-symbolic", _("Justify table")));

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
