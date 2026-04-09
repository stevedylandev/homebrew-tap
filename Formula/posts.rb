class Posts < Formula
  desc "CMS blog with admin interface"
  homepage "https://github.com/stevedylandev/andromeda"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/posts/0.1.4/posts-aarch64-apple-darwin.tar.xz"
      sha256 "3c045bf605853ee6f5f14d880650810be4dbbc96f33a18523a5dccba012348cf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/posts/0.1.4/posts-x86_64-apple-darwin.tar.xz"
      sha256 "7b2e51ac7b19511dba2575b2dbcaca6b537f21573cd05fa2ee5ea567bc7a03e2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/posts/0.1.4/posts-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "991c99a09dc4c43d50a30478102b133e7a6f3b116c961449ef0e3284529a660e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/posts/0.1.4/posts-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "106731889e32de5b96242b9230556d26b01692df0601c1165eee2ec8744c989f"
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
    bin.install "posts" if OS.mac? && Hardware::CPU.arm?
    bin.install "posts" if OS.mac? && Hardware::CPU.intel?
    bin.install "posts" if OS.linux? && Hardware::CPU.arm?
    bin.install "posts" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
