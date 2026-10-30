# Your First Project

**Outcome: a project exists on your
instance, and your own code is in it —
pushed from your machine and visible in the
project's repository on the server.**
Check: the repository tree, asked through
the API, lists your files, exactly as
transcript `gitlab-lab/transcripts/t08-git-over-http.txt`
shows for the lab's project.

## Creating the project

A **project** is GitLab's unit of work: one
repository, plus its issues, merge
requests, pipelines and settings, living
under an owner — your account, or a group
(chapter 8). You can create one from the
first-run page, from the big **New project**
button, or, as the lab did, through the
API:

```bash
curl -s -X POST -H "PRIVATE-TOKEN: $TOK" \
  --data-urlencode "name=field-notes" \
  --data-urlencode "description=Notes from the field — the lab's example project" \
  --data-urlencode "visibility=private" \
  https://your-instance/api/v4/projects
```

The reply names everything you will need:

```text
"id": 1,
"path_with_namespace": "root/field-notes",
"default_branch": "main",
"http_url_to_repo": "http://127.0.0.1:8929/root/field-notes.git",
"web_url": "http://127.0.0.1:8929/root/field-notes",
"visibility": "private",
```

Two choices in that call matter. The
**visibility**: *private* (only members can
see it), *internal* (any signed-in user),
or *public* (the world). Private is the
sane default while you learn. And the
project starts **empty** — an empty
repository is a normal thing, and the next
step fills it.

## Filling it: clone, write, push

Git does not care that the remote lives on
your own GitLab; the moves are the ones
from the Git guide in this series. The
lab's clone used the API token as the
password over HTTP:

```bash
git clone http://root:$TOK@127.0.0.1:8929/root/field-notes.git
```

```text
Cloning into 'field-notes'...
warning: You appear to have cloned an empty repository.
```

That warning is the empty project greeting
you, not an error. Inside the clone, set
your name and email if this machine has not
got them, write something, and push:

```bash
git config user.name "A. Gardener"
git config user.email "gardener@example.org"
# ... create README.md and notes/first-note.txt ...
git add -A
git commit -m "First notes: README and the gate at the bottom of the lane"
git push origin main
```

```text
To http://127.0.0.1:8929/root/field-notes.git
 * [new branch]      main -> main
```

That push is worth a pause. It travelled
the whole of chapter 2: nginx took it,
Workhorse carried it, the application
checked the token's right to write, and
Gitaly stored it on disk. Proving the
server really holds the files — rather than
trusting the push's good manners — is the
API's tree call:

```bash
curl -s -H "PRIVATE-TOKEN: $TOK" \
  "https://your-instance/api/v4/projects/1/repository/tree?recursive=true"
```

```text
[{"name":"notes","type":"tree","path":"notes",...},
 {"name":"README.md","type":"blob","path":"README.md",...},
 {"name":"first-note.txt","type":"blob","path":"notes/first-note.txt",...}]
```

The same files are now browsable at the
project's web address, which is the view
you will use day to day.

## The other door: Git over SSH

Most people end up cloning over **SSH**,
with a key pair instead of a token in the
URL: you add your public key under your
profile's *SSH Keys*, and the address takes
the form `git@your-instance:root/field-notes.git`.
This part of the guide is **documented-only**,
stated plainly: the lab's sandbox ran no
SSH server for GitLab to plug into (the
package deliberately relies on the system's
`openssh-server` for this), so no transcript
pretends an SSH push happened. The moving
part on GitLab's side is gitlab-shell,
which checks the key, maps it to your
account, and hands the session to Gitaly —
after which Git cannot tell the difference,
and neither will you.

An existing repository comes home the same
way, in either direction: add the instance
as a remote (`git remote add home
<address>`) and push. Everything else in
this guide now builds on a project that
exists and holds code — chapter 6 puts it
to work.
