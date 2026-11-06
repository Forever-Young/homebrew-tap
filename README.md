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
mcommander
```

Builds [M-Commander](https://github.com/blue-panels/mcommander) 6.1.0 directly
from its upstream release source archive, verified by SHA-256. Supports macOS;
the local build was verified on Apple Silicon.

A [tap-local patch](patches/mcommander/6.1.0-zsh-rprompt.patch) clears zsh's
right-hand prompt only inside the embedded shell. Version 6.1.0 otherwise
mistakes that prompt for command input, so Enter runs an empty command instead
of opening the selected directory. The left prompt and normal terminal
configuration are unchanged. This is a workaround pending upstream support for
right-hand prompts.

Includes the S-Lang interface, built-in editor and viewer, Lua runtime, and
archive, SFTP, FTP/FTPS and S3 plugins. Samba and MongoDB plugins are disabled
to avoid their large dependencies. Git, Docker and Kubernetes panels use their
respective command-line tools when installed separately.

Run `mcommander` or `mc6`; the release also installs `mcedit6`, `mview`, `mdiff`,
`mctree` and `mcstruct`. It can coexist with Homebrew's `midnight-commander`.

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

Release 6.1.0 uses Autotools and includes a generated `configure` script.
The development branch has moved to Meson, so the build commands must also
change when updating to a release that uses Meson. Any future macOS patches
should live in this tap, leaving upstream sources unchanged.

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).
