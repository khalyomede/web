module web

import net.http { CommonHeader }

pub fn (request Request) bearer_token() ?string {
    authorization_header := request.header(key: CommonHeader.authorization)?
    authorization_parts := authorization_header.split(":")[0] or {
        return none
    }

    bearer_parts := authorization_parts.split(" ")

    if bearer_parts.len != 2 {
        return none
    }

    auth_scheme := bearer_parts[0]
    token := bearer_parts[1].trim_space()

    /**
        @todo Make a auth_scheme enum package.
    **/
    if auth_scheme != "Bearer" {
        return none
    }

    if token.len == 0 {
        return none
    }

    return token
}
