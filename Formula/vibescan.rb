class Vibescan < Formula
  desc "Command-line interface for vibescan"
  homepage "https://github.com/jiayanzeng/vibescan"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jiayanzeng/vibescan/releases/download/v0.2.0/vibescan-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b6ad4aa530e3a0602bbfa2c3b1199208c84c37e2157bc31199c0fef3ebe367b9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jiayanzeng/vibescan/releases/download/v0.2.0/vibescan-cli-x86_64-apple-darwin.tar.xz"
      sha256 "5aa48d0e542938bfc6603f02003ec7076568f8ffd22a05cf59f093bad70182bc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jiayanzeng/vibescan/releases/download/v0.2.0/vibescan-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "291f14485b82f120977ba0fa11144fd2bab4f208525074c8eaa41291260dfca8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jiayanzeng/vibescan/releases/download/v0.2.0/vibescan-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "df67a8bb2271c92851b8ad929211bd0c50c41d0305c9ae1d5fa09c2774a4588e"
    end
  end
  license "PolyForm-Noncommercial-1.0.0"

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
