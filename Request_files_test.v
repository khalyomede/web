module test

import khalyomede.expect { expect }
import khalyomede.faker { Faker }
import khalyomede.mime { Mime }
import net.http { Request, FileData, new_header }
import web

fn test_it_can_get_all_txt_files_uploaded_for_a_multiple_select_with_specific_name_when_there_is_multiple_ones() {
    mut fake := Faker{}
    first_file_content := fake.sentence()
    second_file_content := fake.sentence()

    request := web.Request{
        base_request: Request{
            url: "/upload"
            method: .post
            header: new_header(
                key: .content_type,
                value: "multipart/form-data; boundary=----WebKitFormBoundaryTWQtK6e7HbmMJdeW"
            )
            data: '------WebKitFormBoundaryTWQtK6e7HbmMJdeW
Content-Disposition: form-data; name="documents"; filename="test1.txt"
Content-Type: text/plain

${first_file_content}

------WebKitFormBoundaryTWQtK6e7HbmMJdeW
Content-Disposition: form-data; name="documents"; filename="test2.txt"
Content-Type: text/plain

${second_file_content}

------WebKitFormBoundaryTWQtK6e7HbmMJdeW
Content-Disposition: form-data; name="file2"; filename="test3.json"
Content-Type: application/json

{"title": "2026_revenues"}

------WebKitFormBoundaryTWQtK6e7HbmMJdeW--
'
        }
    }

    files := request.files(name: "documents")
    first_file := files[0] or { FileData{} }
    second_file := files[1] or { FileData{} }

    expect(files.len).to_be_equal_to(2)

    // First file
    expect(first_file.content_type).to_be_equal_to(Mime.text_plain.str())
    expect(first_file.data).to_be_equal_to("${first_file_content}")
    expect(first_file.filename).to_be_equal_to("test1.txt")

    // Second file
    expect(second_file.content_type).to_be_equal_to(Mime.text_plain.str())
    expect(second_file.data).to_be_equal_to("${second_file_content}")
    expect(second_file.filename).to_be_equal_to("test2.txt")
}

fn test_it_get_no_files_when_no_one_match_file_name() {
    mut fake := Faker{}
    first_file_content := fake.sentence()
    second_file_content := fake.sentence()

    request := web.Request{
        base_request: Request{
            url: "/upload"
            method: .post
            header: new_header(
                key: .content_type,
                value: "multipart/form-data; boundary=----WebKitFormBoundaryTWQtK6e7HbmMJdeW"
            )
            data: '------WebKitFormBoundaryTWQtK6e7HbmMJdeW
Content-Disposition: form-data; name="documents"; filename="test1.txt"
Content-Type: text/plain

${first_file_content}

------WebKitFormBoundaryTWQtK6e7HbmMJdeW
Content-Disposition: form-data; name="documents"; filename="test2.txt"
Content-Type: text/plain

${second_file_content}

------WebKitFormBoundaryTWQtK6e7HbmMJdeW
Content-Disposition: form-data; name="file2"; filename="test3.json"
Content-Type: application/json

{"title": "2026_revenues"}

------WebKitFormBoundaryTWQtK6e7HbmMJdeW--
'
        }
    }

    files := request.files(name: "files")

    expect(files.len).to_be_equal_to(0)
}

fn test_it_get_no_files_when_there_is_none() {
    request := web.Request{
        base_request: Request{
            url: "/upload"
            method: .post
            header: new_header(key: .content_type, value: Mime.application_json.str())
            data: '{"name": "John"}'
        }
    }

    files := request.files(name: "files")

    expect(files.len).to_be_equal_to(0)
}
