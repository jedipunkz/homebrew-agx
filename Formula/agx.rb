# frozen_string_literal: true

class Agx < Formula
  desc "Run multiple AI coding agents in parallel, each isolated in its own git worktree, and monitor them all from a single terminal dashboard"
  homepage "https://github.com/jedipunkz/agx"
  version "0.3.2"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/jedipunkz/agx/releases/download/v#{version}/agx_v#{version}_darwin_amd64"
      sha256 "0f0132627b22359e9518c618c4af9555893f544a977528003e8b3a2f56c2ea6b"
    end

    on_arm do
      url "https://github.com/jedipunkz/agx/releases/download/v#{version}/agx_v#{version}_darwin_arm64"
      sha256 "3944ba335a81a57751c92fe0f62e099e6b4675f37ac3ad78fa8e2a447fabd454"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jedipunkz/agx/releases/download/v#{version}/agx_v#{version}_linux_amd64"
      sha256 "82583e76e5fc9e2818a3e42b595a67a4a371e3d4b9aff34860fe7881e6a2281f"
    end

    on_arm do
      url "https://github.com/jedipunkz/agx/releases/download/v#{version}/agx_v#{version}_linux_arm64"
      sha256 "145f7befb25c892c02a92c95b566cd8aad86827f9f7e34888d520583ec0328b1"
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
