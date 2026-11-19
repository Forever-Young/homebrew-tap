class CloudshareCli < Formula
  desc "Upload files to your S3-compatible bucket through the CloudShare Mac app"
  homepage "https://github.com/Forever-Young/homebrew-tap"
  url "https://github.com/Forever-Young/homebrew-tap/releases/download/cloudshare-cli-1.1/cloudshare-cli-1.1.zip"
  version "1.1"
  sha256 "2e65041775a64c3b5be62c19a57aae9d69d87e5f012f0af92455fbdbb3f50742"

  depends_on macos: :sequoia

  def install
    # The provisioning profile that lets the tool reach the app's shared container lives in
    # the signed bundle, so the bundle is installed whole and only the executable is linked.
    (libexec/"cloudshare.app").install "Contents"
    bin.install_symlink libexec/"cloudshare.app/Contents/MacOS/cloudshare"
  end

  def caveats
    <<~EOS
      cloudshare talks to the CloudShare Mac app, which does the upload. Install CloudShare
      from the Mac App Store, set up your storage and open it once.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cloudshare --version")
  end
end
