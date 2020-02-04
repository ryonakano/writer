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
    private Views.EditorView editor_view;
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

#if HAVE_ZEITGEIST
        // Set up the Data Source Registry for Zeitgeist
        var registry = new Zeitgeist.DataSourceRegistry ();

        var ds_event = new Zeitgeist.Event ();
        ds_event.actor = "application://" + Constants.PROJECT_NAME + ".desktop";
        ds_event.add_subject (new Zeitgeist.Subject ());
        var ds_events = new GenericArray<Zeitgeist.Event> ();
        ds_events.add (ds_event);
        var ds = new Zeitgeist.DataSource.full ("writer-logger",
                                        _("Zeitgeist Datasource for Writer"),
                                        _("A data source which logs Open, Close, Save and Move Events"),
                                        ds_events); // FIXME: templates!
        registry.register_data_source.begin (ds, null, (obj, res) => {
            try {
                registry.register_data_source.end (res);
            } catch (Error reg_err) {
                warning ("%s", reg_err.message);
            }
        });
#endif
    }

    public void show_editor () {
        title_bar.set_active (true);
        stack.visible_child_name = "editor";
    }

    public void show_welcome () {
        title_bar.set_active (false);
        stack.visible_child_name = "welcome";
    }

    public void set_title_for_document (string path) {
        ///TRANSLATORS: The string shown in the titlebar. "%s" represents the name of an opened file.
        ///The latter string "Writer" is the name of this app.
        title_bar.title = _("%s — Writer").printf (Path.get_basename (path));
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
