module test

import khalyomede.faker { Faker }
import khalyomede.expect { expect }
import net.http { Request, Header, new_header }
import web

fn test_it_can_get_user_agent_from_header() {
    mut fake := Faker{}
    user_agent := fake.user_agent()

    request := web.Request{
        base_request: Request{
            header: new_header(key: .user_agent, value: user_agent)
        }
    }

    expect(request.user_agent() or { "" }).to_be_equal_to(user_agent)
}

fn test_it_get_no_user_agent_when_not_present_in_header() {
    request := web.Request{
        base_request: Request{
            header: Header{}
        }
    }

    expect(request.user_agent() or { "" }).to_be_equal_to("")
}
