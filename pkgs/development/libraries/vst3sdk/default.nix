{ stdenv
, lib
, fetchFromGitHub
, cmake
, libX11
, freetype
, pkg-config
, xcbutil
, xcbutilcursor
, xcbutilkeysyms
, libxkbcommon
, glib
, cairo
, pango
, gtkmm3
, sqlite
}:

stdenv.mkDerivation rec {
  pname = "vst3sdk";
  version = "3.7.6_build_18";

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "steinbergmedia";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jfh+iP5rqov8q++IyG4FXlYKs4PQtFjCwCP6xou8N0E=";
    fetchSubmodules = true;
  };

  postPatch = ''
    patchShebangs vstgui4/vstgui/uidescription/editing/createuidescdata.sh
  '';

  preBuild = ''
    export HOME=$(mktemp -d)
    export XDG_CONFIG_HOME=$(mktemp -d)
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libX11
    freetype
    xcbutil
    xcbutilcursor
    xcbutilkeysyms
    libxkbcommon
    glib
    cairo
    pango
    gtkmm3
    sqlite
  ];

  meta = {
    description = "VST 3 SDK";
    homepage = "https://github.com/steinbergmedia/vst3sdk";
    license = with lib.licenses; [
      gpl3Only
      unfree
    ];
    maintainers = [ lib.maintainers.anselmschueler ];
  };
}
