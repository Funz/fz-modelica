#!/bin/bash

# Modelica Calculator Script for FZ
# Requires OpenModelica to be installed (omc command available)

# The compiled model file is passed as the first argument
MODEL_FILE="$1"

# Check if OpenModelica is installed
if ! command -v omc &> /dev/null; then
    echo "Error: OpenModelica (omc) not found. Please install OpenModelica."
    echo "Visit: https://openmodelica.org/"
    exit 1
fi

# Check if model file exists
if [ ! -f "$MODEL_FILE" ]; then
    echo "Error: Model file $MODEL_FILE not found"
    exit 1
fi

# Create OpenModelica script to simulate and extract results
cat > simulate.mos << EOF
// Load and simulate the model
loadFile("$MODEL_FILE");
simulate(ProjectileMotion, stopTime=10, numberOfIntervals=1000);

// Get final results using the result file
val(x, 0.0);  // Check simulation worked
quit();
EOF

# Run OpenModelica
omc simulate.mos > omc.log 2>&1
RESULT=$?

if [ $RESULT -ne 0 ]; then
    echo "Error: OpenModelica simulation failed"
    cat omc.log
    exit 1
fi

# Check if result file was created
if [ ! -f "ProjectileMotion_res.mat" ]; then
    echo "Error: Result file not created"
    exit 1
fi

# Extract results using Python (OpenModelica Python API)
python3 << 'PYTHON_EOF'
import sys
try:
    # Try to use OMPython for reading results
    from OMPython import ModelicaSystem

    # Alternative: use numpy and scipy to read MAT file
    import scipy.io
    import numpy as np

    # Read the OpenModelica result file
    mat = scipy.io.loadmat('ProjectileMotion_res.mat')

    # Extract time and variables
    # OpenModelica stores results in specific format
    names = [name.strip() for name in mat['name']]
    data = mat['data_2']  # Trajectory data

    # Find variable indices
    def get_var_idx(var_name):
        for i, name in enumerate(names):
            if name == var_name:
                return i
        return None

    # Get time array
    time_idx = get_var_idx('time')
    if time_idx is None:
        time = np.linspace(0, 10, data.shape[1])
    else:
        time = data[time_idx, :]

    # Get trajectory variables
    x_idx = get_var_idx('x')
    y_idx = get_var_idx('y')
    vx_idx = get_var_idx('vx')
    vy_idx = get_var_idx('vy')

    x = data[x_idx, :]
    y = data[y_idx, :]
    vx = data[vx_idx, :]
    vy = data[vy_idx, :]

    # Find when projectile lands (y crosses zero after launch)
    landing_idx = None
    for i in range(10, len(y)):  # Skip first few points
        if y[i] < 0:
            landing_idx = i - 1
            break

    if landing_idx is None:
        landing_idx = len(y) - 1

    # Calculate outputs
    max_height = np.max(y)
    range_distance = x[landing_idx]
    flight_time = time[landing_idx]

    v_final = np.sqrt(vx[landing_idx]**2 + vy[landing_idx]**2)
    impact_angle = np.degrees(np.arctan2(abs(vy[landing_idx]), abs(vx[landing_idx])))

    # Energy calculations (need mass and v0)
    # These should come from parameters
    # For now, estimate from initial velocity
    v0 = np.sqrt(vx[0]**2 + vy[0]**2)
    m = 1.0  # Default mass

    ke_initial = 0.5 * m * v0**2
    ke_final = 0.5 * m * v_final**2
    energy_loss = ke_initial - ke_final
    energy_loss_percent = 100 * energy_loss / ke_initial if ke_initial > 0 else 0

    # Write results to output.txt in FZ format
    with open('output.txt', 'w') as f:
        f.write(f"max_height = {max_height};\n")
        f.write(f"range = {range_distance};\n")
        f.write(f"flight_time = {flight_time};\n")
        f.write(f"final_velocity = {v_final};\n")
        f.write(f"impact_angle = {impact_angle};\n")
        f.write(f"energy_loss = {energy_loss};\n")
        f.write(f"energy_loss_percent = {energy_loss_percent};\n")

    print("Simulation completed successfully")

except ImportError as e:
    print(f"Error: Required Python package not found: {e}", file=sys.stderr)
    print("Please install: pip install scipy numpy", file=sys.stderr)
    sys.exit(1)
except Exception as e:
    print(f"Error extracting results: {e}", file=sys.stderr)
    sys.exit(1)

PYTHON_EOF

exit $?
