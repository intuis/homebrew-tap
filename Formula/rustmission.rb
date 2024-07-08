class Rustmission < Formula
  desc "TUI for Transmission daemon"
  homepage "https://github.com/intuis/rustmission"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/intuis/rustmission/releases/download/v0.4.1/rustmission-aarch64-apple-darwin.tar.xz"
      sha256 "b5d562c1fd80f6048c19e10dde427052d11cddf966a6b0a0ed19f3d2a6c8a167"
    end
    if Hardware::CPU.intel?
      url "https://github.com/intuis/rustmission/releases/download/v0.4.1/rustmission-x86_64-apple-darwin.tar.xz"
      sha256 "323769a1a9614cd5a2c42be6dd1304b371a439fc2586ac5a6e56122a15e099c6"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/intuis/rustmission/releases/download/v0.4.1/rustmission-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0d3e482462a64660903946be74e74a65bf9a3c199d4e409cf165602d0e8e8fd5"
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
