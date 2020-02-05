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

public class Writer.Widgets.PreferenceWindow : Gtk.Dialog {
    public MainWindow window { get; construct; }

    public PreferenceWindow (MainWindow parent) {
        Object (
            window: parent,
            resizable: false,
            deletable: false,
            modal: true,
            title: _("Preferences"),
            width_request: 420,
            height_request: 300,
            window_position: Gtk.WindowPosition.CENTER_ON_PARENT
        );
    }

    construct {
        var destination_label = new Gtk.Label (_("Document folder location:"));
        destination_label.halign = Gtk.Align.END;

        var destination_chooser_button = new Gtk.FileChooserButton (
            _("Select Document Folder…"),
            Gtk.FileChooserAction.SELECT_FOLDER
        );
        destination_chooser_button.halign = Gtk.Align.START;
        destination_chooser_button.set_current_folder (Application.settings.get_string ("destination"));

        var count_include_spaces_label = new Gtk.Label ("Include spaces to count characters:");
        count_include_spaces_label.halign = Gtk.Align.END;

        var count_include_spaces_switch = new Gtk.Switch ();
        count_include_spaces_switch.halign = Gtk.Align.START;
        count_include_spaces_switch.state_flags_changed.connect (() => {
            window.editor_view.action_bar.update_char_count ();
        });

        var main_grid = new Gtk.Grid ();
        main_grid.margin = 12;
        main_grid.column_spacing = 6;
        main_grid.row_spacing = 6;
        main_grid.attach (destination_label, 0, 0, 1, 1);
        main_grid.attach (destination_chooser_button, 1, 0, 1, 1);
        main_grid.attach (count_include_spaces_label, 0, 1, 1, 1);
        main_grid.attach (count_include_spaces_switch, 1, 1, 1, 1);

        var content = (Gtk.Box) get_content_area ();
        content.add (main_grid);

        var close_button = add_button (_("Close"), Gtk.ResponseType.CLOSE);
        ((Gtk.Button) close_button).clicked.connect (() => destroy ());

        destination_chooser_button.file_set.connect (() => {
            Application.settings.set_string ("destination", destination_chooser_button.get_filename ());
        });

        Application.settings.bind ("count-include-spaces", count_include_spaces_switch, "active", SettingsBindFlags.DEFAULT);
    }
}
