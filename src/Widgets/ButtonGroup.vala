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
    public class ButtonGroup : Gtk.Box {
    
        public ButtonGroup () {
            var provider = new Gtk.CssProvider ();
            try {
                provider.load_from_data (styles, -1);
            } catch (Error err) {
                print ("Provider Error: " + err.message + "\n");
            }
            
            this.get_style_context ().add_provider (provider, 10);
        }
        
        public string styles = """
            GtkButton {
                border-radius: 0;
                border-left-width: 0;
                margin-left: 1px;
            }
            GtkButton:first-child {
                border-radius: 2px 0 0 2px;
                border-left-width: 1px;
                margin-left: 0;
            }
            GtkButton:last-child {
                border-radius: 0 2px 2px 0;
            }
            GtkButton:hover + GtkButton {
                border-left-width: 1px;
                margin-left: 1px;
            }
        """;
    
    }
}