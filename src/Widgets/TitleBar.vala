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

public class Writer.Widgets.TitleBar : Gtk.HeaderBar {
    public Application app { get; construct; }
    private Gtk.Button open_button;
    private Gtk.Button save_as_button;
    private Gtk.Button revert_button;
    private Gtk.Button print_button;
    private Gtk.SearchEntry search_field;
    private Gtk.Button undo_button;
    private Gtk.Button redo_button;

    public TitleBar (Application app) {
        Object (
            app: app,
            title: _("Writer"),
            show_close_button: true
        );
    }

    construct {
        open_button = new Gtk.Button.from_icon_name ("document-open", Gtk.IconSize.LARGE_TOOLBAR);
        open_button.tooltip_markup = Granite.markup_accel_tooltip ({"<Ctrl>O"}, _("Open a file"));

        save_as_button = new Gtk.Button.from_icon_name ("document-save-as", Gtk.IconSize.LARGE_TOOLBAR);
        save_as_button.tooltip_markup = Granite.markup_accel_tooltip ({"<Shift><Ctrl>S"}, _("Save this file with a different name"));

        revert_button = new Gtk.Button.from_icon_name ("document-revert", Gtk.IconSize.LARGE_TOOLBAR);
        revert_button.tooltip_markup = Granite.markup_accel_tooltip ({"<Shift><Ctrl>O"}, _("Restore this file"));

        print_button = new Gtk.Button.from_icon_name ("document-export", Gtk.IconSize.LARGE_TOOLBAR);
        print_button.tooltip_markup = Granite.markup_accel_tooltip ({"<Ctrl>P"}, _("Print this file"));

        search_field = new Gtk.SearchEntry ();
        search_field.valign = Gtk.Align.CENTER;
        search_field.placeholder_text = _("Find");
        search_field.search_changed.connect (() => {
            app.search (search_field.text);
        });

        undo_button = new Gtk.Button.from_icon_name ("edit-undo", Gtk.IconSize.LARGE_TOOLBAR);
        undo_button.tooltip_markup = Granite.markup_accel_tooltip ({"<Ctrl>Z"}, _("Undo"));

        redo_button = new Gtk.Button.from_icon_name ("edit-redo", Gtk.IconSize.LARGE_TOOLBAR);
        redo_button.tooltip_markup = Granite.markup_accel_tooltip ({"<Ctrl><Shift>Z"}, _("Redo"));

        var preferences_item = new Gtk.MenuItem.with_label (_("Preferences"));
        var app_menu_menu = new Gtk.Menu ();
        app_menu_menu.add (preferences_item);
        var app_menu = new Gtk.MenuButton ();
        app_menu.set_popup (app_menu_menu);
        app_menu.set_image (new Gtk.Image.from_icon_name ("open-menu", Gtk.IconSize.LARGE_TOOLBAR));
        app_menu.tooltip_text = _("Preferences");
        app_menu_menu.show_all ();

        pack_start (open_button);
        pack_start (save_as_button);
        pack_start (revert_button);
        pack_end (print_button);
        pack_end (app_menu);
        pack_end (redo_button);
        pack_end (undo_button);
        pack_end (search_field);

        open_button.clicked.connect (app.open_file_dialog);
        save_as_button.clicked.connect (app.save_as);
        revert_button.clicked.connect (() => {
            revert_button.sensitive = !app.revert ();
        });
        print_button.clicked.connect (app.print_file);
        undo_button.clicked.connect (app.undo);
        redo_button.clicked.connect (app.redo);

        preferences_item.activate.connect (app.preferences);

        app.editor.changed.connect (() => {
            if (!revert_button.sensitive) {
                revert_button.sensitive = true;
            }
        });
    }

    public void set_active (bool active) {
        save_as_button.sensitive = active;
        revert_button.sensitive = false;
        print_button.sensitive = active;
        undo_button.sensitive = active;
        redo_button.sensitive = active;
        search_field.sensitive = active;
    }
}
