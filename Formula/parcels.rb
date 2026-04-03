class Parcels < Formula
  desc "Minimal package tracking"
  homepage "https://github.com/stevedylandev/andromeda"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/parcels/0.1.3/parcels-aarch64-apple-darwin.tar.xz"
      sha256 "87f5fa4c6b4e117cea038130a390fc8f0b3e86ddd422426821177645c245831e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/parcels/0.1.3/parcels-x86_64-apple-darwin.tar.xz"
      sha256 "537ef8d660dac0dd14396211f55866b73dfe379cd8446d65edd16acd47eaaa97"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/parcels/0.1.3/parcels-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d3823e83e9b50f9afc8bf4addc8d2418598c55cb69a9b6a8c790f037e9bd49a6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/parcels/0.1.3/parcels-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d9d88437385ee1760105d5b6617c79eb5f9d591a5aa82a72ea46b5c3b6559faf"
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
