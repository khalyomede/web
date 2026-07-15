module web

import net.http { CommonHeader }

/**
    @todo Make a package to return a UserAgent struct with methods to get the device, brand, ...
    @see https://github.com/matomo-org/device-detector/blob/master/regexes for inspiration
**/
pub fn (request Request) user_agent() ?string {
    return request.header(key: CommonHeader.user_agent)
}
