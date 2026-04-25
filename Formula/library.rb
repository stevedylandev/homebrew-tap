class Library < Formula
  desc "Personal book tracking"
  homepage "https://github.com/stevedylandev/andromeda"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/library/0.1.0/library-aarch64-apple-darwin.tar.xz"
      sha256 "c7f4fcc367757f6d3555d2d9e1d5c1cc192bc3c09a4c3e356a23be4a9d69d45e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/library/0.1.0/library-x86_64-apple-darwin.tar.xz"
      sha256 "c42cadb65411db51f7184c5ef8c6a435f005e35820167b1d10be3ee71882ca1c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/library/0.1.0/library-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dada34b750d5f1caff296e02b2d9a42577a0ef0cb8cf7aeaf32c075782b37890"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/library/0.1.0/library-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "91fada1c86abe3b600bd0608d25fb67af2a9a89eb8ac612b10a671337f4c6410"
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
    bin.install "library" if OS.mac? && Hardware::CPU.arm?
    bin.install "library" if OS.mac? && Hardware::CPU.intel?
    bin.install "library" if OS.linux? && Hardware::CPU.arm?
    bin.install "library" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
