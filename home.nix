{ config, pkgs, ... }:

let
  name = {
    first = "Noam";
    last = "Prag";
    user = "noamprag";
    email = "noam.prag0@gmail.com";
    full = "${name.first} ${name.last}";
  };
  homeDirectory = "/Users/${name.user}";
  pyenv = {
    rootPath = ".local/share/pyenv";
  };
  omz = {
    rootPath = ".oh-my-zsh";
    customPath = "${omz.rootPath}/custom";
  };
in
{
  home.username = name.user;
  home.homeDirectory = homeDirectory;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.packages = with pkgs; ([
    # nerdfonts
    zsh-powerlevel10k
    nmap
    cargo
    ncdu
    chafa
    gum
    asciinema
    just
    localsend
    cmatrix
    ffmpeg_8
    spotify
  ]);
  
  nixpkgs.config.allowUnfreePredicate =
    pkg: builtins.elem (pkgs.lib.getName pkg) [
      "spotify"
      "discord"
      "raycast"
    ];

  home.file = {
    "${omz.customPath}/themes/powerlevel10k/powerlevel10k.zsh-theme".source =  "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    "${pyenv.rootPath}/plugins/pyenv-virtualenv".source = pkgs.fetchFromGitHub {
      owner = "pyenv";
      repo = "pyenv-virtualenv";
      rev = "v1.2.4";
      sha256 = "sha256-NgtowwE1T5NoiYiL18vdpYumVuPSWoDCOyP2//d+uHk=";
    };
    ".config/btop/themes/catppuccin_mocha.theme".source = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "btop";
      rev = "1.0.0";
      sha256 = "sha256-J3UezOQMDdxpflGax0rGBF/XMiKqdqZXuX4KMVGTxFk=";
    } + "/themes/catppuccin_mocha.theme";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL=config.home.sessionVariables.EDITOR;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
    };
    wezterm = {
      enable = true;
      extraConfig = ''
        return {
          font = wezterm.font("JetBrainsMono Nerd Font"),
          font_size = 15.0,
          color_scheme = "Catppuccin Mocha",
          hide_tab_bar_if_only_one_tab = true,
        }
      '';
    };
    helix = {
        enable = true;
        settings.theme = "base16_transparent";
    };
    neovim = {
        enable = true;
        defaultEditor = true;
    };
    zellij.enable = true;
    fd = {
        enable = true;
        hidden = true;
        ignores = [".git/"];
    };
    lsd = {
      enable = true;
      enableZshIntegration = true;
    };
    ripgrep.enable = true;
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    pyenv = {
      enable = true;
      enableZshIntegration = true;
      rootDirectory = "${homeDirectory}/${pyenv.rootPath}";
    };
    zoxide = {
        enable = true;
        enableZshIntegration = true;
    };
    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [ batdiff batman batgrep batwatch ];
      config.theme = "Catppuccin Mocha";
      themes = {
        catppuccin = {
          src = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat";
            rev = "6810349b28055dce54076712fc05fc68da4b8ec0";
            sha256 = "sha256-lJapSgRVENTrbmpVyn+UQabC9fpV1G1e+CdlJ090uvg=";
          };
        };
      };
    };
    git = {
      enable = true;
      delta.enable = true;
      userName = name.full;
      userEmail = name.email;
      ignores = [
        "*.swp"
      ];
      signing.format = "ssh";
      extraConfig = {
        init.defaultBranch = "main";
        fetch.prune = true;
        pull.ff = "only";
        delta = {
          # navigate = true;
          # side-by-side = true;
          features = "catppuccin-mocha";
        };
      };
      includes = [
        {
          path = (
            pkgs.fetchFromGitHub {
              owner = "catppuccin";
              repo = "delta";
              rev = "7b06b1f174c03f53ff68da1ae1666ca3ef7683ad";
              sha256 = "sha256-HHD0hszHIxf/tyQgS5KtdAN5m0EM9oI54cA2Ij1keOI=";
            } + "/catppuccin.gitconfig"
          );
        }
      ];
    };
    lazygit.enable = true;
    lazydocker.enable = true;
    btop = {
      enable = true;
      settings.color_theme = "catppuccin_mocha";
    };
    zsh = {
        enable = true;
        autosuggestion.enable = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;
        plugins = [
          {
            name = "zsh-vi-mode";
            src = pkgs.fetchFromGitHub {
              owner = "jeffreytse";
              repo = "zsh-vi-mode";
              rev = "v0.12.0";
              sha256 = "sha256-EYr/jInRGZSDZj+QVAc9uLJdkKymx1tjuFBWgpsaCFw=";
            };
            file = "zsh-vi-mode.plugin.zsh";
          }
          {
            name = "zsh-autopair";
            src = pkgs.fetchFromGitHub {
              owner = "hlissner";
              repo = "zsh-autopair";
              rev = "master";
              sha256 = "sha256-3zvOgIi+q7+sTXrT+r/4v98qjeiEL4Wh64rxBYnwJvQ=";
            };
            file = "zsh-autopair.plugin.zsh";
          }
          {
            name = "zsh-you-should-use";
            src = pkgs.fetchFromGitHub {
              owner = "MichaelAquilina";
              repo = "zsh-you-should-use";
              rev = "1.10.0";
              sha256 = "sha256-dG6E6cOKu2ZvtkwxMXx/op3rbevT1QSOQTgw//7GmSk=";
            };
            file = "zsh-you-should-use.plugin.zsh";
          }
          {
            name = "fzf-tab";
            src = pkgs.fetchFromGitHub {
              owner = "Aloxaf";
              repo = "fzf-tab";
              rev = "v1.2.0";
              sha256 = "sha256-q26XVS/LcyZPRqDNwKKA9exgBByE0muyuNb0Bbar2lY=";
            };
            file = "fzf-tab.plugin.zsh";
          }
        ];
        oh-my-zsh = {
          enable = true;
          plugins = [
            "git"
            "sudo"
            "colored-man-pages"
            "docker"
          ];
          custom = "${homeDirectory}/${omz.customPath}";
          theme = "powerlevel10k/powerlevel10k";
        };
        initContent = let 
        zshConfig = pkgs.lib.mkOrder 1000 ''
          ZVM_KEYTIMEOUT=0.1
          ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
          ZVM_VI_HIGHLIGHT_BACKGROUND=white
          ZVM_VI_HIGHLIGHT_FOREGROUND=black

          zvm_after_init() {
            autopair-init
            bindkey "^r" fzf-history-widget
          }

          [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

          pipclean() {
            pip uninstall -y -r <(pip freeze)
          }
          pipup() {
            pip install --upgrade pip
          }
        '';
        zshConfigLastInit = pkgs.lib.mkOrder 1500 ''
          eval "$(pyenv virtualenv-init -)"
        '';
        in
          pkgs.lib.mkMerge [zshConfig zshConfigLastInit];
        shellAliases = {
          cat = "bat";
          cd = "z";
          vim = "nvim";
          zj = "zellij";

          l = "lsd -lhF --git --gitsort";
          tree = "lsd --tree";


          pipi = "pip install";
          pipli = "pip list";
          pyver = "pyenv versions";
          venv = "pyenv virtualenv";
          venv-del = "pyenv virtualenv-delete";
        };
    };
    aichat.enable = true;
  };
}
