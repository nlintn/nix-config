{
  ...
}:

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
          read_only = " 󰌾";
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

        # nerd font symbols
        aws = {
          symbol = " ";
        };
        azure = {
          symbol = " ";
        };
        battery = {
          charging_symbol = "󰂄 ";
          discharging_symbol = "󰂃 ";
          empty_symbol = "󰂎 ";
          full_symbol = "󰁹 ";
          unknown_symbol = "󰂑 ";
        };
        buf = {
          symbol = " ";
        };
        bun = {
          symbol = " ";
        };
        c = {
          symbol = " ";
        };
        cmake = {
          symbol = " ";
        };
        cobol = {
          symbol = " ";
        };
        conda = {
          symbol = " ";
        };
        container = {
          symbol = " ";
        };
        cpp = {
          symbol = " ";
        };
        crystal = {
          symbol = " ";
        };
        dart = {
          symbol = " ";
        };
        deno = {
          symbol = " ";
        };
        direnv = {
          symbol = " ";
        };
        docker_context = {
          symbol = " ";
        };
        dotnet = {
          symbol = " ";
        };
        elixir = {
          symbol = " ";
        };
        elm = {
          symbol = " ";
        };
        erlang = {
          symbol = " ";
        };
        fennel = {
          symbol = " ";
        };
        fortran = {
          symbol = " ";
        };
        fossil_branch = {
          symbol = " ";
        };
        gcloud = {
          symbol = "󱇶 ";
        };
        git_branch = {
          symbol = " ";
        };
        git_commit = {
          tag_symbol = "  ";
        };
        gleam = {
          symbol = " ";
        };
        golang = {
          symbol = " ";
        };
        gradle = {
          symbol = " ";
        };
        guix_shell = {
          symbol = " ";
        };
        haskell = {
          symbol = " ";
        };
        haxe = {
          symbol = " ";
        };
        helm = {
          symbol = " ";
        };
        hg_branch = {
          symbol = " ";
        };
        hostname = {
          ssh_symbol = " ";
        };
        java = {
          symbol = " ";
        };
        julia = {
          symbol = " ";
        };
        kotlin = {
          symbol = " ";
        };
        kubernetes = {
          symbol = "󱃾 ";
        };
        lua = {
          symbol = " ";
        };
        maven = {
          symbol = " ";
        };
        memory_usage = {
          symbol = "󰍛 ";
        };
        meson = {
          symbol = "󰔷 ";
        };
        mojo = {
          symbol = "󰈸 ";
        };
        nats = {
          symbol = " ";
        };
        netns = {
          symbol = "󰛳 ";
        };
        nim = {
          symbol = " ";
        };
        nix_shell = {
          symbol = " ";
        };
        nodejs = {
          symbol = " ";
        };
        ocaml = {
          symbol = " ";
        };
        odin = {
          symbol = "󰟢 ";
        };
        opa = {
          symbol = " ";
        };
        openstack = {
          symbol = " ";
        };
        os = {
          symbols = {
            AIX = " ";
            ALTLinux = " ";
            AOSC = " ";
            AlmaLinux = " ";
            Alpaquita = " ";
            Alpine = " ";
            Amazon = " ";
            Android = " ";
            Arch = " ";
            Artix = " ";
            Bluefin = " ";
            CachyOS = " ";
            CentOS = " ";
            Debian = " ";
            DragonFly = " ";
            Elementary = " ";
            Emscripten = " ";
            EndeavourOS = " ";
            Fedora = " ";
            FreeBSD = " ";
            Garuda = " ";
            Gentoo = " ";
            HardenedBSD = "󰞌 ";
            Illumos = " ";
            InstantOS = " ";
            Ios = "󰀷 ";
            Kali = " ";
            Linux = " ";
            Mabox = " ";
            Macos = " ";
            Manjaro = " ";
            Mariner = " ";
            MidnightBSD = " ";
            Mint = " ";
            NetBSD = " ";
            NixOS = " ";
            Nobara = " ";
            OpenBSD = " ";
            OpenCloudOS = " ";
            OracleLinux = "󰺡 ";
            PikaOS = " ";
            Pop = " ";
            Raspbian = " ";
            RedHatEnterprise = "󱄛 ";
            Redhat = "󱄛 ";
            Redox = "󰀘 ";
            RockyLinux = " ";
            SUSE = " ";
            Solus = " ";
            Ubuntu = " ";
            Ultramarine = " ";
            Unknown = " ";
            Uos = " ";
            Void = " ";
            Windows = "󰍲 ";
            Zorin = " ";
            openEuler = " ";
            openSUSE = " ";
          };
        };
        package = {
          symbol = "󰏗 ";
        };
        perl = {
          symbol = " ";
        };
        php = {
          symbol = " ";
        };
        pijul_channel = {
          symbol = " ";
        };
        pixi = {
          symbol = "󰏗 ";
        };
        pulumi = {
          symbol = " ";
        };
        purescript = {
          symbol = " ";
        };
        python = {
          symbol = " ";
        };
        raku = {
          symbol = "󱖊 ";
        };
        red = {
          symbol = "󱍼 ";
        };
        rlang = {
          symbol = "󰟔 ";
        };
        ruby = {
          symbol = " ";
        };
        rust = {
          symbol = "󱘗 ";
        };
        scala = {
          symbol = " ";
        };
        shlvl = {
          symbol = "󰹍 ";
        };
        singularity = {
          symbol = " ";
        };
        solidity = {
          symbol = " ";
        };
        spack = {
          symbol = " ";
        };
        sudo = {
          symbol = " ";
        };
        swift = {
          symbol = " ";
        };
        terraform = {
          symbol = " ";
        };
        typst = {
          symbol = " ";
        };
        vagrant = {
          symbol = " ";
        };
        vlang = {
          symbol = " ";
        };
        xmake = {
          symbol = " ";
        };
        zig = {
          symbol = " ";
        };
      };
  };
}
