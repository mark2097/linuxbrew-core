class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.40.0.tar.gz"
  sha256 "2a1877097183b9a47bad7a0942174b4a98ad6182db29d7d76720ee709fcf4c02"
  revision 1
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a6a9aed27da78a3841555e1cf1ee16c8d74c8ad3ec5bbd7746c26976e4102a87" => :catalina
    sha256 "54f40fde3b2a06ce1a7714c9162734dec4b0b3076818e141cb06a643d061b841" => :mojave
    sha256 "8f9e046605109fc38e5e762629cb563c479ca6cff35a587f45bba54897c457a0" => :high_sierra
    sha256 "bf48db12133d652a8b687305bff6b56a017cb8ff0e9e50cc3290db03ad86ee44" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    doctl_version = version.to_s.split(/\./)

    src = buildpath/"src/github.com/digitalocean/doctl"
    src.install buildpath.children
    src.cd do
      base_flag = "-X github.com/digitalocean/doctl"
      ldflags = %W[
        #{base_flag}.Major=#{doctl_version[0]}
        #{base_flag}.Minor=#{doctl_version[1]}
        #{base_flag}.Patch=#{doctl_version[2]}
        #{base_flag}.Label=release
      ].join(" ")
      system "go", "build", "-ldflags", ldflags, "-o", bin/"doctl", "github.com/digitalocean/doctl/cmd/doctl"
    end

    (bash_completion/"doctl").write `#{bin}/doctl completion bash`
    (zsh_completion/"_doctl").write `#{bin}/doctl completion zsh`
    (fish_completion/"doctl.fish").write `#{bin}/doctl completion fish`
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
