class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    :tag      => "v4.11.0",
    :revision => "b9a1e6a541df4b82f3ca9c88ae3698e85f98cc56"

  bottle do
    cellar :any_skip_relocation
    sha256 "7886378acea055f68e48d875f545735f384da57cdbfebfcd809799c220a9aeb2" => :catalina
    sha256 "994777d62e1fc200f8ce55eb7a1421b932828201046bc04b8eb9f2e8fdfd66ac" => :mojave
    sha256 "74a428d8fc1645a8315868c432d3320ba35f7aa1961f2dc7969d0a4c315088bf" => :high_sierra
    sha256 "002b64813ad1cd7158446f5fb207aad3be50b20c281a496aa1b7027510d84fb6" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    system "go", "build", "-trimpath", "-o", bin/"devspace"
    prefix.install_metafiles
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end
