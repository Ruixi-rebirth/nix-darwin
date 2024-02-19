{ config, pkgs, ... }:
{
  programs.gpg.enable = true;
  programs.gpg.package = pkgs.gnupg;
}
