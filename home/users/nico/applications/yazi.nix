{
  config,
  lib,
  pkgs,
  ...
}@args:

let
  editNewTmuxWin = ''${lib.getExe config.programs.tmux.package} new-window -- "$EDITOR" -- "$@"'';
  dragAndDrop = ''${lib.getExe pkgs.dragon-drop} "$@"'';
in
{
  programs.yazi = {
    enable = true;
    package = pkgs.yazi.override { extraPackages = [ pkgs.exiftool ]; };
    settings = {
      mgr = {
        linemode = "mtime";
        show_hidden = true;
      };
      opener = {
        open = [
          {
            run = ''${config.home.shellAliases.open} "$@"'';
            desc = "Open";
          }
          {
            run = dragAndDrop;
            desc = "Drag and Drop";
          }
        ]
        ++ (lib.optional config.programs.tmux.enable {
          run = editNewTmuxWin;
          desc = "Edit in new tmux win";
        });
      };
    };
    keymap = {
      mgr.prepend_keymap = [
        {
          on = "ü";
          run = "shell -- ${dragAndDrop}";
        }
      ]
      ++ (lib.optional config.programs.tmux.enable {
        on = "ä";
        run = "shell -- ${editNewTmuxWin}";
      });
    };
    plugins = with pkgs.yaziPlugins; {
      inherit full-border;
    };
    initLua = /* lua */ ''
      require("full-border"):setup()
    '';
    theme = with config.colorScheme.palette; {
      mgr = {
        cwd = {
          fg = "#${base0C}";
        };

        find_keyword = {
          fg = "#${base01}";
          bg = "#${base0A}";
        };
        find_position = {
          fg = "#${base01}";
          bg = "#${base08}";
          italic = true;
        };

        marker_copied = {
          fg = "#${base0B}";
          bg = "#${base0B}";
        };
        marker_cut = {
          fg = "#${base08}";
          bg = "#${base08}";
        };
        marker_selected = {
          fg = "#${base0E}";
          bg = "#${base0E}";
        };

        tab_active = {
          fg = "#${base01}";
          bg = "#${base05}";
        };
        tab_inactive = {
          fg = "#${base05}";
          bg = "#${base03}";
        };
        tab_width = 1;

        count_copied = {
          fg = "#${base01}";
          bg = "#${base0B}";
        };
        count_cut = {
          fg = "#${base01}";
          bg = "#${base08}";
        };
        count_selected = {
          fg = "#${base01}";
          bg = "#${base0E}";
        };

        border_symbol = "│";
        border_style = {
          fg = "#${base04}";
        };

        syntect_theme = import ./tm-theme.nix args;
      };

      indicator = {
        parent = {
          fg = "#${base00}";
          bg = "#${base0D}";
        };
        current = {
          fg = "#${base00}";
          bg = "#${base0D}";
        };
        preview = {
          underline = true;
        };
        padding = {
          open = "█";
          close = "█";
        };
      };

      mode = {
        normal_main = {
          fg = "#${base02}";
          bg = "#${base0D}";
          bold = true;
        };
        normal_alt = {
          fg = "#${base02}";
          bg = "#${base07}";
          bold = true;
        };
        select_main = {
          fg = "#${base02}";
          bg = "#${base0B}";
          bold = true;
        };
        select_alt = {
          fg = "#${base02}";
          bg = "#${base0C}";
          bold = true;
        };
        unset_main = {
          fg = "#${base02}";
          bg = "#${base0F}";
          bold = true;
        };
        unset_alt = {
          fg = "#${base02}";
          bg = "#${base06}";
          bold = true;
        };
      };

      status = {
        overall = {
          bg = "#${base01}";
        };
        sep_left = {
          open = "";
          close = "";
        };
        sep_right = {
          open = "";
          close = "";
        };

        progress_label = {
          fg = "#${base04}";
          bold = true;
        };
        progress_normal = {
          fg = "#${base0D}";
          bg = "#${base03}";
        };
        progress_error = {
          fg = "#${base08}";
          bg = "#${base03}";
        };

        perm_type = {
          fg = "#${base0C}";
        };
        perm_read = {
          fg = "#${base0A}";
        };
        perm_write = {
          fg = "#${base08}";
        };
        perm_exec = {
          fg = "#${base0B}";
        };
        perm_sep = {
          fg = "#${base03}";
        };
      };

      input = {
        border = {
          fg = "#${base0D}";
        };
        title = { };
        value = { };
        selected = {
          reversed = true;
        };
      };

      select = {
        border = {
          fg = "#${base0D}";
        };
        active = {
          fg = "#${base06}";
        };
        inactive = { };
      };

      tasks = {
        border = {
          fg = "#${base0D}";
        };
        title = { };
        hovered = {
          underline = true;
        };
      };

      which = {
        mask = {
          bg = "#${base02}";
        };
        cand = {
          fg = "#${base0C}";
        };
        rest = {
          fg = "#${base07}";
        };
        desc = {
          fg = "#${base06}";
        };
        separator = "  ";
        separator_style = {
          fg = "#${base04}";
        };
      };

      help = {
        on = {
          fg = "#${base06}";
        };
        exec = {
          fg = "#${base0C}";
        };
        desc = {
          fg = "#${base07}";
        };
        hovered = {
          bg = "#${base04}";
          bold = true;
        };
        footer = {
          fg = "#${base03}";
          bg = "#${base05}";
        };
      };

      filetype = {
        rules = [
          # Media
          {
            mime = "image/*";
            fg = "#${base0E}";
          }
          {
            mime = "video/*";
            fg = "#${base0E}";
          }
          {
            mime = "audio/*";
            fg = "#${base0E}";
          }

          # Archives
          {
            mime = "application/zip";
            fg = "#${base08}";
          }
          {
            mime = "application/gzip";
            fg = "#${base08}";
          }
          {
            mime = "application/x-tar";
            fg = "#${base08}";
          }
          {
            mime = "application/x-bzip";
            fg = "#${base08}";
          }
          {
            mime = "application/x-bzip2";
            fg = "#${base08}";
          }
          {
            mime = "application/x-7z-compressed";
            fg = "#${base08}";
          }
          {
            mime = "application/x-rar";
            fg = "#${base08}";
          }

          {
            url = "*";
            is = "link";
            fg = "#${base0C}";
          }
          {
            url = "*";
            is = "exec";
            fg = "#${base0B}";
          }

          # Fallback
          {
            url = "*";
            fg = "#${base05}";
          }
          {
            url = "*/";
            fg = "#${base0D}";
          }
        ];
      };
    };
  };
}
