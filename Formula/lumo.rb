class Lumo < Formula
  desc "Fast, cross-platform, standalone ClojureScript REPL on Node.js"
  homepage "https://github.com/anmonteiro/lumo#readme"

  head "https://github.com/anmonteiro/lumo.git"

  devel do
    url "https://github.com/anmonteiro/lumo/archive/1.0.0-alpha1.tar.gz"
    version "1.0.0-alpha1"
    sha256 "4fc2682f430ea449a5bacb63ec6f9b7f59d9feef91f431894831d055d1c3bd70"
  end

  depends_on "boot-clj" => :build
  depends_on "yarn" => :build
  depends_on "node" => :build # TODO: should be unnecessary? (yarn already depends on node)

  def install
    ENV["BOOT_JVM_OPTIONS"] = "-Duser.home=#{ENV["HOME"]}"
    system "boot", "test"
    system "boot", "release-ci"
    bin.install "build/lumo"
  end

  test do
    require "English"
    IO.popen("#{bin}/lumo --repl --quiet", "r+") do |io|
      io.puts ":cljs/quit\n"
      assert_equal "\e[1G\e[0Jcljs.user=> \e[13G:cljs/quit", io.gets.chomp
      io.close
      assert $CHILD_STATUS.success?
    end
  end
end
