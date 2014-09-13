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

using Granite.Services;

namespace Writer {
    
    public class WriterApp : Granite.Application {
        
        private MainWindow window;
        private Editor editor;
        
        construct {
            program_name = "Writer";
            exec_name = "writer";
            
            build_data_dir = Constants.DATADIR;
            build_pkg_data_dir = Constants.PKGDATADIR;
            build_release_name = Constants.RELEASE_NAME;
            build_version = Constants.VERSION;
            build_version_info = Constants.VERSION_INFO;
            
            app_copyright = "2014";
            app_years = "2014";
            app_icon = "office-document";
            app_launcher = "writer.desktop";
            application_id = "net.launchpad.writer";
            
            main_url = "https://launchpad.net/writer";
            bug_url = "https://bugs.launchpad.net/writer";
            help_url = "https://answers.launchpad.net/writer";
            translate_url = "https://translations.launchpad.net/writer";
            
            about_authors = {
                "Tuur Dutoit <tuur.dutoit@live.nl>",
                "Anthony Huben <harp37@gmail.com>"
            };
            about_documenters = {
                "Tuur Dutoit <tuur.dutoit@live.nl>"
            };
            about_artists = {
                "Caleb 'spiceofdesign' Riley",
                "Anthony Huben <harp37@gmail.com>",
                "Tuur Dutoit <tuur.dutoit@live.nl>"
            };
            about_comments = "Word Processor";
            about_translators = "Launchpad Translators";
            about_license = "MIT";
            about_license_type = Gtk.License.MIT_X11;
        }
        
        public WriterApp () {
            Logger.initialize ("Writer");
            Logger.DisplayLevel = LogLevel.DEBUG;   
        }
        
        //the application started
        public override void activate () {
            if (get_windows () == null) {
                editor = new Editor ();
                window = new MainWindow (this, editor);
                window.show_welcome ();
                window.show_all ();
            } else {
                window.present ();
            }
        }
        
        //the application was requested to open some files
        public void new_file () {
            window.show_editor ();
        }
        
        public void open_file (Utils.Document doc) {
            editor.set_text (doc.read_all (), -1);
            window.set_title_for_document (doc);
            window.show_editor ();
        }
        
        public void open_file_dialog () {
            var filech = Utils.file_chooser_dialog (Gtk.FileChooserAction.OPEN, "Choose a file to open", window, false);
            
            if (filech.run () == Gtk.ResponseType.ACCEPT) {
                var uri = filech.get_uris ().nth_data (0);
                
                //Update last visited path
                Utils.last_path = Path.get_dirname (uri);
                
                //Open the file
                var doc = new Utils.Document (uri);
                open_file (doc);
            }
            
            filech.close ();
        }
        
        public void undo () {
            print ("undo\n");
            window.show_welcome ();
        }
        
        public void redo () {
            print ("redo\n");
            window.show_editor ();
        }
        
        public void save () {
            print ("save\n");
        }
        
        public void save_as () {
            print ("save as\n");
        }
        
        public void revert () {
            print ("revert\n");
        }
        
        public void print_file () {
            print ("print\n");
        }

        public void search () {
            print ("search\n");
        }
        
        public void preferences () {
            print ("Open preferences dialog\n");
        }
           
        
        public static void main (string [] args) {
            var app = new Writer.WriterApp ();
            
            app.run (args);
        }
    }
}