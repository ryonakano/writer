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

        construct {
            application_id = "com.github.ryonakano.writer";
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
            window.editor_view.set_tab_label_for_document (doc);
            window.show_editor ();
        }

        public void open_file_dialog () {
            var filech = Utils.file_chooser_dialog (Gtk.FileChooserAction.OPEN, "Choose a file to open", window, false);

            if (filech.run () == Gtk.ResponseType.ACCEPT) {
                var uri = filech.get_uris ().nth_data (0);

                // Update last visited path
                Utils.last_path = Path.get_dirname (uri);

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
