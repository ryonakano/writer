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


namespace Writer.Utils {
    
    public void add_stylesheet () {
    
        string stylesheet = """
            .writer-window .writer-toolbar {
                padding: 5px;
                background: linear-gradient(to bottom,
                                            #F8F8F8,
                                            #F8F8F8 65%,
                                            #F0F0F0
                                            );
                border: none;
                border-bottom: 1px solid #DADADA;
            }
        """;
    
    
    
        var style_provider = new Gtk.CssProvider ();
        style_provider.parsing_error.connect ((section, error) => {
            print ("Parsing error: %s\n", error.message);
        });
        
        try {
            style_provider.load_from_data (stylesheet, -1);
        } catch (Error error) {
            print ("CSS loading error: %s\n", error.message);
        }
        
        Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), style_provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);
    }
}