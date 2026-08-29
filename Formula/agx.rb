# frozen_string_literal: true

class Agx < Formula
  desc "Run multiple AI coding agents in parallel, each isolated in its own git worktree, and monitor them all from a single terminal dashboard"
  homepage "https://github.com/jedipunkz/agx"
  version "0.4.0"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/jedipunkz/agx/releases/download/v#{version}/agx_v#{version}_darwin_amd64"
      sha256 "a3dd53a0907cd67b996ef0c18076712ddb163aef4152d18fcf721f886e3f7745"
    end

    on_arm do
      url "https://github.com/jedipunkz/agx/releases/download/v#{version}/agx_v#{version}_darwin_arm64"
      sha256 "2d35efde6253402ed8480d8d72499fe300c151639f52deb1d57926c5d090209b"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jedipunkz/agx/releases/download/v#{version}/agx_v#{version}_linux_amd64"
      sha256 "a2839ab79506c1c58edc8526ddcf14be5addd5b9304949e338e9a2121076cf1d"
    end

    on_arm do
      url "https://github.com/jedipunkz/agx/releases/download/v#{version}/agx_v#{version}_linux_arm64"
      sha256 "4a2c96f9231fb6dcec575ecb62e07e9fb9d70cae886c20611ae22da5f6171a4b"
    end
  end

  def install
    bin.install Dir["agx_v#{version}_*"].first => "agx"
  end

  def post_install
    pid_file = Pathname.new(Dir.home) / ".agx" / "daemon.pid"
    if pid_file.exist?
      pid = pid_file.read.strip.to_i
      if pid.positive?
        begin
          Process.kill("TERM", pid)
          ohai "Stopped agx daemon (PID: #{pid})"
        rescue Errno::ESRCH
          # Process already exited
        end
      end
      pid_file.delete
    end
  end

  test do
    assert_match "Manage multiple Claude Code agents", shell_output("#{bin}/agx --help 2>&1")
  end
end
