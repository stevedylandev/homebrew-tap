class Og < Formula
  desc "Minimal opengraph previewer"
  homepage "https://github.com/stevedylandev/andromeda"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/og/0.1.0/og-aarch64-apple-darwin.tar.xz"
      sha256 "c913397b74a290ccdd5e26ac693405f713e6acb2325bd0d294bfdca0ccbe1e40"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/og/0.1.0/og-x86_64-apple-darwin.tar.xz"
      sha256 "7aa3d7ad5f6427c69b619e212441064002793f49fceb7620530c6a7506886b3f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/og/0.1.0/og-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a08197ef9af1abedf38ff5f0ac0ce50d30dc5fef727ff8123838794e24330e17"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/og/0.1.0/og-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "31d62084e9c1ac0e7ee59afd127246f540f0a1da74aa680641f38691cb0b8537"
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
    bin.install "og" if OS.mac? && Hardware::CPU.arm?
    bin.install "og" if OS.mac? && Hardware::CPU.intel?
    bin.install "og" if OS.linux? && Hardware::CPU.arm?
    bin.install "og" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
