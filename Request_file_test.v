module test

import khalyomede.expect { expect }
import khalyomede.faker { Faker }
import khalyomede.mime { Mime }
import net.http { Request, FileData, new_header }
import web

fn test_it_can_get_first_txt_file_when_there_is_only_one_with_same_name() {
    mut fake := Faker{}
    file_content := fake.sentence()

    request := web.Request{
        base_request: Request{
            url: "/upload"
            method: .post
            header: new_header(
                key: .content_type,
                value: "multipart/form-data; boundary=----WebKitFormBoundaryTWQtK6e7HbmMJdeW"
            )
            data: '------WebKitFormBoundaryTWQtK6e7HbmMJdeW
Content-Disposition: form-data; name="conditions"; filename="test.txt"
Content-Type: text/plain

${file_content}

------WebKitFormBoundaryTWQtK6e7HbmMJdeW--
'
        }
    }

    file := request.file(name: "conditions") or { FileData{} }

    expect(file.content_type).to_be_equal_to(Mime.text_plain.str())
    expect(file.data).to_be_equal_to("${file_content}")
    expect(file.filename).to_be_equal_to("test.txt")
}

fn test_it_can_get_first_txt_file_when_there_is_multiple_ones_with_same_name() {
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
Content-Disposition: form-data; name="conditions"; filename="test1.txt"
Content-Type: text/plain

${first_file_content}

------WebKitFormBoundaryTWQtK6e7HbmMJdeW
Content-Disposition: form-data; name="conditions"; filename="test2.txt"
Content-Type: text/plain

${second_file_content}

------WebKitFormBoundaryTWQtK6e7HbmMJdeW--
'
        }
    }

    file := request.file(name: "conditions") or { FileData{} }

    expect(file.content_type).to_be_equal_to(Mime.text_plain.str())
    expect(file.data).to_be_equal_to("${first_file_content}")
    expect(file.filename).to_be_equal_to("test1.txt")
}

fn test_it_get_no_file_when_no_one_match_file_name() {
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

    file := request.file(name: "insurance") or { FileData{} }

    expect(file.data.len).to_be_equal_to(0)
    expect(file.filename).to_be_equal_to("")
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

    file := request.file(name: "document") or { FileData{} }

    expect(file.data.len).to_be_equal_to(0)
    expect(file.filename).to_be_equal_to("")
}
