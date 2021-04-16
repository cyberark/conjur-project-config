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
   `update-settings` can be run manually too, if needed.
2. `update-workflow` -- This must be run manually -- once when enrolling, and
   then again if we update workflow files in this repository.  Unfortunately,
   for security reasons, we can't update `.github/workflow` files with
   automatic PRs.

Enrollment also creates a file `.make_codeclimate`, which it uses to generate
your project's custom `.codeclimate.yml`. You'll edit this rather than
editing `.codeclimate.yml` directly. This lets `conjur-project-config`
automatically manage and keep current the base portion of `.codeclimate.yml`
shared among all projects. See "How To Enroll" below for more.

## How to Enroll

### Step 1: Add git submodule

After creating a new branch, embed this repository into your project's
repository as a git submodule:

```bash
git submodule add -b main 'https://github.com/cyberark/conjur-project-config.git'
```

### Step 2: Run `update-settings`

Update the settings by running the following command from the root of
the enrolling repository:

```bash
# Note: Run from root of enrolling repository
./conjur-project-config/update-settings
```

You can run `git status` to see what changes the script made.

### Step 3: Configure `.make_codeclimate` and re-run `update_settings`

`.make_codeclimate` (created by the previous step) lets you customize
`.codeclimate.yml` for your repository.

To enable support in `.make_codeclimate` for ruby or rails projects,
uncomment the relevant lines. `.make_codeclimate` is just bash, and can
output arbitrary yaml if your project needs to enable other CodeClimate
plugins. You can also open a pull request on this project to add new
templates for other languages.

**Once enrolled in `conjur-project-config`, you should never edit
`.codeclimate.yml` directly anymore. Instead, edit `.make_codeclimate`.**

**Any time you edit `.make_codeclimate`, you'll need to re-run `update-settings`
to regenerate `.codeclimate.yml` based on your changes.**

### Step 4: Copy `.github/workflow` files

To add the `.github/workflow` files that will automatically create pull
requests in your project when `conjur-project-config` settings change in the
future:

```bash
# Note: Run from root of enrolling repository
./conjur-project-config/update-workflow
```

### Step 5: Commit your changes and open a pull request

Run:

```bash
SKIP_GITLEAKS=YES git add . && git commit -m "Enroll in shared settings"
```

*Note: The `SKIP_GITLEAKS=YES` is needed because gitleaks doesn't play well
with submodules.*

Finally, push your branch to Github and open a new pull request. Once it's
merged into `main`, your project will be enrolled in automatic settings
updates: Whenever `conjur-project-config` settings change, a pull request
will automatically open.

CodeClimate may identify a number of new issues, and depending on how it is
configured in this repository's settings, may block the PR from being merged
because of these new issues. It may require a GitHub admin (an engineering
manager or Infra team member) to merge the PR and override the check. Once the
PR is merged, CodeClimate will still track the issues but only block PRs on new
issues in changes.

*Note: Changes to `.github/workflow` files will not trigger automatic pull
requests. A feature to do so will be added soon.*

## How to update

### Settings changes

When `conjur-project-config` changes, a pull request with those changes
will automatically open in every enrolled project (usually within 10
minutes). Often you can simply merge that pull request.

However, if the pull request does not open for some reason, you can always
run `./conjur-project-config/update-settings` manually and open your own 
pull request.

### Workflow changes

Github actions cannot automatically open pull requests for changes to files
under `.github/workflow` (more precisely, we cannot give our repositories the
permissions to do so without breaking our security requirements).

So, when workflow files change, you will need to run
`./conjur-project-config/update-workflow` manually, and open a pull request
to merge those changes.

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
