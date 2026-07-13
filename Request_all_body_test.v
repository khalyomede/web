module test

import khalyomede.expect { expect }
import khalyomede.faker { Faker }
import khalyomede.mime { Mime }
import net.http { Request, new_header }
import web

fn test_it_can_get_all_key_values_from_form() {
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

    expect(request.all_body()).to_be_equal_to({"email": email, "password": password})
}

fn test_it_can_all_key_values_from_a_json_key() {
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

    expect(request.all_body()).to_be_equal_to({"email": email, "password": password})
}
