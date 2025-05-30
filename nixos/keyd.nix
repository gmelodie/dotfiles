{config, pkgs, lib, ...}:

{
  environment.systemPackages = with pkgs; [
    keyd
  ];
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        settings = {
          main = {
            v = "overloadi(v, overloadt2(shift, v, 125), 25)";
            m = "overloadi(m, overloadt2(shift, m, 125), 25)";
            z = "overloadi(z, overloadt2(control, z, 125), 25)";
            slash = "overloadi(/, overloadt2(control, /, 125), 25)";
          };
        };
      };
    };
  };
}



