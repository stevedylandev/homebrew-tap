class Parcels < Formula
  desc "Minimal package tracking"
  homepage "https://github.com/stevedylandev/andromeda"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/parcels/0.1.1/parcels-aarch64-apple-darwin.tar.xz"
      sha256 "0b785ef2a12c9c79850f5e67fe89822da198af8f2233e3bb997e823060193308"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/parcels/0.1.1/parcels-x86_64-apple-darwin.tar.xz"
      sha256 "833d8f7b32ac916dc56b5d00afb7c6090584ee9cc37ff1f4cd53dfe433163adf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/parcels/0.1.1/parcels-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b81d660b935903509c71df0f98f7812f58f51d45ce293ba7e4cc2094e6786067"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/parcels/0.1.1/parcels-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0c71ea2be5ebde4ee650d663b9face38364f6dbc33a178d3eaae5b558e65c113"
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
    bin.install "parcels" if OS.mac? && Hardware::CPU.arm?
    bin.install "parcels" if OS.mac? && Hardware::CPU.intel?
    bin.install "parcels" if OS.linux? && Hardware::CPU.arm?
    bin.install "parcels" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
