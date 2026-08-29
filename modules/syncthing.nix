{ config, ... }:

let
  allDevices = {
    glados.id = "MSMOCWY-FKLTHHO-ERQPZ42-HJVER5Z-KPW2Q2C-56RVHK5-2A4PION-3APWFAG";
    phone.id = "F6HJUKI-XSLZYZ3-COPRDER-LN7ZXWU-3CTNHEX-AKEIF4O-E6JUVOE-DV7NXAC";
  };

  devices = builtins.removeAttrs allDevices [
    config.networking.hostName
  ];
in
{
  services.syncthing = {
    enable = true;
    user = "coffeeshader";
    group = "users";
    dataDir = "/home/coffeeshader";
    openDefaultPorts = true;

    overrideDevices = true;
    overrideFolders = true;

    settings = {
      inherit devices;

      folders.Music = {
        path = "/home/coffeeshader/Music";
        type = if config.networking.hostName == "glados" then "sendonly" else "receiveonly";
        devices = builtins.attrNames devices;
      };

      options = {
        urAccepted = -1;
        globalAnnounceEnabled = false;
        relaysEnabled = false;
      };
    };
  };
}
