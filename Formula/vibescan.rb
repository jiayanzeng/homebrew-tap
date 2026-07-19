class Vibescan < Formula
  desc "Command-line interface for vibescan"
  homepage "https://github.com/jiayanzeng/vibescan"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jiayanzeng/vibescan/releases/download/v0.1.3/vibescan-cli-aarch64-apple-darwin.tar.xz"
      sha256 "5ecf74f97e378f57d6c67dd50dfef62647f3b7ffc222d9a4f97d7810df67fc95"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jiayanzeng/vibescan/releases/download/v0.1.3/vibescan-cli-x86_64-apple-darwin.tar.xz"
      sha256 "1a010bfb0a5643d88daf8d3ecb0c8fb2dffcc3082687df34a81aad361b42cfd8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jiayanzeng/vibescan/releases/download/v0.1.3/vibescan-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "7bd770ff5b2a8d159c96d65d32d311e66b227c88633d9cabe55dff78b788d008"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jiayanzeng/vibescan/releases/download/v0.1.3/vibescan-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "d4a48575c83b572b624a4ac67b2e70f8ba58c4ff3ad41099a6a5a9c4c25af5d3"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "vibescan" if OS.mac? && Hardware::CPU.arm?
    bin.install "vibescan" if OS.mac? && Hardware::CPU.intel?
    bin.install "vibescan" if OS.linux? && Hardware::CPU.arm?
    bin.install "vibescan" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
