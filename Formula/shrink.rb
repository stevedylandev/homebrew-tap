class Shrink < Formula
  desc "Minimal image compression and resizing service"
  homepage "https://github.com/stevedylandev/andromeda"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/shrink/0.1.2/shrink-aarch64-apple-darwin.tar.xz"
      sha256 "4dca8bea4b3a0353b6f36475cb3730638489bf2caf11895861d87266c2d07239"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/shrink/0.1.2/shrink-x86_64-apple-darwin.tar.xz"
      sha256 "19dafb7d06d4fc73690367ff323c82ca504cd84bf51e5a885b13c26bd77d0b73"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/shrink/0.1.2/shrink-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2ddb35514a2400065b56ede6fd377678509e69dcabca56ca636df9b939f4f892"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/shrink/0.1.2/shrink-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "deaba9e6c0ad7a1d0d070d6e2bebedd5267f26df2427f94506796675f1ae1208"
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
