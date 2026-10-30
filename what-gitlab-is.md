# What GitLab Is

**Outcome: you can say what GitLab is, what
the one box gives you, and what it asks in
return — before any installing starts.**

A Git repository on its own is a folder with
a memory. It is excellent at remembering code
and silent about everything around the code:
who is fixing what, whether a change was
reviewed, whether the tests passed, and who
is allowed to push at all. The websites built
around Git — GitHub is the famous one — added
that surrounding layer: a web page per
project, issues to argue in, a review ritual
for changes, and machines that test every
proposal. A site like that is called a
**forge**, after the workshops where things
get made.

**GitLab is a forge you can install.** It is
one application that holds:

- **Repositories** — your projects' Git data,
  browsable on the web, clonable over HTTPS
  or SSH.
- **Issues** — the to-do list and argument
  record attached to each project.
- **Merge requests** — GitLab's name for the
  review ritual: a proposed change, shown as
  a diff, discussed, approved, merged.
- **CI/CD pipelines** — tests and deployments
  that run automatically when code moves,
  defined in a file inside the repository.
- **The furniture around them** — user
  accounts and groups, permissions, a wiki
  and snippets per project, a container
  registry, and an API that can drive all of
  it.

GitLab comes in two shapes that are the same
software wearing different hats. **GitLab.com**
is the hosted service: you rent space on
GitLab's own instance, as you would on
GitHub. **Self-managed** GitLab is the
installable one — you run the instance, on
your hardware, under your rules. This guide
is about the second shape. It also comes in
editions: the free **Community Edition**
(CE), which is open source and what the lab
ran, and the paid Enterprise tiers, which
unlock extra features in the same program.
Nothing in this guide needs a paid tier.

## Why run your own

Three honest reasons. **Control**: the code
never leaves your building, which matters
when the code is private, the network is
untrusted, or the internet is simply absent —
a forge on the local network works through
every outage. **Terms**: no seats bill, no
rate limits set by a landlord, no feature
retired out from under you. **Learning**: a
forge stops being magic once you have fed
one.

And one honest bill, stated now so chapter 12
does not surprise you: the machine, the
memory, the disk, the upgrades and the
backups are yours now. GitLab is not a small
program. It is a small data centre wearing a
trench coat, and chapter 2 shows you the
crowd inside.

## The privacy line, drawn early

Self-hosting changes who holds the keys, and
this guide states the consequence in chapter
1 rather than chapter 8: **on your own
instance, the administrator can see
everything.** A private project is private
from other *users*. It is not private from
the person who runs the instance — that
person holds the database, the disk and the
backup tapes. If you host other people's
code, they are trusting you with it, and
chapter 8 returns to this. The flip side is
real too: no third party holds it either.
Your repositories answer to exactly one
organisation — yours.

## A first taste

Everything in this guide happens against an
instance installed exactly as chapter 3
describes. This is the smallest true story
about it, from the lab's transcripts — the
instance stating its own version through its
API:

```text
$ curl -s -H "PRIVATE-TOKEN: $TOK" http://127.0.0.1:8929/api/v4/version
{"version":"19.5.3","revision":"0d4c9a9a2fa","kas":{"enabled":false,...},"enterprise":false}
```

Version 19.5.3, Community Edition
(`"enterprise": false`), answering on a
machine in the same room as the person
asking. Chapters 5 to 7 turn that answering
box into a working forge: a project, a push,
an issue, a merge, and a pipeline that runs
green.
