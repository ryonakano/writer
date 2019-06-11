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
        public static Settings settings;
        private string documents = "";
        private string? path = null;
        private string? last_path = null;

        construct {
            application_id = Constants.PROJECT_NAME;

            documents = settings.get_string ("destination");

            if (documents == "") {
                documents = Environment.get_user_special_dir (UserDirectory.DOCUMENTS);
                if (documents != null) {
                    DirUtils.create_with_parents (documents, 0775);
                } else {
                    documents = Environment.get_home_dir ();
                }

                settings.set_string ("destination", documents);
            }
        }

        static construct {
            settings = new Settings (Constants.PROJECT_NAME);
        }

        public override void activate () {
            if (get_windows () != null) {
                window.present ();
                return;
            }

            var window_x = settings.get_int ("window-x");
            var window_y = settings.get_int ("window-y");
            var window_width = settings.get_int ("window-width");
            var window_height = settings.get_int ("window-height");
            var is_maximized = settings.get_boolean ("is-maximized");

            editor = new TextEditor (this);
            window = new MainWindow (this, editor);
            window.set_default_size (window_width, window_height);

            if (window_x == -1 || window_y == -1) {
                window.window_position = Gtk.WindowPosition.CENTER;
            } else {
                window.move (window_x, window_y);
            }

            if (is_maximized) {
                window.maximize ();
            }

            window.show_welcome ();
            window.show_all ();

            var open_file_action = new SimpleAction ("open", null);
            add_action (open_file_action);
            set_accels_for_action ("app.open", {"<Control>o"});
            open_file_action.activate.connect (() => {
                if (window != null) {
                    open_file_dialog ();
                }
            });

            var save_file_action = new SimpleAction ("save", null);
            add_action (save_file_action);
            set_accels_for_action ("app.save", {"<Control>s"});
            save_file_action.activate.connect (() => {
                if (window != null && window.stack.visible_child_name == "editor") {
                    save ();
                }
            });

            var save_as_file_action = new SimpleAction ("save_as", null);
            add_action (save_as_file_action);
            set_accels_for_action ("app.save_as", {"<Control><Shift>s"});
            save_as_file_action.activate.connect (() => {
                if (window != null && window.stack.visible_child_name == "editor") {
                    save_as ();
                }
            });
        }

        public void new_file () {
            int id = 1;
            string file_name = "";
            string suffix = "";
            File? file = null;

            do {
                file_name = "Untitled Document %i".printf (id++);
                suffix = ".rtf";
                file = File.new_for_path ("%s/%s%s".printf (documents, file_name, suffix));
            } while (file.query_exists ());

            path = file.get_path ();
            save ();
            open_file (path);
        }

        public void open_file (string path) {
            editor.set_text (new Utils.RTFParser ().read_all (path), -1);
            window.set_title_for_document (path);
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
                path = filech.get_filename ();

                // Update last visited path
                last_path = path;

                open_file (path);
            }

            filech.close ();
        }

        public void save () {
            new Utils.RTFWriter (editor).write_to_file (path);
        }

        public void save_as () {
            var filech = new Gtk.FileChooserDialog ("Save file with a different name", window, Gtk.FileChooserAction.SAVE);
            var rtf_files_filter = new Gtk.FileFilter ();
            rtf_files_filter.set_filter_name (_("Rich Text Format (.rtf)"));
            rtf_files_filter.add_mime_type ("text/rtf");

            filech.add_button (_("Cancel"), Gtk.ResponseType.CANCEL);
            filech.add_button (_("Save"), Gtk.ResponseType.ACCEPT);
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
                path = filech.get_filename ();

                // Update last visited path
                last_path = path;

                save ();
                open_file (path);
            }

            filech.close ();
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
            var preference_window = new PreferenceWindow (window);
            preference_window.transient_for = window;
            preference_window.show_all ();
        }

        public static void main (string [] args) {
            var app = new Writer.WriterApp ();
            app.run (args);
        }
    }
}
