{ config, pkgs, lib, ... }:

let
  home-manager = builtins.fetchTarball {
  url = "https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz";
  };
  env = builtins.fromJSON (builtins.readFile ./system.json);
  myUser = env.USERNAME;
  zen-browser = import (builtins.fetchTarball "https://github.com/youwen5/zen-browser-flake/archive/master.tar.gz") {
  inherit pkgs;
    };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

   nix.settings.experimental-features = [ "nix-command" "flakes" ];


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

   /* ## FINGERPRINT
  # Standard fprintd (required for PAM to see the device)
  services.fprintd.enable = lib.mkForce true; */

  # PAM authentication
  security.pam.services.login.fprintAuth = true;
  security.pam.services.sudo.fprintAuth = true;


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


  ## HOME MANAGER
  home-manager.users.${myUser} = import ./home.nix  { inherit 
    myUser
    env
    pkgs
    lib; };
  home-manager.useGlobalPkgs = false;
  home-manager.useUserPackages = true;

  ## SECURITY

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false; # or false if you want no password

  security.polkit.enable = true;

  # Install firefox.
  # programs.firefox.enable = true;

  ## Allow unfree



  # List packages installed in system profile. To search, run:
  # $ nix search wget

  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [
  "ventoy-gtk3-1.1.07"
   "ventoy-1.1.07"
];
  
  environment.systemPackages = with pkgs; [
    zen-browser.default 
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    wpgtk
    python3
    networkmanagerapplet         
    trayer             
    networkmanager
    wpa_supplicant
    lxqt.lxqt-policykit

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


    nautilus
    nautilus-open-any-terminal
  ];

  fonts.packages = with pkgs; [
  nerd-fonts.jetbrains-mono
  nerd-fonts.iosevka
];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.zsh.enable = true;   
  programs.zsh.autosuggestions.enable = true;

  programs.hyprland.enable = true;

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

  
  

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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

