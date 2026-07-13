module web

import khalyomede.mime { Mime }

pub fn (request Request) content_type() ?Mime {
    content_type := request.base_request.header.get(.content_type)?
    content_type_parts := content_type.split(";")
    content_type_string := content_type_parts[0] or {
        return none
    }

    return Mime.parse(content_type_string)
}
