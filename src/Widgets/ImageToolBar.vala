/***
The MIT License (MIT)

Copyright (c) 2014 Anthony Huben

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
using Granite.Widgets;

namespace Writer.Widgets {
    public class ImageToolBar : Gtk.HeaderBar {
    
        private Editor editor;
        public ModeButton align_button;
    
        public ImageToolBar (Editor editor) {
            this.editor = editor;
            
            this.get_style_context ().add_class ("primary-toolbar");

            var wrap_combobox = new Gtk.ComboBoxText ();
                wrap_combobox.append ("In line of text", ("In line of text"));
                wrap_combobox.append ("Float above text", ("Float above text"));
                wrap_combobox.append ("On the left", ("On the left"));
                wrap_combobox.append ("On the right", ("On the right"));
                wrap_combobox.set_active_id ("In line of text");

            var lock_aspect_item = new Gtk.CheckButton.with_label ("Lock aspect ratio");
                
            var align_item = new ToolItem ();
                align_button = new ModeButton ();
                    align_button.append (new Gtk.Button.from_icon_name ("format-justify-left-symbolic", Gtk.IconSize.BUTTON));
                    align_button.append (new Gtk.Button.from_icon_name ("format-justify-center-symbolic", Gtk.IconSize.BUTTON));
                    align_button.append (new Gtk.Button.from_icon_name ("format-justify-right-symbolic", Gtk.IconSize.BUTTON));
                    align_button.append (new Gtk.Button.from_icon_name ("format-justify-fill-symbolic", Gtk.IconSize.BUTTON));
                align_item.add (align_button);
                
            var edit_image_item = new Gtk.Button.with_label ("Edit Image");

            var delete_image_item = new Gtk.Button.with_label ("Delete Image");
            
            
            this.add (wrap_combobox);
            this.add (lock_aspect_item);
            this.add (align_item);
            this.add (edit_image_item);
            this.add (delete_image_item);
            
            align_button.mode_changed.connect (() => {
                change_align (align_button.selected);
            });
        }
        
        public void change_align (int index) {
            switch (index) {
                case 1:
                    editor.justify ("center"); break;
                case 2:
                    editor.justify ("right"); break;
                case 3:
                    editor.justify ("fill"); break;
                default:
                    editor.justify ("left"); break;
            }
        }

    }
}