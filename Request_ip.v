module web

import net.http { HeaderQueryConfig }
import khalyomede.ip { Address, Ipv4, Ipv6 }

pub fn (request Request) ip() !Address {
    remote_address := request.base_request.header.get_custom('RemoteAddr', HeaderQueryConfig{exact: true})!

    return Address.parse(remote_address)!
}
