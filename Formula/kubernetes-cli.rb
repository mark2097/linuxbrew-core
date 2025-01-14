class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      :tag      => "v1.18.1",
      :revision => "7879fc12a63337efff607952a323df90cdc7a335"
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0b3d688ee458b70b914a37a4ba867e202c6e71190d0c40a27f84628aec744749" => :catalina
    sha256 "21fddfc86ec6d3e4f7ea787310b0fafd845d368de37524569bbe45938b18ba09" => :mojave
    sha256 "1e20dcd177fd16b862b2432950984807b048cca5879c27bec59e85590f40eece" => :high_sierra
    sha256 "18de6ed8543eb661c994a1a6f704e3f6bbf6c481d987a7cc8d16ffbb92941361" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "rsync" => :build unless OS.mac?

  def install
    ENV["GOPATH"] = buildpath
    os = OS.linux? ? "linux" : "darwin"
    dir = buildpath/"src/k8s.io/kubernetes"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      # Race condition still exists in OS X Yosemite
      # Filed issue: https://github.com/kubernetes/kubernetes/issues/34635
      ENV.deparallelize { system "make", "generated_files" }

      # Make binary
      system "make", "kubectl"
      bin.install "_output/local/bin/#{os}/amd64/kubectl"

      # Install bash completion
      output = Utils.popen_read("#{bin}/kubectl completion bash")
      (bash_completion/"kubectl").write output

      # Install zsh completion
      output = Utils.popen_read("#{bin}/kubectl completion zsh")
      (zsh_completion/"_kubectl").write output

      prefix.install_metafiles

      # Install man pages
      # Leave this step for the end as this dirties the git tree
      system "hack/generate-docs.sh"
      man1.install Dir["docs/man/man1/*.1"]
    end
  end

  test do
    run_output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", run_output

    version_output = shell_output("#{bin}/kubectl version --client 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
    if build.stable?
      assert_match stable.instance_variable_get(:@resource)
                         .instance_variable_get(:@specs)[:revision],
                   version_output
    end
  end
end
