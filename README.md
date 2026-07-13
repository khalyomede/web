# Web

Net HTTP Request/Response utilities.

```v
module main

import khalyomede.web
import net.http { Server, Handler, Request, Response }

struct RequestHandler implements Handler {}

fn (request_handler RequestHandler) handle(base_request Request) Response {
  request := web.Request.from_base(base_request)

  theme := request.query("theme") or { "dark" }

  return web.Response.html(content: "<h1>Hello world (theme: ${theme})</h1>").to_base()
}

fn main() {
  mut server := Server{
    addr: "localhost:80"
    handler: RequestHandler{}
  }

  server.listen_and_serve()
}
```

## About

This package helps you get more out of the base `net.http` `Request` and `Response` structs by offering shortcut utility methods for commonly used data such as client IP, checking if a Mime type is accepted by client, etc...

This packages creates from and returns `net.http` `Request` and `Response` structs for full compatibility with the built-in `net.http` `Server` struct.

## Features

- Compatible with net.http Request/Response structs
- Request and Response utility functions to speed up development

## Installation

- [Using V installer](#using-v-installer)
- [Manual installation](#manual-installation)

### Using V installer

Install the required packages:

```bash
v install khalyomede.web
```

### Manual installation

## Examples

- Request
    - [Get the client IP](#get-the-client-ip)
    - [Get list of accepted content type](#get-list-of-accepted-content-type)
    - [Check if the client accepts a specific content type](#check-if-the-client-accepts-a-specific-content-type)
    - [Get the content type](#get-the-content-type)
    - [Get the path](#get-the-path)
    - Cookies
      - [Get a cookie by key](#get-a-cookie-by-key)
      - [Get all cookies](#get-all-cookies)
    - Query
        - [Get a query string by key](#get-a-query-string-by-key)
        - [Get all queries](#get-all-queries)
    - Body
      - [Get a body by key](#get-a-body-by-key)
      - [Get all body](#get-all-body)
      - File
        - [Get an uploaded file](#get-an-uploaded-file)
        - [Get all files for a key](#get-all-files-for-a-key)
        - [Get all files](#get-all-files)
    - Headers
      - [Get a specific header](#get-a-specific-header)
      - [Get the bearer token](#get-the-bearer-token)
      - [Get basic auth username password](#get-basic-auth-username-password)
      - [Get the user agent](#get-the-user-agent)
      - [Get the first support language](#get-the-first-supported-language)
      - [Get all supported languages](#get-all-supported-languages)
      - [Get all headers](#get-all-headers)
- Response
  - [Return basic response](#return-basic-response)
  - [Return HTML response](#return-html-response)
  - [Return JSON response](#return-json-response)

### Get the client IP

```v
module main

import khalyomede.web
import net.http { Server, Handler, Request, Response }

struct RequestHandler implements Handler {}

fn (request_handler RequestHandler) handle(base_request Request) Response {
  request := web.Request.from_base(base_request)

  ip := request.ip() or {
    return web.Response.html(content: "<h1>Unable to find your IP.</h1>", status: .server_error)
  }

  return web.Response.html(content: "<h1>Hello world</h1>").to_base()
}

fn main() {
  mut server := Server{
    addr: "localhost:80"
    handler: RequestHandler{}
  }

  server.listen_and_serve()
}
```

Note that the return type will be an `!Address` union type (which can be an `Ipv4` or `Ipv6` struct). See [khalyomede/ip](https://github.com/khalyomede/ip) for more information.

**Important notice**: For the moment, this method does not handle Proxies. For example, if your web server is behind a Cloudflare or Nginx Proxy, this method will always return the Proxy IP (and not the client IP). Instead, these proxy return the client IP in a specific header (which may change, hence the fact that for simplicity this method only returns the client IP in non-proxy situation).

For the moment, it is up to you to get the client IP using the proper [`Request.header()`](#get-a-specific-header) method.

In a future update, this package will allow you to declare a proxy configuration, such as calling `Request.ip()` will return the client IP as expect.

[back to examples](#examples)

### Get the path

> [!INFO]
> Install [khalyomede/url](https://github.com/khalyomede/url) to use this method.

```v
module main

import khalyomede.web
import net.http { Server, Handler, Request, Response }

struct RequestHandler implements Handler {}

fn (request_handler RequestHandler) handle(base_request Request) Response {
  request := web.Request.from_base(base_request)

  url := request.url // "/contact?theme=dark#whatsapp"
  path := request.path() // "/contact"

  return web.Response.html(content: "<h1>Hello world</h1>").to_base()
}

fn main() {
  mut server := Server{
    addr: "localhost:80"
    handler: RequestHandler{}
  }

  server.listen_and_serve()
}
```

[back to examples](#examples)

### Get list of accepted content type

This will return a list of `Mime` enum. See [khalyomede/mime](https://github.com/khalyomede/mime) for more information.

```v
module main

import khalyomede.web
import net.http { Server, Handler, Request, Response }

struct RequestHandler implements Handler {}

fn (request_handler RequestHandler) handle(base_request Request) Response {
  request := Request.from_base(request)

  accepted_content_types := request.accepted_content_types()

  for accepted_content_type in accepted_content_types {
    // ...
  }

  return web.Response.text(content: "Hello world").to_base()
}

fn main() {
  mut server := Server{
    addr: "localhost:80"
    handler: RequestHandler{}
  }

  server.listen_and_serve()
}
```

[back to examples](#examples)

### Check if the client accepts a specific content type

This method needs you to install the module `khalyomede.mime`. Learn more on the [documentation](https://github.com/khalyomede/mime).

```v
module main

import khalyomede.web
import net.http { Server, Handler, Request, Response }

struct RequestHandler implements Handler {}

fn (request_handler RequestHandler) handle(base_request Request) Response {
  request := Request.from_base(request)

  return match request.accepts(.text_html) {
    true { web.Response.html(content: "<h1>Hello world</h1>") }
    false { web.Response.text(content: "Hello world") }
  }
}

fn main() {
  mut server := Server{
    addr: "localhost:80"
    handler: RequestHandler{}
  }

  server.listen_and_serve()
}
```

[back to examples](#examples)

### Get the content type

This methods needs you to install `khalyomede.mime`. It will return a `Mime` struct. Learn more on the [documentation](https://github.com/khalyomede/mime).

```v
module main

import khalyomede.web
import net.http { Server, Handler, Request, Response }

struct RequestHandler implements Handler {}

fn (request_handler RequestHandler) handle(base_request Request) Response {
  request := Request.from_base(request)

  type = match request.content_type() {
    .text_html { "html" }
    else { "world" }
  }

  return web.Response.html(content: "<h1>Hello ${type}</h1>")
}

fn main() {
  mut server := Server{
    addr: "localhost:80"
    handler: RequestHandler{}
  }

  server.listen_and_serve()
}
```

[back to examples](#examples)

### Get a cookie by key

```v
module main

import khalyomede.web
import net.http { Server, Handler, Request, Response }

struct RequestHandler implements Handler {}

fn (request_handler RequestHandler) handle(base_request Request) Response {
  request := Request.from_base(request)

  session := request.cookie("session") or { "" }

  return web.Response.html(content: "<h1>Hello world<h1>").to_base()
}

fn main() {
  mut server := Server{
    addr: "localhost:80"
    handler: RequestHandler{}
  }

  server.listen_and_serve()
}
```

[back to examples](#examples)

### Get all cookies

```v
module main

import khalyomede.web
import net.http { Server, Handler, Request, Response }

struct RequestHandler implements Handler {}

fn (request_handler RequestHandler) handle(base_request Request) Response {
  request := Request.from_base(request)

  for key, value in request.cookies() {
    // ...
  }

  return web.Response.html(content: "<h1>Hello world<h1>").to_base()
}

fn main() {
  mut server := Server{
    addr: "localhost:80"
    handler: RequestHandler{}
  }

  server.listen_and_serve()
}
```

[back to examples](#examples)

### Get a query string by key

> [!INFO]
> Install [khalyomede/url](https://github.com/khalyomede/url) to use this method.

```v
module main

import khalyomede.web
import net.http { Server, Handler, Request, Response }

struct RequestHandler implements Handler {}

fn (request_handler RequestHandler) handle(base_request Request) Response {
  request := web.Request.from_base(base_request)

  theme := request.query("theme") or { "dark" }

  return web.Response.html(content: "<h1>Hello world</h1>").to_base()
}

fn main() {
  mut server := Server{
    addr: "localhost:80"
    handler: RequestHandler{}
  }

  server.listen_and_serve()
}
```

`Request.query()` returns a `QueryNotFound` error when the query is not found, so you can handle this specific case.

```v
module main

import khalyomede.web { QueryNotFound }
import net.http { Server, Handler, Request, Response }

struct RequestHandler implements Handler {}

fn (request_handler RequestHandler) handle(base_request Request) Response {
  request := web.Request.from_base(base_request)

  theme := match request.query("theme") or {
    match err {
      QueryNotFound { "light" }
      else { "none" }
    }
  }

  return web.Response.html(content: "<h1>Hello world</h1>").to_base()
}

fn main() {
  mut server := Server{
    addr: "localhost:80"
    handler: RequestHandler{}
  }

  server.listen_and_serve()
}
```

This package uses [khalyomede/url](https://github.com/khalyomede/url) to parse the path and access the query. You should check the errors to exhaustively match them.

```v
module main

import khalyomede.web { QueryNotFound }
import khalyomede.url { BadlyEncodedQuery }
import net.http { Server, Handler, Request, Response }

struct RequestHandler implements Handler {}

fn (request_handler RequestHandler) handle(base_request Request) Response {
  request := web.Request.from_base(base_request)

  theme := match request.query("theme") or {
    match err {
      QueryNotFound { "light" }
      BadlyEncodedQuery { "dark" }
      else { "none" }
    }
  }

  return web.Response.html(content: "<h1>Hello world</h1>").to_base()
}

fn main() {
  mut server := Server{
    addr: "localhost:80"
    handler: RequestHandler{}
  }

  server.listen_and_serve()
}
```

You can find the full list on the [parse URL method documentation of khalyomede/url](https://github.com/khalyomede/url#parse-an-url).

[back to examples](#examples)

### Get all queries

> [!INFO]
> Install [khalyomede/url](https://github.com/khalyomede/url) to use this method.

```v
module main

import khalyomede.web
import net.http { Server, Handler, Request, Response }

struct RequestHandler implements Handler {}

fn (request_handler RequestHandler) handle(base_request Request) Response {
  request := web.Request.from_base(base_request)

  for key, value in request.queries() {
    // ...
  }

  return web.Response.html(content: "<h1>Hello world</h1>").to_base()
}

fn main() {
  mut server := Server{
    addr: "localhost:80"
    handler: RequestHandler{}
  }

  server.listen_and_serve()
}
```

[back to examples](#examples)

### Get an uploaded file

Given you have an HTML form with `multipart/form-data` enctype, this package will let you get a single file matching the same `name` attribute as specified in your `<input type="file">` in your HTML.

The method `web.Request.file(name: "file")` will return a V built-in [`FileData`](https://modules.vlang.io/net.http.html#FileData).

This method will return the **first** file. If you allow multiple files, use the [`web.Request.files(name)`](#get-multiple-uploaded-files) instead.

```v
module main

import net.http { Server, Handler, Request, Response }
import os

struct RequestHandler implements Handler {}

fn (request_handler RequestHandler) handle(base_request Request) Response {
  request := web.Request.from_base(base_request)

  // GET /upload-profile-picture
  if request.path() == '/upload-profile-picture' {
    return web.Response.html(content: "
      <form method="POST" action="validate-profile-picture" enctype="multipart/form-data">
        <input type="file" name="profilePicture" />
        <button type="submit">upload</button>
      </form>
    ")
  }

  // GET /validate-upload
  file := request.file(name: "profilePicture") or {
    return web.Response.html(
      content: "<h1>Unable to download profile picture</h1>"
      status: .internal_server_error
    )
  }

  os.write_file(file.filename, file.data) or {
    return web.Response.html(
      content: "<h1>Unable to save file on the server.</h1>",
      status: .internal_server_error
    )
  }

  return web.Response.html(content: "<h1>Profile picture updated</h1>").to_base()
}

fn main() {
  mut server := Server{
    addr: "localhost:80"
    handler: RequestHandler{}
  }

  server.listen_and_serve()
}
```

[back to examples](#examples)

### Get all files for a key

If your HTML form accepts multiples files for a given `<input type="file" name="documents" multiple />`, use the `web.Request.files('documents')` method.

If you only need a single file (the first one), use the [`web.Request.file()`](#get-an-uploaded-file) method instead.

```v
module main

import net.http { Server, Handler, Request, Response }
import os

struct RequestHandler implements Handler {}

fn (request_handler RequestHandler) handle(base_request Request) Response {
  request := web.Request.from_base(base_request)

  // GET /upload-documents
  if request.path() == '/upload-documents' {
    return web.Response.html(content: "
      <form method="POST" action="validate-documents" enctype="multipart/form-data">
        <input type="file" name="documents" multiple />
        <button type="submit">upload</button>
      </form>
    ")
  }

  // GET /validate-documents
  files := request.files(name: "documents")

  if files.len == 0 {
    return web.Response.html(
      content: "<h1>No document found</h1>"
      status: .bad_request
    )
  }

  for file in files {
    os.write_file(file.filename, file.data) or {
      return web.Response.html(
        content: "<h1>Unable to save document on the server.</h1>",
        status: .internal_server_error
      )
    }
  }

  return web.Response.html(content: "<h1>Documents updated</h1>").to_base()
}

fn main() {
  mut server := Server{
    addr: "localhost:80"
    handler: RequestHandler{}
  }

  server.listen_and_serve()
}
```

[back to examples](#examples)

### Get all files

When you do not care from which `<input type="file" />` the files are coming, and you want to get every files uploaded across the whole HTML forms, use the `web.Request.all_files()` method.

```v
module main

import net.http { Server, Handler, Request, Response }
import os

struct RequestHandler implements Handler {}

fn (request_handler RequestHandler) handle(base_request Request) Response {
  request := web.Request.from_base(base_request)

  // GET /upload-documents
  if request.path() == '/upload-documents' {
    return web.Response.html(content: "
      <form method="POST" action="validate-documents" enctype="multipart/form-data">
        <input type="file" name="documents" multiple />
        <button type="submit">upload</button>
      </form>
    ")
  }

  // GET /validate-documents
  files := request.all_files()

  for file in files {
    os.write_file(file.filename, file.data) or {
      return web.Response.html(
        content: "<h1>Unable to save document on the server.</h1>",
        status: .internal_server_error
      )
    }
  }

  return web.Response.html(content: "<h1>Documents updated</h1>").to_base()
}

fn main() {
  mut server := Server{
    addr: "localhost:80"
    handler: RequestHandler{}
  }

  server.listen_and_serve()
}
```

[back to examples](#examples)

### Get a body by key

```v
module main

import net.http { Server, Handler, Request, Response }
import khalyomede.mime { Mime }

struct RequestHandler implements Handler {}

fn (request_handler RequestHandler) handle(base_request Request) Response {
  request := web.Request.from_base(base_request)

  email := request.body("email") or { "" }

  return web.Response.html(content: "<h1>Settings updated</h1>").to_base()
}

fn main() {
  mut server := Server{
    addr: "localhost:80"
    handler: RequestHandler{}
  }

  server.listen_and_serve()
}
```

[back to examples](#examples)

### Get all body

```v
module main

import net.http { Server, Handler, Request, Response }
import khalyomede.mime { Mime }

struct RequestHandler implements Handler {}

fn (request_handler RequestHandler) handle(base_request Request) Response {
  request := web.Request.from_base(base_request)

  for key, value in request.bodies() {
    // ...
  }

  return web.Response.html(content: "<h1>Settings updated</h1>").to_base()
}

fn main() {
  mut server := Server{
    addr: "localhost:80"
    handler: RequestHandler{}
  }

  server.listen_and_serve()
}
```

[back to examples](#examples)

### Get a specific header

```v
module main

import net.http { Server, Handler, Request, Response }

struct RequestHandler implements Handler {}

fn (request_handler RequestHandler) handle(base_request Request) Response {
  request := web.Request.from_base(base_request)

  client_hints := request.header("Accept-CH")

  return web.Response.html(content: "<h1>Hello world</h1>").to_base()
}

fn main() {
  mut server := Server{
    addr: "localhost:80"
    handler: RequestHandler{}
  }

  server.listen_and_serve()
}
```

[back to examples](#examples)

### Get the bearer token

```v
module main

import khalyomede.web
import net.http { Server, Handler, Request, Response }

struct RequestHandler implements Handler {}

fn (request_handler RequestHandler) handle(base_request Request) Response {
  request := web.Request.from_base(base_request)

  bearer_token := request.bearer_token() or { "" }

  return web.Response.html(content: "<h1>Hello world</h1>").to_base()
}

fn main() {
  mut server := Server{
    addr: "localhost:80"
    handler: RequestHandler{}
  }

  server.listen_and_serve()
}
```

[back to examples](#examples)

### Get basic auth username password

```v
module main

import khalyomede.web
import net.http { Server, Handler, Request, Response }

struct RequestHandler implements Handler {}

fn (request_handler RequestHandler) handle(base_request Request) Response {
  request := web.Request.from_base(base_request)

  username, password := request.basic_auth() or { "", "" }

  return web.Response.html(content: "<h1>Hello world</h1>").to_base()
}

fn main() {
  mut server := Server{
    addr: "localhost:80"
    handler: RequestHandler{}
  }

  server.listen_and_serve()
}
```

[back to examples](#examples)

### Get the user agent

```v
module main

import khalyomede.web
import net.http { Server, Handler, Request, Response }

struct RequestHandler implements Handler {}

fn (request_handler RequestHandler) handle(base_request Request) Response {
  request := web.Request.from_base(base_request)

  user_agent := request.user_agent() or { "Google Chrome v110" }

  return web.Response.html(content: "<h1>Hello world</h1>").to_base()
}

fn main() {
  mut server := Server{
    addr: "localhost:80"
    handler: RequestHandler{}
  }

  server.listen_and_serve()
}
```

[back to examples](#examples)

### Get the first support language

The lang will be a `Lang` enum. See [khalyomede/lang](https://github.com/khalyomede/lang) for more information.

```v
module main

import khalyomede.web
import net.http { Server, Handler, Request, Response }

struct RequestHandler implements Handler {}

fn (request_handler RequestHandler) handle(base_request Request) Response {
  request := web.Request.from_base(base_request)

  language := request.language() or { Lang.en }

  return web.Response.html(content: "<h1>Hello world</h1>").to_base()
}

fn main() {
  mut server := Server{
    addr: "localhost:80"
    handler: RequestHandler{}
  }

  server.listen_and_serve()
}
```

[back to examples](#examples)

### Get all supported languages

The list will be a `Lang` enum. See [khalyomede/lang](https://github.com/khalyomede/lang) for more information.

```v
module main

import khalyomede.web
import net.http { Server, Handler, Request, Response }
import khalyomede.lang { Lang }

struct RequestHandler implements Handler {}

fn (request_handler RequestHandler) handle(base_request Request) Response {
  request := web.Request.from_base(base_request)

  languages := request.languages() or { [Lang.en] }

  return web.Response.html(content: "<h1>Hello world</h1>").to_base()
}

fn main() {
  mut server := Server{
    addr: "localhost:80"
    handler: RequestHandler{}
  }

  server.listen_and_serve()
}
```

[back to examples](#examples)

### Get all headers

```v
module main

import net.http { Server, Handler, Request, Response, Status }

struct RequestHandler implements Handler {}

fn (request_handler RequestHandler) handle(base_request Request) Response {
  request := web.Request.from_base(base_request)

  for key, value in request.headers() {
    // ...
  }

  return web.Response.html(content: "<h1>Hello world</h1>").to_base()
}

fn main() {
  mut server := Server{
    addr: "localhost:80"
    handler: RequestHandler{}
  }

  server.listen_and_serve()
}
```

[back to examples](#examples)

### Return basic response

This example requires the `Mime` enum. See [khalyomede/mime](https://github.com/khalyomede/mime) for more information.

```v
module main

import net.http { Server, Handler, Request, Response, CommonHeader }
import khalyomede.mime { Mime }

struct RequestHandler implements Handler {}

fn (request_handler RequestHandler) handle(base_request Request) Response {
  return khalyomede
    .http
    .Response(
      content: "<h1>Hello world</h1>"
      headers: {
        CommonHeader.content_type.str(): Mime.text_html.str()
      }
    )
    .to_base()
}

fn main() {
  mut server := Server{
    addr: "localhost:80"
    handler: RequestHandler{}
  }

  server.listen_and_serve()
}
```

[back to examples](#examples)

### Return HTML response

```v
module main

import khalyomede.web
import net.http { Server, Handler, Request, Response }

struct RequestHandler implements Handler {}

fn (request_handler RequestHandler) handle(base_request Request) Response {
  return web.Response.html(content: "<h1>Hello world</h1>").to_base()
}

fn main() {
  mut server := Server{
    addr: "localhost:80"
    handler: RequestHandler{}
  }

  server.listen_and_serve()
}
```

[back to examples](#examples)

### Return JSON response

```v
module main

import json
import net.http { Server, Handler, Request, Response }

struct JsonResponse {
  message string
}

struct RequestHandler implements Handler {}

fn (request_handler RequestHandler) handle(base_request Request) Response {
  json_response := json.encode(JsonResponse{
    message: "hello world"
  })

  return web.Response.json(content: json_response).to_base()
}

fn main() {
  mut server := Server{
    addr: "localhost:80"
    handler: RequestHandler{}
  }

  server.listen_and_serve()
}
```

[back to examples](#examples)
