# SF Ruby Cards 🎨☁️

AI-powered cloud character invitations for San Francisco Ruby Conference attendees. Upload a photo, get transformed into a whimsical cloud character over SF's skyline!

## Requirements

- Ruby 3.4+
- **Google Gemini API key**: Get one at https://ai.google.dev/

## Running locally

Install dependencies:

```sh
bin/setup
```

Run a web server along with the Vite dev server:

```sh
bin/dev
```

Go to [localhost:3000](http://localhost:3000) and check it out!

## Running tests

We use RSpec to write tests. You can run them with:

```sh
bundle exec rspec
```

Note that system tests are excluded by default. You can run them as follows:

```sh
bundle exec rspec spec/system
# or
bundle exec rspec --tag type:system
```

## Admin console

You can access our [Avo](https://avohq.io) admin console at: [localhost:3000/admin](http://localhost:3000/admin).

The default admin username and password are `admin` and `pass`. You can update them in the credentials (`app.admin_username` and `app.admin_password` respectively).

## Lookbook

We use [Lookbook](https://lookbook.build) to work with UI (development, previews). All the code related to previews is stored under the `lookbook/` fodler. The lookbook itself is available at: [localhost:3000/dev/lookbook](http://localhost:3000/dev/lookbook).

## Working with emails

We use [letter_opener_web](https://github.com/fgrehm/letter_opener_web) to delivery and view emails in development. You can access the inbox at [localhost:3000/dev/letters](http://localhost:3000/dev/letters).
