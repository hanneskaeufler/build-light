[![Build Status](https://travis-ci.org/hanneskaeufler/build-light.svg?branch=master)](https://travis-ci.org/hanneskaeufler/build-light)
[![Code Climate](https://codeclimate.com/github/hanneskaeufler/build-light/badges/gpa.svg)](https://codeclimate.com/github/hanneskaeufler/build-light)
[![Test Coverage](https://codeclimate.com/github/hanneskaeufler/build-light/badges/coverage.svg)](https://codeclimate.com/github/hanneskaeufler/build-light)

# Build-Light

This projects integrates a LIFX bulb with a post-run hook of Gitlab CI.

## Installation

```
bundle install
```

## Running

This is a Sinatra app, so run

```
ruby build_light.rb
```

and it will listen on port 4567 on localhost. Now set a post-run hook in Gitlab CE to point to
`http://localhost:4567/signal`.
