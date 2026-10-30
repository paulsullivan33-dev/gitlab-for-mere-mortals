# Writing criteria for this guide

Every "for Mere Mortals" guide is written to the same nine-point
standard, so a reader who trusts one can trust the rest. Here it
is, with the verification notes for this particular guide below.

1. **Fix it first.** Reader outcomes lead, not action items: each
   chapter opens by naming the outcome it delivers, shows a check
   the reader can run to confirm they got it, and a reasonable
   reader finishes able to state what was done, what it means,
   and what to try next.
2. **Plain language.** Short sentences, everyday vocabulary,
   technical terms defined on first use. No slang, and no
   idioms that only make sense in one country — the reader may
   be translating as they go.
3. **No dead ends.** A guide never tells the reader to do
   something it cannot show them how to verify. Every claim a
   reader relies on — an install, a command, an output — is
   something this guide demonstrates or clearly labels
   documented-only below.
4. **Live-verified where it matters.** Procedures are run for
   real in the guide's lab wherever the build machine allows it,
   and the transcripts kept in the repository are the evidence.
   What could not be run is listed honestly below, never
   presented as if it had been.
5. **General audiences.** Nothing in this guide — examples,
   fixtures, names, addresses — is modelled on any particular
   reader or author's real life, network, or organisations.
   The lab's project is an invented notebook of field notes.
6. **Standalone.** A reader needs this guide, its lab, and
   nothing else. Where another guide would genuinely help, it
   is pointed to once, by name, and the chapter still completes
   without it.
7. **Honest about limits.** Chapter 12 names what the tool
   costs and cannot do: the 4 GB memory floor the lab felt
   first-hand, the single-machine design point, an
   administrator who stands outside the permission system,
   backups locked to the version that made them and incomplete
   without the configuration and secrets files, an
   omnibus stack patched on GitLab's schedule rather than the
   distribution's, and the CI fact that a runner executes other
   people's code.
8. **The ethics rule is in the text, early.** Self-hosting a
   forge makes its operator the custodian of other people's
   code and conversation, and chapter 1 states the consequence
   before any procedure depends on it: a private project is
   private from other users, never from the instance's
   administrator. Chapter 8 repeats it where permissions are
   taught, and chapter 7 states the twin rule for CI — a
   pipeline is a program written by whoever pushed.
9. **Builds clean.** The site builds with MkDocs in strict mode
   with no warnings, and a fresh reader following the chapters
   in order reaches the stated outcome of each.

## Verification notes for this guide

The build machine is a 2-CPU, ~8 GB Ubuntu 24.04 sandbox,
shared with other work while the lab ran (memory available to
the lab ranged from under 1 GB to about 2 GB, and timings are
therefore ranges). There is no systemd and no container
runtime in the sandbox, and outbound downloads work. GitLab
**Community Edition 19.5.3** was verified from the official
omnibus package `gitlab-ce_19.5.3-ce.0_amd64.deb` for Ubuntu
24.04, fetched from GitLab's own package repository: the
repository index's size (1,214,046,962 bytes) and SHA-256
(`516f3c11...`) both match the downloaded file exactly (t01,
t02). All transcripts live in `gitlab-lab/transcripts/`
(t00–t12); the lab's configuration file is
`gitlab-lab/gitlab.rb.example` and its token script is
`gitlab-lab/make-token.rb`.

The package was extracted with `dpkg -x` (no maintainer
scripts ran) and the tree placed at `/opt/gitlab` by symlink,
which the bundled binaries require: their library paths are
built for that address, and run from elsewhere they cannot
find their own libraries (t03). The lab then followed the
package's own post-install steps by hand — configuration file,
`gitlab-ctl reconfigure` — with a deliberately small
`gitlab.rb`: external URL on loopback (`127.0.0.1:8929`), the
Prometheus monitoring stack and the Kubernetes agent server
disabled, Puma at 2 workers, Sidekiq concurrency 10,
PostgreSQL shared_buffers 256 MB.

Run for real, with transcripts as evidence:

- The repository index read for version, size and checksum;
  a first download attempt that produced a 14-byte
  *404: Not Found* file, kept as evidence (t01), then the
  correct download through the documented endpoint and its
  checksum verification (t02).
- Package internals: `dpkg-deb -I` control data, the
  version-manifest's component list, the post-install and
  pre-install scripts read in full, and the bundled `git`,
  `ruby`, `psql`, `redis-server`, `nginx` and `gitaly`
  binaries executed from the extracted tree (t03).
