# First Sign-In and the Admin Account

**Outcome: you have signed in as the
administrator, and you hold an API token
that can introduce you without a browser.**
Check: a request to `/api/v4/user` with
your token returns your own account, as it
does in transcript
`gitlab-lab/transcripts/t07-api-token-and-project.txt`.

## The root account and its first password

A fresh instance has exactly one account:
username **`root`**, the administrator. Its
first password was generated during
installation and written to a file that
only root can read:

```bash
sudo grep '^Password:' /etc/gitlab/initial_root_password
```

Do not dawdle over this. GitLab deletes
that file shortly after installation (the
documentation gives it 24 hours), and after
that the console routes in chapter 10 are
the way back in. Sign in, and set a
password of your own choosing in the same
sitting.

The lab did the sign-in the way a browser
does, driven with curl so every step is on
the record (transcript `t06`): fetch the
form, take its authenticity token, post the
credentials. The answer it wants you to
learn to read is the redirect — a wrong
password returns the form (HTTP 200), the
right one sends you onward (HTTP 302) to
GitLab's first-run page, which is titled
*Create your first project*. If your fresh
instance greets you with setup questions
instead of a dashboard, that is the design,
not a problem.

## Make the account yours

Three small jobs while you are signed in as
root:

1. **Set your password and email** under
   your profile. The email is where password
   resets and notifications go — on an
   instance with mail configured, which a
   fresh one may not have yet (sending mail
   needs an SMTP server you arrange; the
   package does not bundle one, and the lab
   left mail unconfigured).
2. **Decide who root is.** Many
   administrators keep `root` as a
   break-glass account, create a named
   personal account, and promote it to
   administrator for daily work. The lab
   worked as root to keep its story simple;
   on an instance other people use, the
   two-account habit is worth the minute it
   takes.
3. **Know the switch you will meet
   eventually**: new-user sign-up is open by
   default on a fresh instance, and the
   admin area is where you close it or
   require approval. On a private network
   that is a preference; on a public one it
   is a chore for the first evening, not the
   first month.

## The API token: a key you can hand to scripts

The web pages are one front door; the
**API** is another, and it is how this guide
does most of its remaining work — the same
objects, the same permissions, no clicking.
The API introduces you by a **personal
access token**: a generated string, scoped
to named permissions, shown once at
creation. In the interface you mint one
under your profile's *Access tokens*, with
an expiry date — always set one.

For the lab's first token there was not yet
a comfortable browser session to click
with, so it used the administrator's power
tool, the Rails console runner, with a
four-line script (kept at
`gitlab-lab/make-token.rb`):

```ruby
user = User.find_by_username('root')
token = user.personal_access_tokens.create!(scopes: %i[api read_repository write_repository], name: 'mere-mortals-lab', expires_at: 7.days.from_now)
puts 'TOKEN-VALUE: ' + token.token
puts 'token created for ' + user.username + ', id ' + token.id.to_s
```

```bash
sudo gitlab-rails runner /path/to/make-token.rb
```

```text
token created for root, id 2
```

The scopes deserve a sentence each. `api`
is the broad one — the token can do almost
anything the account can. `read_repository`
and `write_repository` are the narrow git
ones, and a token with only those can clone
and push but cannot administer. **Mint the
narrowest token the job allows**, and treat
every token as a password: it is one. The
lab's transcripts carry their own warning —
an earlier attempt created token id 1 and
failed before its value could be saved, and
an unsaved token is still a working key.
The lab revoked it through the API
(`DELETE /api/v4/personal_access_tokens/1`
answered 204) before going on. Your token
list, in the interface or the API, is worth
an occasional audit.

With the token in hand, introduce yourself:

```bash
curl -s -H "PRIVATE-TOKEN: $TOK" https://your-instance/api/v4/user
```

```text
{"id":1,"username":"root","name":"Administrator","state":"active",...}
```

That answer — your own account, from the
machine — is the key turning in the second
door. The next chapter uses it to build
something.
