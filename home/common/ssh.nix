{ ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        AddKeysToAgent = "yes";
      };
      "github.com" = {
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519_sk_ciri";
      };
      "git.sr.ht" = {
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519_sk_ciri";
      };
      "codeberg.org" = {
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519_sk_ciri";
      };
    };
  };
}
