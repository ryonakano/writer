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
using Pango;

namespace Writer {
    public class Editor : TextBuffer {
    
        public TextView text_view;
    
        public Editor () {
            // Add default tags to this TextBuffer's TextTagTable
            setup_tagtable (this);
            text_view = new TextView.with_buffer (this);
        }
        
        
        /*
         * STYLES
         */
         
        public void apply_style (string name) {
            if (has_selection) {
                TextIter start; TextIter end;
                get_selection_bounds (out start, out end);
                apply_tag_by_name (name, start, end);
            }
        }
        
        public void remove_style (string name) {
            if (has_selection) {
                TextIter start; TextIter end;
                get_selection_bounds (out start, out end);
                var tag = tag_table.lookup (name);
                remove_tag (tag, start, end);
            }
        }
        
        public void toggle_style (string name) {
            if (has_style (name))
                remove_style (name);
            else
                apply_style (name);
        }
        
        public bool has_style (string name) {
            var tag = tag_table.lookup (name);
            return get_selection_range ().has_tag (tag);
        }
        
        public void set_font_size (int size) {
            // TODO
            // Set the font size of the current selection to <size>
            print ("set font size to %d\n", size);
        }
        
        public void justify (string align) {
            // TODO
            // Check if no other justification is already set
            apply_style ("align-" + align);
        }
        
        
        
        private Writer.Utils.TextRange get_selection_range () {
            TextIter start; TextIter end;
            get_selection_bounds (out start, out end);
            return new Writer.Utils.TextRange (this, start, end);
        }
        
        
        // Get a TextTagTable with all the default tags
        private void setup_tagtable (TextBuffer buffer) {
            
            buffer.create_tag ("bold", "weight", 700);
            buffer.create_tag ("italic", "style", Pango.Style.ITALIC);
            buffer.create_tag ("underline", "underline", Pango.Underline.SINGLE);
            buffer.create_tag ("strikethrough", "strikethrough", true);
            
            buffer.create_tag ("align-left", "justification", Gtk.Justification.LEFT);
            buffer.create_tag ("align-center", "justification", Gtk.Justification.CENTER);
            buffer.create_tag ("align-right", "justification", Gtk.Justification.RIGHT);
            buffer.create_tag ("align-fill", "justification", Gtk.Justification.FILL);
            
        }
    
    }
}