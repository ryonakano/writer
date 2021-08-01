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
    public TextEditor editor { get; private set; }
    public static Settings settings;
    private bool has_open_file;
    private string destination = "";
    private string file_name = "";
    private string path = "";
    private File? opened_file = null;
    private File? backedup_file = null;

    public Application () {
        Object (
            application_id: Constants.PROJECT_NAME,
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    construct {
        Intl.setlocale (LocaleCategory.ALL, "");
        GLib.Intl.bindtextdomain (Constants.GETTEXT_PACKAGE, Constants.LOCALEDIR);
        GLib.Intl.bind_textdomain_codeset (Constants.GETTEXT_PACKAGE, "UTF-8");
        GLib.Intl.textdomain (Constants.GETTEXT_PACKAGE);

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

        bool revertable = false;

        var revert_file_action = new SimpleAction ("revert", null);
        add_action (revert_file_action);
        set_accels_for_action ("app.revert", {"<Control><Shift>o"});
        revert_file_action.activate.connect (() => {
            if (window != null && window.stack.visible_child_name == "editor") {
                if (revertable) {
                    revertable = !revert ();
                }

                editor.changed.connect (() => {
                    revertable = true;
                });
            }
        });

        var close_file_action = new SimpleAction ("close", null);
        add_action (close_file_action);
        set_accels_for_action ("app.close", {"<Control>w"});
        close_file_action.activate.connect (() => {
            if (window != null && window.stack.visible_child_name == "editor") {
                close_file ();
            }
        });

        var quit_action = new SimpleAction ("quit", null);
        add_action (quit_action);
        set_accels_for_action ("app.quit", {"<Control>q"});
        quit_action.activate.connect (() => {
            if (window != null) {
                window.destroy ();
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
        string name = "";
        string suffix = "";

        do {
            name = _("Untitled Document %i").printf (id++);
            suffix = ".rtf";
            opened_file = File.new_for_path ("%s/%s%s".printf (destination, name, suffix));
        } while (opened_file.query_exists ());

        path = opened_file.get_path ();
        file_name = opened_file.get_basename ();
        save ();
        open_file ();
        create_backup ();
    }

    private void open_file () {
        has_open_file = true;
        editor.set_text (new Utils.RTFParser ().read_all (path), -1);
        window.set_header_title (path);
        window.show_editor ();
        editor.text_view.grab_focus ();
    }

    public void open_file_dialog () {
        var filech = new Gtk.FileChooserDialog (_("Choose a file to open"), window, Gtk.FileChooserAction.OPEN);
        var rtf_files_filter = new Gtk.FileFilter ();
        rtf_files_filter.set_filter_name (_("Rich Text Format (.rtf)"));
        rtf_files_filter.add_mime_type ("text/rtf");

        filech.add_button (_("Cancel"), Gtk.ResponseType.CANCEL);
        filech.add_button (_("Open"), Gtk.ResponseType.ACCEPT);
        filech.add_filter (rtf_files_filter);
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
            file_name = filech.get_file ().get_basename ();
            open_file ();
            create_backup ();
        }

        filech.close ();
    }

    private void close_file () {
        path = "";
        delete_backup ();
        editor.set_text ("");
        window.set_header_title ("");
        window.show_welcome ();
    }

    private void create_backup () {
        // Take a backup in /tmp
        opened_file = File.new_for_path (path);
        backedup_file = File.new_for_path ("%s/%s".printf (Environment.get_tmp_dir (), file_name));

        try {
            opened_file.copy (backedup_file, FileCopyFlags.OVERWRITE, null, (current_num_bytes, total_num_bytes) => {
                debug ("Opened file backuped");
            });
        } catch (Error err) {
            warning (err.message);
        }
    }

    public void delete_backup () {
        if (!has_open_file) {
            return;
        }

        try {
            backedup_file.delete ();
        } catch (Error err) {
            warning (err.message);
        }
    }

    public void save () {
        if (path != "") {
            Utils.RTFWriter.get_default ().write_to_file (path, editor.text);
        }
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
            file_name = filech.get_current_name ();
            save ();
            open_file ();
        }

        filech.close ();
    }

    public bool revert () {
        var revert_dialog = new Granite.MessageDialog.with_image_from_icon_name (
            _("Are you sure you want to revret this file?"),
            _("Changes you made will be discarded."),
            "dialog-warning",
            Gtk.ButtonsType.CANCEL
        );
        revert_dialog.transient_for = window;

        var revert_button = revert_dialog.add_button (_("Revert"), Gtk.ResponseType.ACCEPT);
        revert_button.get_style_context ().add_class (Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);

        if (revert_dialog.run () == Gtk.ResponseType.ACCEPT) {
            try {
                backedup_file.copy (opened_file, FileCopyFlags.OVERWRITE, null, (current_num_bytes, total_num_bytes) => {
                    // Report copy-status
                    debug ("%" + int64.FORMAT + " bytes of %" + int64.FORMAT + " bytes copied.",
                        current_num_bytes, total_num_bytes);
                });

                // Refresh the text view
                open_file ();
            } catch (Error err) {
                warning (err.message);
            }

            revert_dialog.destroy ();
            return true;
        }

        revert_dialog.destroy ();
        return false;
    }

    public void print_file () {
        print ("print\n");
    }

    public void search (string text) {
        // TODO: When tabs will be added, first get the active Editor
        editor.search (text);
    }

    public void undo () {
        if (editor.can_undo) {
            editor.undo ();
        }

        editor.text_view.grab_focus ();
    }

    public void redo () {
        if (editor.can_redo) {
            editor.redo ();
        }

        editor.text_view.grab_focus ();
    }

    public void preferences () {
        var preference_dialog = new Widgets.PreferenceDialog (window);
        preference_dialog.show_all ();
    }

    public static void main (string [] args) {
        var app = new Writer.Application ();
        app.run (args);
    }
}
