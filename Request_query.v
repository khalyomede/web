module web

import khalyomede.url { Url }

pub fn (request Request) query(key string) !string {
    request_url := request.url.trim_left("/")
    link := Url.parse("https://example.com/${request_url}")!

    for query_key, query_value in link.query {
        if query_key == key {
            return query_value
        }
    }

    return QueryNotFound{
        key: key
    }
}
