module web

import net.http { FileData, Header, parse_multipart_form }

fn (request Request) get_files() map[string][]FileData {
    content_type := request.content_type() or {
        return map[string][]FileData{}
    }

    return match content_type {
        .multipart_form_data {
            raw_content_type := request.base_request.header.get(.content_type) or {
                return map[string][]FileData{}
            }

            mut files := map[string][]FileData{}
            boundary := (raw_content_type.str().split('boundary=')[1] or { "" })

            if boundary.len == 0 {
                return map[string][]FileData{}
            }

            trimmed_boundary := boundary.trim_space()

            if trimmed_boundary.len == 0 {
                return map[string][]FileData{}
            }

            _, list_of_file_data := parse_multipart_form(request.base_request.data, trimmed_boundary)

            for name, file_data_files in list_of_file_data {
                mut all_files := []FileData{}

                for file_data_file in file_data_files {
                    all_files << file_data_file
                }

                files[name] = all_files
            }

            return files
        }
        else {
            return map[string][]FileData{}
        }
    }
}
