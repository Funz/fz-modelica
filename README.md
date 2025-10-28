# fz-modelica

OpenModelica integration for Funz framework - simulate and analyze Modelica models.

## Overview

This repository provides a calculator script (`modelica.sh`) that:
- Runs Modelica model simulations using OpenModelica
- Extracts simulation results
- Outputs results in Funz-compatible format

## Prerequisites

### Required
- **OpenModelica**: Install from [https://openmodelica.org/](https://openmodelica.org/)
- **Python 3**: With scipy and numpy packages

### Install Python dependencies
```bash
pip install scipy numpy
```

## Usage

### Basic Usage
```bash
./modelica.sh <model_file.mo>
```

The script will:
1. Load and simulate the Modelica model
2. Extract trajectory data and calculate outputs
3. Generate `output.txt` with results in Funz format

### Example
```bash
./modelica.sh ProjectileMotion.mo
```

This simulates the projectile motion model and generates outputs including:
- `max_height`: Maximum height reached (m)
- `range`: Horizontal distance traveled (m)
- `flight_time`: Time of flight (s)
- `final_velocity`: Impact velocity (m/s)
- `impact_angle`: Impact angle (degrees)
- `energy_loss`: Kinetic energy lost (J)
- `energy_loss_percent`: Percentage of energy lost (%)

## Testing

Run the test suite:
```bash
./tests/test_modelica.sh
```

The test script validates:
- Script executability
- Error handling (missing files, missing dependencies)
- Simulation execution (if OpenModelica is installed)
- Output file generation and format
- Result value sanity checks

## Project Structure
```
.
├── modelica.sh           # Main calculator script
├── ProjectileMotion.mo   # Example Modelica model
├── tests/
│   └── test_modelica.sh  # Test suite
└── README.md             # This file
```

## Model Requirements

The script expects models that:
- Define a `ProjectileMotion` model (or modify the script for different models)
- Include variables: `x`, `y`, `vx`, `vy` for trajectory calculations
- Can be simulated with OpenModelica's `simulate()` function

## Output Format

Results are written to `output.txt` in Funz format:
```
max_height = <value>;
range = <value>;
flight_time = <value>;
final_velocity = <value>;
impact_angle = <value>;
energy_loss = <value>;
energy_loss_percent = <value>;
```

## Troubleshooting

### OpenModelica not found
```
Error: OpenModelica (omc) not found. Please install OpenModelica.
```
Install OpenModelica from [https://openmodelica.org/](https://openmodelica.org/)

### Python packages missing
```
Error: Required Python package not found: No module named 'scipy'
```
Install required packages: `pip install scipy numpy`

### Simulation fails
Check `omc.log` for detailed error messages from OpenModelica.

## License

This project is part of the Funz framework.
