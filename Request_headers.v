module web

pub fn (request Request) headers() map[string]string {
    mut headers := map[string]string{}
    base_header := request.base_request.header
    header_keys := base_header.keys()

    for header_key in header_keys {
        header_value := base_header.get_custom(header_key) or {
            continue
        }

        headers[header_key] = header_value
    }

    return headers
}
