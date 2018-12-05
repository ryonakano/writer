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
    public class Document : Object {

        construct {
        }

        public string read_all (string path) {
            try {
                string content;
                FileUtils.get_contents (path, out content);
                int start = content.index_of ("{\\rtf\n") + "{\\rtf\n".length;
                int end = content.index_of ("\n}\n");
                string res = content.substring (start, end - start);
                return res;
            } catch (Error err) {
                print ("Error reading file: " + err.message);
                return "";
            }
        }

        private string to_string (TextEditor editor) {
            string rtf = "";
            rtf += "{\\rtf\n" + editor.text + "\n}\n";
            return rtf;
        }

        public void write_to_file (TextEditor editor, string path) {
            try {
                FileUtils.set_contents (path, to_string (editor));
            } catch (Error err) {
                print ("Error writing file: " + err.message);
            }
        }
    }
}
