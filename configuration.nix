{ config, lib, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.systemd-boot = {
      enable = true;
      configurationLimit = 2;
    };
    kernelParams = [ "button.lid_init_state=open" ];
  };

  networking = {
    hostName = "kratos";
    networkmanager.enable = true;
  };

  time.timeZone = "America/Los_Angeles";

  services.xserver = {
    enable = true;
    libinput.enable = true;
    # videoDrivers = [ "nvidia" ];
    # desktopManager.xfce.enable = true;
    desktopManager.gnome.enable = true;
    displayManager.startx.enable = true;
    displayManager.gdm.enable = true;
    # displayManager.sddm = {
    #   enable = true;
    #   theme = "Elegant";
    # };
    windowManager.leftwm.enable = true;
  };

  # services.greetd.enable = true;
  # programs.regreet = {
  #   enable = true;
  #   settings = {
  #     background = {
  #       path = "/etc/greetd/bg.jpg";
  #       fit = "Cover";
  #     };
  #     GTK = {
  #       application_prefer_dark_theme = true;
  #       cursor_theme_name = "Adwaita";
  #       font_name = "Cantarell 16";
  #       icon_theme_name = "Adwaita";
  #       theme_name = "Arc-Dark";
  #     };
  #   };
  # };

  services.printing.enable = true;

  # services.udev.extraRules = ''
  #   ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
  #   ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
  # '';

  services.syncthing = {
    enable = true;
    user = "mike";
    dataDir = "/home/mike/Documents";
  };

  # services.logind.lidSwitchDocked = "ignore";
  services.logind.lidSwitchExternalPower = "ignore";

  services.gnome.gnome-keyring.enable = true;

  services.postgresql.enable = true;

  services.keyd = {
    enable = true;
    keyboards = {
      internal = import ./keyd/internal.nix;
      keychron = import ./keyd/keychron.nix;
    };
  };

  # services.autorandr.enable = true;
  # services.autorandr.profiles = {
  #   "docked" = {
  #     fingerprint = {
  #       DP-1-0 =
  #         " 00ffffffffffff003669621401000000091f0103805021782a1ad5ae5048a625125054bfcf00614081809500b3009528d1e8b328d1c0f57c70a0d0a02a5030203a001d4d3100001e803e70a0d0a0225030203a001d4d3100001e000000fc004d5349204d414733343143510a000000ff004d413048303531333030383539019b02032f314f01020304058687109192131495961f8300000065030c00100067d85dc401788800681a00000101309000f57c70a0d0a02950302035001d4d3100001a43d070a0d0a02950302035001d4d3100001a565e00a0a0a02950302035001d4d31000006023a80d072382d40102c35801d4d31000000000000000000000094";
  #     };
  #     config = {
  #       eDP-1 = { enable = false; };
  #       DP-1-0 = {
  #         enable = true;
  #         mode = "3440x1440";
  #         position = "0x0";
  #         primary = true;
  #         rate = "100.00";
  #       };
  #     };
  #   };
  #   "undocked" = {
  #     fingerprint = {
  #       eDP-1 =
  #         " 00ffffffffffff0006af8ede00000000281d0104a522137803ee95a3544c99260f50540000000101010101010101010101010101010150d0805070381f403020a50058c1100000181c34805070381f403020a50058c110000018000000fd0e3c2d4f4f43010a202020202020000000fe004231353648414e31322e30200a01b570137900000301148c0401847f074f002f001f0037041e00090004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000be90";
  #     };
  #     config = {
  #       eDP-1 = {
  #         enable = true;
  #         primary = true;
  #         mode = "1920x1080";
  #         position = "0x0";
  #         rate = "240.00";
  #       };
  #       DP-1-0 = { enable = false; };
  #     };
  #   };
  #   "both" = {
  #     fingerprint = {
  #       DP-1-0 =
  #         " 00ffffffffffff003669621401000000091f0103805021782a1ad5ae5048a625125054bfcf00614081809500b3009528d1e8b328d1c0f57c70a0d0a02a5030203a001d4d3100001e803e70a0d0a0225030203a001d4d3100001e000000fc004d5349204d414733343143510a000000ff004d413048303531333030383539019b02032f314f01020304058687109192131495961f8300000065030c00100067d85dc401788800681a00000101309000f57c70a0d0a02950302035001d4d3100001a43d070a0d0a02950302035001d4d3100001a565e00a0a0a02950302035001d4d31000006023a80d072382d40102c35801d4d31000000000000000000000094";
  #       eDP-1 =
  #         " 00ffffffffffff0006af8ede00000000281d0104a522137803ee95a3544c99260f50540000000101010101010101010101010101010150d0805070381f403020a50058c1100000181c34805070381f403020a50058c110000018000000fd0e3c2d4f4f43010a202020202020000000fe004231353648414e31322e30200a01b570137900000301148c0401847f074f002f001f0037041e00090004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000be90";
  #     };
  #     config = {
  #       eDP-1 = {
  #         enable = true;
  #         crtc = 0;
  #         gamma = "1.031:1.0:1.02";
  #         mode = "1920x1080";
  #         position = "0x0";
  #         rate = "240.00";
  #         # x-prop-broadcast_rgb = "Automatic";
  #         # x-prop-colorspace = "Default";
  #         # x-prop-max_bpc = 12;
  #         # x-prop-non_desktop = 0;
  #         # x-prop-scaling_mode = "Full aspect";
  #       };
  #       DP-1-0 = {
  #         enable = true;
  #         mode = "3440x1440";
  #         position = "1920x0";
  #         primary = true;
  #         rate = "100.00";
  #         # x-prop-non_desktop = 0;
  #       };
  #     };
  #   };
  # };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   powerManagement = {
  #     enable = false;
  #     finegrained = false;
  #   };
  #   open = false;
  #   nvidiaSettings = true;
  #
  #   prime = {
  #     intelBusId = "PCI:0:2:0";
  #     nvidiaBusId = "PCI:1:0:0";
  #     offload = {
  #       enable = true;
  #       enableOffloadCmd = true;
  #     };
  #   };
  #
  #   package = config.boot.kernelPackages.nvidiaPackages.stable;
  # };

  # specialisation = {
  #   performance.configuration = {
  #     system.nixos.tags = [ "performance" ];
  #     hardware.nvidia = {
  #       prime.offload = {
  #         enable = lib.mkForce false;
  #         enableOffloadCmd = lib.mkForce false;
  #       };
  #       prime.sync.enable = lib.mkForce true;
  #       powerManagement.finegrained = lib.mkForce false;
  #     };
  #   };
  # };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  security = {
    polkit.enable = true;
    sudo = {
      wheelNeedsPassword = false;
      # Needed for nvim to work properly under sudo
      extraConfig = ''
        Defaults env_keep += "WAYLAND_DISPLAY XDG_RUNTIME_DIR"
      '';
    };
    pam.services.mike.enableGnomeKeyring = true;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
  programs.fish.enable = true;

  # programs.steam = {
  #   enable = true;
  #   remotePlay.openFirewall = true;
  #   dedicatedServer.openFirewall = true;
  #   gamescopeSession.enable = true;
  #   package = pkgs.steam.override {
  #     extraPkgs = pkgs: with pkgs; [ libkrb5 keyutils ];
  #   };
  # };

  programs.dconf.enable = true;

  fonts.packages = with pkgs;
    [ (nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];

  users.users.mike = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "input" ];
    shell = pkgs.fish;
  };

  users.users.test = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "input" ];
    shell = pkgs.fish;
  };

  environment.systemPackages = with pkgs; [
    atuin
    bat
    brightnessctl
    btop
    cargo
    clang
    dust
    fd
    fzf
    git
    gnumake
    glxinfo
    just
    lsd
    lshw
    lua-language-server
    neovim
    nil
    nixfmt
    openssh
    procs
    python3
    ripgrep
    rustc
    elegant-sddm
    starship
    sudo
    swayosd
    tealdeer
    unzip
    waypipe
    wget
    wl-clipboard
    xorg.xauth
    ydotool
    zellij
    zip
    zoxide
  ];

  systemd.user.services = import ./user-services.nix { inherit pkgs; };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "mike" ];
      allowed-users = [ "mike" ];
    };
    optimise.automatic = true;
  };

  nixpkgs.config.allowUnfree = true;

  system.copySystemConfiguration = false;

  system.userActivationScripts = {
    gitCommitConfig = {
      text = ''
        source ${config.system.build.setEnvironment}
        GEN=$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | grep current | awk '{print $1}')
        cd /etc/nixos
        git add .
        git commit -m "Gen $GEN" && git push origin master || true
      '';
    };
  };

  system.stateVersion = "24.05"; # Don't change

  boot.extraModprobeConfig = ''
    blacklist nouveau
    options nouveau modeset=0
  '';

  services.udev.extraRules = ''
    # Remove NVIDIA USB xHCI Host Controller devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
    # Remove NVIDIA USB Type-C UCSI devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
    # Remove NVIDIA Audio devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
    # Remove NVIDIA VGA/3D controller devices
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
  '';
  boot.blacklistedKernelModules =
    [ "nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" ];
}
