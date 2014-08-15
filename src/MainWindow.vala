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

namespace Writer {
    
    public class MainWindow : Gtk.Window {
        
        private WriterApp app;
        private Editor editor;
        
        public MainWindow (WriterApp app, Editor editor) {
            this.app = app;
            this.editor = editor;
            this.set_application (app);
            
            this.set_size_request (850, 850);
            this.window_position = Gtk.WindowPosition.CENTER;
            
            // Build UI
            setup_ui ();
            this.show_all ();
        }
        
        private void setup_ui () {
            var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            
            //TitleBar
            var title_bar = new Widgets.TitleBar (app);
            
            
            //EditorView
            var editor_view = new Widgets.EditorView (editor);
            
            
            // Create a new Welcome widget
            var welcome = new Widgets.WelcomeView ("Welcome to Writer", "Open a saved file or create a new one to begin!", app);
            
            
            //Attach headerbar
            this.set_titlebar (title_bar);
            
            // Add main box to window
            // TODO: Add ToolBar to the EditorView (not present yet) and not to the main box
            // Now, it appears above the WelcomeView, which is definitely not what we want
            box.pack_start (welcome, true, true, 0);
            box.pack_end (editor_view, true, true, 0);
            this.add (box);
        }
    }
}