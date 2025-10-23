module web

import net.http { Method }

pub struct Request {
    pub:
        method Method
        url string
}
