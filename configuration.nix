{ config, pkgs, ... }: {
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
  services = {
    xserver = {
      enable = true;
      libinput.enable = true;
      videoDrivers = [ "nvidia" ];
      # desktopManager.xfce.enable = true;
      # desktopManager.gnome.enable = true;
      displayManager.startx.enable = true;
      displayManager.gdm.enable = true;
      # displayManager.sddm = {
      #   enable = true;
      #   theme = "Elegant";
      # };
      windowManager.leftwm.enable = true;
    };

    cpupower-gui.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
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
  services = {
    printing.enable = true;

    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
      ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
    '';

    syncthing = {
      enable = true;
      user = "mike";
      dataDir = "/home/mike/Documents";
    };

    # logind.lidSwitchDocked = "ignore";
    logind.lidSwitchExternalPower = "ignore";

    gnome.gnome-keyring.enable = true;

    postgresql.enable = true;

    keyd = {
      enable = true;
      keyboards = {
        internal = import ./keyd/internal.nix;
        keychron = import ./keyd/keychron.nix;
      };
    };

    # autorandr = import ./autorandr.nix;
  };

  sound.enable = true;

  hardware = {
    pulseaudio.enable = true;

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    nvidia = {
      modesetting.enable = true;
      powerManagement = {
        enable = false;
        finegrained = false;
      };
      open = false;
      nvidiaSettings = true;

      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
        # offload = {
        #   enable = true;
        #   enableOffloadCmd = true;
        # };
        sync.enable = true;
        # reverseSync.enable = true;
      };

      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

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

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      # environment.sessionVariables.NIXOS_OZONE_WL = "1";
    };
    fish.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession.enable = true;
      package = pkgs.steam.override {
        extraPkgs = pkgs: with pkgs; [ libkrb5 keyutils ];
      };
    };

    dconf.enable = true;
  };

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

  systemd.services = {
    swayosd-libinput-backend = {
      serviceConfig = {
        Type = "dbus";
        BusName = "org.erikreider.swayosd";
        ExecStart = "/run/current-system/sw/bin/swayosd-libinput-backend";
        Restart = "on-failure";
      };
      wantedBy = [ "default.target" ];
    };
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "mike" ];
      allowed-users = [ "mike" ];
    };
    optimise.automatic = true;
  };

  nixpkgs.config.allowUnfree = true;

  system = {
    copySystemConfiguration = false;

    userActivationScripts = {
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

    stateVersion = "24.05"; # Don't change
  };
}
