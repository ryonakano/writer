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

public class Writer.Views.WelcomeView : Granite.Widgets.Welcome {
    public Application app { get; construct; }

    public WelcomeView (Application app) {
        Object (
            title: _("No Documents Open"),
            subtitle: _("Open a document to begin editing."),
            app: app
        );
    }

    construct {
        append ("document-new", _("New File"), _("Create a new document."));
        append ("document-open", _("Open File"), _("Open a saved document."));

        activated.connect ((index) => {
            // TODO
            // Open recent
            if (index == 0) {
                app.new_file ();
            } else {
                app.open_file_dialog ();
            }
        });
    }
}
