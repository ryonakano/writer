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

public class Writer.MainWindow : Gtk.ApplicationWindow {
    public Application app { get; construct; }
    public TextEditor editor { get; construct; }
    private Widgets.TitleBar title_bar;
    public Gtk.Stack stack { get; private set; }
    public Views.EditorView editor_view { get; private set; }
    private uint configure_id;

    public MainWindow (Application app, TextEditor editor) {
        Object (
            application: app,
            app: app,
            editor: editor
        );
    }

    construct {
        // Import CSS
        var cssprovider = new Gtk.CssProvider ();
        cssprovider.load_from_resource ("/com/github/ryonakano/writer/Application.css");
        Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (),
                                                    cssprovider,
                                                    Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

        // Follow elementary OS-wide dark preference
        var granite_settings = Granite.Settings.get_default ();
        var gtk_settings = Gtk.Settings.get_default ();

        gtk_settings.gtk_application_prefer_dark_theme = granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK;

        granite_settings.notify["prefers-color-scheme"].connect (() => {
            gtk_settings.gtk_application_prefer_dark_theme = granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK;
        });

        add_events (Gdk.EventMask.BUTTON_PRESS_MASK);

        stack = new Gtk.Stack ();
        stack.transition_duration = 200;
        stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;

        editor_view = new Views.EditorView (editor);
        var welcome_view = new Views.WelcomeView (app);

        stack.add_named (welcome_view, "welcome");
        stack.add_named (editor_view, "editor");
        add (stack);

        title_bar = new Widgets.TitleBar (app);
        set_titlebar (title_bar);

        destroy.connect (app.delete_backup);
    }

    public void show_editor () {
        title_bar.set_active (true);
        stack.visible_child_name = "editor";
    }

    public void show_welcome () {
        title_bar.set_active (false);
        stack.visible_child_name = "welcome";
    }

    public void set_header_title (string path) {
        if (path != "") {
            ///TRANSLATORS: The string shown in the titlebar. "%s" represents the name of an opened file.
            ///The latter string "Writer" is the name of this app.
            title_bar.title = _("%s — Writer").printf (Path.get_basename (path));
        } else {
            ///TRANSLATORS: The string shown in the titlebar. "Writer" is the name of this app.
            title_bar.title = _("Writer");
        }
    }

    protected override bool configure_event (Gdk.EventConfigure event) {
        if (configure_id != 0) {
            GLib.Source.remove (configure_id);
        }

        configure_id = Timeout.add (100, () => {
            configure_id = 0;

            Application.settings.set_boolean ("is-maximized", is_maximized);

            if (!is_maximized) {
                int x, y, w, h;
                get_position (out x, out y);
                get_size (out w, out h);
                Application.settings.set ("window-position", "(ii)", x, y);
                Application.settings.set ("window-size", "(ii)", w, h);
            }

            return false;
        });

        // Redraw document_view when window is resized or maximized/unmaximized, otherwise the view will be broken
        editor_view.document_view.queue_draw ();
        editor_view.document_view_wrapper.queue_draw ();

        return base.configure_event (event);
    }
}
