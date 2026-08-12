# Windows / WSL

Do not try to recreate the PS1 toolchain directly in random Windows command prompts unless you enjoy pain.

The recommended Windows setup is **WSL2 + Ubuntu + Docker Desktop**.

# 1. Install WSL2

From an Administrator PowerShell:

```powershell
wsl --install -d Ubuntu
```

Reboot if Windows asks. Open Ubuntu and finish the first-time user setup.

# 2. Install Git

Inside WSL:

```bash
sudo apt update
sudo apt install -y git
```

Install Docker Desktop on Windows and enable **WSL integration** for your Ubuntu distro.

# 3. Clone The Repo

Inside WSL (keep it in the Linux filesystem, not `/mnt/c`, because builds are much less annoying there):

```bash
git clone https://github.com/fourflipper42/PSXFunkin-COMPLETE.git
cd PSXFunkin-COMPLETE
```

# 4. Add PsyQ Locally

The repo does not ship PsyQ. Copy a compatible converted archive you are legally allowed to use into the ignored `.deps/` folder.

For a file in your Windows Downloads folder:

```bash
mkdir -p .deps
cp /mnt/c/Users/YOURNAME/Downloads/psyq-4_7-converted-light.zip .deps/psyq.zip
```

# 5. Build

```bash
./dev.sh setup --psyq-zip .deps/psyq.zip
./dev.sh build
```

The disc lands in `out/`.

# 6. Play It

The easiest option is to copy the BIN/CUE back to Windows and open the CUE in DuckStation:

```bash
cp out/PSXFunkin-COMPLETE-WIP.bin /mnt/c/Users/YOURNAME/Downloads/
cp out/PSXFunkin-COMPLETE-WIP.cue /mnt/c/Users/YOURNAME/Downloads/
```

Keep the BIN and CUE together.

If Docker is not visible inside WSL, open Docker Desktop → Settings → Resources → WSL Integration and enable your Ubuntu distro.
