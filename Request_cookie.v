module web

pub fn (request Request) cookie(key string) ?string {
    cookie_value := request.base_request.header.get(.cookie) or {
        return none
    }

    cookie_pairs := cookie_value.split(";")

    for cookie_pair in cookie_pairs {
        cookie_parts := cookie_pair.split("=")

        cookie_key := cookie_parts[0] or { "" }

        if cookie_key.trim_space() == key.trim_space() {
            return cookie_parts[1] or {
                none
            }
        }
    }

    return none
}
