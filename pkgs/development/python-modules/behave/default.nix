{ stdenv, fetchFromGitHub
, buildPythonApplication, python
, mock, pathpy, pyhamcrest, pytest, pytest-html
, glibcLocales
, colorama, cucumber-tag-expressions, parse, parse-type, six
}:

buildPythonApplication rec {
  pname = "behave";
  version = "1.2.7.dev1";

  src = fetchFromGitHub {
    owner = "behave";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ssgixmqlg8sxsyalr83a1970njc2wg3zl8idsmxnsljwacv7qwv";
  };

  checkInputs = [ mock pathpy pyhamcrest pytest pytest-html ];
  buildInputs = [ glibcLocales ];
  propagatedBuildInputs = [ colorama cucumber-tag-expressions parse parse-type six ];

  postPatch = ''
    patchShebangs bin
  '';

  doCheck = true;

  checkPhase = ''
    export LANG="en_US.UTF-8"
    export LC_ALL="en_US.UTF-8"

    pytest tests

    ${python.interpreter} bin/behave -f progress3 --stop --tags='~@xfail' features/
    ${python.interpreter} bin/behave -f progress3 --stop --tags='~@xfail' tools/test-features/
    ${python.interpreter} bin/behave -f progress3 --stop --tags='~@xfail' issue.features/
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/behave/behave";
    description = "behaviour-driven development, Python style";
    license = licenses.bsd2;
    maintainers = with maintainers; [ alunduil maxxk ];
  };
}
