# The Neighbours

**Outcome: you can place GitLab among its
alternatives by weight and by landlord.**
These tools are characterised from their
documentation, not run in this guide's lab
— the lab installed exactly one forge, and
this chapter does not pretend otherwise.

## The same software, rented: GitLab.com

GitLab's own hosted service is this very
program, run by GitLab, at company scale.
Everything in chapters 5 to 7 works the
same; what changes is the bill's shape —
per-seat pricing for the tiers, no machine
to feed, no upgrades to schedule, and an
administrator who is not you for the
machine itself. If the *software* is what
you want and the *hosting* is not, this is
the honest competitor to your own instance,
and choosing it is no failure of nerve.

## The reference point: GitHub

GitHub is the forge most people meet first,
and its shape is the same: repositories,
issues, pull requests (the merge request's
twin), Actions for CI (the subject of the
GitHub Actions guide in this series),
packages, pages. It is hosted-only in its
main form — there is an enterprise server
edition, priced for enterprises. Teams
choose between GitHub and GitLab more
often on ecosystem and habit — where the
projects they depend on live, which CI
dialect they already speak — than on any
single feature. If your world already lives
on GitHub, a private GitLab is a second
home, not a replacement, and that is a
perfectly good reason to run one small and
well.

## The lightweights: Gitea and Forgejo

At the other end of the scale sit **Gitea**
and its community fork **Forgejo** (which
also powers the public Codeberg service).
Each is a single small program — tens of
megabytes, content in a fraction of the
memory GitLab asks — offering repositories,
issues, pull requests and a CI system of
its own. What you give up is depth: the
planning tools, the compliance furniture,
much of the API's breadth, and an upgrade
story measured in giant steps of features.
For a household, a club, or a single
maker's public work, the lightweights are
often the *right* answer, and "GitLab,
because it is the famous one" is not
engineering. Chapter 12's memory floor is
the number to compare them against.

## The zero-software option: plain Git

A forge is, at bottom, manners around a
folder. A bare repository on any machine
you can SSH to accepts pushes from everyone
with an account and a key, and for two
people who talk to each other anyway, that
plus an email habit can be enough — the Git
guide in this series covers the bare-repository
shape. What you lose is everything this
guide exists for: the web view, the review
ritual, the issue list, the pipeline
verdicts. People rebuild those by hand,
badly, in that order. But it costs nothing,
never needs an upgrade path, and will be
readable in fifty years — which is more
than any database in chapter 2 can promise.

## Choosing, in one breath

Your machine, your rules, full depth:
**self-managed GitLab**, this guide. Same
depth, someone else's machine: **GitLab.com**
or **GitHub**. Small and light above all:
**Gitea or Forgejo**. Nothing at all:
**plain Git over SSH**. The code itself —
blobs and history, in open formats — moves
between all of them with a push, which is
Git's own mercy: the forge is a landlord,
never a lock-in you cannot leave.
