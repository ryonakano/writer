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

using Granite;
using Granite.Widgets;

namespace Writer.Widgets {
    public class TitleBar : HeaderBar {
        
        private WriterApp app;
        
        public TitleBar (WriterApp app) {
        
            //Basics
            this.app = app;
            this.title = "Writer";
            this.set_show_close_button (true);
            this.get_style_context ().add_class ("primary-toolbar");
            
            //Make buttons
            var new_button  = new Gtk.Button.from_icon_name ("document-new", Gtk.IconSize.LARGE_TOOLBAR);
            var open_button = new Gtk.Button.from_icon_name ("document-open", Gtk.IconSize.LARGE_TOOLBAR);
            var undo_button = new Gtk.Button.from_icon_name ("edit-undo", Gtk.IconSize.LARGE_TOOLBAR);
            var redo_button = new Gtk.Button.from_icon_name ("edit-redo", Gtk.IconSize.LARGE_TOOLBAR);
            var save_button = new Gtk.Button.from_icon_name ("document-save", Gtk.IconSize.LARGE_TOOLBAR);
            
            //Export menu
            var print_item = new Gtk.MenuItem.with_label ("Print");
            var export_menu = new Gtk.Menu ();
                export_menu.append (print_item);
            var export_image = new Image.from_icon_name ("document-export", IconSize.LARGE_TOOLBAR);
            var export_button = new ToolButtonWithMenu (export_image, "Export", export_menu);
            
            //AppMenu
            var app_menu_menu = new Gtk.Menu ();
            var app_menu = app.create_appmenu (app_menu_menu);
            
            //Add buttons to TitleBar
            this.pack_start (new_button);
            this.pack_start (open_button);
            this.pack_start (undo_button);
            this.pack_start (redo_button);
            this.pack_end (app_menu);
            this.pack_end (export_button);
            this.pack_end (save_button);
            
            //Connect events
            new_button.clicked.connect (new_file);
            open_button.clicked.connect (open_file);
            undo_button.clicked.connect (undo);
            redo_button.clicked.connect (redo);
            save_button.clicked.connect (save_file);
            print_item.activate.connect (print_file);
        }
        
        public void new_file () {
            app.new_file ();
        }
        
        public void open_file () {
            app.open_file_dialog ();
        }
        
        public void undo () {
            app.undo ();
        }
        
        public void redo () {
            app.redo ();
        }
        
        public void save_file () {
            app.save_file ();
        }
        
        public void print_file () {
            app.print_file ();
        }
        
    }
}