class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.80.1.tar.gz"
  sha256 "bfcea48761a103e81fc5ac66fd0abd85b06a5f7ea39d91546633bab8a9a00dbe"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3260528dbfdfa5a735f6baa12cef5d8e41fd102684b64b1ee29f7baf689b4dd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3260528dbfdfa5a735f6baa12cef5d8e41fd102684b64b1ee29f7baf689b4dd3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3260528dbfdfa5a735f6baa12cef5d8e41fd102684b64b1ee29f7baf689b4dd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "72fbeca5838c69281acdf7d888aedcc3fc18ec55b2641c057b18e04486154e24"
    sha256 cellar: :any_skip_relocation, ventura:       "72fbeca5838c69281acdf7d888aedcc3fc18ec55b2641c057b18e04486154e24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c6496818a4a7c28fe146524a9765d6d320a8d00db6af6cfed5fcd4c720091b4"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
