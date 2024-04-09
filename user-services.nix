{ pkgs }: {
  libinput-gestures.wantedBy = [ "default.target" ];

  # ydotool.wantedBy = [ "default.target" ];

  # kanshi = {
  #   serviceConfig = {
  #     Type = "simple";
  #     ExecStart = "${pkgs.kanshi}/bin/kanshi";
  #     Restart = "on-failure";
  #   };
  #   wantedBy = [ "default.target" ];
  # };

  protonmail-bridge = {
    serviceConfig = {
      ExecStart =
        "${pkgs.protonmail-bridge}/bin/protonmail-bridge --noninteractive";
    };
    wantedBy = [ "default.target" ];
  };
}
