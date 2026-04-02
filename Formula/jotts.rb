class Jotts < Formula
  desc "Minimal markdown note app"
  homepage "https://github.com/stevedylandev/andromeda"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/jotts/0.1.1/jotts-aarch64-apple-darwin.tar.xz"
      sha256 "fb5ac76ab5bba493041598023795498b1e33be5262bbcfe60a08a9b4e680afab"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/jotts/0.1.1/jotts-x86_64-apple-darwin.tar.xz"
      sha256 "9f3cf8de3cd8d71d73ac5ae4659168fdff4aa0266ab3abf1da09e4d6f11ebcc4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/jotts/0.1.1/jotts-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "874efac64f7c56cfdc218ca761d8a02b54a641586de2b426cb46d51f903a459a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/jotts/0.1.1/jotts-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7edf6569c09d3efd2e100170b62c95087123d5024b97f013238f4b8a185cd5b7"
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
    bin.install "jotts" if OS.mac? && Hardware::CPU.arm?
    bin.install "jotts" if OS.mac? && Hardware::CPU.intel?
    bin.install "jotts" if OS.linux? && Hardware::CPU.arm?
    bin.install "jotts" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
