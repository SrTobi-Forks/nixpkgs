{ stdenv, fetchFromGitHub
, groff
, ncurses
, makeWrapper
} :

stdenv.mkDerivation rec {
  pname = "jove";
  version = "4.17.3.6";

  src = fetchFromGitHub {
    owner = "jonmacs";
    repo = "jove";
    rev = version;
    sha256 = "sha256-uQRNKV06ipOHrOsvsceqIFGGlRv5qOQy18q0tFkR6Kg=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    groff
    ncurses
  ];

  dontConfigure = true;

  preBuild = ''
    makeFlagsArray+=(SYSDEFS="-DSYSVR4 -D_XOPEN_SOURCE=500" \
      TERMCAPLIB=-lncurses JOVEHOME=${placeholder "out"})
  '';

  postInstall = ''
    wrapProgram $out/bin/teachjove \
      --prefix PATH ":" "$out/bin"
  '';

  meta = with stdenv.lib; {
    description = "Jonathan's Own Version or Emacs";
    homepage = "https://github.com/jonmacs/jove";
    license = licenses.bsd2;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
