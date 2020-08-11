/*
* Copyright 2014-2020 Writer Developers
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
    private RTFWriter () {
    }

    private static RTFWriter _instance;
    public static RTFWriter get_default () {
        if (_instance == null) {
            _instance = new RTFWriter ();
        }

        return _instance;
    }

    private string to_string (string contents) {
        string rtf = "";
        rtf += "{\\rtf\n" + contents + "\n}\n";
        return rtf;
    }

    public void write_to_file (string path, string contents) {
        try {
            FileUtils.set_contents (path, to_string (contents));
        } catch (Error err) {
            print ("Error writing file: " + err.message);
        }
    }
}
