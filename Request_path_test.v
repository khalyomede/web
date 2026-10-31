module test

import web
import net.http { Request }

fn test_it_can_get_path_from_url_with_only_path() {
    request := web.Request{
        Request{
            url: "/contact"
        }
    }

    assert request.path() or { "" } == "/contact"
}

fn test_it_can_get_path_from_url_with_multiple_level_path() {
    request := web.Request{
        Request{
           url: "/users/ef53ft5/edit"
        }
    }

    assert request.path() or { "" } == "/users/ef53ft5/edit"
}

fn test_it_can_get_path_from_url_with_path_and_query_strings() {
    request := web.Request{
        Request{
            url: "/users?type=company&active=1"
        }
    }

    assert request.path() or { "" } == "/users"
}

fn test_it_can_get_path_from_url_with_path_and_fragment() {
    request := web.Request{
        Request{
            url: "/about#our-mission"
        }
    }

    assert request.path() or { "" } == "/about"
}

fn test_it_returns_path_without_ending_slash_if_it_contains_one() {
    request := web.Request{
        Request{
            url: "/about/"
        }
    }

    assert request.path() or { "" } == "/about"
}

fn test_it_returns_path_without_ending_slash_if_it_contains_more_than_one() {
    request := web.Request{
        Request{
            url: "/about//"
        }
    }

    assert request.path() or { "" } == "/about"
}

fn test_it_returns_path_without_ending_slash_if_it_contains_more_than_one_after_each_parts() {
    request := web.Request{
        Request{
            url: "/about///our-mission//"
        }
    }

    assert request.path() or { "" } == "/about/our-mission"
}

fn test_it_returns_path_if_it_contains_backward_accesses() {
    request := web.Request{
        Request{
            url: "/about/../contact-us/"
        }
    }

    assert request.path() or { "" } == "/contact-us"
}

fn test_it_returns_nothing_when_trying_to_access_path_outside_scope() {
    request := web.Request{
        Request{
            url: "/about/../../node_modules/bin/vite"
        }
    }

    assert request.path() or { "" } == ""
}

fn test_it_returns_slash_if_path_is_root() {
    request := web.Request{
        Request{
            url: "/"
        }
    }

    assert request.path() or { "" } == "/"
}

fn test_it_returns_one_slash_if_path_is_root_with_multiple_ending_slashes() {
    request := web.Request{
        Request{
            url: "///"
        }
    }

    assert request.path() or { "" } == "/"
}
