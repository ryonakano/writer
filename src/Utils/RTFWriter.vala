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

public class Writer.Utils.RTFWriter : Object {
    public TextEditor editor { get; construct; }

    public RTFWriter (TextEditor editor) {
        Object (
            editor: editor
        );
    }

    private string to_string () {
        string rtf = "";
        rtf += "{\\rtf\n" + editor.text + "\n}\n";
        return rtf;
    }

    public void write_to_file (string path) {
        try {
            FileUtils.set_contents (path, to_string ());
        } catch (Error err) {
            print ("Error writing file: " + err.message);
        }
    }
}
