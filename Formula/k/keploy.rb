class Keploy < Formula
  desc "Testing Toolkit creates test-cases and data mocks from API calls, DB queries"
  homepage "https://keploy.io"
  url "https://github.com/keploy/keploy/archive/refs/tags/v2.4.16.tar.gz"
  sha256 "09f6782ec2e62a00bab2d6125a57410a7d5ac001ba2ca3bbdf8e6472d457b49b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27650a305095705011eb22d36719d560f4d0a28e88f9d3e6408e6ddf24e98f49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27650a305095705011eb22d36719d560f4d0a28e88f9d3e6408e6ddf24e98f49"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "27650a305095705011eb22d36719d560f4d0a28e88f9d3e6408e6ddf24e98f49"
    sha256 cellar: :any_skip_relocation, sonoma:        "0662c04183c20a8a33faae8cf5151baa7cf7b5247557904f12249454204dd9d1"
    sha256 cellar: :any_skip_relocation, ventura:       "0662c04183c20a8a33faae8cf5151baa7cf7b5247557904f12249454204dd9d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87544e42b1968615bb04f381c45f2bdd7012fe260f2d3cbc234df1f20b751fcf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    system bin/"keploy", "config", "--generate", "--path", testpath
    assert_match "# Generated by Keploy", (testpath/"keploy.yml").read

    output = shell_output("#{bin}/keploy templatize --path #{testpath}")
    assert_match "No test sets found to templatize", output

    assert_match version.to_s, shell_output("#{bin}/keploy --version")
  end
end
