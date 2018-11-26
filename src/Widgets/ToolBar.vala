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
    public class ToolBar : Gtk.Stack {
        public TextToolBar text_toolbar;
        public ImageToolBar image_toolbar;
        public TableToolBar table_toolbar;

        public ToolBar (TextEditor editor) {
            transition_type = Gtk.StackTransitionType.NONE;

            text_toolbar = new TextToolBar (editor);
            image_toolbar = new ImageToolBar (editor);
            table_toolbar = new TableToolBar (editor);

            add_named (text_toolbar, "text");
            add_named (image_toolbar, "image");
            add_named (table_toolbar, "table");
        }

        public void show_text_toolbar () {
            visible_child_name = "text";
        }

        public void show_image_toolbar () {
            visible_child_name = "image";
        }

        public void show_table_toolbar () {
            visible_child_name = "table";
        }
    }
}
