class Feeds < Formula
  desc "Minimal RSS feed reader"
  homepage "https://github.com/stevedylandev/andromeda"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/feeds/0.3.0/feeds-aarch64-apple-darwin.tar.xz"
      sha256 "d46a08208a98dc37ceb9ca0efc9e565bb6ffae518f28a64d914eeb9fa2fb4835"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/feeds/0.3.0/feeds-x86_64-apple-darwin.tar.xz"
      sha256 "b2c6b86181be491cfca78dbfac14c8007785db67d15864548342ce160dbe1e42"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/feeds/0.3.0/feeds-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8b89d3e0dcdfeef690f233c68c20b2b1b9f03a5c8e3e1947b492f442434b5210"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/feeds/0.3.0/feeds-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d55b213c20f66a8ad93ee85a78388935208159db556ef050fd74aaef68d5c974"
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
    bin.install "feeds" if OS.mac? && Hardware::CPU.arm?
    bin.install "feeds" if OS.mac? && Hardware::CPU.intel?
    bin.install "feeds" if OS.linux? && Hardware::CPU.arm?
    bin.install "feeds" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
