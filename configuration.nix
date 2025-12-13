{ inputs, config, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix # Include the results of the hardware scan.
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true; # Enable networking

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

  programs.hyprland = { # Enable hyperland Desktop Environment
    enable = true;
    withUWSM = true; # recommended for most users
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland; # set the flake package
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland; # make sure to also set the portal package, so that they are in sync
  };

  # List packages installed in system profile. To search, run:
  nixpkgs.config.allowUnfree = true; # Allow unfree packages (cursor and other proprietary drivers)
  environment.systemPackages = with pkgs; [
    file-roller #for archive manager
    ffmpegthumbnailer #video thumbnail preview for thunar/nemo
    webp-pixbuf-loader #webp thumbnail
  ];
  programs.firefox = { # firefox w/ pwa pluhh
    enable = true;
    package = pkgs.firefox;
    nativeMessagingHosts.packages = [ pkgs.firefoxpwa ]; # firefox pwa install
  };
  services.syncthing = { # syncthing: https://wiki.nixos.org/wiki/Syncthing
    enable = true;
    openDefaultPorts = true; # Open ports in the firewall for Syncthing. (NOTE: this will not open syncthing gui port)
    user = "tony";
    dataDir = "/home/tony";
    configDir = "/home/tony/.config/syncthing";
  };
  environment.variables.EDITOR = "code"; # set vscode as default text editor
  programs.vscode = {
    enable = true;
    # package = pkgs.vscode.fhs; # Use the FHS-compliant VS Code package
    extensions = with pkgs.vscode-extensions; [ # Add desired extensions here
      bbenoist.nix # Example: Nix language support
      dbaeumer.vscode-eslint # Example: ESLint extension
      redhat.vscode-yaml #so I can color peak at yaml files lol
    ];
  };
  programs.adb.enable = true; #for adb platform tool stuffs
  users.users.tony = {
    # pixel9a shizuku: adb shell /data/app/~~FgBzjAeLJkCex7tcP-F4hg==/moe.shizuku.privileged.api-ecslHhLn9OeJ5BHIszH7tw==/lib/arm64/libshizuku.so
    extraGroups = ["adbusers"]; #for adb stuffs
    shell = pkgs.bash;
  };
  programs.kdeconnect.enable = true;

  # DEVELOPER STUFFS
  services.openssh.enable = true;   # Enable the OpenSSH daemon.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";   #to use VSCODE on wayland
  networking.firewall = rec {   # Open ports in the firewall.
    enable = true;
    allowedTCPPorts = [ 8080 8384 ]; #web_localhost, syncthing port
    # allowedUDPPorts = [ ... ];
    allowedTCPPortRanges = [ { from = 1714; to = 1764; } ]; # kde connect ports
    allowedUDPPortRanges = allowedTCPPortRanges; # copy above line
  };

  # HARDWARE and I/O STUFFS
  hardware.bluetooth.enable = true; #ForBluetooth
  services.upower.enable = true; #ForNoctalia Battery Status
  services.power-profiles-daemon.enable = true; #ForNoctalia Battery Profiles
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

  #PERSONAL TWEAKS

  # disable built in laptop keyboard (see libinput device-list)
  services.udev.extraRules = ''
    KERNEL=="event0", ATTRS{name}=="AT Translated Set 2 keyboard", ENV{LIBINPUT_IGNORE_DEVICE}="1"
  '';

  # Enable Flake, Automate Maintenance (GC and Updates)
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];   # Enable flakes w/ home manager
    auto-optimise-store = true;
  };
  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  system.autoUpgrade = {
    enable = true;
    operation = "switch"; # If you don't want to apply updates immediately, only after rebooting, use `boot` option in this case
    flake = "/etc/nixos";
    flags = [ "--update-input" "nixpkgs" "--update-input" "--commit-lock-file" ];
    dates = "weekly";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
