{ ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        AddKeysToAgent = "yes";
      };
      "github.com git.sr.ht codeberg.org" = {
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519_sk_ciri";
      };
    };
  };
}
