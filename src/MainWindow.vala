/***
The MIT License (MIT)

Copyright (c) 2014 Tuur Dutoit

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
***/


using Gtk;

#if HAVE_ZEITGEIST
using Zeitgeist;
#endif

namespace Writer {
    
    public class MainWindow : Gtk.Window {
        
        private WriterApp app;
        private Editor editor;
        private Widgets.TitleBar title_bar;
        public Widgets.EditorView editor_view;
        private Widgets.WelcomeView welcome_view;
        private Gtk.Stack stack;

#if HAVE_ZEITGEIST
        // Zeitgeist integration
        private Zeitgeist.DataSourceRegistry registry;
#endif
        
        public MainWindow (WriterApp app, Editor editor) {
            this.app = app;
            this.editor = editor;
            this.set_application (app);
            
            this.set_size_request (850, 750);
            this.window_position = Gtk.WindowPosition.CENTER;
            this.add_events (Gdk.EventMask.BUTTON_PRESS_MASK);
            
            // Build UI
            setup_ui ();
            this.show_all ();

#if HAVE_ZEITGEIST
            // Set up the Data Source Registry for Zeitgeist
            registry = new DataSourceRegistry ();

            var ds_event = new Zeitgeist.Event ();
            ds_event.actor = "application://writer.desktop";
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
            
            // TitleBar
            title_bar = new Widgets.TitleBar (app);
            
            
            // EditorView
            editor_view = new Widgets.EditorView (editor);
            
            
            // WelcomeView
            welcome_view = new Widgets.WelcomeView (app);
            
            
            //Attach headerbar
            this.set_titlebar (title_bar);
            
            // Add main box to window
            stack.add_named (welcome_view, "welcome");
            stack.add_named (editor_view, "editor");
            this.add (stack);
        }
        
        public void show_editor () {
            stack.visible_child_name = "editor";
        }
        
        public void show_welcome () {
            stack.visible_child_name = "welcome";
        }
        
        public void set_title_for_document (Utils.Document doc) {
            var home_dir = Environment.get_home_dir ();
            var path = Path.get_dirname (doc.file.get_uri ()).replace (home_dir, "~");
            path = path.replace ("file://", "");

            if ("trash://" in path)
                path = "Trash";

            path = Uri.unescape_string (path);
            title_bar.title = doc.file.get_basename () + " (%s)".printf(path);
        }
    }
}