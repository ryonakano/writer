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
    public class ImageToolBar : Gtk.Toolbar {
        private TextEditor editor;
        public ModeButton align_button;

        public ImageToolBar (TextEditor editor) {
            this.editor = editor;

            var wrap_combobox = new Gtk.ComboBoxText ();
            wrap_combobox.append ("In line of text", ("In line of text"));
            wrap_combobox.append ("Float above text", ("Float above text"));
            wrap_combobox.set_active_id ("In line of text");
            var wrap_item = new Gtk.ToolItem ();
            wrap_item.add (wrap_combobox);

            var lock_aspect_check = new Gtk.CheckButton.with_label ("Lock aspect ratio");
            var lock_aspect_item = new Gtk.ToolItem ();
            lock_aspect_item.add (lock_aspect_check);

            var align_item = new ToolItem ();
            align_button = new ModeButton ();
            align_button.append (new Gtk.Button.from_icon_name ("format-justify-left-symbolic", Gtk.IconSize.BUTTON));
            align_button.append (new Gtk.Button.from_icon_name ("format-justify-center-symbolic", Gtk.IconSize.BUTTON));
            align_button.append (new Gtk.Button.from_icon_name ("format-justify-right-symbolic", Gtk.IconSize.BUTTON));
            align_item.add (align_button);

            var edit_image_button = new Gtk.Button.with_label ("Crop");
            var edit_image_item = new Gtk.ToolItem ();
            edit_image_item.add (edit_image_button);

            var delete_image_button = new Gtk.Button.with_label ("Delete Image");
            var delete_image_item = new Gtk.ToolItem ();
            delete_image_item.add (delete_image_button);

            this.add (wrap_item);
            this.add (lock_aspect_item);
            this.add (align_item);
            this.add (edit_image_item);
            this.add (delete_image_item);

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
