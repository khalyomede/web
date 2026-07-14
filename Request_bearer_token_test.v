module test

import khalyomede.faker { Faker }
import khalyomede.expect { expect }
import net.http { Request, Header, new_header }
import web

fn test_it_can_get_bearer_token_from_request() {
    mut fake := Faker{}
    token := fake.u8().str()

    request := web.Request{
        base_request: Request{
            header: new_header(key: .authorization, value: "Bearer ${token}")
        }
    }

    expect(request.bearer_token() or { "" }).to_be_equal_to(token)
}

fn test_it_returns_nothing_if_authorization_header_not_found() {
    mut fake := Faker{}
    token := fake.u8().str()

    request := web.Request{
        base_request: Request{
            header: Header{}
        }
    }

    expect(request.bearer_token() or { "" }).to_be_equal_to("")
}

fn test_it_returns_nothing_if_authorization_header_is_bearer_with_empty_token() {
    mut fake := Faker{}
    token := fake.u8().str()

    request := web.Request{
        base_request: Request{
            header: new_header(key: .authorization, value: "Bearer ")
        }
    }

    expect(request.bearer_token() or { "" }).to_be_equal_to("")
}

fn test_it_returns_nothing_if_authorization_header_is_basic_auth() {
    mut fake := Faker{}
    token := fake.u8().str()

    request := web.Request{
        base_request: Request{
            header: new_header(key: .authorization, value: "Basic base64")
        }
    }

    expect(request.bearer_token() or { "" }).to_be_equal_to("")
}

fn test_it_returns_nothing_if_authorization_header_doesnt_have_auth_scheme() {
    mut fake := Faker{}
    token := fake.u8().str()

    request := web.Request{
        base_request: Request{
            header: new_header(key: .authorization, value: "${token}")
        }
    }

    expect(request.bearer_token() or { "" }).to_be_equal_to("")
}
