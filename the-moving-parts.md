# The Moving Parts

**Outcome: you can name the eight services
that make up an instance, say what each one
holds, and find the three directories where
everything lives.** Check: by the end you
can read the output of `gitlab-ctl status`
(the lab's is in transcript
`gitlab-lab/transcripts/t05-configured-and-answering.txt`)
and point at each line's job.

GitLab looks like one program and is
secretly a small company of them. The
installer — the **omnibus package** — carries
its own copies of everything: its own Ruby,
PostgreSQL, Redis, NGINX and Git, installed
side by side under `/opt/gitlab` and kept
out of the system's way. That is why the
package for the lab was 1.2 GB to download
and 3.9 GB unpacked, and why its dependency
list was nearly empty. The lab read the
manifest so you do not have to take this on
faith (transcript
`gitlab-lab/transcripts/t03-inside-the-package.txt`):

```text
nginx        release-1.31.4
postgresql   17.11
redis        7.2.16
ruby         3.3.12
runit        2.1.2
(and Gitaly 19.5.3, GitLab Rails 19.5.3,
 gitlab-shell 14.58.0, Prometheus 3.13.2)
```

## The eight services

These are the lines `gitlab-ctl status`
reports on a default instance, in the order
a request meets them:

- **nginx** — the front door. It takes every
  web and HTTPS request first, serves the
  static files itself, and hands the rest
  inward. If GitLab answers at all, nginx is
  the part that picked up.
- **gitlab-workhorse** — the doorman for
  heavy lifting. Big uploads, downloads and
  Git pushes pass through Workhorse so the
  application itself does not have to carry
  them.
- **puma** — the application. GitLab is a
  Ruby on Rails program; Puma is the web
  server that runs it, with several worker
  processes. Nearly everything you see in the
  browser is Puma's work. It is also the
  service that takes a minute to warm up
  after a start — remember that in
  chapter 13.
- **sidekiq** — the back office. Sending
  mail, updating caches, running webhooks
  and a hundred other jobs are queued and
  done by Sidekiq in the background, so the
  web request that caused them can finish
  quickly.
- **postgresql** — the memory of everything
  except the code itself. Users, groups,
  issues, comments, permissions, pipeline
  records: all rows in this database. If it
  is not data inside a repository, it is
  almost certainly in PostgreSQL.
- **redis** — the short-term memory and the
  queue. Sessions, caches and the Sidekiq
  job queue live here. Losing Redis is an
  inconvenience; losing PostgreSQL is a
  disaster. Chapter 9's backups treat them
  accordingly.
- **gitaly** — the keeper of the code. Every
  repository read and write — clone, push,
  the file listing in the browser — goes
  through Gitaly, which owns the disk the
  repositories live on. It is the one service
  that must never have its storage meddled
  with by hand.
- **logrotate** — the janitor. It rotates and
  compresses the log files so the instance
  does not drown in its own diary.

Around them sit pieces you meet less often:
**gitlab-shell** handles Git over SSH,
**Prometheus** and its exporters watch the
instance's own health (the lab switched the
monitoring stack off to save memory — chapter
3 explains), and **runit** supervises the
whole company, restarting anything that
falls over. Runit is why GitLab does not
need systemd: the package carries its own
supervisor, which is also how the lab ran it
on a machine that has none.

## The service users

The daemons do not run as root. Reconfigure
creates a small staff of system users —
`git` (the application, Gitaly and
Workhorse), `gitlab-psql` (PostgreSQL),
`gitlab-redis` (Redis), `gitlab-www` (the
nginx workers) — and each service runs as
its own user, holding only its own files.
This is good hygiene on a real server. It is
also the root of the lab's first real
failure, in chapter 13: a program root can
run happily can still be unreachable by the
user who is supposed to run it.

## The three directories

- **`/opt/gitlab`** — the program. The
  package's own tree; you do not edit
  anything here, and upgrades replace it.
- **`/etc/gitlab`** — the configuration.
  Two files matter: `gitlab.rb`, the one
  file an administrator edits, and
  `gitlab-secrets.json`, the generated
  secrets the instance encrypts its
  database with. Lose the secrets file and
  the database becomes unreadable — chapter
  9 treats it as part of every backup.
- **`/var/opt/gitlab`** — the data.
  Repositories (under `git-data`), the
  PostgreSQL and Redis data, uploads,
  artifacts, and the `backups` folder.
  This is the directory that grows.

Logs live in `/var/log/gitlab`, one folder
per service. `gitlab-ctl tail` follows them;
`gitlab-ctl status` and `gitlab-ctl
reconfigure` are the two commands you will
use most, and the next chapter puts them to
work.
