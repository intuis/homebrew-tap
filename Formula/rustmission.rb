class Rustmission < Formula
  desc "TUI for Transmission daemon"
  homepage "https://github.com/intuis/rustmission"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/intuis/rustmission/releases/download/v0.5.0/rustmission-aarch64-apple-darwin.tar.xz"
      sha256 "38f7f8fe821e7886de1ba136b8c8413e10a150022ac7263f484cafdb956c8a65"
    end
    if Hardware::CPU.intel?
      url "https://github.com/intuis/rustmission/releases/download/v0.5.0/rustmission-x86_64-apple-darwin.tar.xz"
      sha256 "ae58d8a795d9fd45725e321fb2485e3a02c04386407c6a1efd7fc2cf1162ff00"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/intuis/rustmission/releases/download/v0.5.0/rustmission-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e455520c1c54089d47c9c00bb565f5169f6657f6f99465d6826276187f575f38"
    end
  end
  license "GPL-3.0-or-later"

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "x86_64-apple-darwin": {}, "x86_64-unknown-linux-gnu": {}}

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
      bin.install "rustmission"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "rustmission"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "rustmission"
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
