module test

import encoding.base64
import khalyomede.expect { expect }
import khalyomede.faker { Faker }
import net.http { Request, Header, new_header }
import web

fn test_it_can_get_basic_auth_from_header() {
    mut fake := Faker{}
    username := fake.email()
    password := fake.u8().str()
    basic_authorization := base64.encode_str("${username}:${password}")

    request := web.Request{
        base_request: Request{
            header: new_header(key: .authorization, value: "Basic ${basic_authorization}")
        }
    }

    user, pass := request.basic_auth() or { "", "" }

    expect(user).to_be_equal_to(username)
    expect(pass).to_be_equal_to(password)
}

fn test_it_cannot_get_basic_auth_from_header_when_it_is_not_correctly_base64_encoded() {
    mut fake := Faker{}
    username := fake.email()
    password := fake.u8().str()
    basic_authorization := "${username}:${password}"

    request := web.Request{
        base_request: Request{
            header: new_header(key: .authorization, value: "Basic ${basic_authorization}")
        }
    }

    user, pass := request.basic_auth() or { "", "" }

    expect(user).to_be_equal_to("")
    expect(pass).to_be_equal_to("")
}

fn test_it_cannot_get_basic_auth_when_username_is_missing() {
    mut fake := Faker{}
    username := fake.email()
    password := fake.u8().str()
    basic_authorization := base64.encode_str(":${password}")

    request := web.Request{
        base_request: Request{
            header: new_header(key: .authorization, value: "Basic ${basic_authorization}")
        }
    }

    user, pass := request.basic_auth() or { "", "" }

    expect(user).to_be_equal_to("")
    expect(pass).to_be_equal_to("")
}

fn test_it_cannot_get_basic_auth_when_password_is_missing() {
    mut fake := Faker{}
    username := fake.email()
    password := fake.u8().str()
    basic_authorization := base64.encode_str("${username}:")

    request := web.Request{
        base_request: Request{
            header: new_header(key: .authorization, value: "Basic ${basic_authorization}")
        }
    }

    user, pass := request.basic_auth() or { "", "" }

    expect(user).to_be_equal_to("")
    expect(pass).to_be_equal_to("")
}

fn test_it_cannot_get_basic_auth_when_username_contains_colon() {
    mut fake := Faker{}
    username := fake.first_name() + ":" + fake.last_name() + "@" + fake.company_name() + "." + fake.top_level_domain()
    password := fake.u8().str()
    basic_authorization := base64.encode_str("${username}:${password}")

    request := web.Request{
        base_request: Request{
            header: new_header(key: .authorization, value: "Basic ${basic_authorization}")
        }
    }

    user, pass := request.basic_auth() or { "", "" }

    expect(user).to_be_equal_to("")
    expect(pass).to_be_equal_to("")
}

fn test_it_cannot_get_basic_auth_when_username_and_password_are_missing() {
    mut fake := Faker{}

    request := web.Request{
        base_request: Request{
            header: new_header(key: .authorization, value: "Basic ")
        }
    }

    user, pass := request.basic_auth() or { "", "" }

    expect(user).to_be_equal_to("")
    expect(pass).to_be_equal_to("")
}

fn test_it_cannot_get_basic_auth_when_no_header_is_found() {
    mut fake := Faker{}

    request := web.Request{
        base_request: Request{
            header: Header{}
        }
    }

    user, pass := request.basic_auth() or { "", "" }

    expect(user).to_be_equal_to("")
    expect(pass).to_be_equal_to("")
}
