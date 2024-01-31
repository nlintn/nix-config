{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      llvm-vs-code-extensions.vscode-clangd
      vadimcn.vscode-lldb
      rust-lang.rust-analyzer
      jnoortheen.nix-ide
      twxs.cmake
      ms-python.vscode-pylance

      ms-vscode-remote.remote-ssh
      usernamehw.errorlens
      eamodio.gitlens
      ms-vscode.hexeditor
      shd101wyy.markdown-preview-enhanced
      mechatroner.rainbow-csv

      # vscodevim.vim
      github.copilot
      # github.copilot-chat
    ];
  };
}