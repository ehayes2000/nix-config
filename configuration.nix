# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./online.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixie"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.wifi.powersave = false;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

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
  #services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
#  services.xserver = {
#    layout = "us";
#    xkbVariant = "";
#  };
#
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
#  sound.enable = true;
#  hardware.pulseaudio.enable = false;
#  security.rtkit.enable = true;
#  services.pipewire = {
#    enable = true;
#    alsa.enable = true;
#    alsa.support32Bit = true;
#    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
#  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.eric = {
    isNormalUser = true;
    description = "Eric";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
    #  thunderbird
    ];
    openssh.authorizedKeys.keys = [
"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGaZL5d8pEfTRPF3JIA6GhEbzERZOOZTwJValpLtuCkgNK+1msU/6USHY4KXx4r5HVbnR2LPzLA4m+tgWW27MxYjTeKlWdMeKc+ktmwBOKseayNAzMJMKl51EjkGjhvirGMr3VKHCXjvQCvISG8z6WlKs6mPQzIkrVpAkCAzTsaHBrgY+yhat/V7I1khCTzpow89ap+ps4TmtaOfzc+SsMTvoT/W71XgqbbyGJUC3WEYhbpDjOPyJh2QXIwkJM+ryMdm708AEo1TBcLjM0ijtnUo7yMV+SEdlzMmHdN+d35z1fdPTDYAG258TAdZc9azAXUjWR3FePiK5uox2crQ2HEUHpT8oUp8YvP4dLoNFtjIII0Fx5YqAd2uOCC3wMxfn77raiXzIVixjTTiEP22GSU7GEIAQX4z3vQfarNAzm+E2Jp3NBFqrB7RgDOvCOEmHGCIeQ1r6vCn0LcNRrnS0smR58XEv2hDNQHptwiiyOTzfNA+XjTXWLTj32UEctpkD2waMmDqHPtmbIKKSlI9+Kr512n5AyNt0R36r4UH+7w1ulrIMKdAeLzBdyv6VroADbZLa9525Bzn0cHgGHTxp/EVcQFAGlKsemR3+FLc5j012mn2taoicxRw0oabRPvKs9X+aSE6Uz71PwHnqyzre20CukYZSL1GnjcyTAbNMX0w== eqhayes@protonmail.com"
];
  };


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
    tmux
    wget
    linuxPackages.nvidia_x11
    cudatoolkit
    nvidia-docker
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
  virtualisation.docker.enable = true;
  
  services.openssh = {    
    enable = true;
    ports = [ 22 418 ];
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "no";
    startWhenNeeded = false;
  };



  # Open ports in the firewall.
  #networking.firewall.allowedTCPPorts = [ 22 80 418 ];
  #networking.firewall.allowedUDPPorts = [ 3333 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).

  system.stateVersion = "23.11"; # Did you read the comment?

}
