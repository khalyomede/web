module web

import khalyomede.lang { Lang }
import net.http { CommonHeader }

pub fn (request Request) language() ?Lang {
	header := request.header(key: CommonHeader.accept_language)?
	accepted_languages := parse_accepted_languages(header)

	if accepted_languages.len == 0 {
		return none
	}

	return accepted_languages[0].lang
}
