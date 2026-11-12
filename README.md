# Forever-Young Tap

## How do I install these formulae?

`brew install forever-young/tap/<formula>`

Or `brew tap forever-young/tap` and then `brew install <formula>`.

Or, in a `brew bundle` `Brewfile`:

```ruby
tap "forever-young/tap"
brew "<formula>"
```

## M-Commander

```sh
brew install forever-young/tap/mcommander
mc
```

Builds [M-Commander](https://github.com/blue-panels/mcommander) directly from
upstream sources, pinned to commit
[`271764985`](https://github.com/blue-panels/mcommander/commit/2717649857e3720de2027b40667e4b57eff251eb)
(November 11, 2026), verified by SHA-256. The formula version
`6.1.0.20261111` identifies this development snapshot; the latest tagged release
is still 6.1.0. Supports macOS; the local build was verified on Apple Silicon.

This snapshot includes the upstream right-prompt fix from
[blue-panels/mcommander#456](https://github.com/blue-panels/mcommander/pull/456).
The zsh right-hand prompt is preserved, and Enter opens directories normally.
No source patches are applied. The old 6.1.0 workaround remains in the tap's
history for reference.

Includes the S-Lang interface, built-in editor and viewer, Lua runtime, and
archive, SFTP, FTP/FTPS and S3 plugins. Samba and MongoDB plugins are disabled
to avoid their large dependencies. Git, Docker and Kubernetes panels use their
respective command-line tools when installed separately.

Run `mc` (also available as `mcommander` or `mc6`); the snapshot also installs
`mcedit6`, `mview`, `mcdiff6`, `mctree` and `mcstruct`. Both packages can remain
installed, but only one can be linked because they
provide the same `mc` command. If stock Midnight Commander is already linked:

```sh
brew unlink midnight-commander
brew install forever-young/tap/mcommander
# If M-Commander was already installed but unlinked:
brew link forever-young/tap/mcommander
```

Switch back without uninstalling either package:

```sh
brew unlink forever-young/tap/mcommander
brew link midnight-commander
```

For future releases, update the source URL and SHA-256 in
`Formula/mcommander.rb` and run:

```sh
brew reinstall --build-from-source forever-young/tap/mcommander
brew test forever-young/tap/mcommander
brew audit --strict forever-young/tap/mcommander
python3 "$(brew --repository forever-young/tap)/tests/mcommander-navigation.py"
```

The PTY regression check verifies navigation with and without zsh RPROMPT and
that typed commands still execute. Add `--real-config` to also test navigation
with your own zsh startup files.

The pinned snapshot uses Meson. When updating, change the commit URL,
SHA-256 and snapshot version together. The formula writes `.tarball-version`
so upstream's version script identifies the build outside a Git checkout.

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).
