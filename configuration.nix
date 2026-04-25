{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # --- BOOTLOADER ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # --- NETWORK ---
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # --- LOCALIZATION ---
  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "ru_RU.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us,ru";
    options = "grp:win_space_toggle";
  };

  # --- USER ---
  users.users.user = {
    isNormalUser = true;
    description = "My User";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # --- AUDIO ---
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # --- WINDOW MANAGER ---
  programs.niri.enable = true;

  # --- DISPLAY MANAGER ---
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "greeter";
      };
    };
  };

  # --- SYSTEM PACKAGES ---
  environment.systemPackages = with pkgs; [
    alacritty
    firefox
    git
    nano
    wget
    fuzzel
    waybar
    wl-clipboard
    xwayland
  ];

  # --- FONTS ---
  fonts.packages = with pkgs; [
    nerdfonts
  ];

  # --- SYSTEM VERSION ---
  system.stateVersion = "25.05"; 
}
