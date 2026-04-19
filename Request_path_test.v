module test

import web
import net.http { Request }

fn test_it_can_get_path_from_url_with_only_path() {
    base_request := Request{
        url: "/contact"
    }

    request := web.Request.from(base_request)

    assert request.path() or { "" } == "/contact"
}

fn test_it_can_get_path_from_url_with_multiple_level_path() {
    base_request := Request{
        url: "/users/ef53ft5/edit"
    }

    request := web.Request.from(base_request)

    assert request.path() or { "" } == "/users/ef53ft5/edit"
}

fn test_it_can_get_path_from_url_with_path_and_query_strings() {
    base_request := Request{
        url: "/users?type=company&active=1"
    }

    request := web.Request.from(base_request)

    assert request.path() or { "" } == "/users"
}

fn test_it_can_get_path_from_url_with_path_and_fragment() {
    base_request := Request{
        url: "/about#our-mission"
    }

    request := web.Request.from(base_request)

    assert request.path() or { "" } == "/about"
}

fn test_it_returns_path_without_ending_slash_if_it_contains_one() {
    base_request := Request{
        url: "/about/"
    }

    request := web.Request.from(base_request)

    assert request.path() or { "" } == "/about"
}

fn test_it_returns_path_without_ending_slash_if_it_contains_more_than_one() {
    base_request := Request{
        url: "/about//"
    }

    request := web.Request.from(base_request)

    assert request.path() or { "" } == "/about"
}

fn test_it_returns_path_without_ending_slash_if_it_contains_more_than_one_after_each_parts() {
    base_request := Request{
        url: "/about///our-mission//"
    }

    request := web.Request.from(base_request)

    assert request.path() or { "" } == "/about/our-mission"
}

fn test_it_returns_path_if_it_contains_backward_accesses() {
    base_request := Request{
        url: "/about/../contact-us/"
    }

    request := web.Request.from(base_request)

    assert request.path() or { "" } == "/contact-us"
}

fn test_it_returns_nothing_when_trying_to_access_path_outside_scope() {
    base_request := Request{
        url: "/about/../../node_modules/bin/vite"
    }

    request := web.Request.from(base_request)

    assert request.path() or { "" } == ""
}

fn test_it_returns_slash_if_path_is_root() {
    base_request := Request{
        url: "/"
    }

    request := web.Request.from(base_request)

    assert request.path() or { "" } == "/"
}

fn test_it_returns_one_slash_if_path_is_root_with_multiple_ending_slashes() {
    base_request := Request{
        url: "///"
    }

    request := web.Request.from(base_request)

    assert request.path() or { "" } == "/"
}
