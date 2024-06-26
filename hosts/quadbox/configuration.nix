# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-61b8a140-943e-45d3-a9fe-7f2277fec922".device = "/dev/disk/by-uuid/61b8a140-943e-45d3-a9fe-7f2277fec922";
  #boot.initrd.kernelModules = [ "amdgpu" ];
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  networking = {
    hostName = "quadbox";
    enableIPv6 = false;
    defaultGateway = "192.168.1.254";
    nameservers = [ 
      "8.8.8.8"
      "8.8.4.4"
    ];
    interfaces = {
      # wlp5s0 = {
      #	 useDHCP = false;
      #  ipv4.addresses = [
      #	   { address = "192.168.0.121"; prefixLength = 24; }
      #	 ];
      #};
      enp7s0 = {
      	useDHCP = false;
	ipv4.addresses = [
	  { address = "192.168.1.122"; prefixLength = 24; }
	];
      };
    };
    networkmanager = {
      enable = true;
    };
  };

  #networking.hostName = "quadbox"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  #networking.interfaces.wlp5s0.useDHCP = false;
  #networking.interfaces.wlp3s0.ipv4.addresses = [
  #  { address = "192.168.0.169"; prefixLength = 24; }
  #];
  # Enable networking
  #networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable containers
  virtualisation.containers.enable = true;
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  programs.zsh.enable = true; 
  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  
  users = {
    users.parallaxis = {
      isNormalUser = true;
      description = "Parker Jones";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
      packages = with pkgs; [
        firefox
        kate
        #  thunderbird
      ];
      openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAao6hYRda8Dc88DgWHblVFV/HFCcj6kJuDWq7oqt7Aq"
    ];

    };
    users.pkearfott = {
      isNormalUser = true;
      description = "Parker Jones";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
      packages = with pkgs; [
        firefox
        kate
        #  thunderbird
      ];
      openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCyhsUy9A6AuNzKcn1HdN4AY1SQhfB30h0TtTWvqPCStGnXVZn6v5EKi3eGWUhxDbSd7o43dC2oNcFs9SdsVO75M5KcHl+0YntznbsgOpdsTlRJR2RSf+ipFM4azVucR4gqjjUCLunWzT5+s7mpmlSV46qXqXdJv6WurbXHcYZDOTReP+zLm+kx5xKBls+HJmsCzq7aYFVwQCawiq+2iXFe5uySwZcpHdPJyP5eDzB22Ta8oJYowOilZy0JtRdVVIBwy0YwKvo/JABWfTMuNyzg4PlUOaT+cB1cA+6P6cbEoqFw1KTnfuWUdlVPjNO6/sKNPmGtZU7vxWMgFVhVk9HBweiHaLiQNrTZEbSIzeLT6DzZytq7NFM6Nog88uxTmVn+p3GSeyblgScPn2dGaWoUzqZvzvox/9W9e81vcWwjVaOpAu8EKGUOI1bbk3RAJXLrnhUYvM3GZA1iHfHWNaQ0wxVpK3QlFzZyHbFmRqCOqHJzJZQpK7ugjPsJ/LbWeFE= pkearfott@mac-pkearfott.local"
    ];

    };
    defaultUserShell = pkgs.zsh; # Make zsh default shell
  };

  home-manager = {
    # also pass inputs to home-manager modules
    extraSpecialArgs = {inherit inputs;};
    users = {
      "parallaxis" = import ./parallaxis.nix;
      "pkearfott" = import ./pkearfott.nix;
    };
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "parallaxis";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ]; 

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    home-manager
    lf
    bat
    wget
    vim
    neovim
    brave
    gimp
    _1password-gui
    _1password
    obsidian
    gh
    git
    alacritty
    distrobox
    podman
    distrobox
    vlc
    tmux
    cheat
    zsh
    #inputs.neovim-flake.defaultPackage.x86_64-linux
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    ports = [ 22 51685 ];
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
