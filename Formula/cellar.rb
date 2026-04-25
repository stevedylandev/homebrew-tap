class Cellar < Formula
  desc "Personal wine tasting log"
  homepage "https://github.com/stevedylandev/andromeda"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/cellar/0.2.2/cellar-aarch64-apple-darwin.tar.xz"
      sha256 "e32e1889e721abe3051e299c8dcdb61a575657f0376a38e3565d17df76fcf46e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/cellar/0.2.2/cellar-x86_64-apple-darwin.tar.xz"
      sha256 "936d6efd1d0764ca1bfddc2dd42a866f85fd45218157a43e34df04a0fd9dfc91"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/andromeda/releases/download/cellar/0.2.2/cellar-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "df4af9149d596a4255c9301b4258a517cefd334eea9257ab641116326f056bbe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/andromeda/releases/download/cellar/0.2.2/cellar-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2cfdfed40cfef9759a280f1ec28e0f669ee44cadc768cea9e389a174b7539bd7"
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
    bin.install "cellar" if OS.mac? && Hardware::CPU.arm?
    bin.install "cellar" if OS.mac? && Hardware::CPU.intel?
    bin.install "cellar" if OS.linux? && Hardware::CPU.arm?
    bin.install "cellar" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
