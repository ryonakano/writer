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

using Gtk;

#if HAVE_ZEITGEIST
using Zeitgeist;
#endif

namespace Writer {

    public class MainWindow : Gtk.Window {
        private WriterApp app;
        private TextEditor editor;
        private Widgets.TitleBar title_bar;
        public Widgets.EditorView editor_view;
        private Widgets.WelcomeView welcome_view;
        private Gtk.Stack stack;

#if HAVE_ZEITGEIST
        // Zeitgeist integration
        private Zeitgeist.DataSourceRegistry registry;
#endif

        public MainWindow (WriterApp app, TextEditor editor) {
            this.app = app;
            this.editor = editor;
            this.set_application (app);

            this.set_size_request (950, 800);
            this.window_position = Gtk.WindowPosition.CENTER;
            this.add_events (Gdk.EventMask.BUTTON_PRESS_MASK);
            Writer.Utils.add_stylesheet ();

            setup_ui ();
            this.show_all ();

#if HAVE_ZEITGEIST
            // Set up the Data Source Registry for Zeitgeist
            registry = new DataSourceRegistry ();

            var ds_event = new Zeitgeist.Event ();
            ds_event.actor = "application://com.github.ryonakano.writer.desktop";
            ds_event.add_subject (new Zeitgeist.Subject ());
            GenericArray<Zeitgeist.Event> ds_events = new GenericArray<Zeitgeist.Event>();
            ds_events.add(ds_event);
            var ds = new DataSource.full ("writer-logger",
                                          _("Zeitgeist Datasource for Writer"),
                                          "A data source which logs Open, Close, Save and Move Events",
                                          ds_events); // FIXME: templates!
            registry.register_data_source.begin (ds, null, (obj, res) => {
                try {
                    registry.register_data_source.end (res);
                } catch (GLib.Error reg_err) {
                    warning ("%s", reg_err.message);
                }
            });
#endif
        }

        private void setup_ui () {
            stack = new Gtk.Stack ();
            stack.transition_duration = 200;
            stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;

            title_bar = new Widgets.TitleBar (app);
            editor_view = new Widgets.EditorView (editor);
            welcome_view = new Widgets.WelcomeView (app);

            this.set_titlebar (title_bar);

            stack.add_named (welcome_view, "welcome");
            stack.add_named (editor_view, "editor");
            this.add (stack);
        }

        public void show_editor () {
            title_bar.set_active (true);
            stack.visible_child_name = "editor";
        }

        public void show_welcome () {
            title_bar.set_active (false);
            stack.visible_child_name = "welcome";
        }
    }
}
