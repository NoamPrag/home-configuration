# 🏠 My Home Manager Configuration (Nix Flake)


This repository contains my personal [Home Manager](https://nix-community.github.io/home-manager/) configuration, managed with [Nix flakes](https://nixos.wiki/wiki/Flakes).
It defines a fully reproducible user environment that can be deployed on any machine running Nix.
* Currently implemented for MacOS - can be easily fitted to Linux.

---

## ⚙️ Prerequisites
- **Nix** (determinate systems) - install via:
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate
```

---

## 🚀 Usage
1. Clone this repo:
```bash
git clone https://github.com/NoamPrag/home-configuration.git ~/.config/home-manager
```

2. Install & Run `home-manager` using Nix itself:
```bash
nix run home-manager/master -- init --switch
```

### 🔄 Optional: updating packages
Update Nix flake registry via:
```bash
nix flake update --flake ~/.config/home-manager
```

---

## 👤 Personal Configuration
The configuration in `home.nix` and in `flake.nix` specify machine and user properties, which should be edited upon installation:

- `flake.nix`:
```nix
system = "aarch64-darwin"; # Specifies MacOS
```

```nix
homeConfiguration."<user>" = ...
```

- Edit the user properties `home.nix`:
```nix
  name = {
    first = "<FILL>";
    last = "<FILL>";
    user = "<FILL>";
    email = "<FILL>";
    full = "${name.first} ${name.last}";
  };
  homeDirectory = "/Users/${name.user}";
```
Note that the home directory is in MacOS format - Edit this field to fit the current OS.
