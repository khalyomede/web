module web

pub fn (request Request) cookies() map[string]string {
    raw_cookie_value := request.base_request.header.get(.cookie) or {
        return map[string]string{}
    }

    mut cookies := map[string]string{}
    cookie_pairs := raw_cookie_value.split(";")

    for cookie_pair in cookie_pairs {
        cookie_parts := cookie_pair.split("=")

        cookie_key := cookie_parts[0] or {
            continue
        }

        cookie_value := cookie_parts[1] or {
            continue
        }

        cookies[cookie_key.trim_space()] = cookie_value
    }

    return cookies
}
