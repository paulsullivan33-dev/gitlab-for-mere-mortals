# CI/CD and Runners

**Outcome: a pipeline defined in your
repository runs by itself when you push, on
a runner you control, and you have read its
log.** Check: the project's pipeline list
shows *success*, and the job trace ends in
the words *Job succeeded* — the lab's run
is transcript
`gitlab-lab/transcripts/t10-ci-runner-and-pipeline.txt`.

## The idea in one paragraph

**CI/CD** — continuous integration,
continuous delivery — means a machine
checks every change: builds it, tests it,
and (if you let it) ships it. In GitLab the
whole arrangement is a file in the
repository, `.gitlab-ci.yml`, describing
**jobs** grouped into **stages**. A push
creates a **pipeline** — one run of the
file — and the work is done not by the
GitLab server but by a separate program,
the **runner**, which polls the instance
for jobs and reports back with logs and a
verdict. Keeping the runner separate is the
design's best feature: the server stays
small, and runners can live wherever the
work should happen.

## A pipeline small enough to see whole

Here is the lab's, complete — it is also
kept at `gitlab-lab/field-notes-gitlab-ci.yml`:

```yaml
stages:
  - check

count-the-notes:
  stage: check
  script:
    - echo "Notes in this repository:"
    - ls notes/
    - echo "Lines in the first note:"
    - wc -l < notes/first-note.txt
```

One stage, one job, four shell lines. A job
is a named block; `script` is a list of
commands run one after another, and the job
fails at the first command that fails — that
exit code is the whole verdict mechanism,
which is why test suites (whose exit codes
mean "all passed" or "something failed")
fit this model so well. Jobs in the same
stage run in parallel (if runners allow);
stages run in order, and a failed stage
stops the pipeline.

## The runner: hired, not born

A fresh instance has no runners, and
pipelines sit pending until one exists.
Runners are **created** in current GitLab
(the old shared registration token is
gone): an administrator creates a runner —
in the admin area or through the API — and
receives an authentication token for it:

```bash
curl -s -X POST -H "PRIVATE-TOKEN: $TOK" \
  --data-urlencode "runner_type=instance_type" \
  --data-urlencode "description=lab shell runner" \
  --data-urlencode "tag_list=lab-shell" \
  https://your-instance/api/v4/user/runners
```

```text
runner id: 1
```

Then the runner program itself — a single
binary, version-matched to the server in
the lab (19.5.0 against 19.5.3) — is
registered with that token and set
running:

```bash
gitlab-runner register --non-interactive \
  --url https://your-instance --token "$RTOK" \
  --executor shell --description "lab shell runner"
gitlab-runner run
```

```text
Verifying runner... is valid
Runner registered successfully.
```

The choice in that command is the
**executor** — how jobs run. The lab used
**shell**: commands execute directly on the
runner's machine, in a fresh checkout of
the repository. It is the simplest
executor and the least isolated: jobs share
the machine with the runner, as the user it
runs as, so it suits a machine you own for
code you trust. The executor most real
installs use is **Docker**, each job in a
clean container from an image the job
names; this sandbox cannot start
containers, so Docker-executor pipelines
are documented-only in this guide.
**Your own CI runs other people's code with
your machine's permissions** — read chapter
1's privacy line again with that in mind,
and be choosy about whose merge requests
get to run pipelines.

## The run

With the runner waiting, the pipeline is
started by nothing more ceremonial than a
push:

```bash
git push origin main
```

```text
pipeline 1 running
pipeline 1 success
```

The job's log — in the interface under the
project's *Build → Jobs*, or through the
API as the lab fetched it — is worth
reading once in full, because it shows the
machine doing the ordinary magic step by
step: it fetches the exact commit from
Gitaly (`Checking out b63e3beb as detached
HEAD`), runs the script in the checkout,
and keeps the output:

```text
$ ls notes/
first-note.txt
parts-list.txt
$ wc -l < notes/first-note.txt
4
Job succeeded
```

From here the file can grow in the
directions real projects need: more stages
(`test`, `deploy`), jobs that only run on
tags or on the main branch, **artifacts**
(files a job leaves behind for later jobs
or for download), and variables and secrets
kept in the project's CI/CD settings rather
than in the file. The GitHub Actions guide
in this series teaches the same ideas in
that system's dialect, and the mental model
transfers: a trigger, a description of
work, a machine that does it, a verdict you
can trust because you read the log.
