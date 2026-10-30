# Recipes

**Outcome: a handful of small jobs, each
done the way the package intends.**
Everything here was run in the lab except
where a recipe says otherwise.

## Apply a configuration change

Edit `/etc/gitlab/gitlab.rb`, then:

```bash
sudo gitlab-ctl reconfigure
```

Safe to re-run at any time — it converges
the machine to the file, changing only what
the edit requires (chapter 3). A syntax
error in the file is reported before
anything is touched, which is the other
reason to make this command a habit:
reconfigure is also your configuration
checker.

## See the state of the whole instance

```bash
sudo gitlab-ctl status
```

```text
run: gitaly: (pid 65658) 238s; run: log: (pid 56275) 411s
run: gitlab-workhorse: (pid 67906) 64s; run: log: (pid 67824) 75s
run: nginx: (pid 67916) 64s; run: log: (pid 67874) 68s
run: postgresql: (pid 65759) 231s; run: log: (pid 65834) 228s
run: puma: (pid 67704) 89s; run: log: (pid 67730) 87s
run: redis: (pid 65559) 240s; run: log: (pid 54627) 468s
run: sidekiq: (pid 67746) 83s; run: log: (pid 67761) 82s
run: logrotate: (pid 65534) 242s; run: log: (pid 54470) 473s
```

`run:` means supervised and running, with
the process id and its age. A service stuck
at `down:` is chapter 13's starting point —
read its log in `/var/log/gitlab/<service>/current`.

## Stop or start everything, or one thing

```bash
sudo gitlab-ctl stop            # everything
sudo gitlab-ctl start           # everything
sudo gitlab-ctl stop puma       # one service
sudo gitlab-ctl start puma
```

The lab's stop, on its borrowed machine,
printed one `ok: down:` line per service as
each went quiet — with Sidekiq taking
longest, because it finishes the job in
hand first. Give it that grace before
reaching for stronger medicine.

## Ask the instance what it is

Three witnesses, in increasing order of
authority:

```bash
curl -s https://your-instance/-/health
# GitLab OK

curl -s -H "PRIVATE-TOKEN: $TOK" https://your-instance/api/v4/version
# {"version":"19.5.3","revision":"0d4c9a9a2fa",...,"enterprise":false}

sudo grep -A1 "^gitlab-ce" /opt/gitlab/version-manifest.txt
# gitlab-ce 19.5.3
```

The lab cross-checked the API's revision
(`0d4c9a9a2fa`) against the package manifest
and found them the same commit — a tidy way
to be sure the package on disk is the
program answering.

## Change the root password from the console

If the sign-in is lost but the machine is
yours — the situation chapter 4's 24-hour
file deadline can create:

```bash
sudo gitlab-rake "gitlab:password:reset[root]"
```

This one is documented-only in this guide
(the lab's password never needed rescue);
it is the package's own task, prompting for
the new password interactively. The Rails
console from chapter 4 can do the same job
and more, which is exactly why both doors
are administrator-shaped and kept shut.

## Find where the disk went

When `/var/opt/gitlab` grows, it is almost
always one of three tenants:

```bash
sudo du -sh /var/opt/gitlab/git-data \
             /var/opt/gitlab/postgresql \
             /var/opt/gitlab/backups
```

Repositories, database, backups — in that
usual order. Artifacts and job logs from CI
are the fourth tenant, under
`/var/opt/gitlab/gitlab-rails/shared/artifacts`;
projects can expire them automatically in
their CI/CD settings, and chapter 12 lists
unbounded artifacts among the quiet ways an
instance fills its own disk.
