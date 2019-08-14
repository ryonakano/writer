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
*
* Taken from Code (https://github.com/elementary/code)
*/

#if HAVE_ZEITGEIST
public class Writer.Utils.ZeitgeistLogger {
    public string actor = "application://" + Constants.PROJECT_NAME + ".desktop";
    public string event_manifestation = Zeitgeist.ZG.USER_ACTIVITY;

    public void open_insert (string? uri, string mimetype) {
        if (uri == null) {
            return;
        }

        var subject = get_subject (uri, mimetype);
        var event = new Zeitgeist.Event.full (Zeitgeist.ZG.ACCESS_EVENT,
                            event_manifestation,
                            actor,
                            null);
        event.add_subject (subject);

        insert_events (event);
    }

    public void close_insert (string? uri, string mimetype) {
        if (uri == null) {
            return;
        }

        var subject = get_subject (uri, mimetype);
        var event = new Zeitgeist.Event.full (Zeitgeist.ZG.LEAVE_EVENT,
                            event_manifestation,
                            actor,
                            null);
        event.add_subject (subject);

        insert_events (event);
    }

    public void save_insert (string uri, string mimetype) {
        var subject = get_subject (uri, mimetype);
        var event = new Zeitgeist.Event.full (Zeitgeist.ZG.MODIFY_EVENT,
                            event_manifestation,
                            actor,
                            null);
        event.add_subject (subject);

        insert_events (event);
    }

    public void move_insert (string old_uri, string new_uri, string mimetype) {
        var subject = get_subject (old_uri, mimetype);
        subject.current_uri = new_uri;
        var event = new Zeitgeist.Event.full (Zeitgeist.ZG.MOVE_EVENT,
                            event_manifestation,
                            actor,
                            null);
        event.add_subject (subject);

        insert_events (event);
    }

    private void insert_events (Zeitgeist.Event ev) {
        var events = new GenericArray<Event> ();
        events.add (ev);
        try {
            var zg_log = new Zeitgeist.Log ();
            zg_log.insert_events_no_reply (events);
        } catch (Error e) {
            warning (e.message);
        }
    }

    private Subject get_subject (string uri, string mimetype) {
        return new Subject.full (uri,
                        interpretation_for_mimetype (mimetype),
                        manifestation_for_uri (uri),
                        mimetype,
                        GLib.Path.get_dirname (uri),
                        GLib.Path.get_basename (uri),
                        ""); // FIXME: storage?!
    }
}
#endif
