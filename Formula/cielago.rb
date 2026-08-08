class Cielago < Formula
  desc "API Client TUI in Rust"
  homepage "https://github.com/stevedylandev/cielago"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/cielago/releases/download/v0.1.1/cielago-aarch64-apple-darwin.tar.xz"
      sha256 "ff497ecba7b0e75dd019f9ee1f11862c382ea3c3269fd7674f59a18866fed2c9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/cielago/releases/download/v0.1.1/cielago-x86_64-apple-darwin.tar.xz"
      sha256 "38c1d24380867fc1eea09d42ec9086d9de5562075f004efebdd9aee549c958a9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/cielago/releases/download/v0.1.1/cielago-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "413020a7198d14f4d6849df5fb4c3d14271700bfe5e47f306399bcc4b45a2ea5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/cielago/releases/download/v0.1.1/cielago-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0b1f1f022768dce9a78674a5452b34b3ea2956bd7815c5d9980bd05a745512ab"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "cielago" if OS.mac? && Hardware::CPU.arm?
    bin.install "cielago" if OS.mac? && Hardware::CPU.intel?
    bin.install "cielago" if OS.linux? && Hardware::CPU.arm?
    bin.install "cielago" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
