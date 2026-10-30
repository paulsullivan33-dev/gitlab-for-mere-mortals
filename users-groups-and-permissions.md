# Users, Groups and Permissions

**Outcome: you can say who can see what on
your instance, arrange people into groups
with the right roles, and state the one
limit no setting changes.** Check: the two
answers in transcript
`gitlab-lab/transcripts/t12-anonymous-access.txt`
— ask your own instance for a private
project with no token, and get a 404.

## The shape of belonging

Three ideas organise everything:

- A **user** is a person (or a bot) with an
  account. Users own tokens, hold SSH keys,
  and sign in.
- A **namespace** is a name-space that owns
  projects — your personal one is your
  username, which is why the lab's project
  is `root/field-notes`.
- A **group** is a shared namespace: a
  named container with members, holding
  projects and subgroups. Groups are how a
  team, a family or a club keeps its work
  in one place with one membership list —
  grant the group once, and every project in
  it follows.

Membership is given at a level — a project,
or a group whose projects inherit it — and
always with a **role**.

## Roles: five rungs

From least to most power, the standard
roles are:

- **Guest** — can see and comment on what
  they are a member of; cannot see the
  code in a private project.
- **Reporter** — can see the code, clone
  it, and work with issues; cannot push.
- **Developer** — the working role: push to
  unprotected branches, open and merge
  merge requests, run pipelines.
- **Maintainer** — runs the project or
  group: settings, members, protected
  branches; everything except ownership
  itself.
- **Owner** — everything, including
  deleting the project or group and
  transferring it away.

The exact edges move a little between
GitLab versions (newer ones add rungs such
as Planner), and the paid tiers add custom
roles; the shape does not change. Give the
lowest role that does the job — the same
advice as chapter 4's token scopes, because
it is the same advice.

## Visibility, proved

Chapter 5 set the lab's project private.
What *private* buys is measurable, and the
lab measured it — two requests from the
network with no token at all:

```text
$ curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8929/api/v4/user
401

$ curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8929/api/v4/projects/1
404
```

401 on identity: without a credential the
API will not even say who nobody is. And
404 — **not** 403 — on the private project:
GitLab answers as though the project did
not exist, so an outsider cannot learn that
it is there at all. Internal projects sit
between: invisible to the world, visible to
anyone signed in. Public is public — on a
public instance, treat it as publishing.

## The limit no setting changes

Chapter 1 drew this line and here it is
again, where it belongs: **permissions rule
users; they do not rule the instance.**
Anyone with the server itself — its
database, its disk, its backups — stands
outside the role ladder entirely. On a
hosted service that person is a stranger at
a company. On your instance it is you,
which is the comfort of self-hosting and
also its duty: people who keep private work
on your GitLab are trusting the operator,
not the software. Run the instance like it:
patch it (chapter 9), keep its backups
guarded, and do not go reading other
people's private projects just because the
building lets you. A tool that makes this
easy to forget is a reason to be more
deliberate, not less.

The administrator's other honest power is
the admin area itself: every user, project
and setting on the instance, the sign-up
rules from chapter 4, and the ability to
become any user for support — a feature to
use rarely and mention when you do.
