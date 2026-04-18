class SippSo < Formula
  desc "Minimal code sharing - single binary for web server, CLI, and TUI"
  homepage "https://sipp.so"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/sipp-so/0.2.0/sipp-so-aarch64-apple-darwin.tar.xz"
      sha256 "29fff2945d6ade6c0101fb2403525e1d80e378c3137d503cefeb293f18653670"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/sipp-so/0.2.0/sipp-so-x86_64-apple-darwin.tar.xz"
      sha256 "b5ede166dcff6784633b37fec7bd1d949adc95c9d8b502865d08b6ae66aa83f0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/sipp-so/0.2.0/sipp-so-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ce328a675e4b13548087b0ddae431c3c064e107447b1c8622ef31a4cd2c57302"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/sipp-so/0.2.0/sipp-so-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6a760488c11c1fed26cf4149b7ddff160bd706171ef42632f3305575d3d056b8"
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
    bin.install "sipp" if OS.mac? && Hardware::CPU.arm?
    bin.install "sipp" if OS.mac? && Hardware::CPU.intel?
    bin.install "sipp" if OS.linux? && Hardware::CPU.arm?
    bin.install "sipp" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
