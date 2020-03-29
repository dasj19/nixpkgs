{stdenv, fetchFromGitLab, bash, perl, gtk2, perlPackages, wrapGAppsHook}:

stdenv.mkDerivation rec {
  pname = "gcstar";
  version = "1.7.2";

  src = fetchFromGitLab {
      owner = "Kerenoc";
      repo = "GCstar";
      rev = "v${version}";
      sha256 = "1vqfff33sssvlvsva1dflggmwl00j5p64sn1669f9wrbvjkxgpv4";
    };

  enableParallelBuilding = false;

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
    perlPackages.JSON
    perlPackages.ImageExifTool
    perlPackages.librelative
    perlPackages.LWPUserAgent
    perlPackages.LWPProtocolHttps
    perlPackages.MP3Info
    perlPackages.MP3Tag
    perlPackages.NetFreeDB
    perlPackages.OggVorbisHeaderPurePerl
    perlPackages.Pango
    perlPackages.XMLSimple
    perlPackages.XMLParser ];

  nativeBuildInputs = [ wrapGAppsHook ];
  buildInputs = perlDeps;
  propagatedBuildInputs = perlDeps;

  installPhase = ''
    cd gcstar

    perl install --text --prefix=$out

    # Setting up the desktop item.
    mkdir -p $out/share/applications
    mkdir -p $out/share/pixmaps
    cp share/applications/$pname.desktop $out/share/applications/$pname.desktop
    cp share/$pname/icons/${pname}_256x256.png $out/share/pixmaps/$pname.png
  '';

  postFixup = ''
    patchShebangs bin/gcstar
    patchShebangs ./install

    wrapProgram $out/bin/gcstar --prefix PERL5LIB : $PERL5LIB
  '';

  meta = with stdenv.lib; {
    homepage = https://gitlab.com/Kerenoc/GCstar;
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

