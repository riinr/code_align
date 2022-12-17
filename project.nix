{ 
  # create .gitignore
  files.gitignore.enable = true;
  files.gitignore.template."Global/Archives" = true;
  files.gitignore.template."Global/Backup"   = true;
  files.gitignore.template."Global/Diff"     = true;
  files.gitignore.pattern.".direnv"          = true;
  files.gitignore.pattern."bin"              = true;

  # LICENSE file creation
  # using templates from https://github.com/spdx/license-list-data
  files.license.enable = true;
  files.license.spdx.name = "MIT";
  files.license.spdx.vars.year = "2023";
  files.license.spdx.vars."copyright holders" = "Cruel Intentions";

  # install a packages
  packages = [
    "nim"
  ];

  # configure direnv .envrc file
  files.direnv.enable = true;
}
