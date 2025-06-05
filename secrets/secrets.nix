let
  theutz = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIbChuj1162NTbJx49GrPJC7qc/mBrXHcDNQO1wbNyJ5";
  users = [theutz];

  kocaeli = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFX1tT+JKfr6NpoZlIXoQMmlJieaaxxD1/fsU7h7Iojq";
  systems = [kocaeli];

  personal = [theutz kocaeli];
in {
  "theutz-id_ed25519.age".publicKeys = personal;
  "spotify-client-id.age".publicKeys = users;
}
