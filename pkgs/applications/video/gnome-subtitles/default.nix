{ stdenv, fetchFromGitLab, pkg-config, intltool, autoconf, automake, libtool, yelp-tools,
mono, gstreamer, enchant, gtkspell3, }:

let
  version = "1.6";
in stdenv.mkDerivation {
  pname = "gcolor3";
  inherit version;

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gnome-subtitles";
    rev = "gnome-subtitles-${version}";
    sha256 = "1crmmcx32i6ca7dlr3xhnc7vgv9jhlpwh6hxhv2fl1x1zbasf42z";
  };

  nativeBuildInputs = [ intltool pkg-config automake automake libtool yelp-tools ];

  buildInputs = [ mono gstreamer enchant gtkspell3];

  installPhase = ''
    make install
  '';

  meta = with stdenv.lib; {
    description = "Gnome Subtitles is a subtitle editor for the GNOME desktop.";
    homepage = "http://gnomesubtitles.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ dasj19 ];
    platforms = platforms.unix;
  };
}
