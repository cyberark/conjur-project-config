# Conjur Project Config

## Note: Intended For Internal Cyberark Use.

This project is intended for synchronizing common settings among different
Cyberark repositories, and is public so that public git repositories that 
need these settings won't need special permissions.  

However, contributing is limited to Cyberark developers.

## Goal

To ensure:

1. Consistent code standards 
2. Consistent developer experience

across all our repositories.

## What

This project houses configuration shared across other repositories.  Currently,
this includes:

1. Rubocop configuration
2. Code Climate configuration
3. "Enforce Rebase" Github action
4. "Update Settings" Github action

## How does it work?

The enrolling repository uses two scripts to stay synced with this repository:

1. `update-settings` -- Once enrolled, this runs automatically, about every 5
   minutes, on Github's servers.  If the settings in this repository have
   changed, a pull request will open in the enrolled repository with the
   changes.  The PR will continually update with any future changes until it is
   merged (so you don't need to worry about multiple PRs being opened).
   `update-settings` script can be run manually too, if needed.
2. `update-workflow` -- This must be run manually -- once when enrolling, and
   then again if we update workflow files in this repository.  Unfortunately,
   for security reasons, we can't update `.github/workflow` files with
   automatic PRs.

## How to Enroll

First embed this repository into your "enrolling" repository as a git submodule:

```bash
git submodule add -b main 'git@github.com:cyberark/conjur-project-config.git'
```

Next update the settings by running this command from the root of the enrolling
repository:

```bash
# Note: Run from root of enrolling repository
./conjur-project-config/update-settings
```

Add a commit with a subject like `Import settings for conjur-project-config`.

Finally, add or update the `.github/workflow` files:

```bash
# Note: Run from root of enrolling repository
./conjur-project-config/update-workflow
```

Add a commit with a subject like `Enroll in automatic settings updates`.

## Contributing

This project is intended for Conjur maintainers only. It is not open to
community contributions at this time.

### Public Discussion

Since changes to common settings affect all Conjur maintainers, we want
to make them by consensus.  Disputes, if they arise, can be settled by voting.

Please create an issue or PR that explains the changes you'd like to create.
The `@cyberark/developers` group will be tagged by default if you open a PR;
if you create an issue for discussion, you should tag this group manually.

Maintainers can emoji-react to share their feedback on the proposed change,
and a discussion can take place in the comments.

## License

Copyright (c) 2020 CyberArk Software Ltd. All rights reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

For the full license text see [`LICENSE`](LICENSE).
