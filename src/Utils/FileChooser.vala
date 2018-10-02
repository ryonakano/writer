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
*
* Taken from Code (https://github.com/elementary/code)
*/

namespace Writer.Utils {

    public string? last_path = null;
    
    // Create a GtkFileChooserDialog to perform the action desired
    public Gtk.FileChooserDialog file_chooser_dialog (Gtk.FileChooserAction action, string title, Gtk.Window? parent, bool select_multiple = false) {
        var filech = new Gtk.FileChooserDialog (title, parent, action);
        filech.set_select_multiple (select_multiple);
        filech.add_button (Gtk.Stock.CANCEL, Gtk.ResponseType.CANCEL);
        if (action == Gtk.FileChooserAction.OPEN)
            filech.add_button (Gtk.Stock.OPEN, Gtk.ResponseType.ACCEPT);
        else
            filech.add_button (Gtk.Stock.SAVE, Gtk.ResponseType.ACCEPT);
        filech.set_default_response (Gtk.ResponseType.ACCEPT);
        filech.set_current_folder_uri (Utils.last_path ?? GLib.Environment.get_home_dir ());
        filech.key_press_event.connect ((ev) => {
            if (ev.keyval == 65307) // Esc key
                filech.destroy ();
            return false;
        });
        var all_files_filter = new Gtk.FileFilter ();
        all_files_filter.set_filter_name ("All files");
        all_files_filter.add_pattern ("*");
        var text_files_filter = new Gtk.FileFilter ();
        text_files_filter.set_filter_name ("Text files");
        text_files_filter.add_mime_type ("text/*");
        filech.add_filter (all_files_filter);
        filech.add_filter (text_files_filter);
        filech.set_filter (text_files_filter);
        return filech;
    }
}