module web

import net.http { FileData, Header, parse_multipart_form }

pub fn (request Request) all_files() []FileData {
    mut files := []FileData{}

    for _, file_data_list in request.get_files() {
        for file_data in file_data_list {
            files << file_data
        }
    }

    return files
}
