{ ... }:

{
  programs.starship = {
    enable = true;
    settings =
      let
        left1 = "$username[@](purple)$hostname$character$directory";
        env = "(<$shell> )$jobs( [⑆](bold)  $all)";
        right = "$git_status$git_branch $cmd_duration$status";
        left2 = "[λ](cyan) ";
      in
      {
        add_newline = false;
        format = "${left1}${env}$fill${right}$line_break${left2}";
        # format ="${left1}${env}$line_break${left2}";
        # right_format = "${right}$line_break";
        continuation_prompt = "[> ](bright-black bold)";

        username = {
          style_root = "red";
          style_user = "purple";
          format = "[$user]($style)";
          show_always = true;
        };

        hostname = {
          ssh_only = false;
          format = "[$ssh_symbol$hostname]($style) ";
          style = "purple";
        };

        character =
          let
            insert = "[+](green)";
            normal = "[#](yellow)";
            visual = "[%](purple)";
          in
          {
            format = "$symbol ";
            success_symbol = insert;
            error_symbol = insert;
            vimcmd_symbol = normal;
            vimcmd_replace_one_symbol = normal;
            vimcmd_replace_symbol = normal;
            vimcmd_visual_symbol = visual;
          };

        directory = {
          truncation_length = 3;
          truncate_to_repo = false;
          format = "[$path]($style)[$read_only]($read_only_style) ";
          style = "blue bold";
          read_only = "";
          fish_style_pwd_dir_length = 1;
        };

        shell = {
          format = "[$indicator]($style)";
          zsh_indicator = "";
          style = "bold";
          disabled = false;
        };

        fill.symbol = " ";

        cmd_duration = {
          format = "[$duration ]($style)";
          style = "yellow";
        };

        status = {
          format = "[$symbol $status]($style)";
          symbol = "🞩";
          success_symbol = "↵";
          success_style = "green bold";
          failure_style = "red bold";
          disabled = false;
        };

        git_branch = {
          format = "[$symbol$branch(:$remote_branch)]($style) ";
          style = "bold cyan";
        };

        battery.disabled = true;

        c.style = "bold blue";
        java.style = "bold blue";
        ocaml.style = "bold blue";

        nix_shell = {
          format = "[<$state( \($name\))>]($style) ";
          style = "bold cyan";
          unknown_msg = "unknown";
        };
      };
  };
}
