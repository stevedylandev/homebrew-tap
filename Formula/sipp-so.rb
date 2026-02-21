class SippSo < Formula
  desc "Minimal code sharing - single binary for web server, CLI, and TUI"
  homepage "https://sipp.so"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/sipp/releases/download/v0.1.5/sipp-so-aarch64-apple-darwin.tar.xz"
      sha256 "b88ecb0e172c6dd0e536380d485ef63fa2f6bb9cccdf3b45594523cee30d5c17"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/sipp/releases/download/v0.1.5/sipp-so-x86_64-apple-darwin.tar.xz"
      sha256 "023ae77454e76b8cb7b97e105aa6bf6fcbdd4be5dd11834e8c7fc2d9b62ba0e8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/sipp/releases/download/v0.1.5/sipp-so-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f230afd43954e04e18ece9783902102fefa7cb1b7cfebf9b8eb3368ef2d44dcb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/sipp/releases/download/v0.1.5/sipp-so-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b445ddc827de738115a874241ea8a9c2734ee763a6d8b93b9c90755e6fda74d1"
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
