class Mcommander < Formula
  desc "Two-panel terminal file manager based on Midnight Commander"
  homepage "https://github.com/blue-panels/mcommander"
  url "https://github.com/blue-panels/mcommander/releases/download/v6.1.0/mcommander-6.1.0.tar.gz"
  sha256 "32fa33be816f9bb40705068ae7b468c2ad640dead8da378a878656562d59fd88"
  license "GPL-3.0-or-later"

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

  def install
    # Keep Homebrew build shims out of the installed syntax definitions.
    ENV["RUBY"] = "/usr/bin/ruby"

    system "./configure", *std_configure_args,
           "--disable-static", "--disable-tests", "--disable-ext2fs-attr",
           "--without-x", "--without-gpm-mouse", "--with-screen=slang",
           "--enable-lua-plugin=yes", "--enable-panel-plugin-sftp=yes",
           "--enable-panel-plugin-ftp=yes", "--enable-panel-plugin-arcmc=yes",
           "--enable-panel-plugin-s3=yes", "--enable-panel-plugin-samba=no",
           "--enable-panel-plugin-mongo=no"
    system "make"
    system "make", "install"
  end

  test do
    ENV["TERM"] = "xterm"
    assert_match version.to_s, shell_output("#{bin}/mcommander --version")
    %w[mc6 mcedit6 mview mdiff mctree mcstruct].each do |command|
      assert_path_exists bin/command
    end
    assert_match "mcommander", shell_output("#{bin}/mcommander --datadir")
  end
end
