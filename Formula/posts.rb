class Posts < Formula
  desc "CMS blog with admin interface"
  homepage "https://github.com/stevedylandev/andromeda"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/posts/0.2.0/posts-aarch64-apple-darwin.tar.xz"
      sha256 "53f009dc3ebff7420696a1667f8b9d926d59e870acb7048c954ad737e3e7aa6e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/posts/0.2.0/posts-x86_64-apple-darwin.tar.xz"
      sha256 "f6ca5eb55dd6944a5c589d1eef38469c84b5984ef428d9dcb19225a5a480cf5f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/posts/0.2.0/posts-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c14db2a51e9f104fee44410be9ab9f01b20dac8c67b892d201a07e280e5f7ae6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/posts/0.2.0/posts-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "617b72dfd19f0c5b9002e524321088b6a73b06a6b23e144a3839f500c96c4ab6"
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
