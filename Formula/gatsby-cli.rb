require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.11.5.tgz"
  sha256 "c1d3c6ed18d58fa463db20ae062ab0750e7887122321474cf9166aadf0e435a4"

  bottle do
    cellar :any_skip_relocation
    sha256 "caa1a238c5d9460a0d8f1b9840f616959020e9c61eeebf4518b544b7eab082c0" => :catalina
    sha256 "342f741d6e441fa7d9bf0d5c1eb9300e397449153ee8f92b2272f161c4ff92eb" => :mojave
    sha256 "a2fb4118b3c79751842ac860640804eb26c216fb22e512ac38bf71c889e93f65" => :high_sierra
    sha256 "25d4267cbfd1e85500bc179637892205078a6bff0d73f4a7ac56549852b8b141" => :x86_64_linux
  end

  depends_on "node"
  depends_on "linuxbrew/xorg/xorg" unless OS.mac?

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    return if Process.uid.zero?

    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
