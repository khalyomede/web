module test

import khalyomede.expect { expect }
import khalyomede.lang { Lang }
import net.http { Request, Header, new_header }
import web

fn test_it_returns_language_when_its_the_only_one_in_header() {
    request := web.Request{
        base_request: Request{
            header: new_header(key: .accept_language, value: "en")
        }
    }

    expect(request.language() or { Lang.fr }).to_be_equal_to(Lang.en)
}

fn test_it_returns_the_first_language_in_header() {
    request := web.Request{
        base_request: Request{
            header: new_header(key: .accept_language, value: "en-US;q=0.9,en;q=0.8,fr;q=0.7,fr-FR")
        }
    }

    expect(request.language() or { Lang.en }).to_be_equal_to(Lang.fr)
}

fn test_it_returns_language_when_no_lang_found_in_header() {
    request := web.Request{
        base_request: Request{
            header: new_header(key: .accept_language, value: "q=0.8")
        }
    }

    expect(request.language() or { Lang.es }).to_be_equal_to(Lang.es)
}

fn test_it_returns_no_language_when_no_header_present() {
    request := web.Request{
        base_request: Request{
            header: Header{}
        }
    }

    expect(request.language() or { Lang.ru }).to_be_equal_to(Lang.ru)
}
