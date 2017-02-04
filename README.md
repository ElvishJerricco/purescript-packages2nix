purescript-packages2nix
---

This package will convert the
[purescript package set](https://github.com/purescript/package-sets)
to a nix format suitable for
[purescriptPackages](https://github.com/ElvishJerricco/nix-purescriptPackages).
This tool currently only converts the entire package set. It cannot be
used to convert a single project to a nix project. The primary purpose
of this package is to generate a Nix package set for
`purescriptPackages`, which can be used to depend on packages in the
PureScript package set.

Usage
---

```bash
$ PACKAGES_URL=https://raw.githubusercontent.com/purescript/package-sets/master/packages.json
$ curl $PACKAGES_URL | purescript-packages2nix-exe > purescript-packages.nix
```
