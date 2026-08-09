class Cielago < Formula
  desc "Like Postman but actually works"
  homepage "https://github.com/stevedylandev/cielago"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/cielago/releases/download/v0.1.3/cielago-aarch64-apple-darwin.tar.xz"
      sha256 "78ff2d12b167e8554e931a7dd55bd678ba81dbf5abc55ba96e9d006fef5da2fa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/cielago/releases/download/v0.1.3/cielago-x86_64-apple-darwin.tar.xz"
      sha256 "a81c20fec325b364cc6df3bcf5c2cc3b9a88b3e2d4e1cef0b6a5472ce72c6e13"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/cielago/releases/download/v0.1.3/cielago-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "842e196f5bec59fe6bb48743ee624bd7f3367359ef08c40eaac64cbe7683e542"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/cielago/releases/download/v0.1.3/cielago-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "18f0e949eed1189917f3b4ed25ac9d6857cfccd0e74e47df9eb138b1316cb476"
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
    bin.install "cielago" if OS.mac? && Hardware::CPU.arm?
    bin.install "cielago" if OS.mac? && Hardware::CPU.intel?
    bin.install "cielago" if OS.linux? && Hardware::CPU.arm?
    bin.install "cielago" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
