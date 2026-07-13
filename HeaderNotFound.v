module web

pub struct HeaderNotFound {
    Error
    header string
}

pub fn (error HeaderNotFound) msg() string {
    return 'Header "${error.header}" not found.'
}
