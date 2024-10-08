class Sextractor < Formula
  desc "Extract catalogs of sources from astronomical images"
  homepage "https://github.com/astromatic/sextractor"
  url "https://github.com/astromatic/sextractor/archive/refs/tags/2.28.0.tar.gz"
  sha256 "36f5afcdfe74cbf1904038a4def0166c1e1dde883e0030b87280dfbdfcd81969"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia:  "a7f3f31267c07643f9e3a7ced91716a987f07b9eaf4c5eb3243ea7dd159c4c1c"
    sha256 arm64_sonoma:   "9761efd0ae4eec0be229834d9808204849eab6417f207253161113bdaa970340"
    sha256 arm64_ventura:  "f890f87b25e094dab7f32d4e7a28d0ee9d951ce118344f6ec38ceb9d7ce37bb6"
    sha256 arm64_monterey: "d0cba7ea8b343695f081803d00db959a4b981f80c075a9b0934ff47a1ccc36f0"
    sha256 arm64_big_sur:  "00d3ecf36384e6b66201a1aaea674759b64774a8d835f34cd2589b046152dca2"
    sha256 sonoma:         "b8c02004215cf32487ad20bf49ef5b674f104f2197328b1db5859e7eac510d30"
    sha256 ventura:        "7ea54185b59849f1e8d270ecf9f5e38d66e8f63387cb6a87c19d06e0eeba075c"
    sha256 monterey:       "25d43de769cd13d866c705c43b9e266230eec0235aebd2adf864859301ad6214"
    sha256 big_sur:        "af97cc3e983b8fee3cda61881b2a0065721ce6cbc6083e6c1832ac665b98392b"
    sha256 x86_64_linux:   "a32fa6c12d120051b9c572648f867c5b37a39f77b7d135721790893e8ed13276"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "cfitsio"
  depends_on "fftw"
  depends_on "openblas"

  # Switch finite to std::isfinite for ICC and GCC, remove in next release
  patch do
    url "https://github.com/astromatic/sextractor/commit/ced65570cb5b7073361dbf2c3c60631c3f54d0f9.patch?full_index=1"
    sha256 "a037f0ece38d7ad57ff831615f22f1d0017a699a78c9c7525c78b4b20cb621be"
  end

  def install
    openblas = Formula["openblas"]
    system "./autogen.sh"
    system "./configure", *std_configure_args,
           "--disable-silent-rules",
           "--enable-openblas",
           "--with-openblas-libdir=#{openblas.lib}",
           "--with-openblas-incdir=#{openblas.include}"
    system "make", "install"
    # Remove references to Homebrew shims
    rm Dir["tests/Makefile*"]
    pkgshare.install "tests"
  end

  test do
    cp_r Dir[pkgshare/"tests/*"], testpath
    system bin/"sex", "galaxies.fits", "-WEIGHT_IMAGE", "galaxies.weight.fits", "-CATALOG_NAME", "galaxies.cat"
    assert_predicate testpath/"galaxies.cat", :exist?, "Failed to create galaxies.cat"
  end
end
