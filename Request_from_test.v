module test

import web
import net.http { Request, Method }
import khalyomede.expect { expect }

fn test_it_can_create_request_from_base_request() {
    request := web.Request.from(Request{
        method: .get
        url: "/test"
    })

    expect(request.method).to_be_equal_to(Method.get)
    expect(request.url).to_be_equal_to("/test")
}
