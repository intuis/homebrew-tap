class Rustmission < Formula
  desc "TUI for Transmission daemon"
  homepage "https://github.com/intuis/rustmission"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/intuis/rustmission/releases/download/v0.3.2/rustmission-aarch64-apple-darwin.tar.xz"
      sha256 "6798139c3064af81915d73eac72a4bf5a2bc10c7c153a66a645942adb2db8565"
    end
    if Hardware::CPU.intel?
      url "https://github.com/intuis/rustmission/releases/download/v0.3.2/rustmission-x86_64-apple-darwin.tar.xz"
      sha256 "ca36c5d51541cba9f07410346de97c12eaeb9208dcc14648503ac24fd7c12cf6"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/intuis/rustmission/releases/download/v0.3.2/rustmission-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "249a23a2f7afa9bf8b4067e59e685fea5cb9a0a99c8cd2c05fee7dad55b8cf51"
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
