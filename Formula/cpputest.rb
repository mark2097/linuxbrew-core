class Cpputest < Formula
  desc "C /C++ based unit xUnit test framework"
  homepage "https://www.cpputest.org/"
  url "https://github.com/cpputest/cpputest/releases/download/v3.8/cpputest-3.8.tar.gz"
  sha256 "c81dccc5a1bfc7fc6511590c0a61def5f78e3fb19cb8e1f889d8d3395a476456"
  head "https://github.com/cpputest/cpputest.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a8ee9e29b325d9e72a799cb182fa2538969a9d0eef4c72483f95d75fcfef3407" => :catalina
    sha256 "0b9d6f1c2a89d9e69ec470882b40903d5d6aee5c784397c9b85f6874ea7c71ed" => :mojave
    sha256 "35e26ea6ad2e7f6a86646a73b24aced18f79791792052cf41fab20ab07c8c117" => :high_sierra
    sha256 "47343762cc3b1b76538115940177a710897254ddf3e968c6a7161c0dd4dc505c" => :sierra
    sha256 "8c0b631188acc7fc0e6e5a8a2502871e4856990786fcb1268b32da7058304297" => :el_capitan
    sha256 "415557e97a8e876764595006b205bd9c61fce448558d22863306ca6b22a30e12" => :yosemite
    sha256 "12d974e118f21b0858c74db544604b7c984d72610a74883ffed12639965d7b99" => :mavericks
    sha256 "709c36f503901875db90f9953afe08dcd9cc4fb2c7d8807e3de1d5bd405b8fda" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    cd "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "CppUTest/CommandLineTestRunner.h"
      int main(int ac, char** av)
      {
        return CommandLineTestRunner::RunAllTests(ac, av);
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lCppUTest", "-o", "test"
    assert_match /OK \(0 tests/, shell_output("./test")
  end
end
