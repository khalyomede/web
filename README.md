# Web

Net HTTP Request/Response utilities.

```v
module main

import khalyomede.web
import net.http { Server, Handler, Request, Response }

struct RequestHandler implements Handler {}

fn (request_handler RequestHandler) handle(request Request) Response {
  request := web.Request.from_base(request)

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
v install khalyomede.http
```

### Manual installation

## Examples

- Request
    - [Get the client IP](#get-the-client-ip)
    - [Get list of accepted content type](#get-list-of-accepted-content-type)
    - [Get the path](#get-the-path)
    - Cookies
      - [Get a cookie by key](#get-a-cookie-by-key)
      - [Get all cookies](#get-all-cookies)
    - Query
        - [Get a query string by key](#get-a-query-string-by-key)
        - [Get all queries](#get-all-queries)
    - Body
        - [Get an uploade file](#get-an-uploaded-file)
        - [Get all files](#get-all-files)
        - [Get a body by key](#get-a-body-by-key)
        - [Get all body](#get-all-body)
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

fn (request_handler RequestHandler) handle(request Request) Response {
  request := web.Request.from_base(request)

  ip := request.ip()

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

### Get the path

```v
module main

import khalyomede.web
import net.http { Server, Handler, Request, Response }

struct RequestHandler implements Handler {}

fn (request_handler RequestHandler) handle(request Request) Response {
  request := web.Request.from_base(request)

  url := request.url // "/contact?theme=dark#whatsapp"
  path := request.path() // "contact"

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

fn (request_handler RequestHandler) handle(request Request) Response {
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

### Get a cookie by key

```v
module main

import khalyomede.web
import net.http { Server, Handler, Request, Response }

struct RequestHandler implements Handler {}

fn (request_handler RequestHandler) handle(request Request) Response {
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

fn (request_handler RequestHandler) handle(request Request) Response {
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

```v
module main

import khalyomede.web
import net.http { Server, Handler, Request, Response }

struct RequestHandler implements Handler {}

fn (request_handler RequestHandler) handle(request Request) Response {
  request := web.Request.from_base(request)

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

[back to examples](#examples)

### Get all queries

```v
module main

import khalyomede.web
import net.http { Server, Handler, Request, Response }

struct RequestHandler implements Handler {}

fn (request_handler RequestHandler) handle(request Request) Response {
  request := web.Request.from_base(request)

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

### Get an uploade file

```v
module main

import net.http { Server, Handler, Request, Response }
import os

struct RequestHandler implements Handler {}

fn (request_handler RequestHandler) handle(request Request) Response {
  request := web.Request.from_base(request)

  file := request.file()

  os.write_file(file.name, file.content) or {
    return web.Response.html(content: "<h1>Error</h1>", status: .internal_server_error)
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

### Get all files

```v
module main

import net.http { Server, Handler, Request, Response }

struct RequestHandler implements Handler {}

fn (request_handler RequestHandler) handle(request Request) Response {
  request := web.Request.from_base(request)

  for file in request.files() {
    // ...
  }

  return web.Response.html(content: "<h1>Pictures saved</h1>").to_base()
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

fn (request_handler RequestHandler) handle(request Request) Response {
  request := web.Request.from_base(request)

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

fn (request_handler RequestHandler) handle(request Request) Response {
  request := web.Request.from_base(request)

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

fn (request_handler RequestHandler) handle(request Request) Response {
  request := web.Request.from_base(request)

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

fn (request_handler RequestHandler) handle(request Request) Response {
  request := web.Request.from_base(request)

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

fn (request_handler RequestHandler) handle(request Request) Response {
  request := web.Request.from_base(request)

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

fn (request_handler RequestHandler) handle(request Request) Response {
  request := web.Request.from_base(request)

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

fn (request_handler RequestHandler) handle(request Request) Response {
  request := web.Request.from_base(request)

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

fn (request_handler RequestHandler) handle(request Request) Response {
  request := web.Request.from_base(request)

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

fn (request_handler RequestHandler) handle(request Request) Response {
  request := web.Request.from_base(request)

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

fn (request_handler RequestHandler) handle(request Request) Response {
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

fn (request_handler RequestHandler) handle(request Request) Response {
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

fn (request_handler RequestHandler) handle(request Request) Response {
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
