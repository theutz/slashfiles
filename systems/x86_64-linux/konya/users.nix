{...}: {
  users.users.michael = {
    isNormalUser = true;
    description = "Michael Utz";
    extraGroups = ["networkmanager"];
  };
  snowfallorg.users.michael = {
    create = true;
    admin = true;
    home.enable = true;
  };

}
