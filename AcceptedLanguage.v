module web

import khalyomede.lang { Lang }

struct AcceptedLanguage {
	region   ?string
	lang     Lang
	priority f64
}
