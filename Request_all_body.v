module web

import json
import net.http { parse_form }

pub fn (request Request) all_body() map[string]string {
    content_type := request.content_type() or {
        return map[string]string{}
    }

    return match content_type {
        .text_html {
            parse_form(request.base_request.data)
        }
        .application_json {
            json.decode(JsonBody, parse_form(request.base_request.data)['json']) or {
                map[string]string{}
            }
        }
        else {
            map[string]string{}
        }
    }
}
