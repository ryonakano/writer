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

namespace Writer.Widgets {
    public class EditorView : Box {
        
        private Editor editor;
        public Widgets.ToolBar toolbar;
        
        public EditorView (Editor editor) {
            Object (orientation: Gtk.Orientation.VERTICAL, spacing: 0);
            
            get_style_context ().add_class("editor-view");
            
            this.editor = editor;
            //editor.text_view.set_border_width (20);
            editor.text_view.wrap_mode = Gtk.WrapMode.WORD_CHAR;
            
            this.toolbar = new Widgets.ToolBar (editor);
            
            var scrolled_window = new Gtk.ScrolledWindow (null, null);
            scrolled_window.border_width = 20;
            scrolled_window.add (editor.text_view);
            
            this.pack_start (toolbar, false, false, 0);
            this.pack_start (scrolled_window, true, true, 0);
        }
        
    }
}