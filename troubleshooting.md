# Troubleshooting

**Outcome: the failures this lab actually
met, each with the evidence that named it
and the fix that closed it — plus the
general method for the ones you will meet
instead.**

The method, before the cases: GitLab is
eight services, so *a* failure is always a
*specific service's* failure. Name it first
(`sudo gitlab-ctl status`), read its diary
second (`/var/log/gitlab/<service>/current`),
and only then fix. Every case below was
found that way.

## "Permission denied" on a program you can run yourself

The lab's first reconfigure ran for minutes
— users created, directories made, services
starting — and then died here:

```text
FATAL: Errno::EACCES: execute[/opt/gitlab/embedded/bin/initdb -D /var/opt/gitlab/postgresql/data -E UTF8] (postgresql::enable line 59) had an error: Errno::EACCES: Permission denied - /opt/gitlab/embedded/bin/initdb
```

And Gitaly's diary, same minute, same
disease:

```text
chpst: fatal: unable to run: /opt/gitlab/embedded/bin/gitaly-wrapper: access denied
```

Root could run both programs fine. The
catch is chapter 2's staff list: the
services run as `gitlab-psql`, `git` and
friends, and **a user needs permission on
every directory along the path**, not just
on the file. The lab's tree sat beneath
folders those users could not enter.
`namei -l <path>` shows the whole chain,
door by door, and found the shut ones. On a
normal installation this cannot happen —
the package installs to `/opt/gitlab` on
open directories — but it awaits anyone who
moves the tree, mounts data oddly, or
restores onto a filesystem with strong
opinions. Fix the permissions for the
*service user*, then re-run reconfigure:
it picks up where it stopped.

## The console that cannot load your file

```text
cannot load such file -- /home/hatch/workspace/gitlab-labwork/make-token.rb (LoadError)
```

`gitlab-rails runner` drops to the `git`
user before loading anything, so a script
only root can read does not exist, as far
as it is concerned. Same disease as above,
different door. Two smaller traps ride
along: the runner changes its working
directory to the application's, so **give
script paths absolutely**, and a script
that needs to *write* somewhere needs a
somewhere the `git` user can write — print
the valuable output and let root's shell
save it, as chapter 4's script does.

## A 502 at the front door, right after starting

```text
$ curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8929/users/sign_in
502
```

Wait. Puma — the application — takes a
minute or two to boot on a modest machine,
and nginx answers 502 ("the back end is not
ready") until its first worker is up. The
lab's second request, seconds later, was
200. If it is still 502 after five minutes,
*then* it is a problem: `gitlab-ctl status`
to see whether puma says `run:`, and
`/var/log/gitlab/puma/current` for what it
said while failing. A freshly *failed*
reconfigure is the usual author.

## The download that is not the download

A 1.2 GB package that arrives as 14 bytes
of `404: Not Found` is this lab's own first
scar (transcript `t01`). URLs get
redirected, endpoints move, mirrors lag.
The defences are mechanical and they are
chapter 3's: know the expected size, check
the SHA-256 against the repository's own
index, and never run an installer whose
numbers do not match — the failure is
cheaper at `sha256sum` than at chapter 13.

## The sign-in that lands on a setup page

A fresh instance redirects its first
administrator to a *Create your first
project* page instead of a dashboard. It
looks like a wrong turn and is in fact the
front steps (transcript `t06`). The real
sign-in faults look different: the form
again (wrong password — check the file from
chapter 4 before it is deleted), or a 422
(clear the browser's cookies for the
address and retry; a stale session cookie
from an earlier experiment is the usual
suspect).

## A pipeline that never starts

Pending forever is the runner's absence
speaking: no runner, or no runner whose
tags the job accepts, or a runner paused in
the admin area. Check the project's
pipeline page — it says which — and the
runner's own state with `gitlab-runner
list` and `gitlab-runner verify` on the
runner machine. A pipeline that does not
exist at all after a push is usually a YAML
error in `.gitlab-ci.yml` — the project's
CI/CD pages keep a **CI Lint** tool that
checks the file without a push, and the
pipeline list shows a *failed* entry
labelled with the syntax complaint when it
got that far.

## Full disk, in the usual order

An instance that degrades slowly is
usually eating its own disk: repositories,
the database, backups, and CI artifacts, in
roughly that order. Chapter 10's recipe
ranks the tenants; the remedies are
retention settings for backups and
artifacts, and a bigger disk bought
deliberately rather than at 3 a.m.

## When all else fails

`sudo gitlab-ctl reconfigure` is the
package's own reset button — idempotent,
patient, and the first thing GitLab's
support would ask about. `sudo gitlab-ctl
restart` re-reads less but resets
everything running. And the logs under
`/var/log/gitlab/` are complete: the
instance writes down why it did everything
it did, which is more than can be said for
most software this size.
