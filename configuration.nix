{ config, pkgs, lib, ... }:

let
  #home-manager = builtins.fetchTarball {
  #url = "https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz";
  #};
  #env = builtins.fromJSON (builtins.readFile ./system.json);
  #myUser = env.USERNAME;
  myUser = "gustavo";
  /* zen-browser = import (builtins.fetchTarball "https://github.com/youwen5/zen-browser-flake/archive/master.tar.gz") {
  inherit pkgs;
    }; */
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #(import "${home-manager}/nixos")
      #inputs.spicetify-nix.nixosModules.spicetify
    ];

   nix.settings.experimental-features = [ "nix-command" "flakes" ];


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.extraModprobeConfig = ''
  options psmouse sensitivity=140 speed=120
  options btusb enable_autosuspend=n
  '';

  networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Dublin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IE.UTF-8";
    LC_IDENTIFICATION = "en_IE.UTF-8";
    LC_MEASUREMENT = "en_IE.UTF-8";
    LC_MONETARY = "en_IE.UTF-8";
    LC_NAME = "en_IE.UTF-8";
    LC_NUMERIC = "en_IE.UTF-8";
    LC_PAPER = "en_IE.UTF-8";
    LC_TELEPHONE = "en_IE.UTF-8";
    LC_TIME = "en_IE.UTF-8";
  };

  # JAPANESE
/*   i18n.defaultLocale = "ja_JP.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ja_JP.UTF-8";
    LC_IDENTIFICATION = "ja_JP.UTF-8";
    LC_MEASUREMENT = "ja_JP.UTF-8";
    LC_MONETARY = "ja_JP.UTF-8";
    LC_NAME = "ja_JP.UTF-8";
    LC_NUMERIC = "ja_JP.UTF-8";
    LC_PAPER = "ja_JP.UTF-8";
    LC_TELEPHONE = "ja_JP.UTF-8";
    LC_TIME = "ja_JP.UTF-8";
    };


  environment.sessionVariables = {
    LANG = "ja_JP.UTF-8";
    LC_ALL = "ja_JP.UTF-8";
  };  */

  i18n.inputMethod = {
  enable = true;
  type = "fcitx5";

  fcitx5 = {
    waylandFrontend = true;   # Needed for Hyprland
    ignoreUserConfig = true;  # Use these settings
    addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk    
    ];
    settings = {
      inputMethod = {
        "Groups/0" = {
          Name = "Default";
          "Default Layout" = "us";
          DefaultIM = "keyboard-us";  # Start with English
        };
        "Groups/0/Items/0".Name = "keyboard-us";
        "Groups/0/Items/1".Name = "mozc";
      };
    };
  };
};



/*    # Fingerprint sensor for enrollment
  services."06cb-009a-fingerprint-sensor" = {                                 
  enable = true;                                                            
  backend = "python-validity";                                              
  };   

  services.python-validity.enable = true; */


  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = false;

  # Enable the KDE Plasma Desktop Environment and SDDM login manager
  services.displayManager.sddm.enable = false;
  services.displayManager.ly.enable = true;
  services.desktopManager.plasma6.enable = false;

  services.greetd = {
  enable = false;
  settings.default_session.command = "Hyprland";
};

  services.flatpak.enable = true;

  services.tlp.enable = true;

  systemd.services.local-webapp = {
  description = "Local HTML Web App Server";
  after = [ "network.target" ];
  wantedBy = [ "multi-user.target" ];

  serviceConfig = {
    ExecStart = "${pkgs.python3}/bin/python -m http.server 8000 --directory /home/gustavo/.config/mpv";
    Restart = "always";
    User = "gustavo";
    WorkingDirectory = "/home/gustavo/.config/mpv";
  };
};

systemd.services.textractor-web = {
  description = "Textractor HTML Server";
  after = [ "network.target" ];
  wantedBy = [ "multi-user.target" ];

  serviceConfig = {
    ExecStart = "${pkgs.python3}/bin/python -m http.server 8001 --directory /home/gustavo/Games/Textractor-5.2.0";
    Restart = "always";
    User = "gustavo";
    WorkingDirectory = "/home/gustavo/Games/Textractor-5.2.0";
  };
};


   /* ## FINGERPRINT
  # Standard fprintd (required for PAM to see the device)
  services.fprintd.enable = lib.mkForce true; */

  # PAM authentication
  security.pam.services.login.fprintAuth = true;
  security.pam.services.sudo.fprintAuth = true;

  services.logind.settings.Login = {
  HandleLidSwitch = "ignore";
  HandleLidSwitchExternalPower = "ignore";

  IdleAction = "ignore";
  IdleActionSec = 0;
};
/* 
services.jellyfin = {
  enable = true;
}; */

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };


  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.blueman.enable = true;

  # Enable the gnome-keyring secrets vault.
  # Will be exposed through DBus to programs willing to store secrets.
  services.gnome.gnome-keyring.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${myUser} = {
    isNormalUser = true;
    description = "";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    #packages = with pkgs; [
    #  kdePackages.kate
    #  thunderbird
    #];
  };

  ## JELLYFIN
