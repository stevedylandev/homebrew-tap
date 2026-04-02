class Shrink < Formula
  desc "Minimal image compression and resizing service"
  homepage "https://github.com/stevedylandev/andromeda"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/shrink/0.1.1/shrink-aarch64-apple-darwin.tar.xz"
      sha256 "8e159a874986e4d19d0a4b46f40c18ae2fbb45b72f532502f41a72b22de24ce9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/shrink/0.1.1/shrink-x86_64-apple-darwin.tar.xz"
      sha256 "bc6e4a9d36ae0fc712f04819f4bfa7d5288402fc228f3fe24d87b25b42f1e09f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/shrink/0.1.1/shrink-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8fbc3ccf98f339c413786abd2b0076e3fc39dc9df65bfb98c0fc262ce9fcb81c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/shrink/0.1.1/shrink-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4d90aaa783256128c0ae2301f804eb44e55ebbb00373b526d45221b60a4b8c79"
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
    bin.install "shrink" if OS.mac? && Hardware::CPU.arm?
    bin.install "shrink" if OS.mac? && Hardware::CPU.intel?
    bin.install "shrink" if OS.linux? && Hardware::CPU.arm?
    bin.install "shrink" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
