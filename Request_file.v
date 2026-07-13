module web

import net.http { FileData }

pub fn (request Request) file(parameters FileParameters) ?FileData {
    return request.files(name: parameters.name)[0] or {
        none
    }
}
