# Update this with this cmd:
# nix-shell -p nix-prefetch-github --run 'nix-prefetch-github m1cr0man nix-configs --nix'
builtins.fetchGit {
  url = "https://github.com/m1cr0man/nix-configs.git";
  ref = "master";
  rev = "d0a50cfcabc1a6dc3af38c8e3b1618535dfd8bc4";
}