- A first `gitlab-ctl reconfigure` that converged 348
  resources — creating the service users `git`, `gitlab-www`,
  `gitlab-psql`, `gitlab-redis` — then failed verbatim on
  `Errno::EACCES` for `initdb`, with Gitaly's `access denied`
  in its log; the cause (service users could not traverse
  the directories above the extracted tree) shown with
  `namei`, the fix applied (world-traversable lab folders;
  execute-only ACLs on the home directory for the four
  service users), and the proof run as `gitlab-psql` (t04).
- A second reconfigure ending in `gitlab Reconfigured!`:
  PostgreSQL initialised, schema loaded, migrations run.
  `gitlab-ctl status` showed all eight services running
  under runit. The sign-in page answered 502 once, then 200
  with the title *Sign in · GitLab* (t05).
- The first sign-in as `root`, driven with curl through the
  real form flow, using the password read from
  `/etc/gitlab/initial_root_password` (never printed in any
  transcript): HTTP 302 to the first-run page, which loaded
  at 200 titled *Create your first project* (t06).
- A personal access token (scopes `api`, `read_repository`,
  `write_repository`) created for `root` through
  `gitlab-rails runner`, after the runner's own `LoadError`
  lesson was captured verbatim; an earlier orphaned token
  revoked through the API (HTTP 204). `/api/v4/version`
  answered 19.5.3 with revision `0d4c9a9a2fa` — the same
  commit the package manifest lists for gitlab-rails — and
  `/api/v4/user` answered the root account. The example
  project `root/field-notes` (private) was created through
  the API (t07).
- Git over HTTP with the token as password: clone of the
  empty project (with its warning), one commit pushed to
  `main`, and the server's own repository tree and commit
  list confirming the stored files (t08).
- The review loop over the API: issue #1 opened; a branch
  pushed; merge request !1 opened with `Closes #1` in its
  description; the merge accepted (merge commit `befa4905`);
  issue #1 then read back as closed (t09).
- CI end to end: GitLab Runner **19.5.0** downloaded from
  the official binary store; a runner created through the
  API (the current create-then-register flow) and registered
  with the shell executor; the example `.gitlab-ci.yml`
  pushed, and pipeline 1 finished **success**, its job trace
  showing the checkout of the pushed commit and the script's
  output, ending *Job succeeded* (t10).
- `/-/health` answering `GitLab OK`, and a full
  `gitlab-backup create` of the running instance, producing
  `1793341793_2026_10_30_19.5.3_gitlab_backup.tar`
  (880,640 bytes) in `/var/opt/gitlab/backups` (t11).
- Anonymous access measured: `/api/v4/user` without a token
  answered 401, and the private project answered 404 (t12).
- The whole stack stopped cleanly with `gitlab-ctl stop`
  after the lab, and the runner process ended.

Documented only — described from the project's documentation,
not run, and the text says so wherever each appears:

- The stock `apt install gitlab-ce` route and the package's
  repository setup script: the sandbox cannot run its own
  package-manager session, so the lab unpacked and configured
  by hand, following the post-install script it read.
- Git over SSH and gitlab-shell: the sandbox runs no SSH
  server for GitLab to use (the package depends on the
  system's openssh-server for this).
- The web interface beyond the sign-in page and the first-run
  page: every later object was driven through the API and
  git, which create and show the same objects the pages do.
- Restoring a backup: it requires a second stopped instance
  of the same version, which the lab did not have the memory
  to stand up; chapter 9 says so and teaches the documented
  procedure as such.
- The Docker executor for runners (the sandbox cannot start
  containers), runners on separate machines, and pipeline
  features beyond one stage and one job (artifacts, rules,
  variables are taught from the documentation).
- Sending email (no SMTP server was configured), the
  container registry, GitLab Pages, the Kubernetes agent
  (disabled in the lab configuration), LDAP/SAML sign-in,
  and every Enterprise-edition feature.
- Upgrading an existing instance: the pre-install script's
  upgrade-path guard was read in full (19.5 refuses jumps
  from before 19.2), but no older instance existed to
  upgrade.
- `gitlab-rake "gitlab:password:reset[root]"` (chapter 10):
  the lab's password never needed rescue; the command is the
  package's documented task, labelled in place.
- The neighbour tools of chapter 11 — characterised, not
  installed or benchmarked.

Fixtures are this guide's own and deliberately generic: one
invented project ("field notes" kept by a fictional gardener,
`gardener@example.org`), a gate that sticks after rain, a
washer to buy for its hinge. Passwords and the access token
used in the lab were generated for it and never printed; the
token was created with a seven-day expiry on an instance that
existed only on loopback and has been stopped.
