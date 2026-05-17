module web

import khalyomede.mime { Mime }

pub fn (request Request) accepted_content_types() []Mime {
    accept := request.base_request.header.get(.accept) or {
        return []Mime{}
     }

    // "text/html,application/xhtml+xml,application/xml;q=0.9" -> ["text/html", "application/xhtml+xml", "application/xml;q=0.9"]
    // ["text/html", "application/xhtml+xml", "application/xml;q=0.9"] -> ["text/html", "application/xhtml+xml", "application/xml"]
    accept_parts := accept.split(",").map(it.split(";")[0])
    mut mimes := []Mime{}

    for accept_part in accept_parts {
        mime_type := Mime.parse(accept_part) or {
            continue
        }

        mimes << mime_type
    }

    return mimes
}
