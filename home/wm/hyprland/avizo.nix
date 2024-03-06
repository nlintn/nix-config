{ ... }:

{
  services.avizo = {
    enable = true;
    settings.default = {
      time = 1.5;
      fade-in = 0.1;
      fade-out = 0.2;
      image-opacity = 0.9;
      border-color = "rgba(54, 58, 79, 0.9)";
      background = "rgba(36, 39, 58, 0.9)";
      bar-fg-color = "rgba(160, 160, 160, 0.9)";
    };
  };
}