/*   users.users.jellyfin.extraGroups = [ "users" ];

  systemd.tmpfiles.rules = [
  "d /home/${myUser}/Videos/mkv 0755 gustavo users -"
];

  systemd.services.jellyfin.serviceConfig = {
  SupplementaryGroups = [ "users" ];
}; */

  ## HOME MANAGER
  home-manager.users.${myUser} = import ./home.nix  { inherit 
    myUser
    #env
    pkgs
    lib; };
  home-manager.useGlobalPkgs = false;
  home-manager.useUserPackages = true;

  ## SECURITY

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false; # or false if you want no password

  security.polkit.enable = true;

  # Install firefox.
  programs.firefox = {
  enable = true;
  languagePacks = [ "ja" ];
  };

/* programs.brave-browser = {
  enable = true;
  # Enable proprietary codecs
  extraOpts = {
    "AllowsCompositing" = true;
    "EnableWidevine" = true;
  };
}; */




  # List packages installed in system profile. To search, run:
  # $ nix search wget

  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [
  "ventoy-gtk3-1.1.07"
   "ventoy-1.1.07"
    "ventoy-1.1.10"
    "imagemagick-6.9.13-10"
];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-unwrapped"
    "steam-run"
  ];
  
  environment.systemPackages = with pkgs; [
    #zen-browser.default 
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    wpgtk
    python3
    python311
    mesa
    libGL
    libglvnd
    gcc.cc.lib
    stdenv.cc.cc.lib
    libgcc

    networkmanagerapplet         
    trayer             
    networkmanager
    wpa_supplicant
    lxqt.lxqt-policykit
    obsidian
    ungoogled-chromium

        ## APPS
    discord
    firefox
    kitty
    filezilla
    #themix-gui
    vscodium
    waybar
    wofi
    waypaper
    brave
    ventoy-full
    thunderbird
    mailspring
    steam
    obs-studio
    seafile-client
    anki
    mokuro
    #spotify
    qbittorrent
    openvpn3
    ffmpeg-full
    vlc
    wineWowPackages.stable
    #bottles
    distrobox

  libva
  libva-utils
  intel-media-driver
  intel-vaapi-driver

  qemu

  nodejs


    nautilus
    kdePackages.dolphin
    nautilus-open-any-terminal
  ];

  fonts.packages = with pkgs; [
  nerd-fonts.jetbrains-mono
  nerd-fonts.iosevka
  noto-fonts-cjk-sans
  noto-fonts-cjk-serif
  ipaexfont
  noto-fonts
  jetbrains-mono
  inter
  sarasa-gothic
];

fonts.fontconfig.defaultFonts = {
  serif = [
    "DejaVu Serif"
    "Noto Serif"
    "Noto Serif CJK JP"
  ];

  sansSerif = [
    "Inter"
    "Noto Sans"
    "Noto Sans CJK JP"
  ];

  monospace = [
    "JetBrains Mono"
    "Sarasa Mono J"
    "Noto Sans Mono CJK JP"
  ];
};

  virtualisation.podman = {
  enable = true;
  dockerCompat = true;
};

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.steam = {
  enable = true;
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
};

  programs.zsh.enable = true;   
  programs.zsh.autosuggestions.enable = true;

  programs.hyprland.enable = true;

  environment.sessionVariables.MOZ_ENABLE_WAYLAND = "1";


  /* xdg.portal = {
  enable = true;
  wlr.enable = true;
  extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}; */



  hardware.bluetooth = {
  enable = true;
  powerOnBoot = true;
  settings = {
    General = {
      # Shows battery charge of connected devices on supported
      # Bluetooth adapters. Defaults to 'false'.
      Experimental = true;
      # When enabled other devices can connect faster to us, however
      # the tradeoff is increased power consumption. Defaults to
      # 'false'.
      FastConnectable = true;
    };
    Policy = {
      # Enable all controllers when they are found. This includes
      # adapters present on start as well as adapters that are plugged
      # in later on. Defaults to 'true'.
      AutoEnable = true;
    };
  };
};


  hardware.graphics = {
  enable = true;
  enable32Bit = true;


  extraPackages = with pkgs; [
    mesa
    libglvnd
  ];

  extraPackages32 = with pkgs.pkgsi686Linux; [
    mesa
    libglvnd
  ];
  };

    programs.spicetify = {
  enable = true;
  #config options
  };

  programs.nix-ld.enable = true;

  programs.nix-ld.libraries = with pkgs; [
  cups
  libgbm
  mesa
  mesa.drivers
  libxkbcommon
  xorg.libXi
  xorg.libXtst
  xorg.libXScrnSaver
  xorg.libxshmfence
  xorg.libXinerama
  libuuid
  libsecret
  udev
  libnotify
  libappindicator-gtk3
  pciutils
  portaudio
  stdenv.cc.cc.lib
  zlib
  libGL
  fontconfig
  freetype
  qt6.qtbase
  qt6.qtwayland
  glib
  gtk3
  nss
  nspr
  dbus
  expat
  cairo
  pango
  atk
  at-spi2-atk
  libdrm
  alsa-lib
  xorg.libX11
  xorg.libXrandr
  xorg.libXcomposite
  xorg.libXdamage
  xorg.libXext
  xorg.libXfixes
  xorg.libxcb
  xorg.libXcursor
  xorg.libXrender
];
   /*  ffmpeg
    steam-run
    xclip
    libevdev
    fuse2 
    python313Packages.pip
    python313Packages.uv
    python313Packages.pyqt6
    portaudio */

  
  

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}

