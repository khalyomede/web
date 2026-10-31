module test

import khalyomede.expect { expect }
import khalyomede.faker { Faker }
import khalyomede.mime { Mime }
import net.http { Status, new_header_from_map }
import web { Response }

fn test_it_can_create_200_response_from_base_response() {
    mut fake := Faker{}
    body := fake.sentence()
    status_ok := Status.ok.int()
    mime_text_html := Mime.text_html.str()

    response := Response{
        Response: http.Response{
            status_code: status_ok
            body: body
            header: new_header_from_map({
                .content_type: mime_text_html
            })
        }
    }

    expect(response.body).to_be_equal_to(body)
    expect(response.status_code).to_be_equal_to(status_ok)
    expect(response.header.get(.content_type) or { Mime.text_plain.str() }).to_be_equal_to(mime_text_html)
}
