# Limits

**Outcome: you can name the walls before
you walk into them.** Honest chapter,
plain list.

## It is heavy, and it stays heavy

GitLab's floor is real: about **4 GB of
memory** for a small instance, several
gigabytes of disk before your first
repository, and a startup measured in
minutes on modest CPUs. The lab ran it in
less, with the trims of chapter 3, on a
borrowed machine — and the transcripts
record the cost honestly: reconfigure
attempts measured in minutes, a Rails
console boot of a minute and a half, a
stack that idled with a few hundred
megabytes to spare. A forge this size is a
*service you operate*, not an app you
install. If that sentence puts you off,
chapter 11's lightweights exist precisely
for you.

## One machine, by default

Everything in this guide is a **single
instance**: one database, one Redis, one
Gitaly, one disk. That is a design point,
not a flaw — but it means the machine is a
single point of failure, and *scaling* past
it is a different architecture (several
machines, shared or clustered storage,
load balancing) that GitLab documents for
large installs and this guide does not
teach. Your ceiling on one box is generous
— hundreds of users on decent hardware —
but it is a ceiling.

## The administrator stands outside the rules

Chapter 8's limit, kept: permissions
organise users, and the operator is not a
user. A private project is private from
other accounts, never from the instance's
own administrator or anyone holding its
disk and backups. That is inherent to
self-hosting anything, and it caps who
should be invited to keep truly private
work on a shared instance: people who trust
the operator, told plainly that this is the
arrangement.

## Backups are version-locked, and partial by design

A backup restores **only into the same
version** that made it, and the tarball by
itself is incomplete — without
`gitlab.rb` and `gitlab-secrets.json`
beside it, the restored instance cannot
read its own encrypted data (chapter 9).
An upgrade therefore has a ratchet: once
migrations have run on the new version,
the road back is the pre-upgrade backup,
not the old package.

## The package brings its own everything

Omnibus self-containment is why
installation is easy, and it has a price:
the stack's PostgreSQL, Redis, Ruby and
NGINX are **GitLab's copies**, patched on
GitLab's schedule, not your distribution's.
Your system's package updates do not touch
them. Keeping the instance secure means
tracking GitLab's releases, not your
distro's — and it is also why two GitLabs,
or a GitLab beside your own Rails stack,
never share parts.

## Furniture that is off until you furnish it

A fresh instance is deliberately
unfinished. **Email** needs an SMTP server
you provide, and without one there are no
invitations, notifications or password
reset mails. The **container registry**,
**GitLab Pages**, and the **Kubernetes
agent** are separate subsystems with their
own setup, off in the lab's configuration
and in this guide. **Sign-up** is open by
default — a door to close deliberately
(chapter 4). None of these are defects;
all of them are evenings.

## The free edition's edge

The Community Edition is genuinely complete
for repositories, issues, merge requests
and CI — everything this guide did was
done in it. Some furniture is reserved for
the paid tiers: certain approval rules and
compliance tools, push rules, group-level
extras, custom roles, and support itself.
The instance will occasionally show you a
greyed-out feature with a price on it.
Whether that is a limit or a relief is a
matter of taste; either way, it is a wall
you should know is there before a plan
leans on it.

## It runs other people's code

Chapter 7's warning, promoted to a limit:
a runner executes whatever its jobs say,
with the runner machine's permissions. A
pipeline is a program written by whoever
pushed the branch. On a single-machine lab
that risk is yours alone; on a shared
instance, the runner's isolation — separate
machines, disposable containers — is not
an optimisation. It is the security model,
and the shell executor on a machine you
care about is where this guide's own
practice stops being a recommendation.
