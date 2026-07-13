module test

import khalyomede.faker { Faker }
import khalyomede.expect { expect }
import khalyomede.mime { Mime }
import net.http { FileData, Header, Request, new_header }
import web

fn test_it_can_get_all_txt_files_uploaded_when_there_is_only_one() {
    mut fake := Faker{}
    file_content := fake.sentence()
    base_request := Request{
        url: "/upload"
        method: .post
        header: new_header(
            key: .content_type,
            value: "multipart/form-data; boundary=----WebKitFormBoundaryTWQtK6e7HbmMJdeW"
        )
        data: '------WebKitFormBoundaryTWQtK6e7HbmMJdeW
Content-Disposition: form-data; name="file"; filename="test.txt"
Content-Type: text/plain

${file_content}

------WebKitFormBoundaryTWQtK6e7HbmMJdeW--
'
    }

    request := web.Request{
        base_request: base_request
    }

    files := request.all_files()
    first_file := files[0] or { FileData{} }

    expect(files.len).to_be_equal_to(1)
    expect(first_file.content_type).to_be_equal_to(Mime.text_plain.str())
    expect(first_file.data).to_be_equal_to("${file_content}")
    expect(first_file.filename).to_be_equal_to("test.txt")
}

fn test_it_can_get_all_txt_files_uploaded_when_there_is_multiple_ones() {
    mut fake := Faker{}
    first_file_content := fake.sentence()
    second_file_content := '{"title": "2026_revenues"}'

    request := web.Request{
        base_request: Request{
            url: "/upload"
            method: .post
            header: new_header(
                key: .content_type,
                value: "multipart/form-data; boundary=----WebKitFormBoundaryTWQtK6e7HbmMJdeW"
            )
            data: '------WebKitFormBoundaryTWQtK6e7HbmMJdeW
Content-Disposition: form-data; name="file1"; filename="test1.txt"
Content-Type: text/plain

${first_file_content}

------WebKitFormBoundaryTWQtK6e7HbmMJdeW
Content-Disposition: form-data; name="file2"; filename="test2.json"
Content-Type: application/json

${second_file_content}

------WebKitFormBoundaryTWQtK6e7HbmMJdeW--
'
        }
    }

    files := request.all_files()
    first_file := files[0] or { FileData{} }
    second_file := files[1] or { FileData{} }

    expect(files.len).to_be_equal_to(2)

    // First file
    expect(first_file.content_type).to_be_equal_to(Mime.text_plain.str())
    expect(first_file.data).to_be_equal_to("${first_file_content}")
    expect(first_file.filename).to_be_equal_to("test1.txt")

    // Second file
    expect(second_file.content_type).to_be_equal_to(Mime.application_json.str())
    expect(second_file.data).to_be_equal_to("${second_file_content}")
    expect(second_file.filename).to_be_equal_to("test2.json")
}

fn test_it_can_get_all_txt_files_uploaded_when_there_is_none() {
    request := web.Request{
        base_request: Request{
            url: "/upload"
            method: .post
            header: new_header(key: .content_type, value: Mime.application_json.str())
            data: '{"name": "John"}'
        }
    }

    expect(request.all_files().len).to_be_equal_to(0)
}
