# jirareports
Swift Playground to generate Sprint reports

# Setup

In order to use this Playground with your account you need to have a JIRA authentification token in your keychain that can be accessed with the key `jira_auth`.
You can also just [modify the playground](https://github.com/alexito4/jirareports/blob/master/MyPlayground.playground/Contents.swift#L11) to hardcode the token.

You probably have to change also the [Story Points field](https://github.com/alexito4/jirareports/blob/master/MyPlayground.playground/Contents.swift#L10), I'm not sure how JIRA generates that id.

The workflow that the Playground uses is based in [Sprints](https://github.com/alexito4/jirareports/blob/master/MyPlayground.playground/Contents.swift#L20) and it separates the results for different teams based in [Components](https://github.com/alexito4/jirareports/blob/master/MyPlayground.playground/Contents.swift#L16).

The reports are based in the status of the tickets for a team in a Sprint, giving the total of story points for tickets in different states:

- Commitment: The total of story points that the team commited to finish in the sprint.
- Resolved: Story points for tickets that are merged.
- Completed: Story points for tickets that have been deployed, tested and accepted.

# TODO

- [ ] Perform a single API request that returns all required data and perform the filtering locally
