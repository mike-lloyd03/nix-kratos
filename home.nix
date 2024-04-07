{ inputs, pkgs, ... }:

{
  gtk.enable = true;
  gtk.theme.name = "Arc-Dark";

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "WhiteSur-cursors";
    package = pkgs.whitesur-cursors;
    size = 24;
  };

  home.packages = with pkgs; [
    inputs.anyrun.packages.${system}.anyrun-with-all-plugins
    arc-theme
    catppuccin-sddm-corners
    cliphist
    delta
    dunst
    evince
    feh
    hypridle
    hyprlock
    hyprpaper
    inotify-tools
    kanshi
    libinput-gestures
    neofetch
    nextcloud-client
    nodePackages_latest.bash-language-server
    nodePackages_latest.prettier
    nvimpager
    obsidian
    onlyoffice-bin_latest
    picom
    polybar
    protonmail-desktop
    rofi-wayland
    rust-analyzer
    stylua
    swayidle
    swaynotificationcenter
    syncthing
    vivaldi
    vlc
    waybar
    wezterm
    wlogout
    whitesur-cursors
    yazi

    # https://github.com/NixOS/nixpkgs/pull/298652
    inputs.super-slicer-fix.legacyPackages.${system}.super-slicer-latest
  ];

  home.stateVersion = "23.11";
}
