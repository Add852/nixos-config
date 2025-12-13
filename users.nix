{ inputs, config, pkgs, ... }:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tony = {
    isNormalUser = true;
    description = "Anthony";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  
  # GREETD LOG IN
  services.greetd = { #someone's log in manager online I saw lol (replaced sddm)
    enable = true;
    settings = {
      default_session = { #agreety or tuigreet
        command = "${pkgs.tuigreet}/bin/tuigreet --greeting 'Welcome to NixOS!' --xsessions ${config.services.displayManager.sessionData.desktops}/share/xsessions --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions --remember --remember-user-session --user-menu --user-menu-min-uid 1000 --asterisks --power-shutdown 'shutdown -P now' --power-reboot 'shutdown -r now'";
        #command = "${pkgs.tuigreet}/bin/tuigreet --greeting 'Welcome to NixOS!' --time --cmd ${pkgs.hyprland}/bin/Hyprland --time-format '%F %R' --asterisks --remember --remember-user-session --power-shutdown 'shutdown -P now' --power-reboot 'shutdown -r now'";
        user = "greeter";
      };
      initial_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "tony";
      };
    };
  };

# SDDM LOG IN
# services.displayManager = {
#     sddm = {
#     enable = true;
#     wayland.enable = true;
#     extraPackages = with pkgs; [
#         sddm-astronaut
#         kdePackages.qtbase
#         kdePackages.qtwayland
#         kdePackages.qtmultimedia
#     ];
#     theme = "sddm-astronaut-theme";
#     settings.Theme.current = "sddm-astronaut-theme";
#     };
#     autoLogin = {
#     enable = true;
#     user = "tony";
#     };
# };
}