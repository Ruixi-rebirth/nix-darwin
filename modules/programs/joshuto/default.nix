{ pkgs, config, inputs, ... }:
{
  home = {
    packages = with pkgs; [
      file
      inputs.joshuto.packages.joshuto
    ];
  };
  home.file.".config/joshuto".source = ./config;
}
