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
    public TextEditor editor { get; construct; }
    private Gtk.Label char_count_label;

    public ActionBar (TextEditor editor) {
        Object (
            editor: editor
        );
    }

    construct {
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
        if (Application.settings.get_boolean ("count-include-spaces")) {
            int char_count_with_spaces = editor.text.char_count ();
            char_count_label.label = ngettext ("%d character with spaces", "%d characters with spaces", char_count_with_spaces).printf (char_count_with_spaces);
        } else {
            int char_count_without_spaces = 0;
            string char_without_spaces = editor.text.replace (" ", "").replace ("　", "");
            for (int i = 0; i < char_without_spaces.length; i++) {
                if (char_without_spaces.valid_char (i)) {
                    char_count_without_spaces++;
                }
            }

            char_count_label.label = ngettext ("%d character without spaces", "%d characters without spaces", char_count_without_spaces).printf (char_count_without_spaces);
        }
    }
}
