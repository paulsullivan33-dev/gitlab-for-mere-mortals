# Issues and Merge Requests

**Outcome: the daily loop, run once end to
end — a piece of work recorded as an issue,
done on a branch, proposed as a merge
request, and merged, with the issue closing
itself as a result.** Check: the project's
commit list shows three commits ending in a
merge, and the issue reads *closed* —
transcript `gitlab-lab/transcripts/t09-issue-and-merge-request.txt`
holds the whole exchange.

Plain Git remembers code. This chapter is
the layer that remembers *work*: what needs
doing, what a proposed change is for, and
who agreed to it.

## Issues: the project's memory of intent

An **issue** is a titled note attached to a
project: a description, a state (open or
closed), an owner if someone is assigned,
and a conversation that accumulates
underneath. The lab opened one the way the
project's own note suggested — the README's
field note mentioned a gate that sticks, so
the issue is the purchase that fixes it:

```bash
curl -s -X POST -H "PRIVATE-TOKEN: $TOK" \
  --data-urlencode "title=Buy a washer for the gate hinge" \
  --data-urlencode "description=From the first field note: the gate at the bottom of the lane sticks after rain. The hinge needs a washer." \
  https://your-instance/api/v4/projects/1/issues
```

```text
issue #1 | Buy a washer for the gate hinge | state: opened
```

In the interface this is the **New issue**
button, and around the basic note you will
find the furniture of all such systems:
labels for sorting, milestones for
grouping, due dates, and boards that lay
open issues out as cards in columns. None
of that changes the essence: an issue is a
numbered, addressable statement of work,
and `#1` is how everything else refers to
it.

## Branches: doing the work apart

Changes are made on a **branch** so that
`main` stays the agreed truth while work is
in progress. The lab added the parts list
on one:

```bash
git checkout -b washer-for-the-gate
# ... write notes/parts-list.txt ...
git commit -m "Add a parts list with the washer for the gate hinge"
git push origin washer-for-the-gate
```

Branches on your own instance behave
exactly as branches anywhere — with one
refinement worth knowing exists:
**protected branches**. A project can rule
that nobody pushes to `main` directly, so
the only road in is the next section.
`main` is protected by default on a new
project in current GitLab, with maintainers
allowed to merge.

## Merge requests: the review ritual

A **merge request** (MR) proposes one
branch into another. It shows the diff,
collects discussion and approvals, runs the
pipelines of chapter 7, and ends in a
merge. Other forges call this a pull
request; the idea is identical. The lab
opened one through the API, with a
description that matters:

```bash
curl -s -X POST -H "PRIVATE-TOKEN: $TOK" \
  --data-urlencode "source_branch=washer-for-the-gate" \
  --data-urlencode "target_branch=main" \
  --data-urlencode "title=Add the parts list (washer for the gate)" \
  --data-urlencode "description=Closes #1 once merged." \
  https://your-instance/api/v4/projects/1/merge_requests
```

```text
MR !1 | Add the parts list (washer for the gate) | state: opened | washer-for-the-gate -> main
```

Merge requests are numbered with a `!`
where issues use a `#`, in the same
project-local sequence. The sentence
**"Closes #1"** in the description is a
small machine: when this merge lands,
issue #1 is closed automatically, with a
note saying the merge did it. Merging,
through the button or the API:

```bash
curl -s -X PUT -H "PRIVATE-TOKEN: $TOK" \
  https://your-instance/api/v4/projects/1/merge_requests/1/merge
```

```text
MR !1 state: merged | merge commit: befa4905
issue #1 state: closed
```

And the history now tells the whole story
to anyone who arrives later:

```text
befa4905 Merge branch 'washer-for-the-gate' into 'main'
060dcf67 Add a parts list with the washer for the gate hinge
cf2ec57c First notes: README and the gate at the bottom of the lane
```

The merge the lab used is the plain **merge
commit**. Two other strategies live in the
project settings — *fast-forward* (no merge
commit; the branch must be up to date) and
*squash* (the branch's commits compressed
into one) — and teams argue about them with
genuine feeling. On your own instance the
argument is with yourself; pick the history
shape you like to read.

That loop — issue, branch, merge request,
merge — is the heartbeat of the forge.
Chapter 7 adds the machine that checks the
work while humans are still deciding.
