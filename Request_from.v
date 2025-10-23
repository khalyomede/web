module web

import net.http

pub fn Request.from(base_request http.Request) Request {
    return Request{
        method: base_request.method
        url: base_request.url
    }
}
