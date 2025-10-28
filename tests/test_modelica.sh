#!/bin/bash

# Test script for modelica.sh
# Tests the Modelica simulation script with the ProjectileMotion model

set -e  # Exit on error

TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$TEST_DIR")"
WORK_DIR="/tmp/modelica_test_$$"

echo "======================================"
echo "Testing modelica.sh"
echo "======================================"
echo ""

# Create working directory
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

echo "Working directory: $WORK_DIR"
echo ""

# Copy necessary files
cp "$REPO_ROOT/ProjectileMotion.mo" .
cp "$REPO_ROOT/modelica.sh" .

echo "Test 1: Check if script is executable"
if [ -x "./modelica.sh" ]; then
    echo "✓ Script is executable"
else
    echo "✗ Script is not executable"
    exit 1
fi
echo ""

echo "Test 2: Check script fails without OpenModelica (if not installed)"
if ! command -v omc &> /dev/null; then
    echo "OpenModelica not installed - skipping actual simulation tests"
    echo "To run full tests, install OpenModelica from https://openmodelica.org/"
    echo ""
    echo "Test 2a: Verify script detects missing OpenModelica"
    if ./modelica.sh ProjectileMotion.mo 2>&1 | grep -q "OpenModelica (omc) not found"; then
        echo "✓ Script correctly detects missing OpenModelica"
    else
        echo "✗ Script did not detect missing OpenModelica"
        exit 1
    fi
    echo ""
    echo "======================================"
    echo "Partial tests PASSED (OpenModelica not available)"
    echo "======================================"
    cd /
    rm -rf "$WORK_DIR"
    exit 0
fi

echo "Test 3: Check script fails with non-existent model file"
if ./modelica.sh NonExistent.mo 2>&1 | grep -q "Model file.*not found"; then
    echo "✓ Script correctly detects missing model file"
else
    echo "✗ Script did not detect missing model file"
    exit 1
fi
echo ""

echo "Test 4: Run simulation with ProjectileMotion model"
if ./modelica.sh ProjectileMotion.mo; then
    echo "✓ Simulation completed successfully"
else
    echo "✗ Simulation failed"
    exit 1
fi
echo ""

echo "Test 5: Check if output.txt was created"
if [ -f "output.txt" ]; then
    echo "✓ output.txt created"
else
    echo "✗ output.txt not created"
    exit 1
fi
echo ""

echo "Test 6: Verify output.txt contains expected variables"
EXPECTED_VARS=("max_height" "range" "flight_time" "final_velocity" "impact_angle" "energy_loss" "energy_loss_percent")
ALL_FOUND=true
for var in "${EXPECTED_VARS[@]}"; do
    if grep -q "^${var} = " output.txt; then
        echo "✓ Found variable: $var"
    else
        echo "✗ Missing variable: $var"
        ALL_FOUND=false
    fi
done

if [ "$ALL_FOUND" = false ]; then
    echo ""
    echo "Output file contents:"
    cat output.txt
    exit 1
fi
echo ""

echo "Test 7: Verify output values are reasonable"
# Extract values
MAX_HEIGHT=$(grep "^max_height = " output.txt | cut -d'=' -f2 | tr -d ' ;')
RANGE=$(grep "^range = " output.txt | cut -d'=' -f2 | tr -d ' ;')
FLIGHT_TIME=$(grep "^flight_time = " output.txt | cut -d'=' -f2 | tr -d ' ;')

# For a projectile with v0=20 m/s at 45 degrees:
# max_height ≈ (v0*sin(45))^2 / (2*g) ≈ 10.2 m
# range ≈ v0^2*sin(2*45) / g ≈ 40.8 m
# flight_time ≈ 2*v0*sin(45) / g ≈ 2.9 s

echo "Extracted values:"
echo "  max_height = $MAX_HEIGHT m (expected ~10 m)"
echo "  range = $RANGE m (expected ~40 m)"
echo "  flight_time = $FLIGHT_TIME s (expected ~3 s)"

# Basic sanity checks (allow wide tolerance)
if (( $(echo "$MAX_HEIGHT > 5 && $MAX_HEIGHT < 15" | bc -l) )); then
    echo "✓ max_height is reasonable"
else
    echo "✗ max_height is out of expected range"
    exit 1
fi

if (( $(echo "$RANGE > 20 && $RANGE < 60" | bc -l) )); then
    echo "✓ range is reasonable"
else
    echo "✗ range is out of expected range"
    exit 1
fi

if (( $(echo "$FLIGHT_TIME > 1 && $FLIGHT_TIME < 5" | bc -l) )); then
    echo "✓ flight_time is reasonable"
else
    echo "✗ flight_time is out of expected range"
    exit 1
fi
echo ""

echo "Test 8: Check simulation artifacts"
if [ -f "ProjectileMotion_res.mat" ]; then
    echo "✓ Result file (ProjectileMotion_res.mat) created"
else
    echo "✗ Result file not created"
    exit 1
fi

if [ -f "simulate.mos" ]; then
    echo "✓ OpenModelica script (simulate.mos) created"
else
    echo "✗ OpenModelica script not created"
    exit 1
fi

if [ -f "omc.log" ]; then
    echo "✓ Log file (omc.log) created"
else
    echo "✗ Log file not created"
    exit 1
fi
echo ""

echo "======================================"
echo "All tests PASSED"
echo "======================================"

# Cleanup
cd /
rm -rf "$WORK_DIR"

exit 0
