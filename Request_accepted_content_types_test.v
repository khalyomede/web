module test

import khalyomede.expect { expect }
import khalyomede.mime { Mime }
import net.http { Request, Header, new_custom_header_from_map }
import web

fn test_it_returns_accepted_content_types_associated_with_browser_html_request() {
    request := web.Request.from(Request{
        method: .get
        url: "/"
        header: new_custom_header_from_map({
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7"
        }) or { Header{} }
    })

    expect(request.accepted_content_types()).to_be_equal_to([
        Mime.text_html,
        Mime.application_xhtml_xml,
        Mime.application_xml,
        Mime.image_avif,
        Mime.image_webp,
        Mime.image_apng,
    ])
}

fn test_it_returns_accepted_content_types_associated_with_web_service_requesting_json_response() {
    request := web.Request.from(Request{
        method: .get
        url: "/"
        header: new_custom_header_from_map({
            "Accept": "application/json"
        }) or { Header{} }
    })

    expect(request.accepted_content_types()).to_be_equal_to([
        Mime.application_json,
    ])
}

fn test_it_returns_no_content_types_when_request_has_no_accept_header() {
    request := web.Request.from(Request{
        method: .get
        url: "/"
    })

    expect(request.accepted_content_types()).to_be_equal_to([]Mime{})
}

fn test_it_returns_no_content_types_when_request_accepts_unknown_content_type() {
    request := web.Request.from(Request{
        method: .get
        url: "/"
        header: new_custom_header_from_map({
            "Accept": "application/signed-exchange;v=b3;q=0.7"
        })  or { Header{} }
    })

    expect(request.accepted_content_types()).to_be_equal_to([]Mime{})
}
