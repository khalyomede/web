module web

import khalyomede.url { Url }

pub fn (request Request) path() !string {
    url_without_leading_slash := request.url.trim_left("/")

    link := Url.parse("https://example.com/${url_without_leading_slash}")!

    return link.path
}
