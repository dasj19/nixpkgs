{ stdenv, fetchFromGitHub, apacheHttpd }:


stdenv.mkDerivation rec {
  pname = "mod_cspnonce";
  version = "1.2.1";
  src = fetchFromGitHub {
    owner = "wyattoday";
    repo = "mod_cspnonce";
    rev = version;
    sha256 = "1qmc7i53p88jqd5gab8315lfrxn9q5l49r03zpaj3fh1afps2p0z";
  };

  buildInputs = [ apacheHttpd ];

  buildPhase = ''
    export APACHE_LIBEXECDIR=$out/modules
    export makeFlagsArray=(APACHE_LIBEXECDIR=$out/modules)
    apxs -ca mod_cspnonce.c
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/modules
    cp .libs/mod_cspnonce.so $out/modules
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "An Apache2 module that makes it dead simple to add nonce values to the CSP";

    homepage = "https://github.com/wyattoday/mod_cspnonce";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dasj19 ];
  };
}
