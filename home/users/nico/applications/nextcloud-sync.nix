{
  config,
  ...
}:

{
  services.nextcloud-sync.home = {
    remotePath = "/Sync";
    localPath = "${config.home.homeDirectory}/Sync";
    host = "https://wolke.nlintn.de";
    environmentFiles = [
      config.age.secrets."ncsync-user".path
      config.age.secrets."ncsync-password".path
    ];
    timerConfig = {
      OnCalendar = "*:0/5";
      OnBootSec = 60;
      Persistent = true;
    };
  };
}
