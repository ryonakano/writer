/*
* Copyright (c) 2014-2018 Writer Developers
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

using Gtk;
using Gdk;
using Granite.Widgets;

namespace Writer.Widgets {
    public class TextToolBar : Gtk.Toolbar {
        private TextEditor editor;
        public FontButton font_button;
        public ColorButton font_color_button;
        public ToggleButton bold_button;
        public ToggleButton italic_button;
        public ToggleButton underline_button;
        public ToggleButton strikethrough_button;
        public Button indent_more_button;
        public Button indent_less_button;
        public ModeButton align_button;
        public Gtk.SeparatorToolItem item_separator;

        public TextToolBar (TextEditor editor) {
            this.get_style_context ().add_class ("writer-toolbar");

            this.editor = editor;
            editor.cursor_moved.connect (cursor_moved);

            setup_ui ();
        }

        public void setup_ui () {
            var paragraph_combobox = new Gtk.ComboBoxText ();
            paragraph_combobox.append ("Paragraph", ("Paragraph"));
            paragraph_combobox.append ("Title", ("Title"));
            paragraph_combobox.append ("Subtitle", ("Subtitle"));
            paragraph_combobox.append ("Bullet List", ("Bullet List"));
            paragraph_combobox.append ("Numbered List", ("Numbered List"));
            paragraph_combobox.append ("Two-Column", ("Two-Column"));
            paragraph_combobox.set_active_id ("Paragraph");
            var paragraph_item = new ToolItem ();
            paragraph_item.add (paragraph_combobox);

            var font_item = new ToolItem ();
            font_button = new Gtk.FontButton ();
            font_button.use_font = true;
            font_button.use_size = true;
            font_item.add (font_button);

            font_color_button = new Gtk.ColorButton ();
            font_color_button.use_alpha = false;
            font_color_button.set_title ("Choose a Font Color");

            var font_color_item = new Gtk.ToolItem ();
            font_color_item.add (font_color_button);

            var styles_item = new ToolItem ();
            var styles_buttons = new ButtonGroup ();
            bold_button = new Gtk.ToggleButton ();
            bold_button.add (new Image.from_icon_name ("format-text-bold-symbolic", Gtk.IconSize.MENU));
            bold_button.focus_on_click = false;
            styles_buttons.pack_start (bold_button);
            italic_button = new Gtk.ToggleButton ();
            italic_button.add (new Image.from_icon_name ("format-text-italic-symbolic", Gtk.IconSize.BUTTON));
            italic_button.focus_on_click = false;
            styles_buttons.pack_start (italic_button);
            underline_button = new Gtk.ToggleButton ();
            underline_button.add (new Image.from_icon_name ("format-text-underline-symbolic", Gtk.IconSize.BUTTON));
            underline_button.focus_on_click = false;
            styles_buttons.pack_start (underline_button);
            strikethrough_button = new Gtk.ToggleButton ();
            strikethrough_button.add (new Image.from_icon_name ("format-text-strikethrough-symbolic", Gtk.IconSize.BUTTON));
            strikethrough_button.focus_on_click = false;
            styles_buttons.pack_start (strikethrough_button);
            styles_item.add (styles_buttons);

            var align_item = new ToolItem ();
            align_button = new ModeButton ();
            align_button.append (new Gtk.Image.from_icon_name ("format-justify-left-symbolic", Gtk.IconSize.BUTTON));
            align_button.append (new Gtk.Image.from_icon_name ("format-justify-center-symbolic", Gtk.IconSize.BUTTON));
            align_button.append (new Gtk.Image.from_icon_name ("format-justify-right-symbolic", Gtk.IconSize.BUTTON));
            align_button.append (new Gtk.Image.from_icon_name ("format-justify-fill-symbolic", Gtk.IconSize.BUTTON));
            align_item.add (align_button);

            var indent_button = new ButtonGroup ();
            var indent_more_button = new Button.from_icon_name ("format-indent-more-symbolic", Gtk.IconSize.BUTTON);
            var indent_less_button = new Button.from_icon_name ("format-indent-less-symbolic", Gtk.IconSize.BUTTON);
            indent_button.add (indent_more_button);
            indent_button.add (indent_less_button);
            var indent_item = new Gtk.ToolItem ();
            indent_item.add (indent_button);

            item_separator = new Gtk.SeparatorToolItem ();

            var insert_button = new ButtonGroup ();
            var insert_comment_button = new Button.from_icon_name ("insert-text-symbolic", Gtk.IconSize.BUTTON);
            var insert_link_button = new Button.from_icon_name ("insert-link-symbolic", Gtk.IconSize.BUTTON);
            var insert_image_button = new Button.from_icon_name ("insert-image-symbolic", Gtk.IconSize.BUTTON);
            var insert_table_button = new Button.from_icon_name ("insert-object-symbolic", Gtk.IconSize.BUTTON);
            insert_button.add (insert_comment_button);
            insert_button.add (insert_link_button);
            insert_button.add (insert_image_button);
            insert_button.add (insert_table_button);
            var insert_item = new Gtk.ToolItem ();
            insert_item.add (insert_button);

            paragraph_item.border_width = 5;
            font_item.border_width = 5;
            font_color_item.border_width = 5;
            styles_item.border_width = 5;
            align_item.border_width = 5;
            indent_item.border_width = 5;
            insert_item.border_width = 5;

            this.add (paragraph_item);
            this.add (font_item);
            this.add (font_color_item);
            this.add (styles_item);
            this.add (align_item);
            this.add (indent_item);
            this.add (item_separator);
            this.add (insert_item);

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
                if (event.type == EventType.BUTTON_PRESS)
                    editor.toggle_style ("bold");
                return false;
            });
            italic_button.button_press_event.connect ((event) => {
                if (event.type == EventType.BUTTON_PRESS)
                    editor.toggle_style ("italic");
                return false;
            });
            underline_button.button_press_event.connect ((event) => {
                if (event.type == EventType.BUTTON_PRESS)
                    editor.toggle_style ("underline");
                return false;
            });
            strikethrough_button.button_press_event.connect ((event) => {
                if (event.type == EventType.BUTTON_PRESS)
                    editor.toggle_style ("strikethrough");
                return false;
            });
        }

        /*
         * Signal callbacks
         */

        public void change_align (int index) {
            switch (index) {
                case 1:
                    editor.set_justification ("center"); break;
                case 2:
                    editor.set_justification ("right"); break;
                case 3:
                    editor.set_justification ("fill"); break;
                default:
                    editor.set_justification ("left"); break;
            }
        }

        public void cursor_moved () {
            bold_button.active = editor.has_style ("bold");
            italic_button.active = editor.has_style ("italic");
            underline_button.active = editor.has_style ("underline");
            strikethrough_button.active = editor.has_style ("strikethrough");

            align_button.selected = editor.get_justification_as_int ();

            // TODO
            // Update font and color buttons
        }
    }
}
