/*
* Copyright 2014-2020 Writer Developers
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

public class Writer.TextEditor : Gtk.SourceBuffer {
    public Gtk.SourceView text_view { get; private set; }
    private bool style_bold;
    private bool style_italic;
    private bool style_underline;
    private bool style_strikethrough;

    public signal void cursor_moved ();
    public signal void text_inserted ();

    public TextEditor () {
        setup_tagtable (this);
        text_view = new Gtk.SourceView.with_buffer (this);
        text_view.pixels_below_lines = 20;
        text_view.wrap_mode = Gtk.WrapMode.WORD_CHAR;
        text_view.hexpand = true;
        text_view.vexpand = true;
        text_view.margin = 48;

        text_view.key_press_event.connect (key_press_callback);
        text_view.move_cursor.connect (cursor_moved_callback);
        text_view.button_release_event.connect (editor_clicked_callback);
        insert_text.connect_after (text_inserted_callback);
    }

    // Get a TextTagTable with all the default tags
    private void setup_tagtable (Gtk.TextBuffer buffer) {
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
        if (has_selection) {
            get_selection_range ().apply_style (name);
        }

        switch (name) {
            case "bold":
                style_bold = true;
                break;
            case "italic":
                style_italic = true;
                break;
            case "underline":
                style_underline = true;
                break;
            case "strikethrough":
                style_strikethrough = true;
                break;
        }
    }

    public void remove_style (string name) {
        if (has_selection) {
            get_selection_range ().remove_style (name);
        }

        switch (name) {
            case "bold":
                style_bold = false;
                break;
            case "italic":
                style_italic = false;
                break;
            case "underline":
                style_underline = false;
                break;
            case "strikethrough":
                style_strikethrough = false;
                break;
        }
    }

    public void toggle_style (string name) {
        if (has_selection) {
            get_selection_range ().toggle_style (name);
        }

        switch (name) {
            case "bold":
                style_bold = !style_bold;
                break;
            case "italic":
                style_italic = !style_italic;
                break;
            case "underline":
                style_underline = !style_underline;
                break;
            case "strikethrough":
                style_strikethrough = !style_strikethrough;
                break;
        }
    }

    public bool has_style (string name) {
        if (has_selection) {
            return get_selection_range ().has_style (name);
        } else {
            return iter_has_style (get_cursor (), name);
        }
    }


    public Gtk.Justification get_justification () {
        if (has_selection) {
            return get_selection_range ().get_justification ();
        } else {
            return get_justification_at_iter (get_cursor ());
        }
    }

    public Gtk.Justification get_justification_at_iter (Gtk.TextIter iter) {
        if (iter_has_style (iter, "align-center")) {
            return Gtk.Justification.CENTER;
        } else if (iter_has_style (iter, "align-right")) {
            return Gtk.Justification.RIGHT;
        } else if (iter_has_style (iter, "align-fill")) {
            return Gtk.Justification.FILL;
        } else {
            return Gtk.Justification.LEFT;
        }
    }

    public int get_justification_as_int () {
        if (has_selection) {
            return get_selection_range ().get_justification_as_int ();
        } else {
            return get_justification_as_int_at_iter (get_cursor ());
        }
    }

    public int get_justification_as_int_at_iter (Gtk.TextIter iter) {
        if (iter_has_style (iter, "align-center")) {
            return 1;
        } else if (iter_has_style (iter, "align-right")) {
            return 2;
        } else if (iter_has_style (iter, "align-fill")) {
            return 3;
        } else {
            return 0;
        }
    }

    public void set_justification (string align) {
        get_paragraph (get_cursor ()).set_justification (align);
    }


    public void set_font (Pango.FontDescription font) {
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
        Gtk.TextIter insert_cursor = get_cursor ();
        insert_line_at_iter (insert_cursor);
    }

    public void insert_paragraph () {
        Gtk.TextIter cursor = get_cursor ();
        insert_paragraph_at_iter (cursor);
    }

    public void insert_line_at_iter (Gtk.TextIter iter) {
        // TODO
        // Cursor does not move to next line
        // Only happens when inserting at the end of the buffer
        // Bug reported in GTK+

        insert (ref iter, "\u2028", -1);
    }

    public void insert_paragraph_at_iter (Gtk.TextIter iter) {
        insert (ref iter, "\n", -1);
    }


    /*
    * Paragraphs
    */

    // Moves iter to the start of the paragraph it is located in
    public Gtk.TextIter get_paragraph_start (Gtk.TextIter iter) {
        iter.backward_find_char ((char) => {
            if (char.to_string () == "\n") {
                return true;
            } else {
                return false;
            }
        }, null);
        return iter;
    }

    // Moves iter to the end of the paragraph it is located in
    public Gtk.TextIter get_paragraph_end (Gtk.TextIter iter) {
        iter.forward_find_char ((char) => {
            if (char.to_string () == "\n") {
                return true;
            } else {
                return false;
            }
        }, null);
        return iter;
    }

    public Writer.Utils.TextRange get_paragraph (Gtk.TextIter iter) {
        Gtk.TextIter start = get_paragraph_start (iter);
        Gtk.TextIter end = get_paragraph_end (iter);

        return new Writer.Utils.TextRange (this, start, end);
    }


    /*
    * Search
    */

    public void search (string text) {
        if (text.length > 0) {
            search_string (text);
        } else {
            clear_search ();
        }
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

    public Gtk.TextIter get_cursor () {
        Gtk.TextIter iter;
        get_iter_at_mark (out iter, get_insert ());
        return iter;
    }

    public Writer.Utils.TextRange get_cursor_as_range () {
        var cursor = get_cursor ();
        return new Writer.Utils.TextRange (this, cursor, cursor);
    }

    public Writer.Utils.TextRange get_selection_range () {
        Gtk.TextIter start; Gtk.TextIter end;
        get_selection_bounds (out start, out end);
        return new Writer.Utils.TextRange (this, start, end);
    }

    public bool iter_has_tag (Gtk.TextIter iter, Gtk.TextTag tag) {
        return iter.has_tag (tag) || iter.starts_tag (tag) || iter.ends_tag (tag);
    }

    public bool iter_has_style (Gtk.TextIter iter, string name) {
        var tag = tag_table.lookup (name);
        return iter_has_tag (iter, tag);
    }

    public Gtk.TextIter copy_iter (Gtk.TextIter iter) {
        Gtk.TextIter copy;
        get_iter_at_offset (out copy, iter.get_offset ());
        return copy;
    }


    private void update_styles () {
        var iter = get_cursor ();

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

    private void text_inserted_callback (Gtk.TextIter cursor, string new_text, int length) {
        Gtk.TextIter previous;
        get_iter_at_offset (out previous, cursor.get_offset () - length);

        if (style_bold) {
            apply_tag_by_name ("bold", previous, cursor);
        }
        if (style_italic) {
            apply_tag_by_name ("italic", previous, cursor);
        }
        if (style_underline) {
            apply_tag_by_name ("underline", previous, cursor);
        }
        if (style_strikethrough) {
            apply_tag_by_name ("strikethrough", previous, cursor);
        }

        // Emit signals
        text_inserted ();
        cursor_moved ();
    }

    private bool key_press_callback (Gdk.EventKey event) {
        if (Gdk.keyval_name (event.keyval) == "Return") {
            Gdk.ModifierType modifiers = Gtk.accelerator_get_default_mod_mask ();

            if ((event.state & modifiers) == Gdk.ModifierType.SHIFT_MASK) {
                insert_line ();
            } else {
                insert_paragraph ();
            }

            return true;
        } else {
            return false;
        }
    }

    private bool editor_clicked_callback (Gdk.EventButton event) {
        update_styles ();
        cursor_moved ();

        return false;
    }
}
