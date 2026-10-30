# Glossary

**Artifact** — a file a CI job leaves
behind: a built program, a report, a
bundle for a later job or for download.

**Community Edition (CE)** — the free,
open-source edition of GitLab. The paid
Enterprise tiers unlock extra features in
the same program.

**external_url** — the address the
instance is known by, set in `gitlab.rb`.
Every link GitLab generates is built from
it.

**Executor** — a runner's way of running
jobs: directly in a shell on its machine,
or inside a fresh Docker container per
job, among others.

**Forge** — a website built around Git
that adds issues, review and automation
to bare repositories. GitHub and GitLab
are forges.

**Gitaly** — the GitLab service that owns
repository storage. Every clone, push and
file listing passes through it.

**gitlab.rb** — the one configuration
file for an omnibus install, in
`/etc/gitlab`. Edit it, then reconfigure.

**gitlab-ctl** — the administrator's
command for the whole instance:
`reconfigure`, `status`, `start`, `stop`,
and friends.

**gitlab-secrets.json** — the generated
file in `/etc/gitlab` holding the keys
that encrypt values in the database.
Back it up with the configuration, or a
restore cannot read itself.

**Group** — a shared namespace with
members and a role ladder, holding
projects and subgroups.

**Issue** — a project's numbered unit of
work: a title, a description, a state,
and the conversation under it. Referred
to as `#1`, `#2`, ...

**Job** — one named block of commands in
a pipeline. A job's exit code is its
verdict.

**Merge request (MR)** — a proposed
change from one branch to another, with
its diff, discussion, approvals and
pipeline results; ends in a merge.
Referred to as `!1`, `!2`, ... Other
forges call this a pull request.

**Namespace** — the name-space that owns
a project: a user's, or a group's.

**Omnibus package** — GitLab's installer:
one package carrying the application and
its own Ruby, PostgreSQL, Redis, NGINX
and Git, all supervised by runit.

**Personal access token** — a generated
string that introduces a person (or a
script acting for one) to the API and to
Git over HTTP. Scoped, expiring, and a
password in every sense that matters.

**Pipeline** — one full run of a
project's `.gitlab-ci.yml`: its stages,
jobs, logs and final verdict.

**Project** — GitLab's unit of work: one
repository plus its issues, merge
requests, pipelines and settings.

**Protected branch** — a branch with
rules: typically, no direct pushes, so
changes arrive only by merge request.

**Puma** — the web server that runs the
Rails application; the part of GitLab
that draws most pages, and the part that
takes a minute to warm up.

**Reconfigure** — `gitlab-ctl
reconfigure`: the command that converges
a machine to its `gitlab.rb`, safe to run
again after every fix or edit.

**Role** — a member's rung on the
permission ladder: Guest, Reporter,
Developer, Maintainer, Owner.

**Runner** — the separate program that
polls an instance for pipeline jobs, runs
them, and reports logs and verdicts.
Created in the admin area or API, then
registered with its own token.

**runit** — the supervisor inside the
omnibus package that starts, watches and
restarts the services — why GitLab does
not need systemd.

**Sidekiq** — the background worker:
mail, webhooks, caches and long jobs,
queued through Redis.

**Stage** — a named phase of a pipeline
(`check`, `test`, `deploy`). Jobs in a
stage run in parallel; stages run in
order.

**Visibility** — a project's openness:
private (members only), internal (any
signed-in user), or public.

**Workhorse** — the service that carries
heavy traffic — uploads, downloads, Git
pushes — so the application does not have
to.
