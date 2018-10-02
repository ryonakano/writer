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
using Gdk;
using Pango;
using Writer.Utils;

namespace Writer {
    public class TextEditor : TextBuffer {
        public TextView text_view;
        public bool style_bold;
        public bool style_italic;
        public bool style_underline;
        public bool style_strikethrough;

        public signal void cursor_moved ();
        public signal void text_inserted ();

        public TextEditor () {
            setup_tagtable (this);
            text_view = new TextView.with_buffer (this);

            style_bold = false;
            style_italic = false;
            style_underline = false;
            style_strikethrough = false;

            text_view.move_cursor.connect (cursor_moved_callback);
            text_view.button_release_event.connect (editor_clicked_callback);
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

            if (name == "bold")
                style_bold = true;
            else if (name == "italic")
                style_italic = true;
            else if (name == "underline")
                style_underline = true;
            else if (name == "strikethrough")
                style_strikethrough = true;
        }

        public void remove_style (string name) {
            if (has_selection)
                get_selection_range ().remove_style (name);

            if (name == "bold")
                style_bold = false;
            else if (name == "italic")
                style_italic = false;
            else if (name == "underline")
                style_underline = false;
            else if (name == "strikethrough")
                style_strikethrough = false;
        }

        public void toggle_style (string name) {
            if (has_selection)
                get_selection_range ().toggle_style (name);

            if (name == "bold")
                style_bold = !style_bold;
            else if (name == "italic")
                style_italic = !style_italic;
            else if (name == "underline")
                style_underline = !style_underline;
            else if (name == "strikethrough")
                style_strikethrough = !style_strikethrough;
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


        public void set_font_color (Gdk.RGBA rgba) {
            get_selection_range ().set_font_color (rgba);
        }

        public void set_font_color_from_string (string rgba) {
            get_selection_range ().set_font_color_from_string (rgba);
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
            // TODO
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
            return iter.has_tag (tag) || iter.starts_tag (tag) || iter.ends_tag (tag);
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



        private void update_styles () {
            var iter = get_cursor();

            style_bold = iter_has_style (iter, "bold");
            style_italic = iter_has_style (iter, "italic");
            style_underline = iter_has_style (iter, "underline");
            style_strikethrough = iter_has_style (iter, "strikethrough");
        }

        /*
         * Signal callbacks
         */

        private void cursor_moved_callback () {
            // Emit 'cursor_moved' signal
            update_styles ();
            cursor_moved ();
        }

        private void text_inserted_callback (TextIter cursor, string new_text, int length) {
            TextIter previous;
            get_iter_at_offset (out previous, cursor.get_offset () - length);

            if (style_bold)
                apply_tag_by_name ("bold", previous, cursor);
            if (style_italic)
                apply_tag_by_name ("italic", previous, cursor);
            if (style_underline)
                apply_tag_by_name ("underline", previous, cursor);
            if (style_strikethrough)
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

        private bool editor_clicked_callback (EventButton event) {
            update_styles ();
            cursor_moved ();

            return false;
        }
    }
}
