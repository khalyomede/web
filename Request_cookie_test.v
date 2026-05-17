module test

import khalyomede.expect { expect }
import net.http { Header, Request, new_custom_header_from_map }
import web

fn test_it_get_single_cookie_from_request() {
    request := web.Request{
        base_request: Request{
            url: "/"
            method: .post,
            header: new_custom_header_from_map({
                "Cookie": "session=abc123; theme=dark"
            }) or { Header{} }
        }
    }

    cookie := request.cookie("theme") or { "light" }

    expect(cookie).to_be_equal_to("dark")
}

fn test_it_finds_no_cookie_from_requets_when_key_is_not_set() {
    request := web.Request{
        base_request: Request{
            url: "/"
            method: .post,
            header: new_custom_header_from_map({
                "Cookie": "session=abc123; prefer_reduced_motion=true"
            }) or { Header{} }
        }
    }

    cookie := request.cookie("theme") or { "light" }

    expect(cookie).to_be_equal_to("light")
}

fn test_it_finds_no_cookie_from_requets_when_no_cookie_is_set() {
    request := web.Request{
        base_request: Request{
            url: "/"
            method: .post,
        }
    }

    cookie := request.cookie("theme") or { "light" }

    expect(cookie).to_be_equal_to("light")
}
