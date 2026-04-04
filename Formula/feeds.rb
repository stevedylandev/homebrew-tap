class Feeds < Formula
  desc "Minimal RSS feed reader"
  homepage "https://github.com/stevedylandev/andromeda"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/feeds/0.1.2/feeds-aarch64-apple-darwin.tar.xz"
      sha256 "43a558a655e4ace462bb3ad47d306c9a0525b3c2d3e4aa7c9f1433bf06577ab3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/feeds/0.1.2/feeds-x86_64-apple-darwin.tar.xz"
      sha256 "ab60d52951b98b50353be40f84d54bdb1a77dff4828bee3f58b7837acb7059cf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/feeds/0.1.2/feeds-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c4193e8333a89f21a87fbed26a85da6843192de69625cfea075fa48c6db502db"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/feeds/0.1.2/feeds-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5fa305c72bd4b59b0b95d50001bf177db6714b198567cc14afc8e14bc1a04181"
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
