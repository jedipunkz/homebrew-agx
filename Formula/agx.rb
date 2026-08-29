# frozen_string_literal: true

class Agx < Formula
  desc "Run multiple AI coding agents in parallel, each isolated in its own git worktree, and monitor them all from a single terminal dashboard"
  homepage "https://github.com/jedipunkz/agx"
  version "1.0.0"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/jedipunkz/agx/releases/download/v#{version}/agx_v#{version}_darwin_amd64"
      sha256 "3942251ffe36da6a21e952cc66a34eea172852a14548a29424f57bde6de5d247"
    end

    on_arm do
      url "https://github.com/jedipunkz/agx/releases/download/v#{version}/agx_v#{version}_darwin_arm64"
      sha256 "bd411235b23b546b222bcd2dcb6995847cede784ecb03c68edfc06f373193e11"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jedipunkz/agx/releases/download/v#{version}/agx_v#{version}_linux_amd64"
      sha256 "ce28044bea4cec66d8fdd43e595ab83389b53c75eb09e2c2b2d4fc228e16d064"
    end

    on_arm do
      url "https://github.com/jedipunkz/agx/releases/download/v#{version}/agx_v#{version}_linux_arm64"
      sha256 "0e56d89425821a114f48960e52adee636dd9f7e6151473a891535020cd7123a7"
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
