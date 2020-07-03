{ stdenv, fetchurl, gnome3, cmake, gettext, intltool, pkg-config, evolution-data-server
, sqlite, gtk3, webkitgtk, libgdata }:

stdenv.mkDerivation rec {
  pname = "evolution-ews";
  version = "3.36.3";

  src = fetchurl {
    url = "mirror://gnome/sources/evolution-ews/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "011dfl0q66v928w46sjlik2cb3h65im6qivdrwxqm97p22dsb5vs";
  };

  nativeBuildInputs = [ cmake gettext intltool pkg-config ];

  buildInputs = [
    evolution-data-server gnome3.evolution
    sqlite libgdata
    gtk3 webkitgtk
  ];

  cmakeFlags = [
    "-DWITH_MSPACK=OFF"
    "-DCMAKE_BUILD_TYPE=Debug"
    "-DBACKENDDIR=$out"
  ];

   passthru = {
    updateScript = gnome3.updateScript {
      packageName = "evolution-ews";
    };
  };

  meta = with stdenv.lib; {
    description = "Evolution connector for Microsoft Exchange Server protocols.";
    license = licenses.lgpl2;
    maintainers = [ dasj19 ];
    platforms = platforms.linux;
  };
}
