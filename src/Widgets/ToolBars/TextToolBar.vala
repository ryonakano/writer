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

public class Writer.Widgets.TextToolBar : Gtk.Grid {
    public TextEditor editor { get; construct; }
    private Gtk.ToggleButton bold_button;
    private Gtk.ToggleButton italic_button;
    private Gtk.ToggleButton underline_button;
    private Gtk.ToggleButton strikethrough_button;
    private Gtk.Button indent_more_button;
    private Gtk.Button indent_less_button;
    public Granite.Widgets.ModeButton align_button;

    public TextToolBar (TextEditor editor) {
        Object (
            editor: editor
        );
    }

    construct {
        get_style_context ().add_class ("writer-toolbar");
        get_style_context ().add_class ("frame");

        editor.cursor_moved.connect (cursor_moved);

        var paragraph_combobox = new Gtk.ComboBoxText ();
        paragraph_combobox.margin = 12;
        paragraph_combobox.margin_end = 6;
        paragraph_combobox.append ("paragraph", _("Paragraph"));
        paragraph_combobox.append ("title", _("Title"));
        paragraph_combobox.append ("subtitle", _("Subtitle"));
        paragraph_combobox.append ("bullet-list", _("Bullet List"));
        paragraph_combobox.append ("numbered-List", _("Numbered List"));
        paragraph_combobox.append ("two-column", _("Two-Column"));
        paragraph_combobox.set_active_id ("paragraph");
        paragraph_combobox.tooltip_text = _("Set text style");

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

        bold_button = new Gtk.ToggleButton ();
        bold_button.add (new ToolBarImage ("format-text-bold-symbolic",  _("Toggle bold"), "<Ctrl>B"));
        bold_button.focus_on_click = false;

        italic_button = new Gtk.ToggleButton ();
        italic_button.add (new ToolBarImage ("format-text-italic-symbolic", _("Toggle italic"), "<Ctrl>I"));
        italic_button.focus_on_click = false;

        underline_button = new Gtk.ToggleButton ();
        underline_button.add (new ToolBarImage ("format-text-underline-symbolic", _("Toggle underline"), "<Ctrl>U"));
        underline_button.focus_on_click = false;

        strikethrough_button = new Gtk.ToggleButton ();
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

        align_button = new Granite.Widgets.ModeButton ();
        align_button.margin = 12;
        align_button.margin_start = 6;
        align_button.margin_end = 6;
        align_button.append (new ToolBarImage ("format-justify-left-symbolic", _("Align text left")));
        align_button.append (new ToolBarImage ("format-justify-center-symbolic", _("Center text")));
        align_button.append (new ToolBarImage ("format-justify-right-symbolic", _("Align text right")));
        align_button.append (new ToolBarImage ("format-justify-fill-symbolic", _("Justify text")));

        indent_more_button = new Gtk.Button.from_icon_name ("format-indent-more-symbolic", Gtk.IconSize.BUTTON);
        indent_more_button.tooltip_text = _("Increase indent");
        indent_less_button = new Gtk.Button.from_icon_name ("format-indent-less-symbolic", Gtk.IconSize.BUTTON);
        indent_less_button.tooltip_text = _("Decrease indent");
        var indent_button = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        indent_button.margin = 12;
        indent_button.margin_start = 6;
        indent_button.margin_end = 6;
        indent_button.get_style_context ().add_class (Gtk.STYLE_CLASS_LINKED);
        indent_button.add (indent_more_button);
        indent_button.add (indent_less_button);

        var insert_comment_button = new Gtk.Button.from_icon_name ("insert-text-symbolic", Gtk.IconSize.BUTTON);
        insert_comment_button.tooltip_text = _("Insert text");
        var insert_link_button = new Gtk.Button.from_icon_name ("insert-link-symbolic", Gtk.IconSize.BUTTON);
        insert_link_button.tooltip_text = _("Insert link");
        var insert_image_button = new Gtk.Button.from_icon_name ("insert-image-symbolic", Gtk.IconSize.BUTTON);
        insert_image_button.tooltip_text = _("Insert image");
        var insert_table_button = new Gtk.Button.from_icon_name ("insert-object-symbolic", Gtk.IconSize.BUTTON);
        insert_table_button.tooltip_text = _("Insert table");
        var insert_button = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        insert_button.margin = 12;
        insert_button.margin_start = 6;
        insert_button.get_style_context ().add_class (Gtk.STYLE_CLASS_LINKED);
        insert_button.add (insert_comment_button);
        insert_button.add (insert_link_button);
        insert_button.add (insert_image_button);
        insert_button.add (insert_table_button);

        attach (paragraph_combobox, 0, 0, 1, 1);
        attach (font_button, 1, 0, 1, 1);
        attach (font_color_button, 2, 0, 1, 1);
        attach (styles_buttons, 3, 0, 1, 1);
        attach (align_button, 4, 0, 1, 1);
        attach (indent_button, 5, 0, 1, 1);
        attach (insert_button, 6, 0, 1, 1);

        align_button.mode_changed.connect (() => {
            change_align (align_button.selected);
        });

        font_button.font_set.connect (() => {
            editor.set_font_from_string (font_button.font);
        });

        font_color_button.color_set.connect (() => {
            var rgba = Gdk.RGBA ();
            rgba = font_color_button.rgba;
            editor.set_font_color (rgba);
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

    /*
    * Signal callbacks
    */

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

    private void cursor_moved () {
        bold_button.active = editor.has_style ("bold");
        italic_button.active = editor.has_style ("italic");
        underline_button.active = editor.has_style ("underline");
        strikethrough_button.active = editor.has_style ("strikethrough");

        align_button.selected = editor.get_justification_as_int ();

        // TODO
        // Update font and color Gtk.Buttons
    }
}
