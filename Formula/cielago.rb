class Cielago < Formula
  desc "Like Postman but actually works"
  homepage "https://github.com/stevedylandev/cielago"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/cielago/releases/download/v0.2.0/cielago-aarch64-apple-darwin.tar.xz"
      sha256 "cf13e894ed9c05f7113421e726ad3c8d056f7fc743205fc015198f7581308d47"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/cielago/releases/download/v0.2.0/cielago-x86_64-apple-darwin.tar.xz"
      sha256 "ead537f2aa49ea77f9ec1c702bb616e1f7d4510ef6cd86f557cdbf060ec34d5e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/cielago/releases/download/v0.2.0/cielago-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e03d23533eec8606c2df48ee26fb2ef65eea03441e7363e202f36e8b5a397d42"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/cielago/releases/download/v0.2.0/cielago-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ab11c836225a3e88ac756f3dceab4f0ae84fde1bf3a0e88125ec5049c0d05405"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "cielago"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "cielago"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "cielago"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "cielago"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
