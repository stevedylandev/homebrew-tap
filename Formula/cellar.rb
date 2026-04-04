class Cellar < Formula
  desc "Personal wine tasting log"
  homepage "https://github.com/stevedylandev/andromeda"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/cellar/0.1.2/cellar-aarch64-apple-darwin.tar.xz"
      sha256 "8acb673f002aaecbba0bcdd6f447237e74e7f1b1193720163f9759bde8c3a237"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/cellar/0.1.2/cellar-x86_64-apple-darwin.tar.xz"
      sha256 "725cff7862e3e66d512404cca36c0b6f212835198de6b2469dd906559bdce86e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/cellar/0.1.2/cellar-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d654787e85507070a158768472f911e9183cbf2dac67a9d9b619143a42f17158"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/cellar/0.1.2/cellar-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1fcd229841fe52683d83932e0c26011b3c5b16a44d9d6400f50b5c8e73760da4"
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
