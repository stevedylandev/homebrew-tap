class Jotts < Formula
  desc "Minimal markdown note app"
  homepage "https://github.com/stevedylandev/andromeda"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/jotts/0.2.0/jotts-aarch64-apple-darwin.tar.xz"
      sha256 "b6540bc8049c3d19218737ec4e9a24e771265d1eb0dcb7e0c9d930e438248b6b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/jotts/0.2.0/jotts-x86_64-apple-darwin.tar.xz"
      sha256 "04d2dabe8a21c31435e6d27056b9c017de13f25a4b4d602ee3128bffdbb82841"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/jotts/0.2.0/jotts-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7b5ad2dbe2784fa247ad097e13d4ec1d584c97a8b02224f6e9028a4af35d8ca7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/jotts/0.2.0/jotts-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bc478c1c0a34425d2abd50606e93871bbe5def3cdbbe8436027040996e1361ff"
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
    bin.install "jotts" if OS.mac? && Hardware::CPU.arm?
    bin.install "jotts" if OS.mac? && Hardware::CPU.intel?
    bin.install "jotts" if OS.linux? && Hardware::CPU.arm?
    bin.install "jotts" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
