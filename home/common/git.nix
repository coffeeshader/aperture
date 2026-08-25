{ config, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Hélder Rodrigues";
        email = "me@shader.coffee";
        signingkey = "~/.ssh/id_ed25519_sk_ciri.pub";
      };

      push = {
        default = "simple";
        followTags = true;
      };

      sendmail.annotate = true;
      pull.rebase = true;
      init.defaultBranch = "master";

      commit = {
        verbose = true;
        gpgsign = true;
      };

      gpg = {
        format = "ssh";
        ssh = {
          allowedSignersFile = "${config.xdg.configHome}/git/allowed_signers";
          defaultKeyCommand = "ssh-add -L";
        };
      };

      tag.gpgsign = true;
    };
  };

  xdg.configFile."git/allowed_signers".text = ''
    sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAICNcdy7rKlx1Hgldb/JJInHDFK5IEk+XmGbsaNkds72iAAAABHNzaDo= me@shader.coffee
  '';
}
