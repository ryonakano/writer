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

namespace Writer.Widgets {
    public class TableChooser : Gtk.Grid {
    
        public int columns;
        public int rows;
        
        public signal void selected (int columns, int rows);
        
        public TableChooser () {
            column_spacing = 6;
            row_spacing = 4;
            
            
            setup_ui ();
        }
        
        private void setup_ui () {
            // Make some content
            var cols_spin = new Gtk.SpinButton.with_range (1, 10, 1);
            var rows_spin = new Gtk.SpinButton.with_range (1, 10, 1);
            
            var insert_button = new Gtk.Button.with_label ("Insert Table");
            
            // Make some labels
            var main_label = new Gtk.Label ("Table");
                main_label.xalign = 0;
            var cols_label = new Gtk.Label ("Columns:");
                cols_label.xalign = 0;
            var rows_label = new Gtk.Label ("Rows:");
                rows_label.xalign = 0;
            
            // Package...
            attach (main_label, 0, 0, 2, 1);
            attach (cols_label, 0, 1, 1, 1);
            attach (cols_spin, 1, 1, 1, 1);
            attach (rows_label, 0, 2, 1, 1);
            attach (rows_spin, 1, 2, 1, 1);
            attach (insert_button, 0, 3, 2, 1);
            
            
            // Attach signals
            insert_button.clicked.connect (() => {
                columns = cols_spin.get_value_as_int ();
                rows = rows_spin.get_value_as_int ();
                selected (columns, rows);
            });
        }
    
    }
}

