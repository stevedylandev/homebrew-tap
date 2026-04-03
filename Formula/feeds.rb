class Feeds < Formula
  desc "Minimal RSS feed reader"
  homepage "https://github.com/stevedylandev/andromeda"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/feeds/0.1.1/feeds-aarch64-apple-darwin.tar.xz"
      sha256 "fcf0309fce4a19378fbc12b309ba7635b5e4c6f66814f335a2b741c726c6f575"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/feeds/0.1.1/feeds-x86_64-apple-darwin.tar.xz"
      sha256 "13ce876ef4374de1b4b6b63f7504dfb2a4e33f338944da548c0583d948e33e68"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/feeds/0.1.1/feeds-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1ef4eaae1c8f3b374f2de27b09fd87ae2a65ffec0e31278b02a3587f89c0e9d6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/feeds/0.1.1/feeds-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5490e9aab195ab5ea1056170c4f7f73d2c2209c73e4a1f6ee59e7b2bbac30066"
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
