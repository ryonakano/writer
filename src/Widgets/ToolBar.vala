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

namespace Writer.Widgets {
    public class ToolBar : Gtk.Stack {
    
        public EditorToolBar editor_toolbar;
        public ImageToolBar image_toolbar;
        public TableToolBar table_toolbar;
        
    
        public ToolBar (Editor editor) {
            this.transition_type = Gtk.StackTransitionType.NONE;
            
            editor_toolbar = new EditorToolBar (editor);
            image_toolbar = new ImageToolBar (editor);
            table_toolbar = new TableToolBar (editor);
            
            add_named (editor_toolbar, "editor");
            add_named (image_toolbar, "image");
            add_named (table_toolbar, "table");
        }
        
        public void show_editor_toolbar () {
            this.visible_child_name = "editor";
        }
        
        public void show_image_toolbar () {
            this.visible_child_name = "image";
        }
        
        public void show_table_toolbar () {
            this.visible_child_name = "table";
        }
    
    }
}