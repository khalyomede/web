module web

import net.http { Method }

/**
  @todo Just use struct inheritance.
**/
pub struct Request {
    pub:
        method Method
        url string
        base_request http.Request
}
