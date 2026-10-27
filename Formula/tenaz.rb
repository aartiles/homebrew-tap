class Tenaz < Formula
  desc "Single-model runner: plans, builds and verifies a goal with one resident local model at a time."
  homepage "https://github.com/aartiles/tenaz"
  version "0.1.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/aartiles/tenaz/releases/download/v0.1.0/tenaz-aarch64-apple-darwin.tar.gz"
    sha256 "46f230075e7859edcaba4bf8d0b6183fbc9f42ef477917af2a48a4f384a3803e"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/aartiles/tenaz/releases/download/v0.1.0/tenaz-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "ca06ee38dc41d6124a896901b4af0b739870e40ee30c82c902493e373a966de4"
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
