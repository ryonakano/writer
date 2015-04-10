/***
The MIT License (MIT)

Copyright (c) 2014 Anthony Huben

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

Inspired by Footnote.
***/

namespace Writer.Utils {

    public class ExportDialog : Gtk.FileChooserDialog {

        GLib.HashTable<string, string> files;
        string current_ext = "";

        const string DEFAULT = "text/rtf";
        const int PREFS_NUM = 1;

        signal void filter_changed ();

        public ExportDialog.export_document (List<Note> notes, string title, Gtk.Window window) {
            string[] bins = {"pdf"};

            files = new GLib.HashTable<string, string> (str_hash, str_equal);
            files["text/rtf"] = "Rich Text Format (.rtf)";
            files["application/pdf"] = "Portable Document Format (.pdf)";
            build ();

            var default_name = files[DEFAULT];
            var default_ext = default_name[default_name.index_of ("(")+1:-1];
            set_current_name (title + default_ext);
            current_ext = default_ext;

            string str = "";

            notify.connect ( (p)=> {
                if (p.get_name () == "filter")
                    filter_changed ();
            });

            response.connect ( (id)=> {
                if (id == Gtk.ResponseType.ACCEPT) {
                    string ext = current_ext[1:current_ext.length];

                    var output = File.new_for_path (this.get_filename ());
                    try {output.delete ();} catch (GLib.Error e) {};
                    var data_stream = new DataOutputStream (output.create (FileCreateFlags.NONE));
                    switch (ext) {
                        case "rtf":
                            // rework to get it working for documents
                            foreach (Text a in text) {
                                str += rtf (a);
                            }
                            break;
                    }
                    data_stream.put_string (str);
                } catch (GLib.Error e) {
                    stderr.printf ("Error: %s\n", e.message);
                }
            }
            this.destroy ();
        }
    });
}

private void build () {
            set_action (Gtk.FileChooserAction.SAVE);
            set_title ("");
            set_create_folders (true);
            set_do_overwrite_confirmation (true);
            set_default_response (Gtk.ResponseType.ACCEPT);
            
            var entry = new Gtk.Entry ();
            ((Gtk.Box)get_child ()).get_children ().foreach ( (w)=> {
                ((Gtk.Container)w).foreach ( (d)=> {
                    if (d as Gtk.Container != null) {
                      ((Gtk.Container)d).foreach ( (f)=> {
                            if (f as Gtk.Container != null) {
                                ((Gtk.Container)f).foreach ( (g)=> {
                                    if (g as Gtk.Container != null) {                            
                                        ((Gtk.Container)g).foreach ( (h)=> {
                                            if (h as Gtk.Entry != null) {
                                                entry = (Gtk.Entry)h;
                                            }
                                        });
                                    }
                                });                         
                            }
                        });
                    }
                });
            });
            
            filter_changed.connect ( ()=> {
                var name = entry.get_text ();
                if (name != null) {
                    var ext_name = this.get_filter ().get_filter_name ();
                    var ext = ext_name[ext_name.index_of ("(")+1:-1];
                    if (name.has_suffix (current_ext))
                        set_current_name (name[0:-4] + ext);
                    else
                        set_current_name (name + ext);
                    current_ext = ext;
                }
            });
            
            
            var cancel = (Gtk.Button)add_button (Gtk.Stock.CANCEL, 1);
            cancel.clicked.connect ( ()=> {this.destroy ();});
            add_button (Gtk.Stock.SAVE, Gtk.ResponseType.ACCEPT);
            
            files.foreach ( (mime, name) => {
                var filter = new Gtk.FileFilter ();
                filter.add_mime_type (mime);
                filter.set_filter_name (name);
                this.add_filter (filter);
                if (DEFAULT in mime)
                    this.set_filter (filter);
            });
                        
            this.show_all ();
        }
        
        private string rtf (Text a) {
            string r = "";
            string body = a.content.buffer.text.replace ("\\", "\\\\");
            body = body.replace("\a", "\\line\a");
            string document_body = @"\\cf1\a\\pard $body\\par\a\\line\\line";
                r += document_body;
            return r;
        }
    }
}
