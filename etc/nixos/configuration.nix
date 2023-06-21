{ config, pkgs, ... }:

let
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire wireplumber pipewire-pulse xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire wireplumber pipewire-pulse xdg-desktop-portal xdg-desktop-portal-wlr
      '';

  };

  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;

    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Adwaita'
      '';
  };

  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz";

in {
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      ./machine.nix
      (import "${home-manager}/nixos")
    ];

  # Bootloader.
  boot = {
		loader = {
		  systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
		};

		plymouth.enable = true;

		kernelParams = [ "quiet" ];

		initrd.systemd.enable = true;

		initrd.secrets = {
			"/crypto_keyfile.bin" = null;
		};
	};

  hardware = {
    bluetooth.enable = true;
  };

  networking = {
		# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

		# Configure network proxy if necessary
		# networking.proxy.default = "http://user:password@proxy:port/";
		# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

		# Enable networking
		networkmanager.enable = true;
	};

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.russ = {
    isNormalUser = true;
    description = "Russ Morris";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  home-manager.users.russ = {
    home = {
      stateVersion = "23.05";
      sessionPath = [
        "$HOME/.cargo/bin"
      ];
    };

    programs.home-manager.enable = true;

    programs.zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
        theme = "flazz";
      };
    };

    home.pointerCursor = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
      size = 24;
      x11 = {
        enable = true;
        defaultCursor = "Adwaita";
      };
    };
  };


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "23.05"; # Did you read the comment?

  virtualisation = {
    libvirtd.enable = true;
    containers.enable = true;
  };

  fonts = {
    fontDir.enable = true;
    fonts = [
      pkgs.nerdfonts
      pkgs.hack-font
      pkgs.font-awesome
    ];
  };

  environment = {
    systemPackages = with pkgs; [
      brightnessctl
      configure-gtk
      dbus-sway-environment
      dotnet-sdk_8
      firefox
      file
      foot
      fwupd
      gcc
      glib
      gnome3.adwaita-icon-theme
      go
      google-chrome
      greetd.greetd
      greetd.wlgreet
      grim
      mako
      networkmanagerapplet
      nodejs_20
      playerctl
      podman
      polkit_gnome
      python3
      ripgrep 
      rustup
      slurp
      swaybg
      swayidle
      swaylock
      tmux
      virt-manager
      waybar
      wayland
      xdg-utils
      wdisplays
      wl-clipboard
      wofi
    ];

    shells = [ pkgs.zsh ];
  };

  programs = {
    dconf.enable = true;

    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };

    neovim = {
      enable = true;
      defaultEditor = true;
    };

    light.enable = true;

    git.enable = true;

    zsh = {
      enable = true;
      autosuggestions.enable = true;
    };
  };

  services = {

    # Configure keymap in X11
    xserver = {
      layout = "us";
      xkbVariant = "";
    };

    blueman.enable = true;

    dbus.enable = true;

    flatpak.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

		# Enable automatic login for the user.
		getty.autologinUser = "russ";

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "agreety -c sway";
        };
        initial_session = {
          command = "sway";
          user = "russ";
        };
      };
    };

  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr ];
  };

  security = {
    polkit.enable = true;
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
    };

  };

}
