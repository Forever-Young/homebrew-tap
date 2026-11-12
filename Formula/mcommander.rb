class Mcommander < Formula
  desc "Two-panel terminal file manager based on Midnight Commander"
  homepage "https://github.com/blue-panels/mcommander"
  url "https://github.com/blue-panels/mcommander/archive/2717649857e3720de2027b40667e4b57eff251eb.tar.gz"
  version "6.1.0.20261111"
  sha256 "5ca74e5e059440a0b2832b2738e726fb784db2328da0c5ce12306ff2c68ad811"
  license "GPL-3.0-or-later"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "curl"
  depends_on "gettext"
  depends_on "glib"
  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "libssh2"
  depends_on "lua"
  depends_on :macos
  depends_on "s-lang"

  conflicts_with "midnight-commander", because: "both install the mc command"

  def install
    # GitHub commit archives have no .git directory for upstream's version.sh.
    (buildpath/".tarball-version").write "#{version}\n"

    # Avoid embedding Homebrew's temporary Ruby shim in syntax definitions.
    (buildpath/"homebrew-native.ini").write "[binaries]\nruby = '/usr/bin/ruby'\n"

    system "meson", "setup", "build", *std_meson_args,
           "--native-file=#{buildpath}/homebrew-native.ini",
           "-Dscreen=slang", "-Dgpm=disabled", "-Dx11=disabled",
           "-Dext2fs_attr=disabled", "-Dtests=disabled", "-Dsession=disabled",
           "-Dlua=enabled", "-Dpanel_plugin_sftp=enabled",
           "-Dpanel_plugin_ftp=enabled", "-Dpanel_plugin_arcmc=enabled",
           "-Dpanel_plugin_s3=enabled", "-Dpanel_plugin_samba=disabled",
           "-Dpanel_plugin_mongo=disabled", "-Dpanel_plugin_acl=disabled",
           "-Dpanel_plugin_postgres=disabled"
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
    bin.install_symlink "mcommander" => "mc"
  end

  def caveats
    <<~EOS
      Run mc to launch M-Commander.

      To switch from stock Midnight Commander without uninstalling it:
        brew unlink midnight-commander
        brew link forever-young/tap/mcommander

      To switch back:
        brew unlink forever-young/tap/mcommander
        brew link midnight-commander
    EOS
  end

  test do
    ENV["TERM"] = "xterm"
    assert_match version.to_s, shell_output("#{bin}/mcommander --version")
    assert_match version.to_s, shell_output("#{bin}/mc --version")
    %w[mc6 mcedit6 mview mcdiff6 mctree mcstruct].each do |command|
      assert_path_exists bin/command
    end
    assert_match "mcommander", shell_output("#{bin}/mcommander --datadir")
  end
end
