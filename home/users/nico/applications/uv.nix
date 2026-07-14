{
  ...
}:

{
  programs.uv = {
    enable = true;
    python = {
      prune = true;
      versions = [
        "3.13"
      ];
    };
    tool = {
      prune = true;
      packages = [
        "pwntools"
      ];
    };
  };
}
