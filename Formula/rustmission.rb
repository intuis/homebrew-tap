class Rustmission < Formula
  desc "TUI for Transmission daemon"
  homepage "https://github.com/intuis/rustmission"
  version "0.3.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/intuis/rustmission/releases/download/v0.3.3/rustmission-aarch64-apple-darwin.tar.xz"
      sha256 "ae2f837321e154d54ba603045d262c467e807003a64d2ef46f4e0eb9e475e723"
    end
    if Hardware::CPU.intel?
      url "https://github.com/intuis/rustmission/releases/download/v0.3.3/rustmission-x86_64-apple-darwin.tar.xz"
      sha256 "bedc12865c29039bcd867d55c8e06eece42a4d0f62bea7ca334b09456cd5d021"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/intuis/rustmission/releases/download/v0.3.3/rustmission-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "984dcb09d807033356267641ec27936547cd05b5e1bbadfdee4125255cc9baff"
    end
  end
  license "GPL-3.0-or-later"

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "x86_64-apple-darwin": {}, "x86_64-unknown-linux-gnu": {}, "x86_64-unknown-linux-musl-dynamic": {}, "x86_64-unknown-linux-musl-static": {}}

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
