module test

import khalyomede.expect { expect }
import net.http { Request, new_header }
import web

fn test_it_returns_true_if_request_accepts_text_html() {
    request := web.Request{
        base_request: Request{
            header: new_header(key: .accept, value: "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7")
        }
    }

    expect(request.accepts(.text_html)).to_be_true()
}

fn test_it_returns_true_if_request_doesnt_accept_application_json() {
    request := web.Request{
        base_request: Request{
            header: new_header(key: .accept, value: "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7")
        }
    }

    expect(request.accepts(.application_json)).to_be_false()
}
