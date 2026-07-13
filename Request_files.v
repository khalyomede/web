module web

import net.http { FileData }

pub fn (request Request) files(parameters FilesParameters) []FileData {
    return request.get_files()[parameters.name] or { []FileData{} }
}
