module web

import khalyomede.mime { Mime }

pub fn (request Request) accepts(accepted Mime) bool {
    accepted_content_types := request.accepted_content_types()

    return accepted_content_types.contains(accepted)
}
