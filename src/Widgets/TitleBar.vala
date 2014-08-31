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
        
        private Button save_button;
        private Button undo_button;
        private Button redo_button;
        private Gtk.MenuItem save_as_item;
        private Gtk.MenuItem save_file_item;
        private Gtk.MenuItem save_as_app_item;
        
        public TitleBar (WriterApp app) {
        
            //Basics
            this.app = app;
            this.title = "Writer";
            this.set_show_close_button (true);
            this.get_style_context ().add_class ("primary-toolbar");
            
            //Make buttons
            var open_button = new Gtk.Button.from_icon_name ("document-open", Gtk.IconSize.LARGE_TOOLBAR);
            save_button = new Gtk.Button.from_icon_name ("document-save", Gtk.IconSize.LARGE_TOOLBAR);
            undo_button = new Gtk.Button.from_icon_name ("edit-undo", Gtk.IconSize.LARGE_TOOLBAR);
            redo_button = new Gtk.Button.from_icon_name ("edit-redo", Gtk.IconSize.LARGE_TOOLBAR);
            
            //Export menu
            var print_item = new Gtk.MenuItem.with_label ("Print");
            save_as_item = new Gtk.MenuItem.with_label ("Save As");
            var export_menu = new Gtk.Menu ();
                export_menu.append (save_as_item);
                export_menu.append (print_item);
            var export_image = new Image.from_icon_name ("document-export", IconSize.LARGE_TOOLBAR);
            var export_button = new ToolButtonWithMenu (export_image, "Export", export_menu);
            
            //AppMenu
            var new_file_item = new Gtk.MenuItem.with_label ("New");
            var open_file_item = new Gtk.MenuItem.with_label ("Open");
            save_file_item = new Gtk.MenuItem.with_label ("Save");
            save_as_app_item = new Gtk.MenuItem.with_label ("Save As");
            var preferences_item = new Gtk.MenuItem.with_label ("Preferences");
            var app_menu_menu = new Gtk.Menu ();
                app_menu_menu.add (new_file_item);
                app_menu_menu.add (open_file_item);
                app_menu_menu.add (save_file_item);
                app_menu_menu.add (save_as_app_item);
                app_menu_menu.add (new Gtk.SeparatorMenuItem ());
                app_menu_menu.add (preferences_item);
            var app_menu = app.create_appmenu (app_menu_menu);
            
            //Add buttons to TitleBar
            this.pack_start (open_button);
            this.pack_start (save_button);
            this.pack_start (undo_button);
            this.pack_start (redo_button);
            this.pack_end (app_menu);
            this.pack_end (export_button);
            
            //Connect signals
            open_button.clicked.connect (app.open_file_dialog);
            save_button.clicked.connect (app.save);
            undo_button.clicked.connect (app.undo);
            redo_button.clicked.connect (app.redo);
            
            save_as_item.activate.connect (app.save_as);
            print_item.activate.connect (app.print_file);
            
            new_file_item.activate.connect (app.new_file);
            open_file_item.activate.connect (app.open_file_dialog);
            save_file_item.activate.connect (app.save);
            save_as_app_item.activate.connect (app.save);
            preferences_item.activate.connect (app.preferences);
        }
        
        
        public void set_active (bool active) {
            save_button.sensitive = active;
            undo_button.sensitive = active;
            redo_button.sensitive = active;
            
            save_as_item.sensitive = active;
            save_file_item.sensitive = active;
            save_as_app_item.sensitive = active;
        }       
    }
}