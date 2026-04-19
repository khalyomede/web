module web

pub fn (error QueryNotFound) msg() string {
    return 'Key "${error.key}" not found in query string.'
}
