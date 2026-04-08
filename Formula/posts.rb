class Posts < Formula
  desc "CMS blog with admin interface"
  homepage "https://github.com/stevedylandev/andromeda"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/posts/0.1.1/posts-aarch64-apple-darwin.tar.xz"
      sha256 "6295caafc6bd9f367a8c2caf99c85c921fcb48d48f3f60d6dade7cd85349eef7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/posts/0.1.1/posts-x86_64-apple-darwin.tar.xz"
      sha256 "b4fcb179ce78fb7224c1d2f83223a0d0479381a2006f82b8bf4af4080040c05a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/posts/0.1.1/posts-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e47476f8eeb2463442bef560a95b6eed40281379a9affb8f35405729e8d8da9e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/posts/0.1.1/posts-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7e1aac2b25367fa9e23b31af11ef1acc8382582799b49bfe19390a56b93438e2"
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
