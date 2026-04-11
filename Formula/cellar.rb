class Cellar < Formula
  desc "Personal wine tasting log"
  homepage "https://github.com/stevedylandev/andromeda"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/cellar/0.1.4/cellar-aarch64-apple-darwin.tar.xz"
      sha256 "9cfa5be1e62cf54a94d859c9d03dd8d5123ca44343211c7c72bf15a51977082a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/cellar/0.1.4/cellar-x86_64-apple-darwin.tar.xz"
      sha256 "64c8811856337120f53609189bf839e8e22f107bf848afb493319cb65a11d194"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/cellar/0.1.4/cellar-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9e0bd51a047ee26bdd9b37852828a745bc9855601898f0a70c09c7fc21bf6fb9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/cellar/0.1.4/cellar-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c8f7a1cc2f99149155f7a00845e9892df298ee8a54df919b968856c5194a2526"
    end
  end
  license "MIT"

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
    bin.install "cellar" if OS.mac? && Hardware::CPU.arm?
    bin.install "cellar" if OS.mac? && Hardware::CPU.intel?
    bin.install "cellar" if OS.linux? && Hardware::CPU.arm?
    bin.install "cellar" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
