module test

import khalyomede.faker { Faker }
import khalyomede.expect { expect }
import khalyomede.ip { Address, Ipv4, Ipv6 }
import net.http { Request, Header }
import web

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
        Ipv6 { request_ip.str() }
    }

    expect(actual.str()).to_be_equal_to(expected)
}
