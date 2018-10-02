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

        private Button open_button;
        private Button save_button;
        private Button revert_button;
        private Button print_button;
        private Gtk.MenuItem save_as_item;
        private Gtk.SearchEntry search_field;

        public TitleBar (WriterApp app) {

            //Basics
            this.app = app;
            this.title = "Writer";
            this.set_show_close_button (true);
            this.get_style_context ().add_class ("primary-toolbar");

            //Make buttons
            open_button = new Gtk.Button.from_icon_name ("document-open", Gtk.IconSize.LARGE_TOOLBAR);
            save_button = new Gtk.Button.from_icon_name ("document-save", Gtk.IconSize.LARGE_TOOLBAR);
            revert_button = new Gtk.Button.from_icon_name ("document-revert", Gtk.IconSize.LARGE_TOOLBAR);
            print_button = new Gtk.Button.from_icon_name ("document-export", Gtk.IconSize.LARGE_TOOLBAR);

            //Search Field
            search_field = new Gtk.SearchEntry ();
            search_field.placeholder_text = "Find";
            search_field.search_changed.connect (() => {
                app.search (search_field.text);
            });

            //AppMenu
            save_as_item = new Gtk.MenuItem.with_label ("Save As");
            var preferences_item = new Gtk.MenuItem.with_label ("Preferences");
            var app_menu_menu = new Gtk.Menu ();
            app_menu_menu.add (save_as_item);
            app_menu_menu.add (new Gtk.SeparatorMenuItem ());
            app_menu_menu.add (preferences_item);
            var app_menu = new Gtk.MenuButton ();
            app_menu.set_popup (app_menu_menu);
            app_menu.set_image (new Gtk.Image.from_icon_name ("open-menu", Gtk.IconSize.LARGE_TOOLBAR));
            app_menu.tooltip_text = _("Preferences");
            app_menu_menu.show_all ();

            //Add buttons to TitleBar
            this.pack_start (open_button);
            this.pack_start (save_button);
            this.pack_start (revert_button);
            this.pack_end (print_button);
            this.pack_end (app_menu);
            this.pack_end (search_field);

            //Connect signals
            open_button.clicked.connect (app.open_file_dialog);
            save_button.clicked.connect (app.save);
            revert_button.clicked.connect (app.revert);
            print_button.clicked.connect (app.print_file);

            save_as_item.activate.connect (app.save);
            preferences_item.activate.connect (app.preferences);
        }


        public void set_active (bool active) {
            save_button.sensitive = active;
            revert_button.sensitive = active;
            print_button.sensitive = active;
            search_field.sensitive = active;

            save_as_item.sensitive = active;
        }
    }
}
