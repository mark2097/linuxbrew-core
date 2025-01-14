class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://github.com/falkTX/Carla/archive/v2.0.0.tar.gz"
  sha256 "d0c8d8417f8cce9abe807f6359231f187d60db7121ec1dccce3b596a22ef6c41"
  revision 3
  head "https://github.com/falkTX/Carla.git"

  bottle do
    cellar :any
    sha256 "4c87b641d0b342a0ae6f9adf1a33cc0d6b4c442148edd47fda80cd64f95b71bc" => :catalina
    sha256 "28f491373706b273c19553b39959ac8216da1529711fb0bfae476de982eec79f" => :mojave
    sha256 "b1407f9b72fbc3c351382015a6ae99cc2aedff289674cec1409c381f2230cc1f" => :high_sierra
    sha256 "74a120d3f26e79749d5329d32e80b79dada3cf0395d181d6ac23855dcc75a4a1" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "liblo"
  depends_on "libmagic"
  depends_on "pyqt"
  depends_on "python@3.8"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"

    inreplace bin/"carla", "PYTHON=$(which python3 2>/dev/null)",
                           "PYTHON=#{Formula["python@3.8"].opt_bin}/python3"
  end

  test do
    system bin/"carla", "--version"
    system lib/"carla/carla-discovery-native", "internal", ":all"
  end
end
