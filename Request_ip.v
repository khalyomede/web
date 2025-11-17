module web

import net.http { HeaderQueryConfig }
import khalyomede.ip { Address, Ipv4, Ipv6 }

pub fn (request Request) ip() !Address {
    remote_address := request.base_request.header.get_custom('RemoteAddr', HeaderQueryConfig{exact: true})!

    is_ip_v6 := Ipv6.parse(remote_address) or { Ipv6{} } != Ipv6{}

    if is_ip_v6 {
        address := Ipv6.parse(remote_address)!

        return Address(address)
    }

    address := Ipv4.parse(remote_address)!

    return Address(address)
}
