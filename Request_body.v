module web

pub fn (request Request) body(parameters BodyParameters) ?string {
    return request.all_body()[parameters.key] or { none }
}
