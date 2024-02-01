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

      ms-vscode.hexeditor
      shd101wyy.markdown-preview-enhanced
      mechatroner.rainbow-csv

      ms-vscode-remote.remote-ssh
      # vscodevim.vim
      github.copilot
      # github.copilot-chat
      eamodio.gitlens

      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
      usernamehw.errorlens
    ];
  };
}
