{ pkgs, lib, myUser, ... }:

let
  myUser = "gustavo";
in
{
  home.username = myUser;
  home.homeDirectory = "/home/${myUser}";
  home.stateVersion = "25.11";

  fonts.fontconfig.enable = true;

  nixpkgs.config.allowUnfree = true;



  home.packages = with pkgs; [

    (pkgs.python3.withPackages (ps: with ps; [
      sounddevice
    ]))
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

    ##MINER
     ffmpeg
    steam-run
    xclip
    libevdev
    fuse2 
    python313Packages.pip
    python313Packages.uv
    python313Packages.pyqt6
    portaudio

    jq
    appimage-run
    ruby
    micro

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
    chafa
    steamtinkerlaunch
    p7zip
    dua
    ncdu
    yt-dlp
    ##screenshot
    hyprshot
    mako
    wl-clipboard
    zip
    ddrescue
    pavucontrol
    wine
    winetricks
    ffmpeg
    ani-cli
    hakuneko
    anime-downloader
    openvpn
    animdl
    upower
    tlp
    powertop
    android-tools
    ffsubsync
    mpv
    imagemagick
    libjpeg
    libpng
    #imagemagick6
    wallust
    peaclock
    termdown

      fuse
  fuse3
  appimage-run
  

    ## GTK
    adwaita-icon-theme
    nwg-look
    ##
  ];

  #home.file.".icons/default/index.theme".force = true;

  home.sessionVariables = {
    LD_LIBRARY_PATH = "${pkgs.portaudio}/lib";
  };

  imports = [ 
  ];


  

  programs.waybar.enable = true;

  
  
  programs.git = {
    enable = true;
    settings = {
      user = {
        name  = "thedance";
        email = "lsbgustavo@gmail.com";
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

  xdg.mimeApps.defaultApplications = {
  "application/x-msdownload" = "wine.desktop";
  "application/octet-stream" = "wine.desktop";
  };


  # WAYBAR
  xdg.configFile."waybar/config".source = ./waybar/config;
  xdg.configFile."waybar/style.css".source = lib.mkForce ./waybar/style.css;

  # PYWAL
  xdg.configFile."wal/templates/colors-gtk.css".source = ./wal/templates/colors-gtk.css;
  xdg.configFile."wal/templates/hyprland.conf".source = ./wal/templates/hyprland.conf;
  xdg.configFile."wal/templates/mako".source = ./wal/templates/mako;

  ## TERMINAL
  xdg.configFile."fastfetch/config.jsonc".source = ./fastfetch/config.jsonc;
  xdg.configFile."kitty/kitty.conf".source = ./kitty/kitty.conf;

  ## ZSH
  home.file.".zshrc".source = ./zsh/.zshrc;
  
  # FIREFOX
  home.file.".mozilla/firefox/1gir5vgc.default/chrome/userChrome.css".source = ./firefox/userChrome.css;

  ## HYPRLAND
  xdg.configFile."hypr/hyprland.conf".source = ./hypr/hyprland.conf;

  ## WAYPAPER
  #xdg.configFile."waypaper/config.ini".source = ./waypaper/config.ini;
  xdg.configFile."waypaper/post.sh".source = ./waypaper/post.sh;


  services.mako = {
  enable = true;

  extraConfig = ''
    include=/home/${myUser}/.cache/wal/mako
  '';
};
}