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
        public string uri { get; construct; }
        public string path;
        public File file;

        public Document (string uri) {
            Object (
                uri: uri
            );
        }

        construct {
            file = File.new_for_uri (uri);
            path = file.get_path ();
        }

        public string read_all () {
            try {
                string content;
                FileUtils.get_contents (path, out content);

                return content;
            }
            catch (Error err) {
                print ("Error reading file: " + err.message);
                return "";
            }
        }

        private string to_string (TextEditor editor) {
            string rtf;
            rtf = editor.text;
            return rtf;
        }

        public void write_to_file (TextEditor editor) {
            try {
                FileUtils.set_contents (path, to_string (editor));
            }
            catch (Error err) {
                print ("Error writing file: " + err.message);
            }
        }
    }
}
