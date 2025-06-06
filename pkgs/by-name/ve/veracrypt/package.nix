{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  makeself,
  yasm,
  fuse,
  wxGTK32,
  lvm2,
  replaceVars,
  e2fsprogs,
  exfat,
  ntfs3g,
  btrfs-progs,
  pcsclite,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "veracrypt";
  version = "1.26.24";

  src = fetchurl {
    url = "https://launchpad.net/veracrypt/trunk/${finalAttrs.version}/+download/VeraCrypt_${finalAttrs.version}_Source.tar.bz2";
    hash = "sha256-f1wgr0KTd6tW97UsqGiTa5kj14T0YG2piGw2KXiQPng=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      ext2 = "${e2fsprogs}/bin/mkfs.ext2";
      ext3 = "${e2fsprogs}/bin/mkfs.ext3";
      ext4 = "${e2fsprogs}/bin/mkfs.ext4";
      exfat = "${exfat}/bin/mkfs.exfat";
      ntfs = "${ntfs3g}/bin/mkfs.ntfs";
      btrfs = "${btrfs-progs}/bin/mkfs.btrfs";
    })

    # https://github.com/veracrypt/VeraCrypt/commit/2cca2e1dafa405addc3af8724baf8563f352ac1c
    ./nix-system-paths.patch
  ];

  sourceRoot = "src";

  nativeBuildInputs = [
    makeself
    pkg-config
    yasm
    wrapGAppsHook3
  ];
  buildInputs = [
    fuse
    lvm2
    wxGTK32
    pcsclite
  ];

  enableParallelBuilding = true;

  installPhase = ''
    install -Dm 755 Main/veracrypt "$out/bin/veracrypt"
    install -Dm 444 Resources/Icons/VeraCrypt-256x256.xpm "$out/share/pixmaps/veracrypt.xpm"
    install -Dm 444 License.txt -t "$out/share/doc/veracrypt/"
    install -d $out/share/applications
    substitute Setup/Linux/veracrypt.desktop $out/share/applications/veracrypt.desktop \
      --replace-fail "Exec=/usr/bin/veracrypt" "Exec=$out/bin/veracrypt" \
      --replace-fail "Icon=veracrypt" "Icon=veracrypt.xpm"
  '';

  meta = {
    description = "Free Open-Source filesystem on-the-fly encryption";
    homepage = "https://www.veracrypt.fr/";
    license = with lib.licenses; [
      asl20 # and
      unfree # TrueCrypt License version 3.0
    ];
    maintainers = with lib.maintainers; [
      dsferruzza
      ryand56
    ];
    platforms = lib.platforms.linux;
  };
})
