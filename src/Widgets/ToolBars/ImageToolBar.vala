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

public class Writer.Widgets.ImageToolBar : Gtk.Grid {
    private TextEditor editor;

    public ImageToolBar () {
    }

    construct {
        editor = Writer.TextEditor.get_default ();

        get_style_context ().add_class ("writer-toolbar");
        get_style_context ().add_class ("frame");

        var wrap_combobox = new Gtk.ComboBoxText ();
        wrap_combobox.margin = 12;
        wrap_combobox.margin_end = 6;
        wrap_combobox.append ("in-line", _("In line of text"));
        wrap_combobox.append ("float", _("Float above text"));
        wrap_combobox.set_active_id ("in-line");
        wrap_combobox.tooltip_text = _("Set how to wrap text");

        var lock_aspect_check = new Gtk.CheckButton.with_label (_("Lock aspect ratio"));
        lock_aspect_check.margin = 12;
        lock_aspect_check.margin_start = 6;
        lock_aspect_check.margin_end = 6;
        lock_aspect_check.tooltip_text = _("Allow to resize images without changing aspect ratio");

        var align_button = new Granite.Widgets.ModeButton ();
        align_button.margin = 12;
        align_button.margin_start = 6;
        align_button.margin_end = 6;
        align_button.append (new ToolBarImage ("format-justify-left-symbolic", _("Align image left")));
        align_button.append (new ToolBarImage ("format-justify-center-symbolic", _("Center image")));
        align_button.append (new ToolBarImage ("format-justify-right-symbolic", _("Align image right")));

        var edit_image_button = new Gtk.Button.with_label (_("Crop"));
        edit_image_button.margin = 12;
        edit_image_button.margin_start = 6;
        edit_image_button.margin_end = 6;
        edit_image_button.tooltip_text = _("Remove unnecessary part of image");

        var delete_image_button = new Gtk.Button.with_label (_("Delete Image"));
        delete_image_button.margin = 12;
        delete_image_button.margin_start = 6;
        delete_image_button.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);
        delete_image_button.tooltip_text = _("Delete selected image");

        attach (wrap_combobox, 0, 0, 1, 1);
        attach (lock_aspect_check, 1, 0, 1, 1);
        attach (align_button, 2, 0, 1, 1);
        attach (edit_image_button, 3, 0, 1, 1);
        attach (delete_image_button, 4, 0, 1, 1);

        align_button.mode_changed.connect (() => {
            change_align (align_button.selected);
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
            default:
                editor.set_justification ("left");
                break;
        }
    }
}
