require "language/haskell"

class ElmFormat < Formula
  include Language::Haskell::Cabal
  desc "Elm source code formatter, inspired by gofmt."
  homepage "https://github.com/avh4/elm-format"

  head "https://github.com/avh4/elm-format.git"

  devel do
    url "https://github.com/avh4/elm-format/archive/0.4.0-alpha.tar.gz"
    version "0.4.0-alpha"
    sha256 "d5998e8f89207205ffe75362c982381800e1e6295e063ae71e4b5e0982068527"
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    (buildpath/"elm-format").install Dir["*"]

    # GHC 8 compat
    # Fixes: "cabal: Could not resolve dependencies"
    # Reported 26 May 2016: https://github.com/avh4/elm-format/issues/188
    (buildpath/"cabal.config").write("allow-newer: aeson,base,transformers\n")

    cabal_sandbox do
      cabal_sandbox_add_source "elm-format"
      cabal_install "--only-dependencies", "elm-format"
      cabal_install "--prefix=#{prefix}", "elm-format"
    end
  end

  test do
    src_path = testpath/"Hello.elm"
    src_path.write <<-EOS.undent
      import Html exposing (text)
      main = text "Hello, world!"
    EOS

    system bin/"elm-format-0.17", testpath/"Hello.elm", "--yes"
  end
end
