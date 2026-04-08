class Posts < Formula
  desc "CMS blog with admin interface"
  homepage "https://github.com/stevedylandev/andromeda"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/posts/0.1.2/posts-aarch64-apple-darwin.tar.xz"
      sha256 "2014cb0a8a9d35018539e9111f9d69dcb2d0baa1ba9bec770bcd2081f51427a7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/posts/0.1.2/posts-x86_64-apple-darwin.tar.xz"
      sha256 "16000d7568a4125380cb20ac66586081d9be754a6c9c43910c8b151439086637"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/posts/0.1.2/posts-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "95ca5fbf5d3affe6d23c97b975559e0edb236a219d1fb96f6143b898f56a2e39"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/posts/0.1.2/posts-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1d0e695c6a32cbfdaca15300c92a0154e82a6b5767dcbc542ec416d3e53bc779"
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
