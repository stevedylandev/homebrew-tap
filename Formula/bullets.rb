class Bullets < Formula
  desc "Minimal RSS TUI"
  homepage "https://github.com/stevedylandev/bullets"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/bullets/releases/download/v0.1.1/bullets-aarch64-apple-darwin.tar.xz"
      sha256 "f551909badab8375fc04c231c3218f918943ddac38ffd0ab51cb68d816413203"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/bullets/releases/download/v0.1.1/bullets-x86_64-apple-darwin.tar.xz"
      sha256 "16ffb2289808464370f4d0c1de833beddc356676915895fc5d940920a96b0521"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/bullets/releases/download/v0.1.1/bullets-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a02548a1dde465b06904d9fe8f5426d15e6149b3b4faee81e21c4f4d5da5ee4d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/bullets/releases/download/v0.1.1/bullets-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "110cb7dc996c799ef8c5ef97cd8c5451ce60c738e604a57cd9da3fc3c96e8af9"
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
