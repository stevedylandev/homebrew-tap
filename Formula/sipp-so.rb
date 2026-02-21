class SippSo < Formula
  desc "Minimal code sharing - single binary for web server, CLI, and TUI"
  homepage "https://sipp.so"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/sipp/releases/download/v0.1.4/sipp-so-aarch64-apple-darwin.tar.xz"
      sha256 "c8a6ccf7bce3893adf8bac220c3bbf502a0d17d5a5e33c897bc234c73aa7b96c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/sipp/releases/download/v0.1.4/sipp-so-x86_64-apple-darwin.tar.xz"
      sha256 "1913023053b85ecacb87893aacf813e2f48c4adb702d2b9e30fe4ee9494daac7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/sipp/releases/download/v0.1.4/sipp-so-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bd10da005475e6ceb6527128a29cc570f575436bddb8f4fadca9485ad00185f9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/sipp/releases/download/v0.1.4/sipp-so-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ee560d014e02d8f80bfea72f828ba742360cc369d904d958360150a87d22d436"
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
