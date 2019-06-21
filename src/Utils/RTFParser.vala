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

public class Writer.Utils.RTFParser : Object {

    public RTFParser () {
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
}
