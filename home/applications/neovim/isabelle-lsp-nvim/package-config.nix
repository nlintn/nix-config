{ pkgs }:

let
  isabelle = pkgs.isabelle.overrideAttrs
    (
      _: let
        src_dev = pkgs.fetchFromGitHub {
          owner = "m-fleury";
          repo = "isabelle-emacs";
          rev = "bd8fd356fbd373ff9e78cea09a58ba6de1d6ccfc";
          sha256 = "sha256-97x+BjFU3+QIAzqiCWArxb21FzdCDjK7TjZr191yX9k=";
        };
      in {
        prePatch = ''
          rm -r src/
          cp -r ${src_dev}/src ./
          cp ${src_dev}/etc/build.props etc/
          chmod -R +w ./src
        '';
        patches = [ ./isabelle-emacs.patch ];
      }
    );
in {
  package = pkgs.vimUtils.buildVimPlugin {
    name = "isabelle-lsp-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "Treeniks";
      repo = "isabelle-lsp.nvim";
      rev = "f35632c86930e71e2517ee7dc0d054e785d64728";
      sha256 = "sha256-0IEkzyX05TVaAEABTRCuKWKMj1GFkrRx9g9u11C31p4=";
    };
    patches = [ ./highlight-group.patch ];
  };
  config = /* lua */ ''
    require("isabelle-lsp").setup({
      isabelle_path = "${isabelle}/bin/isabelle",
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "isabelle" },
      callback = function()
        vim.schedule(function()
          vim.keymap.set("i", "=>", "\\<Rightarrow>", { buffer = true, silent = true })
          vim.keymap.set("i", "==>", "\\<Longrightarrow>", { buffer = true, silent = true })
          vim.keymap.set("i", "->", "\\<rightarrow>", { buffer = true, silent = true })
          vim.keymap.set("i", "-->", "\\<longrightarrow>", { buffer = true, silent = true })
          vim.keymap.set("i", "--->", "\\<longlongrightarrow>", { buffer = true, silent = true })
          vim.keymap.set("i", "<=", "\\<Leftarrow>", { buffer = true, silent = true })
          vim.keymap.set("i", "<==", "\\<Longleftarrow>", { buffer = true, silent = true })
          vim.keymap.set("i", "<-", "\\<leftarrow>", { buffer = true, silent = true })
          vim.keymap.set("i", "<--", "\\<longleftarrow>", { buffer = true, silent = true })
          vim.keymap.set("i", "<---", "\\<longlongleftarrow>", { buffer = true, silent = true })

          vim.keymap.set("i", "<=", "\\<le>", { buffer = true, silent = true })
          vim.keymap.set("i", ">=", "\\<ge>", { buffer = true, silent = true })
          vim.keymap.set("i", "!=", "\\<noteq>", { buffer = true, silent = true })
          vim.keymap.set("i", "=3", "\\<equiv>", { buffer = true, silent = true })

          vim.keymap.set("i", "<<", "\\<open>", { buffer = true, silent = true })
          vim.keymap.set("i", ">>", "\\<close>", { buffer = true, silent = true })
        end)
      end,
    })
  '';
}
