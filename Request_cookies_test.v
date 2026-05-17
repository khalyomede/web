module test

import khalyomede.expect { expect }
import net.http { Header, Request, new_custom_header_from_map }
import web

fn test_it_gets_all_cookies_from_request() {
    request := web.Request{
        base_request: Request{
            url: "/"
            method: .get
            header: new_custom_header_from_map({
                "Cookie": "session_id=123abc; theme=dark"
            }) or { Header{} }
        }
    }

    expect(request.cookies()).to_be_equal_to({
        "session_id": "123abc"
        "theme": "dark"
    })
}

fn test_it_gets_no_cookies_when_cookie_header_is_empty_in_request() {
    request := web.Request{
        base_request: Request{
            url: "/"
            method: .get
            header: new_custom_header_from_map({
                "Cookie": ""
            }) or { Header{} }
        }
    }

    expect(request.cookies()).to_be_equal_to(map[string]string{})
}

fn test_it_gets_no_cookie_when_no_cookie_header_is_present_in_request() {
    request := web.Request{
        base_request: Request{
            url: "/"
            method: .get
        }
    }

    expect(request.cookies()).to_be_equal_to(map[string]string{})
}


