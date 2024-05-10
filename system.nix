{ config, pkgs, lib, inputs, user, ... }:
{
  imports = [
    ./modules/desktop
  ];

  users.users."${user}" = {
    # macOS user
    home = "/Users/${user}";
    shell = pkgs.zsh;
  };

  networking = {
    hostName = "MacBook";
  };

  environment = {
    shells = with pkgs; [ zsh ];
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    systemPackages = with pkgs; [
      git
      neovim
      wget
      neofetch
      eza
      p7zip
      unzip
      ffmpeg
      nodejs
      fd
      ripgrep
    ];
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      nerdfonts
      twemoji-color-font
    ];
  };
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Necessary for using flakes on this system.
  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = false; # Optimise syslinks
    };
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  programs.fish.enable = true;
  programs.gnupg.agent.enable = true;

  homebrew = {
    # Declare Homebrew using Nix-Darwin
    enable = true;
    onActivation = {
      autoUpdate = false; # Auto update packages
      upgrade = false;
      cleanup = "zap"; # Uninstall not listed packages and casks
    };
    brews = [
      "iproute2mac"
      "pinentry-mac"
      "aliyun-cli"
      "awscli"
      "jq"
      "anhoder/go-musicfox/go-musicfox"
      "mysql"
      "pkg-config"
      "poetry"
      "cloc"
      "yazi"
      "rust"
    ];
    taps = [
      "anhoder/go-musicfox"
      {
        name = "lencx/chatgpt";
        clone_target = "https://github.com/lencx/ChatGPT.git";
        force_auto_update = true;
      }
    ];
    casks = [
      "neteasemusic"
      "dingtalk"
      "firefox"
      "qq"
      "todesk"
      "wpsoffice-cn"
      "chatgpt"
      "docker"
      "dbeaver-community"
      "iterm2"
    ];
  };

  system = {
    defaults = {
      dock = {
        autohide = true;
        show-recents = false;
      };
    };
    keyboard.remapCapsLockToEscape = true;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "x86_64-darwin";
}
