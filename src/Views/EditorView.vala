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

namespace Writer.Widgets {
    public class EditorView : Gtk.Box {
        public TextEditor editor { get; construct; }
        public Widgets.ToolBar toolbar;

        public EditorView (TextEditor editor) {
            Object (
                orientation: Gtk.Orientation.VERTICAL,
                spacing: 0,
                editor: editor
            );
        }

        construct {
            editor.text_view.wrap_mode = Gtk.WrapMode.WORD_CHAR;

            toolbar = new Widgets.ToolBar (editor);

            var scrolled_window = new Gtk.ScrolledWindow (null, null);
            scrolled_window.border_width = 20;
            scrolled_window.add (editor.text_view);

            pack_start (toolbar, false, false, 0);
            pack_start (scrolled_window, true, true, 0);
        }
    }
}
