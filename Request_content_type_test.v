module test

import khalyomede.expect { expect }
import khalyomede.faker { Faker }
import khalyomede.mime { Mime }
import net.http { Request, Header, new_header }
import web

fn test_it_can_get_application_json_content_type_from_request() {
    request := web.Request{
        base_request: Request{
            method: .post
            url: "/login"
            header: new_header(key: .content_type, value: Mime.application_json.str())
        }
    }

    expect(request.content_type() or { Mime.text_plain }).to_be_equal_to(Mime.application_json)
}

fn test_it_can_get_multipart_form_data_content_type_from_request() {
    mut fake := Faker{}
    file_content := fake.sentence()

    request := web.Request{
        base_request: Request{
            url: "/upload"
            method: .post
            header: new_header(
                key: .content_type,
                value: "multipart/form-data; boundary=----WebKitFormBoundaryoTz0CAYWkKwTP7QO"
            )
            data: '------WebKitFormBoundaryTWQtK6e7HbmMJdeW
Content-Disposition: form-data; name="file"; filename="test.txt"
Content-Type: text/plain

${file_content}

------WebKitFormBoundaryTWQtK6e7HbmMJdeW--
'
        }
    }

    expect(request.content_type() or { Mime.text_plain }).to_be_equal_to(Mime.multipart_form_data)
}
