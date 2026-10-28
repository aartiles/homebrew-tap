class Tenaz < Formula
  desc "Drives a local model through a coding agent until the goal passes its checks."
  homepage "https://github.com/aartiles/tenaz"
  version "0.2.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/aartiles/tenaz/releases/download/v0.2.0/tenaz-aarch64-apple-darwin.tar.gz"
    sha256 "c08ecb4872d6488a7021ef5bc88935cfcda547ce0a11c5cd612246ad38d605bd"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/aartiles/tenaz/releases/download/v0.2.0/tenaz-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "7edaaee14fb3257f3163782d0a0ca31393f2be61c697265b7ee0a28bf272bdac"
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-unknown-linux-gnu": {},
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
      bin.install "tenaz"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "tenaz"
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
