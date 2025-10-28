#!/usr/bin/env python3
"""
Example script demonstrating parametric study with fz-modelica plugin.
Runs multiple cases with different convection coefficients and plots results.
"""

import fz

# Run parametric study
print("Running Newton's cooling model with multiple convection coefficients")
results = fz.fzr(
    "samples/NewtonCooling.mo",
    {"convection": [0.1, 0.3, 0.5, 0.7, 0.9]},
    "Modelica",
    calculators="localhost",
    results_dir="results_parametric"
)

print("\nResults summary:")
print(results[['convection', 'status']])

# Plot results if matplotlib is available
try:
    import matplotlib.pyplot as plt
    
    print("\nGenerating plot...")
    plt.figure(figsize=(10, 6))
    
    for idx, row in results.iterrows():
        if row['status'] == 'done' and 'res' in row:
            convection = row['convection']
            res_data = row['res']['NewtonCooling']
            time = list(res_data['time'].values())
            temp = list(res_data['T'].values())
            plt.plot(time, temp, marker='o', markersize=3, label=f'h={convection}')
    
    plt.xlabel('Time (s)')
    plt.ylabel('Temperature (°C)')
    plt.title("Newton's Law of Cooling - Temperature vs Time")
    plt.legend()
    plt.grid(True, alpha=0.3)
    plt.savefig('cooling_curves.png', dpi=150, bbox_inches='tight')
    print("Plot saved to cooling_curves.png")
    
except ImportError:
    print("\nNote: Install matplotlib to generate plots:")
    print("  pip install matplotlib")

print(f"\nFull results saved in: results_parametric/")
