# GitLab for Mere Mortals

Most code lives on a website somebody else
runs: you push your **Git** repositories to
GitHub or GitLab.com, and the issues, the
review conversations and the test runs live
there too, on their machines, under their
rules. **GitLab** is that whole place —
repositories, issues, merge requests,
pipelines — as a program you can install on
a machine of your own. Same kind of front
door, your own building.

This guide explains what GitLab is, what
arrives inside its (very large) installer,
how to install it and sign in, and how to
do the four things it exists for: host a
project, push code to it, work through an
issue and a merge request, and let a
pipeline test the result. Then it covers
the part the brochures skip: what it costs
you, every day, in memory, disk and
attention, to be your own GitHub.

The lab that wrote this guide ran the real
thing: **GitLab Community Edition 19.5.3**,
the official omnibus package for Ubuntu
24.04, downloaded from GitLab's own
repository and checked against its
published checksum. The package was
unpacked, configured with a small
deliberate configuration file, and brought
up by hand on a small shared machine with
no systemd — where it ran, all eight
services, answered its web pages, accepted
a real sign-in as the administrator, and
stored real work: a project created
through the API, commits pushed over HTTP,
an issue opened, a merge request merged
(closing the issue by itself), a CI runner
registered and a pipeline run green, and a
full backup taken of the running instance.

What the lab could not do, it did not
fake. The sandbox runs no SSH server, so
Git over SSH is taught from the
documentation. Nobody clicked through the
web interface beyond the sign-in and
first-run pages — the lab drove the same
objects through the API and says so. The
backup was taken but not restored: a
restore needs a second stopped instance of
the same version, and the lab had neither
the memory nor a reason to pretend
otherwise. Email, the container registry,
GitLab Pages and the rest of the optional
furniture were left off and are labelled
wherever they appear. `criteria.md` keeps
the full ledger of what was run and what
was only read.

## What this guide covers

- [**What GitLab is**](what-gitlab-is.md) —
  the forge in one program: repositories,
  issues, reviews and pipelines under one
  roof, and what changes when the roof is
  yours
- [**The moving parts**](the-moving-parts.md) —
  the eight services inside the package,
  what each one holds, and the three
  directories that matter
- [**Installing GitLab**](installing-gitlab.md) —
  the omnibus package, the checksum habit,
  the one configuration file, and the
  reconfigure command that builds the
  instance from it
- [**First sign-in and the admin
  account**](first-sign-in.md) — the root
  account, its first password in a file,
  and minting an API token
- [**Your first project**](your-first-project.md) —
  creating a project, cloning it, and
  pushing your first commits home
- [**Issues and merge
  requests**](issues-and-merge-requests.md) —
  the review loop: an issue, a branch, a
  merge request, and a merge that closes
  the issue itself
- [**CI/CD and runners**](ci-cd-and-runners.md) —
  pipelines defined in a file in the repo,
  and the separate runner program that
  does the work
- [**Users, groups and
  permissions**](users-groups-and-permissions.md) —
  who can see what, the roles, and the
  thing a private project is *not* private
  from
- [**Backups and upgrades**](backups-and-upgrades.md) —
  the backup command, the two files it
  leaves behind, and why upgrades walk a
  set path instead of jumping
- [**Recipes**](recipes.md) — applying a
  configuration change, stopping one
  service, asking the instance its own
  version, and other small jobs done once,
  properly
- [**The neighbours**](the-neighbours.md) —
  GitHub and GitLab.com the rented
  versions, Gitea and Forgejo the light
  ones, and plain Git with SSH the
  zero-software option
- [**Limits**](limits.md) — the memory
  floor, the administrator who can see
  everything, version-locked backups, and
  the features that are switched off until
  you switch them on
- [**Troubleshooting**](troubleshooting.md) —
  permission denied on a program you can
  run yourself, the 502 that means "still
  warming up", and the lab's other real
  failures, each with its fix
- [**Glossary**](glossary.md) — the terms,
  collected in one place

## What it doesn't cover

Running GitLab for a company: high
availability, clusters of Gitaly servers,
and hundreds of users are a different
book, and this one runs a single machine
for a small team or one person. The paid
tiers (Premium and Ultimate) add features
this guide points at but does not teach —
the lab ran the free Community Edition.
Kubernetes integration, the container
registry and GitLab Pages are present in
the package but switched off here.
Training courses and certification are
somebody else's business entirely.

## How to use this guide

Read chapter 1 for the model and chapter 2
before installing anything — knowing which
service holds what turns later confusion
into a named problem. Chapters 3 and 4 get
you an instance and an administrator;
chapter 5 has code living in it in the same
sitting. Chapter 6 is the daily loop and
chapter 7 the automation; read chapter 9
before your instance holds anything you
would miss, because the backup habit is
easier started than rescued. The lab's
transcripts live in `gitlab-lab/transcripts/`;
its configuration file is
`gitlab-lab/gitlab.rb.example` and its
token script is `gitlab-lab/make-token.rb`.

---

## Part of the series

This guide is one of the [For Mere Mortals](https://paulsullivan33-dev.github.io/mere-mortals/) guides: plain-language guides to the tools programmers and makers use.

Related guides:

- [Git for Mere Mortals](https://paulsullivan33-dev.github.io/git-for-mere-mortals/)
- [GitHub Actions for Mere Mortals](https://paulsullivan33-dev.github.io/github-actions-for-mere-mortals/)

## License

The writing in this guide is licensed under [CC BY 4.0](https://github.com/paulsullivan33-dev/gitlab-for-mere-mortals/blob/main/LICENSE). Code examples and lab scripts are licensed under the [MIT License](https://github.com/paulsullivan33-dev/gitlab-for-mere-mortals/blob/main/LICENSE-CODE).
