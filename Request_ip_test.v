module test

import khalyomede.faker { Faker }
import khalyomede.expect { expect }
import khalyomede.ip { Address, Ipv4, Ipv6 }
import net.http { Request, Header }
import web { HeaderNotFound }

fn test_it_can_get_ip_v4_from_request() {
    mut fake := Faker{}
    mut header := Header{}
    expected := fake.ip_v4()

    header.set_custom('RemoteAddr', expected)!

    base_request := Request{
        header: header
    }

    request := web.Request.from(base_request)
    request_ip := request.ip()!

    actual := match request_ip {
        Ipv4 { request_ip.str() }
        Ipv6 { '' }
    }

    expect(actual.str()).to_be_equal_to(expected)
}

fn test_it_can_get_ip_v6_from_request() {
    mut fake := Faker{}
    mut header := Header{}
    expected := fake.ip_v6()

    header.set_custom('RemoteAddr', expected)!

    base_request := Request{
        header: header
    }

    request := web.Request.from(base_request)
    request_ip := request.ip()!

    actual := match request_ip {
        Ipv4 { '' }
        Ipv6 { request_ip.to_full_string() }
    }

    expect(actual.str()).to_be_equal_to(expected)
}

fn test_it_returns_header_not_found_error_when_header_not_present() {
    request := web.Request.from(Request{
        header: Header{}
    })

    mut error_matched := false

    address := request.ip() or {
        match err {
            HeaderNotFound {
                error_matched = err.msg() == 'Header "RemoteAddr" not found.'
            }
            else {
                error_matched = false
            }
        }

        Address(Ipv4{})
    }

    expect(error_matched).to_be_true()
}
