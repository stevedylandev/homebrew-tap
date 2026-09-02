class Cielago < Formula
  desc "Like Postman but actually works"
  homepage "https://github.com/stevedylandev/cielago"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/cielago/releases/download/v0.3.0/cielago-aarch64-apple-darwin.tar.xz"
      sha256 "021b5e906f7891ce3da89987080013dac2e89e494f8067463c850112dbce643e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/cielago/releases/download/v0.3.0/cielago-x86_64-apple-darwin.tar.xz"
      sha256 "6c61244401ae27187d635bfb20d292c7c8e2f8677d9a43efd47fbbe4d0beee7f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevedylandev/cielago/releases/download/v0.3.0/cielago-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2a52f1bd32b26662cc7fb9fc487483e9fa7e3c37e1d28a7ceb125975720b0625"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevedylandev/cielago/releases/download/v0.3.0/cielago-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "510c716a3e75e888cbbb609087d34a7f607e7e9ee5aa6276ac8f5f6cdfa24ada"
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
