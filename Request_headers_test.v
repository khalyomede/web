module test

import khalyomede.expect { expect }
import khalyomede.faker { Faker }
import khalyomede.mime { Mime }
import net.http { Request, Header, new_header_from_map }
import web

fn test_it_returns_all_headers_from_request() {
    mut fake := Faker{}
    mut header := Header{}
    accept := Mime.text_html.str()
    x_client_id := fake.u8().str()

    header.add(.accept, accept)
    header.add_custom("X-Client-Id", x_client_id)!

    request := web.Request{
        base_request: Request{
            header: header
        }
    }

    expect(request.headers()).to_be_equal_to({
        "Accept": accept,
        "X-Client-Id": x_client_id,
    })
}

fn test_it_return_no_header_if_request_contains_none() {
    request := web.Request{
        base_request: Request{
            header: Header{}
        }
    }

    expect(request.headers()).to_be_equal_to(map[string]string{})
}
