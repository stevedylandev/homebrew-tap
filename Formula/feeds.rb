class Feeds < Formula
  desc "Minimal RSS feed reader"
  homepage "https://github.com/stevedylandev/andromeda"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/feeds/0.1.3/feeds-aarch64-apple-darwin.tar.xz"
      sha256 "7693e3f4e50c2fdfe8a28b07b23da744b60f133d693cd9800a0d8acf10ed248a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/feeds/0.1.3/feeds-x86_64-apple-darwin.tar.xz"
      sha256 "23d281fca1ddd2d40a718ebc3eebfa89ae7a7d0350faca56ac65eae6c7eeb4a3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/feeds/0.1.3/feeds-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fb249215f8920c13d93f62d23e576c6b8c13fe2618941cecc49b10d7a6e93d6a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/feeds/0.1.3/feeds-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "30d1f127e1f218485f7d8b258fb5a4712589cc4c8162de6536d0abe19c8dc036"
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
    bin.install "feeds" if OS.mac? && Hardware::CPU.arm?
    bin.install "feeds" if OS.mac? && Hardware::CPU.intel?
    bin.install "feeds" if OS.linux? && Hardware::CPU.arm?
    bin.install "feeds" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
