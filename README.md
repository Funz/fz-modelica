# fz-modelica

OpenModelica plugin for Funz framework - simulate and analyze Modelica models through parametric studies.

## Overview

This plugin integrates OpenModelica with the Funz framework, enabling:
- Parametric studies of Modelica models
- Batch simulations with different parameter sets
- Result extraction and analysis
- Optimization and design of experiments using Funz capabilities

## Prerequisites

### Required
- **Funz framework**: `pip install funz-fz`
- **OpenModelica**: Install from [https://openmodelica.org/](https://openmodelica.org/) (see [INSTALL_OPENMODELICA.md](INSTALL_OPENMODELICA.md))
- **Python 3.7+**: With pandas package

### Install Dependencies
```bash
# Core dependencies
pip install funz-fz pandas

# For running example notebooks
pip install jupyter matplotlib scipy
```

See [INSTALL_OPENMODELICA.md](INSTALL_OPENMODELICA.md) for detailed OpenModelica installation instructions for different platforms.

## Quick Start

### 1. Verify Installation
```bash
python tests/verify_installation.py
```

### 2. Explore Example Notebooks

The `examples/` directory contains comprehensive Jupyter notebooks demonstrating the plugin:

**📓 01_NewtonCooling_Parametric.ipynb**
- Introduction to Funz-Modelica workflow
- Single and parametric simulations
- Visualization of cooling curves
- Analysis of convection effects

**📓 02_ProjectileMotion_Parametric.ipynb**
- Projectile motion physics
- Effect of launch angle and velocity
- Range and height calculations
- Classical mechanics validation

**📓 03_ProjectileMotion_Advanced.ipynb**
- 2D parameter space exploration
- Contour plots and heatmaps
- Target hitting optimization
- Result caching for efficiency

### 3. Run the Notebooks
```bash
# Start Jupyter
jupyter notebook

# Or use JupyterLab
jupyter lab

# Navigate to examples/ and open any notebook
```

## Project Structure
```
.
├── .fz/                                    # Funz plugin configuration
│   ├── models/
│   │   └── Modelica.json                   # Model definition
│   └── calculators/
│       ├── localhost.json                  # Calculator configuration
│       └── Modelica.sh                     # Execution script
├── examples/                               # Jupyter notebook examples
│   ├── 01_NewtonCooling_Parametric.ipynb  # Intro to parametric studies
│   ├── 02_ProjectileMotion_Parametric.ipynb  # Physics simulations
│   └── 03_ProjectileMotion_Advanced.ipynb    # Advanced features & optimization
├── tests/
│   └── verify_installation.py             # Installation verification
└── Documentation files
    ├── README.md                           # This file
    ├── STRUCTURE.md                        # Repository structure details
    ├── MIGRATION.md                        # Migration from old plugin
    ├── INSTALL_OPENMODELICA.md            # OpenModelica setup
    └── CONTRIBUTING.md                     # Contribution guidelines
```

## Creating Parametric Models

Add variable syntax to your Modelica model parameters:

```modelica
model MyModel
  parameter Real param1=${var1~default_value};
  // ... rest of model
end MyModel;
```

Then run with Funz:

```python
import fz

results = fz.fzr(
    "MyModel.mo",
    {"var1": [0.5, 0.7, 0.9]},  # Test multiple values
    "Modelica",
    calculators="localhost"
)
```

## Testing

Verify the plugin structure:
```bash
python tests/verify_installation.py
```

This checks:
- Directory structure
- Configuration files
- Example notebooks
- Plugin executability

### Running Example Notebooks

The notebooks demonstrate complete workflows and can be run interactively:
```bash
# Install Jupyter if needed
pip install jupyter matplotlib scipy

# Launch Jupyter
jupyter notebook examples/
```

## Troubleshooting

### OpenModelica not found
```
Error: omc command not found
```
Install OpenModelica from [https://openmodelica.org/](https://openmodelica.org/) or see [INSTALL_OPENMODELICA.md](INSTALL_OPENMODELICA.md)

### Funz not installed
```
Error: No module named 'fz'
```
Install Funz: `pip install funz-fz`

### Simulation fails
Check the temporary directory for `*.moo` log files from OpenModelica.

## Documentation

- [README.md](README.md) - This file (quick start)
- [STRUCTURE.md](STRUCTURE.md) - Complete repository structure
- [MIGRATION.md](MIGRATION.md) - Migration guide from old plugin
- [INSTALL_OPENMODELICA.md](INSTALL_OPENMODELICA.md) - OpenModelica installation
- [CONTRIBUTING.md](CONTRIBUTING.md) - Contribution guidelines

## License

This project is part of the Funz framework. See [LICENSE](LICENSE) for details.
