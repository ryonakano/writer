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
using Gdk;
using Pango;
using Writer.Utils;

namespace Writer {
    public class TextEditor : TextBuffer {
    
        public TextView text_view;
        
        public signal void cursor_moved ();
        public signal void text_inserted ();
    
        public TextEditor () {
            setup_tagtable (this);
            text_view = new TextView.with_buffer (this);
            
            this.notify["cursor-position"].connect (cursor_moved_callback);
            this.insert_text.connect_after (text_inserted_callback);
            
            text_view.key_press_event.connect (key_press_callback);
            text_view.pixels_below_lines = 20;
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
         * Styles (apply, remove, check)
         */
         
        public void apply_style (string name) {
            if (has_selection)
                get_selection_range ().apply_style (name);
        }
        
        public void remove_style (string name) {
            if (has_selection)
                get_selection_range ().remove_style (name);
        }
        
        public void toggle_style (string name) {
            if (has_selection)
                get_selection_range ().toggle_style (name);
        }
        
        public bool has_style (string name) {
            if (has_selection)
                return get_selection_range ().has_style (name);
            else
                return iter_has_style (get_cursor (), name);
        }
        
        
        public Gtk.Justification get_justification () {
            if (has_selection)
                return get_selection_range ().get_justification ();
            else
                return get_justification_at_iter (get_cursor ());
        }
        
        public Gtk.Justification get_justification_at_iter (TextIter iter) {
            if (iter_has_style (iter, "align-center"))
                return Gtk.Justification.CENTER;
            else if (iter_has_style (iter, "align-right"))
                return Gtk.Justification.RIGHT;
            else if (iter_has_style (iter, "align-fill"))
                return Gtk.Justification.FILL;
            else
                return Gtk.Justification.LEFT;
        }
        
        public int get_justification_as_int () {
            if (has_selection)
                return get_selection_range ().get_justification_as_int ();
            else
                return get_justification_as_int_at_iter (get_cursor ());
        }
        
        public int get_justification_as_int_at_iter (TextIter iter) {
            if (iter_has_style (iter, "align-center"))
                return 1;
            else if (iter_has_style (iter, "align-right"))
                return 2;
            else if (iter_has_style (iter, "align-fill"))
                return 3;
            else
                return 0;
        }
        
        public void set_justification (string align) {
            get_paragraph (get_cursor ()).set_justification (align);
        }
        
        
        public void set_font (FontDescription font) {
            get_selection_range ().set_font (font);
        }
        
        public void set_font_from_string (string font) {
            get_selection_range ().set_font_from_string (font);
        }
        
        
        public void set_font_color (Gdk.Color color) {
            get_selection_range ().set_font_color (color);
        }
        
        public void set_font_color_from_string (string color) {
            get_selection_range ().set_font_color_from_string (color);
        }
        
        
        
        /*
         * Inserts
         */
        
        public void insert_comment () {
            print ("Insert Comment\n");
        }
        
        public void insert_image () {
            print ("Insert Image\n");
        }
        
        public void insert_link () {
            print ("Insert Link\n");
        }
        
        public void insert_table (int cols, int rows) {
            print ("Insert Table of %d columns by %d rows\n", cols, rows);
        }
        
        
        public void insert_line () {
            TextIter insert_cursor = get_cursor ();
            insert_line_at_iter (insert_cursor);
        }
        
        public void insert_paragraph () {
            TextIter cursor = get_cursor ();
            insert_paragraph_at_iter (cursor);
        }
        
        public void insert_line_at_iter (TextIter iter) {
            //TODO
            // Cursor does not move to next line
            // Only happens when inserting at the end of the buffer
            // Bug reported in GTK+
            
            insert (ref iter, "\u2028", -1);
        }
        
        public void insert_paragraph_at_iter (TextIter iter) {
            insert (ref iter, "\n", -1);
        }
        
        
        
        
        /*
         * paragraphs
         */
        
        // Moves iter to the start of the paragraph it is located in
        public TextIter get_paragraph_start (TextIter iter) {
            iter.backward_find_char ((char) => {
                if (char.to_string () == "\n")
                    return true;
                else
                    return false;
            }, null);
            return iter;
        }
        
        // Moves iter to the end of the paragraph it is located in
        public TextIter get_paragraph_end (TextIter iter) {
            iter.forward_find_char ((char) => {
                if (char.to_string () == "\n")
                    return true;
                else
                    return false;
            }, null);
            return iter;
        }
        
        public TextRange get_paragraph (TextIter iter) {
            TextIter start = get_paragraph_start (iter);
            TextIter end = get_paragraph_end (iter);
            
            return new TextRange (this, start, end);
        }
        
        
        
        
        /*
         * Search
         */
        
        public void search (string text) {
            if (text.length > 0)
                search_string (text);
            else
                clear_search ();
        }
        
        public void search_string (string text) {
            print ("Searching for: %s\n", text);
        }
        
        public void clear_search () {
            print ("Clearing search");
        }
        
        
        
        /*
         * Utilities
         */
        
        public TextIter get_cursor () {
            TextIter iter;
            get_iter_at_mark (out iter, get_insert ());
            return iter;
        }
        
        public TextRange get_cursor_as_range () {
            var cursor = get_cursor ();
            return new TextRange (this, cursor, cursor);
        }
        
        public TextRange get_selection_range () {
            TextIter start; TextIter end;
            get_selection_bounds (out start, out end);
            return new TextRange (this, start, end);
        }
        
        public bool iter_has_tag (TextIter iter, TextTag tag) {
            return iter.has_tag (tag) || iter.begins_tag (tag) || iter.ends_tag (tag);
        }
        
        public bool iter_has_style (TextIter iter, string name) {
            var tag = tag_table.lookup (name);
            return iter_has_tag (iter, tag);
        }
        
        public TextIter copy_iter (TextIter iter) {
            TextIter copy;
            get_iter_at_offset (out copy, iter.get_offset ());
            return copy;
        }
        
        
        
        
        
        /*
         * Signal callbacks
         */
        
        private void cursor_moved_callback () {
            // Emit 'cursor_moved' signal
            cursor_moved ();
        }
        
        private void text_inserted_callback (TextIter cursor, string new_text, int length) {
            TextIter previous;
            get_iter_at_offset (out previous, cursor.get_offset () - length);
            
            if (iter_has_style (previous, "bold"))
                apply_tag_by_name ("bold", previous, cursor);
            if (iter_has_style (previous, "italic"))
                apply_tag_by_name ("italic", previous, cursor);
            if (iter_has_style (previous, "underline"))
                apply_tag_by_name ("underline", previous, cursor);
            if (iter_has_style (previous, "strikethrough"))
                apply_tag_by_name ("strikethrough", previous, cursor);
            
            
            // Emit signals
            text_inserted ();
            cursor_moved ();
        }
        
        private bool key_press_callback (EventKey event) {
            if (Gdk.keyval_name (event.keyval) == "Return") {
                ModifierType modifiers = Gtk.accelerator_get_default_mod_mask ();
                
                if ((event.state & modifiers) == Gdk.ModifierType.SHIFT_MASK)
                    insert_line ();
                else
                    insert_paragraph ();
                
                return true;
            }
            else {                
                return false;
            }
        }
    
    }
}