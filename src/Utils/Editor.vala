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
        public Widgets.EditorToolBar toolbar;
    
        public Editor () {
            // Add default tags to this TextBuffer's TextTagTable
            setup_tagtable (this);
            text_view = new TextView.with_buffer (this);
            
            toolbar = new Widgets.EditorToolBar (this);
            
            this.notify["cursor-position"].connect (() => {cursor_moved ();});
            this.insert_text.connect_after (text_inserted);
        }
        
        
        /*
         * STYLES (apply, remove, check)
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
            
            if (has_selection) {
                return get_selection_range ().has_tag (tag);
            } else {
                var cursor = get_cursor ();
                return cursor.has_tag (tag) || cursor.begins_tag (tag) || cursor.ends_tag (tag);
            }
        }
        
        public bool iter_has_style (TextIter iter, string name) {
            var tag = tag_table.lookup (name);
            return iter.has_tag (tag) || iter.begins_tag (tag) || iter.ends_tag (tag);
        }
        
        public int get_align_type (TextIter iter) {
            //0=left, 1=center, 2=right, 3=fill
            if (iter_has_style (iter, "align-center"))
                return 1;
            else if (iter_has_style (iter, "align-right"))
                return 2;
            else if (iter_has_style (iter, "align-fill"))
                return 3;
            else
                return 0;
                
        }
        
        
        
        public void set_font_size (int size) {
            // TODO
            // Set the font size of the current selection to <size>
            print ("set font size to %d\n", size);
        }
        
        public void justify (string align) {
            // TODO
            // Check if no other justification is already set
            remove_style ("align-left");
            remove_style ("align-center");
            remove_style ("align-right");
            remove_style ("align-fill");
            
            apply_style ("align-" + align);
        }
        
        
        
        /*
         * Utilities
         */
        
        private Writer.Utils.TextRange get_selection_range () {
            TextIter start; TextIter end;
            get_selection_bounds (out start, out end);
            return new Writer.Utils.TextRange (this, start, end);
        }
        
        private TextIter get_cursor () {
            TextIter iter;
            get_iter_at_mark (out iter, get_insert ());
            return iter;
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
        
        
        
        /*
         * Signal callbacks
         */
        
        private void cursor_moved () {
            toolbar.bold_button.active = has_style ("bold");
            toolbar.italic_button.active = has_style ("italic");
            toolbar.underline_button.active = has_style ("underline");
            toolbar.strikethrough_button.active = has_style ("strikethrough");
            
            toolbar.align_button.selected = get_align_type (get_cursor ());
        }
        
        private void text_inserted (TextIter cursor, string new_text, int length) {
            if (length == 1) {
                TextIter previous;
                get_iter_at_offset (out previous, cursor.get_offset () - 1);
                
                if (iter_has_style (previous, "bold"))
                    apply_tag_by_name ("bold", previous, cursor);
                if (iter_has_style (previous, "italic"))
                    apply_tag_by_name ("italic", previous, cursor);
                if (iter_has_style (previous, "underline"))
                    apply_tag_by_name ("underline", previous, cursor);
                if (iter_has_style (previous, "strikethrough"))
                    apply_tag_by_name ("strikethrough", previous, cursor);
            }
        }
    
    }
}