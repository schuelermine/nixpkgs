{ python3, fetchFromGitHub, redis }:
python3.pkgs.buildPythonApplication rec {
  pname = "spdx-license-matcher";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "spdx";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oaG1GGAWMokW7vRqotufGUwvvBzm7KBlaermVngBRzs=";
  };

  nativeBuildInputs = [ redis python3.pkgs.pythonRelaxDepsHook ];
  propagatedBuildInputs = with python3.pkgs; [
    redis
    requests
    JPype1
    jellyfish
    click
    python-dotenv
  ];
}
