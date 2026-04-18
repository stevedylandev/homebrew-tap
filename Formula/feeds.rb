class Feeds < Formula
  desc "Minimal RSS feed reader"
  homepage "https://github.com/stevedylandev/andromeda"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/feeds/0.2.0/feeds-aarch64-apple-darwin.tar.xz"
      sha256 "071e819d14768828023e11b382ebb4d80676b9371136b57506f52575e3c109cc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/feeds/0.2.0/feeds-x86_64-apple-darwin.tar.xz"
      sha256 "b636a7121c1800a7b2edbf5bd9697dbe2c1a596886e546c3ba547fae060517ed"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/feeds/0.2.0/feeds-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5482169e8b7ac5cc03e0e245c55ada0ba484e56d286d622982d71b5c7b8e7142"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/feeds/0.2.0/feeds-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "50400750ec420c3db69cad812bb8b8c2f5dea23c7a98f30b43f9146009923bc7"
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
