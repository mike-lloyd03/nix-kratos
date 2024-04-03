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

  networking.hostName = "kratos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    useXkbConfig = false;
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    libinput.enable = true;
    videoDrivers = [ "nvidia" ];
    desktopManager.xfce.enable = true;
    desktopManager.gnome.enable = true;
  };

  services.printing.enable = true;

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
  '';

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
      internal = {
        ids = [ "1532:0253" ];
        settings = {
          main = {
            f1 = "mute";
            f2 = "volumedown";
            f3 = "volumeup";
            f5 = "previoussong";
            f6 = "playpause";
            f7 = "nextsong";
            f8 = "brightnessdown";
            f9 = "brightnessup";
            f10 = "kbdillumdown";
            f11 = "kbdillumup";
            control = "layer(meta)";
            alt = "layer(control)";
            meta = "layer(alt)";
            capslock = "overload(nav, esc)";
            "leftshift+rightshift" = "capslock";
          };
          control = {
            f1 = "f1";
            f2 = "f2";
            f3 = "f3";
            f5 = "f5";
            f6 = "f6";
            f7 = "f7";
            f8 = "f8";
            f9 = "f9";
            f10 = "f10";
            f11 = "f11";
            f12 = "f12";
          };
          shift = {
            f1 = "f1";
            f2 = "f2";
            f3 = "f3";
            f5 = "f5";
            f6 = "f6";
            f7 = "f7";
            f8 = "f8";
            f9 = "f9";
            f10 = "f10";
            f11 = "f11";
            f12 = "f12";
          };
          control-alt = {
            f1 = "f1";
            f2 = "f2";
            f3 = "f3";
            f5 = "f5";
            f6 = "f6";
            f7 = "f7";
            f8 = "f8";
            f9 = "f9";
            f10 = "f10";
            f11 = "f11";
            f12 = "f12";
          };
          nav = {
            h = "left";
            k = "up";
            j = "down";
            l = "right";
            y = "copy";
            p = "paste";
            x = "cut";
            u = "undo";
            "0" = "home";
            "4" = "end";
          };
        };
      };
      keychron = {
        ids = [ "05ac:024f" ];
        settings = {
          main = {
            f1 = "brightnessdown";
            f2 = "brightnessup";
            f5 = "kbdillumdown";
            f6 = "kbdillumup";
            f7 = "previoussong";
            f8 = "playpause";
            f9 = "nextsong";
            f10 = "mute";
            f11 = "volumedown";
            f12 = "volumeup";
            control = "layer(meta)";
            alt = "layer(control)";
            meta = "layer(alt)";
            capslock = "overload(nav, esc)";
            "leftshift+rightshift" = "capslock";
          };
          control = {
            f1 = "f1";
            f2 = "f2";
            f3 = "f3";
            f5 = "f5";
            f6 = "f6";
            f7 = "f7";
            f8 = "f8";
            f9 = "f9";
            f10 = "f10";
            f11 = "f11";
            f12 = "f12";
          };
          shift = {
            f1 = "f1";
            f2 = "f2";
            f3 = "f3";
            f5 = "f5";
            f6 = "f6";
            f7 = "f7";
            f8 = "f8";
            f9 = "f9";
            f10 = "f10";
            f11 = "f11";
            f12 = "f12";
          };
          control-alt = {
            f1 = "f1";
            f2 = "f2";
            f3 = "f3";
            f5 = "f5";
            f6 = "f6";
            f7 = "f7";
            f8 = "f8";
            f9 = "f9";
            f10 = "f10";
            f11 = "f11";
            f12 = "f12";
          };
          nav = {
            h = "left";
            k = "up";
            j = "down";
            l = "right";
            y = "copy";
            p = "paste";
            x = "cut";
            u = "undo";
            "0" = "home";
            "4" = "end";
          };
        };
      };
    };
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    #   # Fine-grained power management. Turns off GPU when not in use.
    #   # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;

    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };

  specialisation = {
    performance.configuration = {
      system.nixos.tags = [ "performance" ];
      hardware.nvidia = {
        prime.offload = {
          enable = lib.mkForce false;
          enableOffloadCmd = lib.mkForce false;
        };
        prime.sync.enable = lib.mkForce true;
      };
    };
  };

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true;

  security = {
    polkit.enable = true;
    sudo = {
      wheelNeedsPassword = false;
      # Needed for nvim to work properly under sudo
      # WAYLAND_DISPLAY and XDG_RUNTIME_DIR are so the clipboard provider works with wl-clipboard
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

  services.xserver.displayManager.gdm = { enable = true; };

  # services.xserver.displayManager.sddm = {
  #   enable = true;
  #   theme = "Elegant";
  # };
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

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
    package = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [ libkrb5 keyutils ];
    };
  };

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
    # keyd
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

  # systemd.services.keyd = {
  #   serviceConfig = { ExecStart = "/run/current-system/sw/bin/keyd"; };
  #   wantedBy = [ "multi-user.target" ];
  # };

  systemd.services.swayosd-libinput-backend = {
    unitConfig = {
      Description =
        "SwayOSD LibInput backend for listening to certain keys like CapsLock, ScrollLock, VolumeUp, etc...";
      Documentation = "https://github.com/ErikReider/SwayOSD";
      PartOf = "graphical.target";
      After = "graphical.target";
    };
    serviceConfig = {
      Type = "dbus";
      BusName = "org.erikreider.swayosd";
      ExecStart = "/run/current-system/sw/bin/swayosd-libinput-backend";
      Restart = "on-failure";
    };
    wantedBy = [ "graphical.target" "multi-user.target" ];
  };

  systemd.user.services.libinput-gestures.wantedBy = [ "default.target" ];
  systemd.user.services.ydotool.wantedBy = [ "default.target" ];

  systemd.user.services.kanshi = {
    description = "kanshi daemon";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.kanshi}/bin/kanshi";
      Restart = "on-failure";
    };
    wantedBy = [ "default.target" ];
  };

  systemd.user.services.protonmail-bridge = {
    description = "An IMAP/SMTP bridge to a ProtonMail account";
    serviceConfig = {
      ExecStart =
        "${pkgs.protonmail-bridge}/bin/protonmail-bridge --noninteractive";
    };
    wantedBy = [ "default.target" ];

  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "mike" ];
  nix.settings.allowed-users = [ "mike" ];
  nix.optimise.automatic = true;

  nixpkgs.config.allowUnfree = true;

  system.copySystemConfiguration = false;

  system.userActivationScripts = {
    gitCommitConfig = {
      text = ''
        source ${config.system.build.setEnvironment}
        GEN=$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | grep current | awk '{print $1}')
        cd /etc/nixos
        git add .
        git commit -m "Gen $GEN"
        git push origin master
      '';
    };
  };

  system.stateVersion = "24.05"; # Don't change
}
