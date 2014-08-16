/***
The MIT License (MIT)

Copyright (c) 2014 Tuur Dutoit

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

-> Taken from Scratch (https://launchpad.net/scratch/)
***/


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