class Rustmission < Formula
  desc "TUI for Transmission daemon"
  homepage "https://github.com/intuis/rustmission"
  version "0.4.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/intuis/rustmission/releases/download/v0.4.3/rustmission-aarch64-apple-darwin.tar.xz"
      sha256 "01ba062c438e61320eb2c69b6beafaf297b6842c96b3916605670508f4d12723"
    end
    if Hardware::CPU.intel?
      url "https://github.com/intuis/rustmission/releases/download/v0.4.3/rustmission-x86_64-apple-darwin.tar.xz"
      sha256 "277c8da6a32836d4d484cb2f64bdcea354355601b92091082592a3b445f97cf1"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/intuis/rustmission/releases/download/v0.4.3/rustmission-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "aed3958a6767f428811fa81cb8ef8dbb9b7df4b62423cf501eee8c41abcc55e5"
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
