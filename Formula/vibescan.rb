class Vibescan < Formula
  desc "Command-line interface for vibescan"
  homepage "https://github.com/jiayanzeng/vibescan"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jiayanzeng/vibescan/releases/download/v0.1.2/vibescan-cli-aarch64-apple-darwin.tar.xz"
      sha256 "2b9a5e637806a0f7d0cd8e400292861e8da99eea5ff2597a297f87dbfdada483"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jiayanzeng/vibescan/releases/download/v0.1.2/vibescan-cli-x86_64-apple-darwin.tar.xz"
      sha256 "020d7fd0c1e52ae9681fe3b93936ea5413e7c87bb8a4efbead6caf10dae7df4a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jiayanzeng/vibescan/releases/download/v0.1.2/vibescan-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "b04d26d17abe30a238dc9cff8173f6756a692ec651f4ee159066777f1143a0c3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jiayanzeng/vibescan/releases/download/v0.1.2/vibescan-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "d72647b7752ca5d6d39178da202f82ec23668e010bc631c0d67091d243312ffa"
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
