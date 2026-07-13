module test

import khalyomede.expect { expect }
import khalyomede.faker { Faker }
import net.http { CommonHeader, Header, Request, new_custom_header_from_map, new_header }
import web

fn test_it_can_get_custom_header() {
    mut fake := Faker{}
    header_key := "X-Client-Id"
    /**
        @todo Replace by fake.uuid() once https://github.com/khalyomede/faker/issues/12 is resolved.
    **/
    header_value := fake.u8().str()

    request := web.Request{
        base_request: Request{
            header: new_custom_header_from_map({
                header_key: header_value
            }) or { Header{} }
        }
    }

    expect(request.header(key: header_key) or { "" }).to_be_equal_to(header_value)
}

fn test_it_can_get_common_header() {
    mut fake := Faker{}
    referer := fake.base_url()

    request := web.Request{
        base_request: Request{
            header: new_header(key: .referer, value: referer)
        }
    }

    expect(request.header(key: CommonHeader.referer) or { "" }).to_be_equal_to(referer)
}

fn test_it_returns_nothing_if_header_not_found() {
    request := web.Request{
        base_request: Request{
            header: Header{}
        }
    }

    expect(request.header(key: "foo") or { "" }).to_be_equal_to("")
}
