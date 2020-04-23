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

public class Writer.Widgets.ActionBar : Gtk.ActionBar {
    private TextEditor editor;
    private Gtk.Label char_count_label;

    public ActionBar () {
    }

    construct {
        editor = Writer.TextEditor.get_default ();

        char_count_label = new Gtk.Label (null);

        update_char_count ();

        pack_end (char_count_label);

        editor.changed.connect (() => {
            Idle.add (() => {
                update_char_count ();
            });
        });
    }

    public void update_char_count () {
        string text_to_count = editor.text;

        if (Application.settings.get_boolean ("count-include-spaces")) {
            int char_count_with_spaces = text_to_count.char_count ();
            char_count_label.label = ngettext ("%d character with spaces", "%d characters with spaces", char_count_with_spaces).printf (char_count_with_spaces);
        } else {
            int char_count_without_spaces = 0;
            MatchInfo match_info;

            try {
                var regex = new Regex ("\\S");
                for (regex.match (text_to_count, 0, out match_info); match_info.matches (); match_info.next ()) {
                    char_count_without_spaces++;
                }
            } catch (RegexError err) {
                warning (err.message);
            }

            char_count_label.label = ngettext ("%d character without spaces", "%d characters without spaces", char_count_without_spaces).printf (char_count_without_spaces);
        }
    }
}
