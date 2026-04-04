class Cellar < Formula
  desc "Personal wine tasting log"
  homepage "https://github.com/stevedylandev/andromeda"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/cellar/0.1.1/cellar-aarch64-apple-darwin.tar.xz"
      sha256 "fe6348cfc50cd6fdadebe20e989ae3f9e102b53d050ccc9836d30afc9c0fc27d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/cellar/0.1.1/cellar-x86_64-apple-darwin.tar.xz"
      sha256 "dff6e7d004872c503338c38b249a5a0503f81a07145499157f72115089ff178e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/cellar/0.1.1/cellar-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dc2021b12522d5f26a183b655cfb4ba9219461b1a956e84cebe22b2ecedb4787"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/cellar/0.1.1/cellar-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e31beac1a7a484ca3e50c889cb4a955233970dcbd5f75e6b0a412143efc95fac"
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
