module web

import encoding.base64
import net.http { CommonHeader }

/**
    @todo Think about returning a detailed error using !(string, string) instead?
**/
pub fn (request Request) basic_auth() ?(string, string) {
    authorization_header := request.header(key: CommonHeader.authorization)?
    authorization_header_parts := authorization_header.split(" ")

    if authorization_header_parts.len != 2 {
        return none
    }

    auth_scheme := authorization_header_parts[0]
    basic_auth := authorization_header_parts[1].trim_space()

    /**
        @todo Make a auth_scheme enum package.
    **/
    if auth_scheme != "Basic" {
        return none
    }

    /**
        @todo Make a package that returns a ?string if the string is malformed
    **/
    decoded_basic_auth := base64.decode_str(basic_auth).trim_space()

    if decoded_basic_auth == "" {
        return none
    }

    decoded_basic_auth_parts := decoded_basic_auth.split(":")

    if decoded_basic_auth_parts.len != 2 {
        return none
    }

    username := decoded_basic_auth_parts[0].trim_space()
    password := decoded_basic_auth_parts[1]

    if username.len == 0 || password.len == 0 {
        return none
    }

    return username, password
}
