{ pkgs, lib, myUser, env, ... }:

let
  env = builtins.fromJSON (builtins.readFile ./system.json);
  myUser = env.USERNAME;
in
{
  home.username = myUser;
  home.homeDirectory = "/home/${myUser}";
  home.stateVersion = "25.11";

  fonts.fontconfig.enable = true;

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    ## TERMINAL
    fastfetch
    zsh
    zsh-autosuggestions
    fzf
    nano
    unzip
    unrar
    git 
    pywal
    parted
    fprintd
    

    pkg-config
    gtk3
    yazi
    swww
    imagemagick
    bc
    pywalfox-native
    brightnessctl
    cava
    asciiquarium
    cmatrix 
    sshs

    htop
    btop
    glances
    bastet
    tty-clock
    termshark
    bluetuith


    ## GTK
    adwaita-icon-theme
    nwg-look
    ##
  ];

  #home.file.".icons/default/index.theme".force = true;

  home.sessionVariables = {
  };

  imports = [
  ];


  

  programs.waybar.enable = true;

  
  
  programs.git = {
    enable = true;
    # Load name/email from JSON
    settings = {
      user = {
        name  = env.GIT_NAME;
        email = env.GIT_EMAIL;
      };
    };
  };

  home.pointerCursor = {
  gtk.enable = true;
  x11.enable = true;
  name = "capitaine-cursors";
  size = 48;
  package = pkgs.capitaine-cursors;
};


  # WAYBAR
  xdg.configFile."waybar/config".source = ./waybar/config;
  xdg.configFile."waybar/style.css".source = lib.mkForce ./waybar/style.css;

  # PYWAL
  xdg.configFile."wal/templates/colors-gtk.css".source = ./wal/templates/colors-gtk.css;
  xdg.configFile."wal/templates/hyprland.conf".source = ./wal/templates/hyprland.conf;

  ## TERMINAL
  xdg.configFile."fastfetch/config.jsonc".source = ./fastfetch/config.jsonc;
  xdg.configFile."kitty/kitty.conf".source = ./kitty/kitty.conf;

  ## ZSH
  home.file.".zshrc".source = ./zsh/.zshrc;

  ## HYPRLAND
  xdg.configFile."hypr/hyprland.conf".source = ./hypr/hyprland.conf;

  ## WAYPAPER
  #xdg.configFile."waypaper/config.ini".source = ./waypaper/config.ini;
  xdg.configFile."waypaper/post.sh".source = ./waypaper/post.sh;

}