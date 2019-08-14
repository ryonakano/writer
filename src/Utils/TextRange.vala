/*
* Copyright (c) 2014-2019 Writer Developers
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

public class Writer.Utils.TextRange : Object {
    public Gtk.TextBuffer buffer { get; construct; }
    public Gtk.TextIter start { get; construct; }
    public Gtk.TextIter end { get; construct; }
    private int start_offset;
    private int end_offset;

    public TextRange (Gtk.TextBuffer buffer, Gtk.TextIter start, Gtk.TextIter end) {
        Object (
            buffer: buffer,
            start: start,
            end: end
        );
    }

    construct {
        start_offset = start.get_offset ();
        end_offset = end.get_offset ();
    }


    /*
    * Style and Tag checks
    * ====================
    */

    // Check if every Iter in the range has the given tag
    private bool has_tag (Gtk.TextTag tag) {
        Gtk.TextIter temp;
        for (int i = start_offset; i < end_offset; i++) {
            temp = get_iter_at_offset (i);

            if (! temp.has_tag (tag)) {
                return false;
            }
        }

        return true;
    }

    public bool has_style (string name) {
        var tag = buffer.tag_table.lookup (name);
        return has_tag (tag);
    }

    // Check if at least one Iter in the range has the given tag
    private bool contains_tag (Gtk.TextTag tag) {
        Gtk.TextIter temp;
        for (int i = start_offset; i < end_offset; i++) {
            temp = get_iter_at_offset (i);

            if (temp.has_tag (tag)) {
                return true;
            }
        }

        return false;
    }

    public bool contains_style (string name) {
        var tag = buffer.tag_table.lookup (name);
        return contains_tag (tag);
    }

    // Check if the range wraps the given tag, i.e. if the tag begins and ends within the range
    private bool wraps_tag (Gtk.TextTag tag) {
        if ( (!start.has_tag (tag) || start.starts_tag (tag)) &&
                (!end.has_tag (tag) || end.ends_tag (tag)) &&
                (contains_tag (tag))) {
            return true;
        } else {
            return false;
        }
    }

    public bool wraps_style (string name) {
        var tag = buffer.tag_table.lookup (name);
        return wraps_tag (tag);
    }

    // Check if the range wraps the given tag exactly, i.e. if the tag begins and ends at the bounds of the range
    private bool wraps_tag_exact (Gtk.TextTag tag) {
        var range = new TextRange (buffer,
                                    get_iter_at_offset (start_offset + 1),
                                    get_iter_at_offset (end_offset - 1));

        if ( (!start.has_tag (tag) || start.starts_tag (tag)) &&
                (!end.has_tag (tag) || end.ends_tag (tag)) &&
                (range.has_tag (tag))
            ) {
            return true;
        } else {
            return false;
        }
    }

    public bool wraps_style_exact (string name) {
        var tag = buffer.tag_table.lookup (name);
        return wraps_tag_exact (tag);
    }


    // Check if the range wraps the tag, with the bounds beginning and ending the tag
    private bool wraps_tag_with_bounds (Gtk.TextTag tag) {
        if ( (start.starts_tag (tag)) &&
                (end.ends_tag (tag)) &&
                (has_tag (tag))
            ) {
            return true;
        } else {
            return false;
        }
    }

    public bool wraps_style_with_bounds (string name) {
        var tag = buffer.tag_table.lookup (name);
        return wraps_tag_with_bounds (tag);
    }

    // Check if the range wraps the tag, with the offset next to start beginning the tag,
    // and the offset preceding end ending the tag
    private bool wraps_tag_without_bounds (Gtk.TextTag tag) {
        var range = new TextRange (buffer,
                                    get_iter_at_offset (start_offset + 1),
                                    get_iter_at_offset (end_offset - 1));

        if ( (!start.has_tag (tag)) &&
                (!end.has_tag (tag)) &&
                (range.has_tag (tag))
            ) {
            return true;
        } else {
            return false;
        }
    }

    public bool wraps_style_without_bounds (string name) {
        var tag = buffer.tag_table.lookup (name);
        return wraps_tag_without_bounds (tag);
    }


    /*
    * Apply/Remove Tags/Styles
    * ========================
    */

    private void apply_tag (Gtk.TextTag tag) {
        buffer.apply_tag (tag, start, end);
    }

    public void apply_style (string name) {
        var tag = buffer.tag_table.lookup (name);
        apply_tag (tag);
    }

    private void remove_tag (Gtk.TextTag tag) {
        buffer.remove_tag (tag, start, end);
    }

    public void remove_style (string name) {
        var tag = buffer.tag_table.lookup (name);
        remove_tag (tag);
    }

    public void toggle_tag (Gtk.TextTag tag) {
        if (has_tag (tag)) {
            remove_tag (tag);
        } else {
            apply_tag (tag);
        }
    }

    public void toggle_style (string name) {
        if (has_style (name)) {
            remove_style (name);
        } else {
            apply_style (name);
        }
    }


    /*
    * Justification
    * =============
    */

    public Gtk.Justification get_justification () {
        if (has_style ("align-center")) {
            return Gtk.Justification.CENTER;
        } else if (has_style ("align-right")) {
            return Gtk.Justification.RIGHT;
        } else if (has_style ("align-fill")) {
            return Gtk.Justification.FILL;
        } else {
            return Gtk.Justification.LEFT;
        }
    }

    public int get_justification_as_int () {
        if (has_style ("align-center")) {
            return 1;
        } else if (has_style ("align-right")) {
            return 2;
        } else if (has_style ("align-fill")) {
            return 3;
        } else {
            return 0;
        }
    }

    public void set_justification (string align) {
        remove_style ("align-left");
        remove_style ("align-center");
        remove_style ("align-right");
        remove_style ("align-fill");

        apply_style ("align-" + align);
    }


    /*
    * Fonts
    * =====
    */

    public void set_font (Pango.FontDescription font) {
        var font_name = font.to_string ();
        set_font_from_string (font_name);
    }

    public void set_font_from_string (string font) {
        if (buffer.tag_table.lookup (font) == null) {
            buffer.create_tag (font, "font", font);
        }

        apply_style (font);
    }

    public void set_font_color (Gdk.RGBA rgba) {
        var name = rgba.to_string ();
        set_font_color_from_string (name);
    }

    public void set_font_color_from_string (string rgba) {
        if (buffer.tag_table.lookup (rgba) == null) {
            buffer.create_tag (rgba, "foreground", rgba);
        }

        apply_style (rgba);
    }


    /*
    * Utilities
    */

    public Gtk.TextIter get_iter_at_offset (int offset) {
        Gtk.TextIter iter;
        buffer.get_iter_at_offset (out iter, offset);
        return iter;
    }
}
