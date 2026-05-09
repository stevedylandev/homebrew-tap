class Bookmarks < Formula
  desc "Personal link saver"
  homepage "https://github.com/stevedylandev/andromeda"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/bookmarks/0.1.0/bookmarks-aarch64-apple-darwin.tar.xz"
      sha256 "161330846d33f19aecdeca230cb1dd004b79e2a4e42e2135108cf44cb9c9edae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/bookmarks/0.1.0/bookmarks-x86_64-apple-darwin.tar.xz"
      sha256 "836e1bd645d773f8cfbb5c7f7b9b955efc644f499b6bccc1215a50a0ced1bbbf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/bookmarks/0.1.0/bookmarks-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ccec66cd9fe06864c0ee2d9fc3af9e4deea4b8d18789e2642db77b3d6f97f46c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/bookmarks/0.1.0/bookmarks-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5cb37a72cd314b6bb2b456e86dc5242dacfc764817f9e94e9ea3b9473fe8e697"
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
    bin.install "bookmarks" if OS.mac? && Hardware::CPU.arm?
    bin.install "bookmarks" if OS.mac? && Hardware::CPU.intel?
    bin.install "bookmarks" if OS.linux? && Hardware::CPU.arm?
    bin.install "bookmarks" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
