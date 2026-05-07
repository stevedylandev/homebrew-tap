class Bullets < Formula
  desc "Minimal RSS TUI"
  homepage "https://github.com/stevedylandev/bullets"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/bullets/releases/download/v0.1.0/bullets-aarch64-apple-darwin.tar.xz"
      sha256 "f8b19baa07ebcba9967e1b916489ef897eafacb666dd08c8abea141efcb62ecb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/bullets/releases/download/v0.1.0/bullets-x86_64-apple-darwin.tar.xz"
      sha256 "901a2db6e3e1e3ec280e2847c91ec710776a9c8b459fc96b97624c5cd86c977c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/bullets/releases/download/v0.1.0/bullets-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "84431123363ff393d676cc7e94bd7a8d018a5fded947facb52c03da07d6d7d56"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/bullets/releases/download/v0.1.0/bullets-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c64b0b4e3dfc5766b38ec5dde693c4d85faa657f0f0288e357ca1e89103eb6c2"
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
    bin.install "bullets" if OS.mac? && Hardware::CPU.arm?
    bin.install "bullets" if OS.mac? && Hardware::CPU.intel?
    bin.install "bullets" if OS.linux? && Hardware::CPU.arm?
    bin.install "bullets" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
