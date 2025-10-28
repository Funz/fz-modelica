# Repository Structure

Complete file structure of the fz-modelica plugin:

```
fz-modelica/
├── .github/
│   └── workflows/
│       └── verify.yml                    # CI workflow to verify plugin structure
│
├── .fz/                                  # fz framework configuration
│   ├── models/
│   │   └── Modelica.json                 # Modelica model definition
│   └── calculators/
│       ├── localhost.json                # Local calculator configuration
│       └── Modelica.sh                   # Modelica execution script (executable)
│
├── examples/                             # Example Jupyter notebooks
│   ├── 01_NewtonCooling_Parametric.ipynb    # Introduction to parametric studies
│   ├── 02_ProjectileMotion_Parametric.ipynb # Physics simulations & analysis
│   └── 03_ProjectileMotion_Advanced.ipynb   # 2D parameter space & optimization
│
├── tests/                                # Testing utilities
│   └── verify_installation.py            # Plugin structure verification script
│
├── .gitignore                            # Git ignore rules
├── CONTRIBUTING.md                       # Contribution guidelines
├── INSTALL_OPENMODELICA.md              # OpenModelica installation guide
├── LICENSE                               # BSD 3-Clause license
├── MIGRATION.md                          # Migration guide from old plugin
└── README.md                             # Main documentation
```

## File Descriptions

### Configuration Files (.fz/)

- **`.fz/models/Modelica.json`**: Defines how to parse Modelica files and extract outputs
  - Variable syntax: `${variable_name}` or `${variable_name~default_value}`
  - Output parsing: Python command to read CSV results
  
- **`.fz/calculators/localhost.json`**: Defines local calculator
  - Maps "Modelica" model to execution script
  - Uses shell URI scheme
  
- **`.fz/calculators/Modelica.sh`**: Execution script
  - Handles .mo and .mos files
  - Creates simulation script
  - Runs OpenModelica compiler (omc)
  - Detects errors

### Example Notebooks (examples/)

Comprehensive Jupyter notebooks with embedded models, executable code, and visualizations:

- **`01_NewtonCooling_Parametric.ipynb`**: Introduction to Funz-Modelica
  - Creates Newton's cooling model with parametric convection coefficient
  - Single and parametric simulations
  - Temperature curve visualization
  - Cooling efficiency analysis
  - ~150 lines of code + documentation

- **`02_ProjectileMotion_Parametric.ipynb`**: Projectile motion physics
  - Parametric projectile model (angle and velocity)
  - Launch angle effects on trajectory
  - Velocity effects on range
  - Theoretical vs simulation validation
  - Multiple visualizations and analysis plots
  - ~200 lines of code + documentation

- **`03_ProjectileMotion_Advanced.ipynb`**: Advanced Funz features
  - 2D parameter space exploration (velocity × angle grid)
  - Contour plots and heatmaps
  - Target hitting optimization
  - Result caching demonstration
  - Parameter interpolation
  - ~250 lines of code + documentation

### Documentation

- **`README.md`** (333 lines): Complete user guide
  - Installation instructions
  - Quick start guide
  - Usage examples
  - API reference
  - Troubleshooting

- **`MIGRATION.md`** (213 lines): Migration from old plugin
  - Structure comparison
  - Configuration changes
  - Usage comparison
  - Benefits of new approach

- **`INSTALL_OPENMODELICA.md`** (215 lines): OpenModelica setup
  - Ubuntu/Debian
  - Fedora/RedHat
  - macOS
  - Windows
  - Docker
  - Troubleshooting

- **`CONTRIBUTING.md`** (146 lines): Contribution guide
  - How to contribute
  - Development setup
  - Testing guidelines
  - Code style

- **`LICENSE`**: BSD 3-Clause license

### Testing

- **`tests/verify_installation.py`**: Plugin structure verification
  - Checks directory structure
  - Validates JSON configuration files
  - Verifies script executability
  - Confirms all required files present
  - Does not require OpenModelica to run

### CI/CD

- **`.github/workflows/verify.yml`**: GitHub Actions workflow
  - Runs on push/PR
  - Executes verification script
  - Validates JSON and shell syntax

## File Statistics

| Type           | Count | Total Lines/Cells |
|----------------|-------|-------------------|
| Configuration  | 3     | 51                |
| Documentation  | 5     | ~900              |
| Notebooks      | 3     | ~180 cells        |
| Tests          | 1     | 165               |
| CI/CD          | 1     | 51                |
| **Total**      | **13**| **~1350**         |

## Key Features

✅ Complete port of old Modelica plugin to new fz framework
✅ Comprehensive documentation (4 markdown files)
✅ Working examples with different use cases
✅ Automated verification script
✅ CI/CD workflow for validation
✅ BSD 3-Clause license (compatible with fz)
✅ Git ignore for build artifacts
✅ Contribution guidelines

## Comparison with Old Plugin

| Aspect              | Old Plugin        | New Plugin (fz-modelica) |
|---------------------|-------------------|--------------------------|
| Configuration       | 1 .ioplugin file  | 2 JSON files             |
| Scripts             | .sh + .bat        | .sh only                 |
| Documentation       | 1 README + 1 md   | 5 markdown files         |
| Examples            | Test cases only   | 3 working examples       |
| Testing             | Ant + Java        | Python verification      |
| CI/CD               | None              | GitHub Actions           |
| Total files         | ~10               | 14                       |

## Dependencies

**Runtime:**
- OpenModelica (omc)
- Python 3.7+
- fz framework
- pandas (for output parsing)

**Development:**
- Git
- Python 3.7+

**Optional:**
- matplotlib (for plotting examples)
