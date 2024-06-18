class Rustmission < Formula
  desc "TUI for Transmission daemon"
  homepage "https://github.com/rustmission/rustmission"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rustmission/rustmission/releases/download/v0.3.1/rustmission-aarch64-apple-darwin.tar.xz"
      sha256 "58ac4ed305db1e2f06897e8a51bf01c5dbe8da09fd33ca14d0319e49c4ee797f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rustmission/rustmission/releases/download/v0.3.1/rustmission-x86_64-apple-darwin.tar.xz"
      sha256 "4065cee8ea503c129150d37a454e833a789f2782e0eb6b38d62314153d85730e"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/rustmission/rustmission/releases/download/v0.3.1/rustmission-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e79cf4e95afc67f93a771710e3c5e4dc7d03adf148905bc3473849016b5511e3"
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
