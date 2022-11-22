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
        if (print_settings != null) {
            print_operation.set_print_settings (print_settings);
        }

        Gtk.PrintOperationResult result;
        try {
            result = print_operation.run (Gtk.PrintOperationAction.PRINT_DIALOG,
                                          ((Gtk.Application) GLib.Application.get_default ()).active_window);
        } catch (Error e) {
            warning ("Gtk.PrintOperation.run(): %s", e.message);
            return;
        }

        print_operation.begin_print.connect (begin_print);

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
    }

    private void print_resp_apply (Gtk.PrintOperation operation) {
    }

    private void print_resp_cancel (Gtk.PrintOperation operation) {
    }

    private void print_resp_error (Gtk.PrintOperation operation) {
    }

    private void print_resp_in_progress (Gtk.PrintOperation operation) {
    }
}
