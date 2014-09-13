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
using Granite.Widgets;

namespace Writer.Widgets {
    public class EditorToolBar : Gtk.HeaderBar {
    
        private Editor editor;
        public FontButton font_button;
        public ColorButton font_color_button;
        public ToggleButton bold_button;
        public ToggleButton italic_button;
        public ToggleButton underline_button;
        public ToggleButton strikethrough_button;
        public Button indent_more_button;
        public Button indent_less_button;
        public ModeButton align_button;
        public Popover insert_popover;
    
        public EditorToolBar (Editor editor) {
            this.editor = editor;
            editor.cursor_moved.connect (cursor_moved);
            
            this.get_style_context ().add_class ("primary-toolbar");
    
            setup_ui ();
        }
        
        public void setup_ui () {
        
            // Make Widgets
            
            var paragraph_combobox = new Gtk.ComboBoxText ();
                paragraph_combobox.append ("Paragraph", ("Paragraph"));
                paragraph_combobox.append ("Heading One", ("Heading One"));
                paragraph_combobox.append ("Heading Two", ("Heading Two"));
                paragraph_combobox.append ("Bullet List", ("Bullet List"));
                paragraph_combobox.append ("Dashed List", ("Dashed List"));
                paragraph_combobox.append ("Numbered List", ("Numbered List"));
                paragraph_combobox.append ("Two-Column", ("Two-Column"));
                paragraph_combobox.set_active_id ("Paragraph");
                
            var font_item = new ToolItem ();
                font_button = new Gtk.FontButton ();
                font_button.use_font = true;
                font_button.use_size = true;
                font_item.add (font_button);

            font_color_button = new Gtk.ColorButton ();
                font_color_button.use_alpha = false;
                font_color_button.set_title ("Choose a Font Color");
                
            var styles_item = new ToolItem ();
                var styles_buttons = new ButtonGroup ();
                    bold_button = new Gtk.ToggleButton ();
                        bold_button.add (new Image.from_icon_name ("format-text-bold-symbolic", Gtk.IconSize.BUTTON));
                        bold_button.focus_on_click = false;
                        styles_buttons.pack_start (bold_button);
                    italic_button = new Gtk.ToggleButton ();
                        italic_button.add (new Image.from_icon_name ("format-text-italic-symbolic", Gtk.IconSize.BUTTON));
                        styles_buttons.pack_start (italic_button);
                    underline_button = new Gtk.ToggleButton ();
                        underline_button.add (new Image.from_icon_name ("format-text-underline-symbolic", Gtk.IconSize.BUTTON));
                        styles_buttons.pack_start (underline_button);
                    strikethrough_button = new Gtk.ToggleButton ();
                        strikethrough_button.add (new Image.from_icon_name ("format-text-strikethrough-symbolic", Gtk.IconSize.BUTTON));
                        styles_buttons.pack_start (strikethrough_button);
                styles_item.add (styles_buttons);

            var indent_button = new ButtonGroup ();
                var indent_more_button = new Image.from_icon_name ("format-indent-more-symbolic", Gtk.IconSize.BUTTON);
                var indent_less_button = new Image.from_icon_name ("format-indent-less-symbolic", Gtk.IconSize.BUTTON);
                indent_button.add (indent_more_button);
                indent_button.add (indent_less_button);
                
            var align_item = new ToolItem ();
                align_button = new ModeButton ();
                    align_button.append (new Gtk.Button.from_icon_name ("format-justify-left-symbolic", Gtk.IconSize.BUTTON));
                    align_button.append (new Gtk.Button.from_icon_name ("format-justify-center-symbolic", Gtk.IconSize.BUTTON));
                    align_button.append (new Gtk.Button.from_icon_name ("format-justify-right-symbolic", Gtk.IconSize.BUTTON));
                    align_button.append (new Gtk.Button.from_icon_name ("format-justify-fill-symbolic", Gtk.IconSize.BUTTON));
                align_item.add (align_button);
            
            var insert_button = new Gtk.Button.with_label ("Insert");
            insert_popover = new Gtk.Popover (insert_button);
            var insert_popover_content = new Gtk.Grid ();
                insert_popover_content.column_spacing = 6;
                insert_popover_content.row_spacing = 12;
                var comment_button = new Gtk.Button.with_label ("Comment");
                    insert_popover_content.attach (comment_button, 0, 0, 1, 1);
                var picture_button = new Gtk.Button.with_label ("Picture");
                    insert_popover_content.attach  (picture_button, 1, 0, 1, 1);
                var link_button = new Gtk.Button.with_label ("Link");
                    insert_popover_content.attach  (link_button, 2, 0, 1, 1);
                var table_chooser = new TableChooser ();
                    insert_popover_content.attach  (table_chooser, 0, 1, 3, 1);
                    
                insert_popover.set_position (Gtk.PositionType.BOTTOM);
                insert_popover.set_border_width (12);
                insert_popover.add (insert_popover_content);
                insert_popover.show_all ();
                insert_popover.hide ();

            
            // Add Widgets
            
            this.add (paragraph_combobox);
            this.add (font_item);
            this.add (font_color_button);
            this.add (styles_item);
            this.add (indent_button);
            this.add (align_item);
            this.add (insert_button);
            
            
            
            // Connect signals
            
            insert_button.clicked.connect (() => {
                insert_popover.show ();
            });
            
            comment_button.clicked.connect (editor.insert_comment);
            picture_button.clicked.connect (editor.insert_image);
            link_button.clicked.connect (editor.insert_link);
            table_chooser.selected.connect (editor.insert_table);
            
            align_button.mode_changed.connect (() => {
                change_align (align_button.selected);
            });
            
            font_button.font_set.connect (() => {
                editor.set_font_from_string (font_button.get_font_name ());
            });
            font_color_button.color_set.connect (() => {
                Gdk.Color color;
                font_color_button.get_color (out color);
                editor.set_font_color (color);
            });
            
            bold_button.button_press_event.connect ((event) => {
                if (event.type == EventType.BUTTON_PRESS)
                    editor.toggle_style ("bold");
                return false;
            });
            italic_button.button_press_event.connect ((event) => {
                if (event.type == EventType.BUTTON_PRESS)
                    editor.toggle_style ("italic");
                return false;
            });
            underline_button.button_press_event.connect ((event) => {
                if (event.type == EventType.BUTTON_PRESS)
                    editor.toggle_style ("underline");
                return false;
            });
            strikethrough_button.button_press_event.connect ((event) => {
                if (event.type == EventType.BUTTON_PRESS)
                    editor.toggle_style ("strikethrough");
                return false;
            });
            
        }
        
        
        
        
        /*
         * Signal callbacks
         */
        
        public void change_align (int index) {
            switch (index) {
                case 1:
                    editor.set_justification ("center"); break;
                case 2:
                    editor.set_justification ("right"); break;
                case 3:
                    editor.set_justification ("fill"); break;
                default:
                    editor.set_justification ("left"); break;
            }
        }
         
        public void cursor_moved () {
            bold_button.active = editor.has_style ("bold");
            italic_button.active = editor.has_style ("italic");
            underline_button.active = editor.has_style ("underline");
            strikethrough_button.active = editor.has_style ("strikethrough");
            
            align_button.selected = editor.get_justification_as_int ();
            
            //TODO
            // Update font and color buttons
        }

    }
}