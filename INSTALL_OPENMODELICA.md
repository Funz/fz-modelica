# Installing OpenModelica

OpenModelica is required to run Modelica models with fz-modelica. This guide covers installation on various platforms.

## Ubuntu / Debian

### Quick Install (Stable Release)

```bash
# Add OpenModelica repository
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg

sudo curl -fsSL http://build.openmodelica.org/apt/openmodelica.asc | \
  sudo gpg --dearmor -o /usr/share/keyrings/openmodelica-keyring.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/openmodelica-keyring.gpg] \
  https://build.openmodelica.org/apt \
  $(cat /etc/os-release | grep "\(UBUNTU\|DEBIAN\|VERSION\)_CODENAME" | sort | cut -d= -f 2 | head -1) \
  stable" | sudo tee /etc/apt/sources.list.d/openmodelica.list

# Install OpenModelica compiler
sudo apt-get update
sudo apt install --no-install-recommends omc
```

### Verify Installation

```bash
omc --version
# Should output: OpenModelica vX.X.X
```

### Test Installation

```bash
# Create a simple test model
cat > test.mo << 'EOF'
model Test
  Real x;
equation
  x = time;
end Test;
EOF

# Create simulation script
cat > test.mos << 'EOF'
loadModel(Modelica);
loadFile("test.mo");
simulate(Test, stopTime=1);
EOF

# Run simulation
omc test.mos

# Check output
ls -la Test_*
# Should see Test_res.csv and other files
```

## Other Linux Distributions

### Fedora / Red Hat / CentOS

```bash
# Add repository
sudo dnf config-manager --add-repo https://build.openmodelica.org/rpm/openmodelica.repo

# Install
sudo dnf install openmodelica
```

### Arch Linux

```bash
# Install from AUR
yay -S openmodelica
# or
paru -S openmodelica
```

## macOS

### Using Homebrew

```bash
# Install Homebrew if not already installed
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install OpenModelica
brew install openmodelica
```

### Using Official Installer

1. Download the macOS installer from [OpenModelica Downloads](https://openmodelica.org/download/download-mac)
2. Run the installer
3. Add to PATH if needed:
   ```bash
   echo 'export PATH="/Applications/OpenModelica.app/Contents/MacOS:$PATH"' >> ~/.zshrc
   source ~/.zshrc
   ```

## Windows

### Using Official Installer

1. Download the Windows installer from [OpenModelica Downloads](https://openmodelica.org/download/download-windows)
2. Run the installer (choose appropriate version for your system)
3. Follow installation wizard
4. Verify installation:
   ```cmd
   omc --version
   ```

### Using Windows Subsystem for Linux (WSL)

If you're using WSL, follow the Ubuntu/Debian instructions above.

## Docker (All Platforms)

If you prefer using Docker:

```bash
# Pull OpenModelica image
docker pull openmodelica/openmodelica:latest

# Run simulation
docker run -v $(pwd):/data openmodelica/openmodelica:latest \
  omc /data/your_model.mo
```

## Troubleshooting

### Command Not Found

If `omc` command is not found after installation:

1. Check if OpenModelica is installed:
   ```bash
   # Linux/macOS
   which omc
   dpkg -l | grep openmodelica  # Debian/Ubuntu
   rpm -qa | grep openmodelica  # Fedora/RedHat
   
   # macOS
   brew list | grep openmodelica
   ```

2. Add to PATH:
   ```bash
   # Linux
   export PATH="/usr/bin:$PATH"
   
   # macOS (if installed via installer)
   export PATH="/Applications/OpenModelica.app/Contents/MacOS:$PATH"
   
   # Add to shell profile for persistence
   echo 'export PATH="/path/to/omc:$PATH"' >> ~/.bashrc  # or ~/.zshrc
   ```

### Permission Denied

```bash
# Linux/macOS
sudo chmod +x /usr/bin/omc
# or
sudo chmod +x /Applications/OpenModelica.app/Contents/MacOS/omc
```

### Missing Libraries

If you get library errors:

```bash
# Ubuntu/Debian
sudo apt-get install -f
sudo apt-get install libgomp1 libexpat1

# Fedora
sudo dnf install libgomp expat
```

### Simulation Fails

Common issues:

1. **Model syntax errors**: Check the `.moo` output file for OpenModelica error messages
2. **Missing Modelica library**: Make sure `loadModel(Modelica);` is in the simulation script
3. **Path issues**: Use absolute paths for model files

## Version Requirements

For fz-modelica, we recommend:

- OpenModelica >= 1.18.0 (latest stable)
- Python >= 3.7
- pandas >= 1.0.0

## Additional Resources

- [OpenModelica User's Guide](https://openmodelica.org/doc/OpenModelicaUsersGuide/latest/)
- [OpenModelica Forum](https://forum.openmodelica.org/)
- [OpenModelica GitHub](https://github.com/OpenModelica/OpenModelica)

## Testing with fz-modelica

Once OpenModelica is installed, test with fz-modelica:

```bash
cd fz-modelica
python examples/run_single.py
```

If successful, you should see output showing temperature simulation results.
