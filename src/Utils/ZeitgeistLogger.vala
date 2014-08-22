// -*- Mode: vala; indent-tabs-mode: nil; tab-width: 4 -*-
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

-> Taken from Scratch (https://launchpad.net/scratch/)
***/

#if HAVE_ZEITGEIST
using Zeitgeist;

namespace Writer.Utils {

    public class ZeitgeistLogger {

        Zeitgeist.Log zg_log = new Zeitgeist.Log();

        public string actor = "application://writer.desktop";
        public string event_manifestation = Zeitgeist.ZG.USER_ACTIVITY;

        public void open_insert (string? uri, string mimetype) {

            if (uri == null)
                return;

            var subject = get_subject(uri, mimetype);
            var event = new Zeitgeist.Event.full (Zeitgeist.ZG.ACCESS_EVENT,
                                event_manifestation,
                                actor,
                                null);
            event.add_subject(subject);

            insert_events(event);
        }

        public void close_insert (string? uri, string mimetype) {

            if (uri == null)
                return;

            var subject = get_subject(uri, mimetype);
            var event = new Zeitgeist.Event.full (Zeitgeist.ZG.LEAVE_EVENT,
                                event_manifestation,
                                actor,
                                null);
            event.add_subject(subject);

            insert_events(event);
       }

        public void save_insert (string uri, string mimetype) {

            var subject = get_subject(uri, mimetype);
            var event = new Zeitgeist.Event.full (Zeitgeist.ZG.MODIFY_EVENT,
                                event_manifestation,
                                actor,
                                null);
            event.add_subject(subject);

            insert_events(event);
        }

        public void move_insert (string old_uri, string new_uri, string mimetype) {

            var subject = get_subject(old_uri, mimetype);
            subject.current_uri = new_uri;
            var event = new Zeitgeist.Event.full (Zeitgeist.ZG.MOVE_EVENT,
                                event_manifestation,
                                actor,
                                null);
            event.add_subject(subject);

            insert_events(event);
        }

        private void insert_events (Zeitgeist.Event ev) {
            GenericArray<Event> events = new GenericArray<Event>();
            events.add(ev);
            try {
                zg_log.insert_events_no_reply (events);
            } catch (Error e) { warning (e.message); }
        }

        private Subject get_subject(string uri, string mimetype) {

            return new Subject.full (uri,
                          interpretation_for_mimetype (mimetype),
                          manifestation_for_uri (uri),
                          mimetype,
                          GLib.Path.get_dirname(uri),
                          GLib.Path.get_basename(uri),
                          ""); // FIXME: storage?!
        }
    }

}
#endif
