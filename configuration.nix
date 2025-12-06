{ inputs, config, pkgs, ... }:
{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true; # Enable networking
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  time.timeZone = "Asia/Manila"; # Set your time zone.
  i18n.defaultLocale = "en_PH.UTF-8"; # Select internationalisation properties.
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fil_PH";
    LC_IDENTIFICATION = "fil_PH";
    LC_MEASUREMENT = "fil_PH";
    LC_MONETARY = "fil_PH";
    LC_NAME = "fil_PH";
    LC_NUMERIC = "fil_PH";
    LC_PAPER = "fil_PH";
    LC_TELEPHONE = "fil_PH";
    LC_TIME = "fil_PH";
  };

  # X11 stuffs dafuq even is X11
  # Configure keymap in X11
  # services.xserver.xkb = {
  #  layout = "us";
  #  variant = "";
  # };
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  # services.xserver.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tony = {
    isNormalUser = true;
    description = "Anthony";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # SDDM LOG IN
  # services.displayManager.sddm.wayland.enable = true;
  # services.displayManager.sddm.enable = true; #Log In Manager
  # services.displayManager.autoLogin.enable = true; # Enable automatic login for the user.
  # services.displayManager.autoLogin.user = "tony";
  # services.desktopManager.plasma6.enable = false; #Enable the KDE Plasma Desktop Environment.
  services.greetd = { #someone's log in manager online I saw lol (replaced sddm)
    enable = true;
    settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --greeting 'Welcome to NixOS!' --xsessions ${config.services.displayManager.sessionData.desktops}/share/xsessions --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions --remember --remember-user-session --user-menu --user-menu-min-uid 1000 --asterisks --power-shutdown 'shutdown -P now' --power-reboot 'shutdown -r now'";
  };
  programs.hyprland = { # Enable hyperland Desktop Environment
    enable = true;
    withUWSM = true; # recommended for most users
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;     # set the flake package
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;     # make sure to also set the portal package, so that they are in sync
  };

  # List packages installed in system profile. To search, run:
  nixpkgs.config.allowUnfree = true; # Allow unfree packages (cursor and other proprietary drivers)
  environment.systemPackages = with pkgs; [
    git
    wget
  ];

  programs.firefox = {   # firefox w/ pwa pluhh
    enable = true;
    package = pkgs.firefox;
    nativeMessagingHosts.packages = [ pkgs.firefoxpwa ]; # firefox pwa install
  };
  
  environment.variables.EDITOR = "code"; # set vscode as default text editor
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs; # Use the FHS-compliant VS Code package
    extensions = with pkgs.vscode-extensions; [ # Add desired extensions here
      bbenoist.nix # Example: Nix language support
      dbaeumer.vscode-eslint # Example: ESLint extension
    ];
  };

  # DEVELOPER STUFFS
  services.openssh.enable = true;   # Enable the OpenSSH daemon.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";   #to use VSCODE on wayland
  networking.firewall = {   # Open ports in the firewall.
    enable = true;
    allowedTCPPorts = [ 8080 ];
    # allowedUDPPorts = [ ... ];
  };

  # HARDWARE and I/O STUFFS
  hardware.bluetooth.enable = true; #ForBluetooth
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # media-session.enable = true; # use the example session manager (no others are packaged yet so this is enabled by default, no need to redefine it in your config for now)
  };
  # services.printing.enable = true;   # Enable CUPS to print documents.
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  #PERSONAL TWEAKS
  fonts.packages = with pkgs; [ #fonts
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
  ];
  # disable built in laptop keyboard (see libinput device-list)
  services.udev.extraRules = ''
    KERNEL=="event0", ATTRS{name}=="AT Translated Set 2 keyboard", ENV{LIBINPUT_IGNORE_DEVICE}="1"
  '';

  nix.settings.experimental-features = [ "nix-command" "flakes" ];   # Enable flakes w/ home manager
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
