{stdenv, fetchurl, bash, perl, perlPackages,  makeWrapper, makeDesktopItem}:

stdenv.mkDerivation rec {
  pname = "gcstar";
  version = "1.7.1";

  src = fetchurl {
    url = "https://launchpad.net/${pname}/1.7/${version}/+download/${pname}-${version}.tar.gz";
    sha256 = "0gcz88slgm14rlsw84gpka7hpdmrdvpdvxp9qvs45gv1383r0b6s";
  };

  enableParallelBuilding = false;
  doCheck = false;

 perlDeps = [
    perl
    perlPackages.ArchiveZip
    perlPackages.DateCalc
    perlPackages.DateTimeFormatStrptime
    perlPackages.Glib
    perlPackages.Gtk2
    perlPackages.GD
    perlPackages.GDGraph
    perlPackages.GDText
    perlPackages.HTMLParser
    perlPackages.librelative
    perlPackages.LWPUserAgent
    perlPackages.Pango
    perlPackages.XMLSimple
    perlPackages.XMLParser ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = perlDeps;
  propagatedBuildInputs = perlDeps;

  installPhase = ''
    tar xvfz $src
    cd gcstar

    sed -i 's|/usr/bin/perl|'"${perl}"'/bin/perl|g' bin/gcstar
    sed -i 's|/usr/bin/perl|'"${perl}"'/bin/perl|g' ./install
    sed -i 's|/bin/sh|'"${bash}"'/bin/bash|g' share/gcstar/helpers/xdg-open

    sed -i 's|/usr/bin/perl|'"${perl}"'/bin/perl|g' share/applications/gcstar-thumbnailer
    sed -i 's|/usr/local/share|'"$out"'|g' share/applications/gcstar-thumbnailer

    perl install --text --prefix=$out

    # Setting up the desktop item.
    mkdir -p $out/share/applications
    mkdir -p $out/share/pixmaps
    cp share/applications/$pname.desktop $out/share/applications/$pname.desktop
    cp share/$pname/icons/${pname}_256x256.png $out/share/pixmaps/$pname.png
  '';

  postFixup = "wrapProgram $out/bin/gcstar --prefix PERL5LIB : $PERL5LIB";

  meta = with stdenv.lib; {
    homepage = https://launchpad.net/gcstar;
    description = "A general purpose collection manager";
    longDescription = ''
    GCstar is an application for managing your collections.
    It supports many types of collections, including movies, books, games, comics, stamps, coins, and many more.
    You can even create your own collection type for whatever unique thing it is that you collect!
    Detailed information on each item can be automatically retrieved from the internet and you can store additional data, such as the location or who you've lent it to. You may also search and filter your collections by many criteria.
    '';
    license = licenses.gpl2;
    platforms = platforms.all;
  };
  
  inherit perl;
  inherit (perlPackages) Gtk2;
}

