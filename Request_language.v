module web

import khalyomede.lang { Lang }

pub fn (request Request) language() ?Lang {
	return request.languages()[0] or { none }
}
