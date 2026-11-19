{ ... }:

{
  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;
      settings."mail.tabs.drawInTitlebar" = false;
    };
  };

  catppuccin.thunderbird.profile = "default";

  accounts.email.accounts = {
    personal = {
      primary = true;
      address = "me@shader.coffee";
      userName = "me@shader.coffee";
      realName = "Hélder Rodrigues";

      imap = {
        host = "mail.kagimail.com";
        port = 993;
      };

      smtp = {
        host = "mail.kagimail.com";
        port = 465;
      };

      thunderbird.enable = true;
    };

    university = {
      flavor = "outlook.office365.com";
      address = "1251034@isep.ipp.pt";
      userName = "1251034@isep.ipp.pt";
      realName = "Hélder Rodrigues";

      thunderbird = {
        enable = true;
        settings = id: {
          "mail.server.server_${id}.authMethod" = 10;
          "mail.server.server_${id}.autosync_max_age_days" = 180;
          "mail.smtpserver.smtp_${id}.authMethod" = 10;
        };
      };
    };
  };
}
