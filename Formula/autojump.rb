class Autojump < Formula
  desc "Shell extension to jump to frequently used directories"
  homepage "https://github.com/wting/autojump"
  url "https://github.com/wting/autojump/archive/release-v22.5.3.tar.gz"
  sha256 "00daf3698e17ac3ac788d529877c03ee80c3790472a85d0ed063ac3a354c37b1"
  head "https://github.com/wting/autojump.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "11ab5e57c200bd21825899a7f2a7792afd0c19f8c065729e56673f5f949a97e7" => :catalina
    sha256 "5576b3f2b9fcb2a236d6ac22b163af03994edb98b69c997ed5a88db85c8d0a15" => :mojave
    sha256 "5576b3f2b9fcb2a236d6ac22b163af03994edb98b69c997ed5a88db85c8d0a15" => :high_sierra
    sha256 "c95107719bd784e0e348be6dbfb3a780240d96f8d76710271c3642335babbd8f" => :sierra
    sha256 "922ca87c1c1f1cb50bb7a8d68d06c0709ea5ed6e5aa71ecd5b72eb370fcc7449" => :x86_64_linux
  end

  depends_on :macos # Due to Python 2

  def install
    system "./install.py", "-d", prefix, "-z", zsh_completion

    # Backwards compatibility for users that have the old path in .bash_profile
    # or .zshrc
    (prefix/"etc").install_symlink prefix/"etc/profile.d/autojump.sh"

    libexec.install bin
    bin.write_exec_script libexec/"bin/autojump"
  end

  def caveats
    <<~EOS
      Add the following line to your ~/.bash_profile or ~/.zshrc file (and remember
      to source the file to update your current session):
        [ -f #{etc}/profile.d/autojump.sh ] && . #{etc}/profile.d/autojump.sh

      If you use the Fish shell then add the following line to your ~/.config/fish/config.fish:
        [ -f #{HOMEBREW_PREFIX}/share/autojump/autojump.fish ]; and source #{HOMEBREW_PREFIX}/share/autojump/autojump.fish
    EOS
  end

  test do
    path = testpath/"foo/bar"
    path.mkpath
    output = shell_output("bash -c '. #{etc}/profile.d/autojump.sh; j -a #{path.relative_path_from(testpath)}; j foo >/dev/null; pwd'").strip
    assert_equal path.realpath.to_s, output
  end
end
