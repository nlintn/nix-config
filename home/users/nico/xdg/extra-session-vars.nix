{
  config,
  ...
}:

let
  inherit (config.xdg)
    cacheHome
    configHome
    dataHome
    stateHome
    ;

  runtimeDir = "\${XDG_RUNTIME_DIR:-/run/user/$UID}";
in
{
  home.sessionVariables = {
    XCOMPOSECACHE = "${cacheHome}/X11/compose";

    NPM_CONFIG_INIT_MODULE = "${configHome}/npm/config/npm-init.js";
    NPM_CONFIG_CACHE = "${cacheHome}/npm";
    NPM_CONFIG_TMP = "${runtimeDir}/npm";

    ANSIBLE_HOME = "${dataHome}/ansible";

    GRADLE_USER_HOME = "${dataHome}/gradle";

    PYTHON_HISTORY = "${stateHome}/python_history";

    GOPATH = "${dataHome}/go";
  };
}
