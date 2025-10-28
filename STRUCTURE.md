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
├── samples/                              # Sample Modelica models
│   └── NewtonCooling.mo                  # Newton's law of cooling example
│
├── examples/                             # Example usage scripts
│   ├── run_single.py                     # Run single case example
│   ├── run_parametric.py                 # Run parametric study example
│   └── run_with_cache.py                 # Run with cache example
│
├── tests/                                # Testing utilities
│   └── verify_installation.py            # Verification script
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
  - Variable syntax: `${variable_name}`
  - Output parsing: Python command to read CSV results
  
- **`.fz/calculators/localhost.json`**: Defines local calculator
  - Maps "Modelica" model to execution script
  - Uses shell URI scheme
  
- **`.fz/calculators/Modelica.sh`**: Execution script
  - Handles .mo and .mos files
  - Creates simulation script
  - Runs OpenModelica compiler (omc)
  - Detects errors

### Sample Files (samples/)

- **`samples/NewtonCooling.mo`**: Example model demonstrating:
  - Parameter with variable: `h=${convection~0.7}`
  - Default value syntax
  - Physical modeling

### Example Scripts (examples/)

All examples are executable Python scripts:

- **`run_single.py`**: Run single case
- **`run_parametric.py`**: Run multiple cases and plot results
- **`run_with_cache.py`**: Demonstrate cache usage

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

- **`tests/verify_installation.py`**: Verification script
  - Checks directory structure
  - Validates JSON files
  - Checks executability
  - Verifies configuration content

### CI/CD

- **`.github/workflows/verify.yml`**: GitHub Actions workflow
  - Runs on push/PR
  - Executes verification script
  - Validates JSON and shell syntax

## File Statistics

| Type           | Count | Total Lines |
|----------------|-------|-------------|
| Configuration  | 3     | ~50         |
| Documentation  | 5     | ~1000       |
| Samples        | 1     | 15          |
| Examples       | 3     | ~100        |
| Tests          | 1     | ~160        |
| CI/CD          | 1     | ~50         |
| **Total**      | **14**| **~1375**   |

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
