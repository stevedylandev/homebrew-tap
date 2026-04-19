class Cellar < Formula
  desc "Personal wine tasting log"
  homepage "https://github.com/stevedylandev/andromeda"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/cellar/0.2.1/cellar-aarch64-apple-darwin.tar.xz"
      sha256 "2ddd1466fdaa21313458cb48aaf8ae32393a3c7054eae9987009d3a8419bdb8b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/cellar/0.2.1/cellar-x86_64-apple-darwin.tar.xz"
      sha256 "9ad512edc7cffd1b38175e7ecaaaad6583db9ee429ef41c3a79883d856ab6d42"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/cellar/0.2.1/cellar-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f8e20712e071387887657a1f0f7a580a778fbd0fb808f8bfd163edff5f32613b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/cellar/0.2.1/cellar-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "aa02dceacb0d4970ebd53c086cc0d091cea69ffa1965f6c1c017ad9903fa5322"
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
    bin.install "cellar" if OS.mac? && Hardware::CPU.arm?
    bin.install "cellar" if OS.mac? && Hardware::CPU.intel?
    bin.install "cellar" if OS.linux? && Hardware::CPU.arm?
    bin.install "cellar" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
