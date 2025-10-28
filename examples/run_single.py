#!/usr/bin/env python3
"""
Example script demonstrating basic usage of fz-modelica plugin.
Runs a single parametric case with the Newton's cooling model.
"""

import fz

# Run a single case
print("Running Newton's cooling model with convection coefficient = 0.7")
results = fz.fzr(
    "samples/NewtonCooling.mo",
    {"convection": 0.7},
    "Modelica",
    calculators="localhost",
    results_dir="results_single"
)

print("\nResults:")
print(results)

# Extract and display temperature data
if len(results) > 0 and 'res' in results.columns:
    res_data = results.iloc[0]['res']['NewtonCooling']
    print(f"\nTemperature at t=0: {list(res_data['T'].values())[0]:.2f}°C")
    print(f"Temperature at t=1: {list(res_data['T'].values())[-1]:.2f}°C")
    print(f"\nFull results saved in: results_single/")
