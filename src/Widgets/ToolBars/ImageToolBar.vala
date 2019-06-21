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

namespace Writer.Widgets {
    public class ImageToolBar : Gtk.Toolbar {
        public TextEditor editor { get; set; }
        public Granite.Widgets.ModeButton align_button;

        public ImageToolBar (TextEditor editor) {
            Object (
                editor: editor
            );
        }

        construct {
            get_style_context ().add_class ("writer-toolbar");

            var wrap_combobox = new Gtk.ComboBoxText ();
            wrap_combobox.append (_("In line of text"), ("In line of text"));
            wrap_combobox.append (_("Float above text"), ("Float above text"));
            wrap_combobox.set_active_id ("In line of text");
            var wrap_item = new Gtk.ToolItem ();
            wrap_item.add (wrap_combobox);

            var lock_aspect_check = new Gtk.CheckButton.with_label (_("Lock aspect ratio"));
            var lock_aspect_item = new Gtk.ToolItem ();
            lock_aspect_item.add (lock_aspect_check);

            align_button = new Granite.Widgets.ModeButton ();
            align_button.append (new Gtk.Image.from_icon_name ("format-justify-left-symbolic", Gtk.IconSize.BUTTON));
            align_button.append (new Gtk.Image.from_icon_name ("format-justify-center-symbolic", Gtk.IconSize.BUTTON));
            align_button.append (new Gtk.Image.from_icon_name ("format-justify-right-symbolic", Gtk.IconSize.BUTTON));
            var align_item = new Gtk.ToolItem ();
            align_item.add (align_button);

            var edit_image_button = new Gtk.Button.with_label (_("Crop"));
            var edit_image_item = new Gtk.ToolItem ();
            edit_image_item.add (edit_image_button);

            var delete_image_button = new Gtk.Button.with_label (_("Delete Image"));
            delete_image_button.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);
            var delete_image_item = new Gtk.ToolItem ();
            delete_image_item.add (delete_image_button);

            wrap_item.border_width = 6;
            lock_aspect_item.border_width = 6;
            align_item.border_width = 6;
            edit_image_item.border_width = 6;
            delete_image_item.border_width = 6;

            add (wrap_item);
            add (lock_aspect_item);
            add (align_item);
            add (edit_image_item);
            add (delete_image_item);

            align_button.mode_changed.connect (() => {
                change_align (align_button.selected);
            });
        }

        public void change_align (int index) {
            switch (index) {
                case 1:
                    editor.set_justification ("center"); break;
                case 2:
                    editor.set_justification ("right"); break;
                default:
                    editor.set_justification ("left"); break;
            }
        }
    }
}
