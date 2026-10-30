# Backups and Upgrades

**Outcome: your instance's data is packed
into a backup you could rebuild from, you
know the two files the backup leaves
behind, and you know why upgrades walk a
marked path.** Check: `/var/opt/gitlab/backups`
holds a dated tarball with your version in
its name, as in transcript
`gitlab-lab/transcripts/t11-backup-and-health.txt`.

## The backup command

GitLab packs itself with one command:

```bash
sudo gitlab-backup create
```

It walks everything the instance holds —
database, repositories, uploads, build
traces, artifacts, pages, LFS objects,
terraform states — announcing each as it
goes, and leaves a single tarball:

```text
2026-10-30 06:30:01 UTC -- Dumping database ... done
2026-10-30 06:30:02 UTC -- Dumping repositories ... done
2026-10-30 06:30:02 UTC -- Dumping uploads ... done
2026-10-30 06:30:02 UTC -- Dumping builds ... done
2026-10-30 06:30:02 UTC -- Dumping artifacts ... done
2026-10-30 06:30:02 UTC -- Dumping pages ... done
2026-10-30 06:30:02 UTC -- Dumping lfs objects ... done
2026-10-30 06:30:02 UTC -- Dumping terraform states ... done

-rw------- 1 git git 880640 ... 1793341793_2026_10_30_19.5.3_gitlab_backup.tar
```

The lab's instance held one small project,
and the tarball is 880,640 bytes. Yours
will grow with your repositories — measure
it, because a backup you have not sized is
a schedule you have not planned.

## The two files the tarball leaves behind

Read the filename again: `19.5.3` is in it
because **a backup restores only into the
same GitLab version that made it**, exactly
the same, down to the patch release. And
the tarball is not the whole story. Two
things live in `/etc/gitlab` and are *not*
in the backup:

- **`gitlab.rb`** — your configuration.
- **`gitlab-secrets.json`** — the keys the
  instance uses to encrypt values inside
  its database.

Without the secrets file, a restored
database's encrypted contents are
unreadable: the backup opens into an
instance that cannot make sense of itself.
The package has a companion command for
exactly this:

```bash
sudo gitlab-ctl backup-etc
```

which archives `/etc/gitlab` into
`/etc/gitlab/config_backup`. A backup
routine that deserves the name takes both,
on a schedule (the backup command is built
to be run from cron, with a retention
setting in `gitlab.rb`), and keeps a copy
somewhere that is not the same disk.

## The restore: stated honestly

Restoring means: install the *same*
version fresh, stop it, place the tarball
and the two configuration files, run
`gitlab-backup restore`, reconfigure,
start. **The lab did not run a restore** —
it needs a second instance of the same
version standing ready, and the lab's
machine had neither the memory nor a
reason to fake one — so this paragraph is
documented-only, from GitLab's own restore
documentation, and the guide says so rather
than dressing a reading as a result. The
practical moral does not need the run: an
untested backup is a hope, and the time to
learn your restore works is before you
need it. If your instance matters, schedule
the rehearsal.

## Upgrades: a path, not a jump

GitLab releases monthly and patches in
between, and self-hosting means *you* are
the release schedule now. Two rules keep
upgrades boring:

1. **Follow the upgrade path.** You cannot
   always jump straight to the newest
   version; GitLab names required
   intermediate stops (versions where the
   database migrations change shape), and
   the package enforces it. The lab read
   this guard with its own eyes in the
   installer's pre-install script: an
   upgrade to 19.5 from anything older than
   19.2 is refused, with instructions to
   stop at the latest 19.2 first. Upgrading
   is therefore sometimes a staircase of
   two or three installs — plan the window
   for it.
2. **Back up first** — both halves, the
   tarball and `/etc/gitlab` — before every
   upgrade, so the staircase has a ground
   floor.

The mechanics are otherwise the chapter 3
ones: install the new package, and its
post-install runs the reconfigure and
migrations for you. Then check the
instance's own report of itself —
`/-/health` answers `GitLab OK`, and
`/api/v4/version` states what is now
running:

```text
$ curl -s http://127.0.0.1:8929/-/health
GitLab OK
```

Small, frequent upgrades beat rare, heroic
ones: each monthly step is a few migrations
and a short restart, while a year of
deferred updates is a staircase climbed in
the dark.
