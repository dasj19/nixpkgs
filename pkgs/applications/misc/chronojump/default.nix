{ stdenv, fetchurl, automake, mono4, mono-addins, python37, pkg-config,
gettext, intltool }:

stdenv.mkDerivation rec {
  pname = "chronojump";
  version = "1.9.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0xmnaxlpzrm4wy4wiiid1zrgk3fn9q1jx2h5vlibfnjilyrnns72";
  };

  nativeBuildInputs = [ automake mono4 pkg-config gettext intltool ];

#  makeWrapperArgs = [
#    "--prefix MONO_GAC_PREFIX : ${mono4}/lib/mono/gac"
#    ''--prefix LD_LIBRARY_PATH : ${mono4}/lib''
#  ];

  propagatedBuildInputs = [ python37 ];

  meta = with stdenv.lib; {
    description = "Chronojump is a free software dedicated to the management of several human movement measurement devices.";
    license = licenses.gpl2;
    maintainers = [ "dasj19" ];
    platforms = platforms.linux;
  };
}
