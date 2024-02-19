{ config, lib, pkgs, user, ... }:

{
  imports =
    (import ./modules/shell) ++
    (import ./modules/editors) ++
    (import ./modules/programs) ++
    (import ./modules/devlop);

  home = {
    username = "${user}";
  };
  programs = {
    home-manager.enable = true;
  };

  home.stateVersion = "22.11";
}
