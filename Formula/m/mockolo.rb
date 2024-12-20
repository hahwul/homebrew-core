class Mockolo < Formula
  desc "Efficient Mock Generator for Swift"
  homepage "https://github.com/uber/mockolo"
  url "https://github.com/uber/mockolo/archive/refs/tags/2.1.1.tar.gz"
  sha256 "6707a0a7b73822f9c6cf986a73a9adc452b3052e38b87169432c0893948861da"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a52b3fb229429ecbbdbb5364d7d4380183b7fd70f805ca5846b8e36b52642bd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c247e590442eaed00151e9f0a89d6dd6bacc6ea41316f64a5a737e7da726985"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a91db23727d736125f17987131edb5c8f0a4634724b0cff6f73c7a6986315c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7a3cbecc795c95ef277406051c4d87904fe770c83c3ff9f70f7e95f5cb13930"
    sha256 cellar: :any_skip_relocation, ventura:       "b15049d8170ece9b3fc1461ff3a5e21dbdbda971032d39e83d741a2dab320f52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a0dfa912abfa8ec8b1156c687e5a1a5ac8a90526a38a3c6fa531fdfae35dfbe"
  end

  depends_on xcode: ["14.0", :build]

  uses_from_macos "swift" => :build

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "-c", "release", "--product", "mockolo"
    bin.install ".build/release/mockolo"
  end

  test do
    (testpath/"testfile.swift").write <<~SWIFT
      /// @mockable
      public protocol Foo {
          var num: Int { get set }
          func bar(arg: Float) -> String
      }
    SWIFT
    system bin/"mockolo", "-srcs", testpath/"testfile.swift", "-d", testpath/"GeneratedMocks.swift"
    assert_predicate testpath/"GeneratedMocks.swift", :exist?
    output = <<~SWIFT.gsub(/\s+/, "").strip
      ///
      /// @Generated by Mockolo
      ///
      public class FooMock: Foo {
        public init() { }
        public init(num: Int = 0) {
            self.num = num
        }

        public private(set) var numSetCallCount = 0
        public var num: Int = 0 { didSet { numSetCallCount += 1 } }

        public private(set) var barCallCount = 0
        public var barHandler: ((Float) -> (String))?
        public func bar(arg: Float) -> String {
            barCallCount += 1
            if let barHandler = barHandler {
                return barHandler(arg)
            }
            return ""
        }
      }
    SWIFT
    assert_equal output, shell_output("cat #{testpath/"GeneratedMocks.swift"}").gsub(/\s+/, "").strip
  end
end
