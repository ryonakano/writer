public class Writer.PrintManager : GLib.Object {
    private Gtk.PrintSettings print_settings;
    private Gtk.PageSetup page_setup;

    public static PrintManager get_default () {
        if (instance == null) {
            instance = new PrintManager ();
        }

        return instance;
    }
    private static PrintManager instance;

    private PrintManager () {
    }

    construct {
    }

    public void show_page_setup () {
        if (print_settings == null) {
            print_settings = new Gtk.PrintSettings ();
        }

        Gtk.print_run_page_setup_dialog (((Gtk.Application) GLib.Application.get_default ()).active_window,
                                            page_setup, print_settings);
    }

    public void show_print_dialog () {
        var print_operation = new Gtk.PrintOperation ();
        print_operation.n_pages = 1;
        if (print_settings != null) {
            print_operation.set_print_settings (print_settings);
        }

        print_operation.begin_print.connect (begin_print);
        print_operation.draw_page.connect (draw_page);
        print_operation.end_print.connect (end_print);

        Gtk.PrintOperationResult result;
        try {
            result = print_operation.run (Gtk.PrintOperationAction.PRINT_DIALOG,
                                          ((Gtk.Application) GLib.Application.get_default ()).active_window);
        } catch (Error e) {
            warning ("Gtk.PrintOperation.run(): %s", e.message);
            return;
        }

        switch (result) {
            case Gtk.PrintOperationResult.APPLY:
                print_resp_apply (print_operation);
                break;
            case Gtk.PrintOperationResult.CANCEL:
                print_resp_cancel (print_operation);
                break;
            case Gtk.PrintOperationResult.ERROR:
                print_resp_error (print_operation);
                break;
            case Gtk.PrintOperationResult.IN_PROGRESS:
                print_resp_in_progress (print_operation);
                break;
            default:
                break;
        }
    }

    private void begin_print (Gtk.PrintContext context) {
        print ("begin print\n");
    }

    private void draw_page (Gtk.PrintContext context, int page_nr) {
        print ("draw pages\n");
        var cr = context.get_cairo_context ();
        var layout = context.create_pango_layout ();
        Pango.cairo_show_layout (cr, layout);
    }

    private void end_print (Gtk.PrintContext context) {
        print ("end print\n");
    }

    private void print_resp_apply (Gtk.PrintOperation operation) {
        print ("apply\n");
    }

    private void print_resp_cancel (Gtk.PrintOperation operation) {
        print ("cancel\n");
    }

    private void print_resp_error (Gtk.PrintOperation operation) {
        print ("error\n");
    }

    private void print_resp_in_progress (Gtk.PrintOperation operation) {
        print ("in progress\n");
    }
}
