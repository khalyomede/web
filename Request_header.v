module web

import net.http { CommonHeader }

pub fn (request Request) header(parameters HeaderParameters) ?string {
    return match parameters.key {
        string { request.base_request.header.get_custom(parameters.key) }
        CommonHeader { request.base_request.header.get(parameters.key) }
    }
}
