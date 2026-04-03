class SippSo < Formula
  desc "Minimal code sharing - single binary for web server, CLI, and TUI"
  homepage "https://sipp.so"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/sipp-so/0.1.6/sipp-so-aarch64-apple-darwin.tar.xz"
      sha256 "e5fd36dd12611df968cd49f58c244e1625d0df3508be0c59bc8940c404735bfc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/sipp-so/0.1.6/sipp-so-x86_64-apple-darwin.tar.xz"
      sha256 "6a9eb59b484e62ea662556385fa80498eb796b3c696aeea588179be422aaea4a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/sipp-so/0.1.6/sipp-so-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "62d1795e63dbb0f3276326088c7ffeee5505d3df4bb0ad6620c8be1070bbe4b8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/sipp-so/0.1.6/sipp-so-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "03c1d8f649f5d5300f29fbf7744c767aef323e75f34bb142739fa1d4aedbd8aa"
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
