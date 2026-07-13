module test

import khalyomede.expect { expect }
import khalyomede.mime { Mime }
import khalyomede.faker { Faker }
import net.http { Request, new_header }
import web

fn test_it_can_get_a_value_from_a_form_key() {
    mut fake := Faker{}
    email := fake.email()
    password := fake.word()

    request := web.Request{
        base_request: Request{
            method: .post
            header: new_header(key: .content_type, value: Mime.text_html.str())
            data: "email=${email}&password=${password}"
        }
    }

    expect(request.body(key: "email") or { "" }).to_be_equal_to(email)
    expect(request.body(key: "password") or { "" }).to_be_equal_to(password)
}

fn test_it_can_get_a_value_from_a_json_key() {
    mut fake := Faker{}
    email := fake.email()
    password := fake.word()

    request := web.Request{
        base_request: Request{
            method: .post
            header: new_header(key: .content_type, value: Mime.application_json.str())
            data: '{"email": "${email}", "password": "${password}"}'
        }
    }

    expect(request.body(key: "email") or { "" }).to_be_equal_to(email)
    expect(request.body(key: "password") or { "" }).to_be_equal_to(password)
}
