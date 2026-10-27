class Tenaz < Formula
  desc "Drives a local model through a coding agent until the goal passes its checks."
  homepage "https://github.com/aartiles/tenaz"
  version "0.1.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/aartiles/tenaz/releases/download/v0.1.1/tenaz-aarch64-apple-darwin.tar.gz"
    sha256 "9e4434dda27a06a43aac4f46c38dc173c43f0ec7222493f96c2b1dbcb5d7f21b"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/aartiles/tenaz/releases/download/v0.1.1/tenaz-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "5dd7798ead8d28086632a4cdab1100ca6fd0edb674a00a0d669e9a7d6695a1a2"
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
