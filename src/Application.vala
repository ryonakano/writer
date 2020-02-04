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

public class Writer.Application : Gtk.Application {
    private MainWindow window;
    private TextEditor editor;
    public static Settings settings;
    private string destination = "";
    private string? path = null;
    private string? last_path = null;

    #if HAVE_ZEITGEIST
    private Utils.ZeitgeistLogger zg_log = new Utils.ZeitgeistLogger ();
    #endif

    public Application () {
        Object (
            application_id: Constants.PROJECT_NAME,
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    construct {
        destination = settings.get_string ("destination");

        if (destination == "") {
            destination = Environment.get_user_special_dir (UserDirectory.DOCUMENTS);

            if (destination != null) {
                DirUtils.create_with_parents (destination, 0775);
            } else {
                destination = Environment.get_home_dir ();
            }

            settings.set_string ("destination", destination);
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

        int window_x, window_y, window_width, window_height;
        settings.get ("window-position", "(ii)", out window_x, out window_y);
        settings.get ("window-size", "(ii)", out window_width, out window_height);
        var is_maximized = settings.get_boolean ("is-maximized");

        editor = new TextEditor ();
        editor.changed.connect (() => {
            save ();
        });

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

        var bold_action = new SimpleAction ("bold", null);
        add_action (bold_action);
        set_accels_for_action ("app.bold", {"<Control>b"});
        bold_action.activate.connect (() => {
            if (window != null && window.stack.visible_child_name == "editor") {
                editor.toggle_style ("bold");
            }
        });

        var italic_action = new SimpleAction ("italic", null);
        add_action (italic_action);
        set_accels_for_action ("app.italic", {"<Control>i"});
        italic_action.activate.connect (() => {
            if (window != null && window.stack.visible_child_name == "editor") {
                editor.toggle_style ("italic");
            }
        });

        var underline_action = new SimpleAction ("underline", null);
        add_action (underline_action);
        set_accels_for_action ("app.underline", {"<Control>u"});
        underline_action.activate.connect (() => {
            if (window != null && window.stack.visible_child_name == "editor") {
                editor.toggle_style ("underline");
            }
        });

        var strikethrough_action = new SimpleAction ("strikethrough", null);
        add_action (strikethrough_action);
        set_accels_for_action ("app.strikethrough", {"<Control>h"});
        strikethrough_action.activate.connect (() => {
            if (window != null && window.stack.visible_child_name == "editor") {
                editor.toggle_style ("strikethrough");
            }
        });
    }

    public void new_file () {
        int id = 1;
        string file_name = "";
        string suffix = "";
        File? file = null;

        do {
            file_name = _("Untitled Document %i").printf (id++);
            suffix = ".rtf";
            file = File.new_for_path ("%s/%s%s".printf (destination, file_name, suffix));
        } while (file.query_exists ());

        path = file.get_path ();
        save ();
        open_file (path);
    }

    private void open_file (string path) {
        editor.set_text (new Utils.RTFParser ().read_all (path), -1);
        window.set_title_for_document (path);
        window.show_editor ();

        #if HAVE_ZEITGEIST
        try {
            string uri = GLib.Filename.to_uri (path);
            zg_log.open_insert (uri, uri.substring (uri.last_index_of (".") + 1));
        } catch (ConvertError e) {
            warning (e.message);
        }
        #endif
    }

    public void open_file_dialog () {
        var filech = new Gtk.FileChooserDialog (_("Choose a file to open"), window, Gtk.FileChooserAction.OPEN);
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

        filech.key_press_event.connect ((event) => {
            if (Gdk.keyval_name (event.keyval) == "Escape") {
                filech.destroy ();
            }

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
        var filech = new Gtk.FileChooserDialog (
            _("Save file with a different name"),
            window,
            Gtk.FileChooserAction.SAVE
        );
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

        filech.key_press_event.connect ((event) => {
            if (Gdk.keyval_name (event.keyval) == "Escape") {
                filech.destroy ();
            }

            return false;
        });

        if (filech.run () == Gtk.ResponseType.ACCEPT) {
            path = filech.get_filename ();
            // Update last visited path
            last_path = path;
            save ();
            open_file (path);

            #if HAVE_ZEITGEIST
            try {
                string uri = GLib.Filename.to_uri (path);
                zg_log.open_insert (uri, uri.substring (uri.last_index_of (".") + 1));
            } catch (ConvertError e) {
                warning (e.message);
            }
            #endif
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
        var preference_window = new Widgets.PreferenceWindow (window);
        preference_window.transient_for = window;
        preference_window.show_all ();
    }

    public static void main (string [] args) {
        var app = new Writer.Application ();
        app.run (args);
    }
}
