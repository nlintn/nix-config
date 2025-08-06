{ config, pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    package = pkgs.yazi.override { extraPackages = [ pkgs.exiftool ]; };
    enableZshIntegration = true;
    settings = {
      mgr.show_hidden = true;
      opener.open = [
        { run = ''${config.home.shellAliases.open} "$@"'';  desc = "Open"; }
        { run = ''${config.home.shellAliases.xopen} "$@"''; desc = "XOpen"; }
      ];
    };
    theme = with config.colorScheme.palette; {
      mgr = {
        cwd = { fg = "#${base0C}"; };

        # Hovered
        hovered         = { fg = "#${base00}"; bg = "#${base0D}"; };
        preview_hovered = { underline = true; };

        # Find
        find_keyword  = { fg = "#${base0A}"; italic = true; };
        find_position = { fg = "#${base06}"; bg = "reset"; italic = true; };

        # Marker
        marker_copied   = { fg = "#${base0B}"; bg = "#${base0B}"; };
        marker_cut      = { fg = "#${base08}"; bg = "#${base08}"; };
        marker_selected = { fg = "#${base0E}"; bg = "#${base0E}"; };

        # Tab
        tab_active   = { fg = "#${base00}"; bg = "#${base05}"; };
        tab_inactive = { fg = "#${base05}"; bg = "#${base03}"; };
        tab_width    = 1;

        # Count
        count_copied   = { fg = "#${base00}"; bg = "#${base0B}"; };
        count_cut      = { fg = "#${base00}"; bg = "#${base08}"; };
        count_selected = { fg = "#${base00}"; bg = "#${base0E}"; };

        # Border
        border_symbol = "│";
        border_style  = { fg = "#${base04}"; };

        # Highlighting
        # syntect_theme = "~/.config/yazi/Catppuccin-macchiato.tmTheme";
      };

      status = {
        separator_open  = "";
        separator_close = "";
        separator_style = { fg = "#${base03}"; bg = "#${base03}"; };

        # Mode
        mode_normal = { fg = "#${base00}"; bg = "#${base0D}"; bold = true; };
        mode_select = { fg = "#${base00}"; bg = "#${base0B}"; bold = true; };
        mode_unset  = { fg = "#${base00}"; bg = "#${base0F}"; bold = true; };

        # Progress
        progress_label  = { fg = "#${base04}"; bold = true; };
        progress_normal = { fg = "#${base0D}"; bg = "#${base03}"; };
        progress_error  = { fg = "#${base08}"; bg = "#${base03}"; };

        # Permissions
        permissions_t = { fg = "#${base0D}"; };
        permissions_r = { fg = "#${base0A}"; };
        permissions_w = { fg = "#${base08}"; };
        permissions_x = { fg = "#${base0B}"; };
        permissions_s = { fg = "#${base04}"; };
      };

      input = {
        border   = { fg = "#${base0D}"; };
        title    = {};
        value    = {};
        selected = { reversed = true; };
      };

      select = {
        border   = { fg = "#${base0D}"; };
        active   = { fg = "#${base06}"; };
        inactive = {};
      };

      tasks = {
        border  = { fg = "#${base0D}"; };
        title   = {};
        hovered = { underline = true; };
      };

      which = {
        mask            = { bg = "#${base02}"; };
        cand            = { fg = "#${base0C}"; };
        rest            = { fg = "#${base07}"; };
        desc            = { fg = "#${base06}"; };
        separator       = "  ";             
        separator_style = { fg = "#${base04}"; };
      };

      help = {
        on      = { fg = "#${base06}"; };
        exec    = { fg = "#${base0C}"; };
        desc    = { fg = "#${base07}"; };
        hovered = { bg = "#${base04}"; bold = true; };
        footer  = { fg = "#${base03}"; bg = "#${base05}"; };
      };

      filetype = {
        rules = [
          # Images
          { mime = "image/*"; fg = "#${base0C}"; }

          # Videos
          { mime = "video/*"; fg = "#${base0A}"; }
          { mime = "audio/*"; fg = "#${base0A}"; }

          # Archives
          { mime = "application/zip";             fg = "#${base06}"; }
          { mime = "application/gzip";            fg = "#${base06}"; }
          { mime = "application/x-tar";           fg = "#${base06}"; }
          { mime = "application/x-bzip";          fg = "#${base06}"; }
          { mime = "application/x-bzip2";         fg = "#${base06}"; }
          { mime = "application/x-7z-compressed"; fg = "#${base06}"; }
          { mime = "application/x-rar";           fg = "#${base06}"; }

          # Fallback
          { name = "*"; fg = "#${base05}"; }
          { name = "*/"; fg = "#${base0D}"; }
        ];
      };
    };
  };
}
