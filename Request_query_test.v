module test

import web { QueryNotFound }
import net.http { Request }
import khalyomede.expect { expect }

fn test_it_returns_query_string() {
    base_request := Request{
        url: "/users?type=company"
    }

    request := web.Request.from(base_request)

    expect(request.query("type") or { "" }).to_be_equal_to("company")
}

fn test_it_returns_error_when_no_query_found() {
    base_request := Request{
        url: "/users?type=company"
    }

    request := web.Request.from(base_request)

    query := request.query("active") or {
        match err {
            QueryNotFound { "query not found" }
            else { "none" }
        }
    }

    expect(query).to_be_equal_to("query not found")
}

fn test_it_returns_empty_string_when_query_has_no_value() {
    base_request := Request{
        url: "/users?type=company&active"
    }

    request := web.Request.from(base_request)

    expect(request.query("active") or { "nothing" }).to_be_equal_to("")
}
