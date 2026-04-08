class Posts < Formula
  desc "CMS blog with admin interface"
  homepage "https://github.com/stevedylandev/andromeda"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/posts/0.1.3/posts-aarch64-apple-darwin.tar.xz"
      sha256 "2368a653b24da610cf6d391af3bd2388609555f369d61fce50f355a483685b12"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/posts/0.1.3/posts-x86_64-apple-darwin.tar.xz"
      sha256 "511c718f9c35a5c41d9e5eaadf7ff6e61b8bdc884effb794df530fa15a73d804"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/posts/0.1.3/posts-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f8d634006f2d67eb165a25f01b577861a09f9eb494fd4099d27139dba8269f85"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/posts/0.1.3/posts-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6a13e042c66b3d94f5ed3fce05370a38420a41bd0b00e40f9e559f8ea79b528e"
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
