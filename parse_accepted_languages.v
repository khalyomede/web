module web

import khalyomede.lang { Lang }
import strconv { atof64 }

/**
    @todo make a package?
**/
fn parse_accepted_languages(header string) []AcceptedLanguage {
	mut accepted := []AcceptedLanguage{}

	// e.g. "en-US,en;q=0.9,fr-FR;q=0.8,fr;q=0.7" -> ["en-US", "en;q=0.9", "fr-FR;q=0.8", "fr;q=0.7"]
	for raw_part in header.split(',') {
		part := raw_part.trim_space()

		if part == '' {
			continue
		}

		// e.g. "fr-FR;q=0.8" -> ["fr-FR", "q=0.8"]
		sub_parts := part.split(';')
		language_part := sub_parts[0].trim_space() // e.g. "fr-FR", "en", "*"

		mut priority := f64(1.0)

		for sub_part in sub_parts[1..] {
			trimmed_sub_part := sub_part.trim_space()

			if !trimmed_sub_part.starts_with('q') {
				continue
			}

			// e.g. "q=0.8" -> ["q", "0.8"]
			priority_parts := trimmed_sub_part.split('=')

			if priority_parts.len != 2 {
				continue
			}

			priority_value := atof64(priority_parts[1].trim_space()) or { continue }

			if priority_value < 0.0 || priority_value > 1.0 {
				continue
			}
			priority = priority_value
		}

		// e.g. "fr-FR" -> ["fr", "FR"], "en" -> ["en"], "zh-Hant-TW" -> ["zh", "Hant", "TW"]
		language_parts := language_part.split('-')

		if language_parts.len == 0 || language_parts[0] == '' {
			continue
		}

		language_code := language_parts[0].to_lower()
		parsed_lang := Lang.from_iso_2(language_code) or { continue }

		mut region := ?string(none)

		if language_parts.len >= 2 && language_parts[1] != '' {
			region = language_parts[1].to_upper()
		}

		accepted << AcceptedLanguage{
			region: region
			lang: parsed_lang
			priority: priority
		}
	}

	accepted.sort(a.priority > b.priority)

	return accepted
}
