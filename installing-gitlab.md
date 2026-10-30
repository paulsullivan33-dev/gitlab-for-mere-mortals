# Installing GitLab

**Outcome: an instance installed from the
official package, configured by one small
file, answering its sign-in page on your
machine.** Check: `sudo gitlab-ctl status`
shows the services running, and
`http://your-address/users/sign_in` loads
with the title *Sign in · GitLab* — the
lab's exact evidence is transcripts `t05`
and `t06` in `gitlab-lab/transcripts/`.

## Before you start: the honest sizing

GitLab's own documentation asks for at
least **4 GB of addressable memory** for a
small instance, and the lab can confirm
that is a floor, not a boast. With the
trims below, the lab's configured stack ran
in what a shared 8 GB machine could spare —
and a fat application like this one is
never *fast* on two CPUs. Give it 4 GB and
two cores of its own and it is comfortable
for a household or a small team. Give it a
laptop's leftovers and it will still run,
but chapter 13 is in your future.

You also need a name or address for the
instance — the **external URL**. It can be
a domain name, a local name, or (as in the
lab, which never left loopback) an IP
address with a port. Pick it before
installing: it is baked into every link
GitLab generates.

## The route: the omnibus package

GitLab ships several installers. The one
this guide uses — and the one GitLab
recommends for a single machine — is the
**omnibus package**: one `.deb` (or `.rpm`)
per distribution release, carrying all of
chapter 2 inside it. The Docker image and
the cloud images are the same software in
different wrapping; installing from source
is a maintainer's exercise, not an
administrator's. On a stock Ubuntu server
the whole install is the documented three
steps — add GitLab's repository, install
the package with your URL, wait:

```bash
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
sudo EXTERNAL_URL="https://gitlab.example.org" apt install gitlab-ce
```

The lab could not run a stock install — its
sandbox has no package-manager session of
its own — so it walked the same road by
hand, which has the advantage of showing
what the road is made of. It read GitLab's
repository index to learn the current
version (19.5.3 for Ubuntu 24.04 at lab
time), downloaded the package through the
documented endpoint, and **verified it
before trusting it**:

```text
$ sha256sum gitlab-ce_19.5.3-ce.0_amd64.deb
516f3c112c5b043ab87fee0e27d7fec98ad577c734a221f088e40a2c409aab40  gitlab-ce_19.5.3-ce.0_amd64.deb
```

That sum matches the one in the repository
index, byte for byte (transcripts `t01` and
`t02`). Make this a habit, not a ceremony:
the lab's first attempt at the same
download produced a 14-byte file containing
the words *404: Not Found*, because a
plausible-looking URL was not the real one.
Size and checksum are how you know what you
actually fetched.

The package's own post-install script then
does three things (the lab read it, and did
them in the same order): it links the
`gitlab-ctl` commands into place, it writes
`/etc/gitlab/gitlab.rb` from the template,
and it runs `gitlab-ctl upgrade`, which
configures everything. A real `apt install`
does all of this for you.

## The one file: gitlab.rb

Everything about the instance is decided in
`/etc/gitlab/gitlab.rb`, a Ruby file whose
full template runs to 3,849 lines — almost
all of it comments and defaults. You do not
need the template. A working configuration
can be small enough to read at a glance.
Here is the lab's, complete (also kept as
`gitlab-lab/gitlab.rb.example`):

```ruby
external_url 'http://127.0.0.1:8929'

prometheus_monitoring['enable'] = false
alertmanager['enable'] = false
gitlab_kas['enable'] = false
puma['worker_processes'] = 2
sidekiq['concurrency'] = 10
postgresql['shared_buffers'] = "256MB"
```

One line is the instance: `external_url` is
where the world reaches it — yours will be
your domain or server name, with `https`
once you arrange a certificate (the package
can fetch a Let's Encrypt one by itself
when the name is public and port 80 is
reachable). The rest is the lab's diet, each
line a deliberate saving:

- The **monitoring stack off**. Prometheus
  and its exporters watch the instance's
  health; on a machine that is short of
  memory they are guests you can invite
  later.
- **KAS off**. The Kubernetes agent server
  is a whole subsystem for a feature this
  guide does not use.
- **Puma trimmed to 2 workers** and
  **Sidekiq to 10 concurrent jobs** — fewer
  hands, less memory, slightly slower
  queues.
- **PostgreSQL's cache fixed at 256 MB**
  instead of scaled to the machine it
  *wishes* it had.

On a server with memory to spare, skip the
diet: set `external_url` and let the
defaults stand. Every setting can be
changed later — edit the file, re-run
reconfigure, and the instance converges.

## Reconfigure: the command that builds it

```bash
sudo gitlab-ctl reconfigure
```

This runs GitLab's configuration machinery
(the package carries its own Chef) and
turns your `gitlab.rb` into users,
directories, configuration files for all
eight services, an initialised database
with its schema loaded, and the services
running. On the lab's two shared CPUs the
successful run took about four minutes;
the first run failed halfway, on a
permission problem of the lab's own making,
and chapter 13 tells that story in full
because you will meet its cousins. The
property to remember is that **reconfigure
is safe to re-run**: it converges the
machine to the file, doing only what is
still missing. Fix the cause, run it again.

When it ends with `gitlab Reconfigured!`,
give Puma a minute to warm up — the first
request or two can meet a 502 from the
front door while the application boots —
then load the sign-in page. That page is
this chapter's finish line, and the next
chapter signs in.
