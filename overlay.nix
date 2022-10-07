{ self }:
final: prev: {
  enoslib = self.packages.${prev.system}.enoslib;
}