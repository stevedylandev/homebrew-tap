class Parcels < Formula
  desc "Minimal package tracking"
  homepage "https://github.com/stevedylandev/andromeda"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/parcels/0.1.2/parcels-aarch64-apple-darwin.tar.xz"
      sha256 "783414fc68484bd3e424d40ef44e883db34b0b3d7787f990a9f187ba156c0e4a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/parcels/0.1.2/parcels-x86_64-apple-darwin.tar.xz"
      sha256 "80ef219bd7e0446b00a40ec1cf5fa1b66f95cdd6a288c7c106d7ea78fa791908"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/parcels/0.1.2/parcels-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8a578f11cf2cb4ff283bf609b2362c2a75a51521da7db5d8f22f56fc01991bff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/parcels/0.1.2/parcels-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8f49113d41a6286bd40c020d71940b26a41d5dec8d8e2ccab57c7166170718a2"
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
