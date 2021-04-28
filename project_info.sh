#!/usr/bin/env bash
set -e

# Is this repo a ruby project?
is_ruby() {
  [ -f Gemfile ]
}

# Is this repo a rails project?  Test for brakeman config file, since currently
# that's the only CC plugin we turn on for rails.
is_rails() {
  [ -f ./config/brakeman.yml ]
}
