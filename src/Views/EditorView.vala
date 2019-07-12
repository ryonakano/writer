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

public class Writer.Views.EditorView : Gtk.Box {
    public TextEditor editor { get; construct; }

    public EditorView (TextEditor editor) {
        Object (
            orientation: Gtk.Orientation.VERTICAL,
            spacing: 0,
            editor: editor
        );
    }

    construct {
        var toolbar = new Widgets.ToolBar (editor);

        var document_view = new Gtk.Grid ();
        document_view.get_style_context ().add_class ("page-decoration");
        document_view.margin = 24;
        // Set document_view size to A4 size
        document_view.height_request = 1123;
        document_view.width_request = 794;
        document_view.add (editor.text_view);

        var document_view_wrapper = new Gtk.Grid ();
        document_view_wrapper.halign = Gtk.Align.CENTER;
        document_view_wrapper.valign = Gtk.Align.CENTER;
        document_view_wrapper.add (document_view);

        var scrolled_window = new Gtk.ScrolledWindow (null, null);
        scrolled_window.add (document_view_wrapper);

        pack_start (toolbar, false, false, 0);
        pack_start (scrolled_window, true, true, 0);
    }
}
