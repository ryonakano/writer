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

namespace Writer.Utils {
    
    public void add_stylesheet () {
    
        string stylesheet = """
            .writer-toolbar {
                background: @bg_color;
                border-radius: 0;
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