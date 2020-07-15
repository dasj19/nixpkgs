{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "filtron";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "asciimoo";
    repo = "filtron";
    rev = "v${version}";
    sha256 = "1yvln4im9cwxsan6x245sfcy0lc4k6l89ibvxpsx0y274nllq7qy";
  };

  goPackagePath = "github.com/asciimoo/filtron";

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Reverse HTTP proxy to filter requests by different rules.";
    homepage = "https://github.com/asciimoo/filtron";
    license = licenses.agpl3;
    maintainers = [ maintainers.dasj19 ];
    platforms = platforms.linux;
  };
}
