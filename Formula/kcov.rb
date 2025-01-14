class Kcov < Formula
  desc "Code coverage tester for compiled programs, Python, and shell scripts"
  homepage "https://simonkagstrom.github.io/kcov/"
  url "https://github.com/SimonKagstrom/kcov/archive/38.tar.gz"
  sha256 "b37af60d81a9b1e3b140f9473bdcb7975af12040feb24cc666f9bb2bb0be68b4"
  head "https://github.com/SimonKagstrom/kcov.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a3af28e85c85c6f1dc684086884c724dfdbcf72efca48add536c5dd08bda4c0" => :catalina
    sha256 "833750a5d75e99a392010b305841daca6d0007e5a9b2ccd2ab5d54f18c01b6ad" => :mojave
    sha256 "e5c6cc5b5ed21b5609107cb80ac67dec4ffc9b9227e272464b9eeade66932bd3" => :high_sierra
    sha256 "753c990c08ad1f08aaf0595db7418289f0fd586e08182e16bffb50748ff49b3e" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build
  depends_on :macos # Due to Python 2

  depends_on :macos # Due to Python 2
  unless OS.mac?
    depends_on "curl"
    depends_on "elfutils"
    depends_on "python@2"
    depends_on "zlib"
  end

  def install
    mkdir "build" do
      system "cmake", "-DSPECIFY_RPATH=ON", *std_cmake_args, ".."
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"hello.bash").write <<~EOS
      #!/bin/bash
      echo "Hello, world!"
    EOS
    system "#{bin}/kcov", testpath/"out", testpath/"hello.bash"
    assert_predicate testpath/"out/hello.bash/coverage.json", :exist?
  end
end
