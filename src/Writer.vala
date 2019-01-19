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

namespace Writer {

    public class WriterApp : Gtk.Application {
        private MainWindow window;
        private TextEditor editor;
        private string? last_path = null;

        construct {
            application_id = Constants.PROJECT_NAME;
        }

        public override void activate () {
            if (get_windows () == null) {
                editor = new TextEditor ();
                window = new MainWindow (this, editor);
                window.show_welcome ();
                window.show_all ();
            } else {
                window.present ();
            }
        }

        public void new_file () {
            window.show_editor ();
        }

        public void open_file (Utils.Document doc) {
            editor.set_text (doc.read_all (), -1);
            window.set_title_for_document (doc.path);
            window.show_editor ();
        }

        public void open_file_dialog () {
            var filech = new Gtk.FileChooserDialog ("Choose a file to open", window, Gtk.FileChooserAction.OPEN);
            var rtf_files_filter = new Gtk.FileFilter ();
            rtf_files_filter.set_filter_name (_("Rich Text Format (.rtf)"));
            rtf_files_filter.add_mime_type ("text/rtf");

            filech.add_button (_("Cancel"), Gtk.ResponseType.CANCEL);
            filech.add_button (_("Open"), Gtk.ResponseType.ACCEPT);
            filech.add_filter (rtf_files_filter);
            filech.set_current_folder_uri (last_path ?? Environment.get_home_dir ());
            filech.set_default_response (Gtk.ResponseType.ACCEPT);
            filech.select_multiple = false;
            filech.filter = rtf_files_filter;

            filech.key_press_event.connect ((ev) => {
                if (ev.keyval == 65307) // Esc key
                    filech.destroy ();
                return false;
            });

            if (filech.run () == Gtk.ResponseType.ACCEPT) {
                var uri = filech.get_uris ().nth_data (0);

                // Update last visited path
                last_path = Path.get_dirname (uri);

                // Open the file
                var doc = new Utils.Document (uri);
                open_file (doc);
            }

            filech.close ();
        }

        public void save () {
            print ("save\n");
        }

        public void save_as () {
            print ("save as\n");
        }

        public void revert () {
            print ("revert\n");
        }

        public void print_file () {
            print ("print\n");
        }

        public void search (string text) {
            // TODO: When tabs will be added, first get the active Editor
            editor.search (text);
        }

        public void preferences () {
            print ("Open preferences dialog\n");
        }

        public static void main (string [] args) {
            var app = new Writer.WriterApp ();
            app.run (args);
        }
    }
}
