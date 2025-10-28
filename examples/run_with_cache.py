#!/usr/bin/env python3
"""
Example script demonstrating cache usage with fz-modelica plugin.
Shows how to reuse previous results to avoid redundant calculations.
"""

import fz

# First run - calculate all cases
print("First run: calculating all cases...")
results1 = fz.fzr(
    "samples/NewtonCooling.mo",
    {"convection": [0.3, 0.5, 0.7]},
    "Modelica",
    calculators="localhost",
    results_dir="results_cache_demo"
)

print(f"First run completed: {len(results1)} cases")
print(results1[['convection', 'status']])

# Second run - with cache, should reuse results and only calculate new cases
print("\nSecond run: using cache for existing cases, adding new ones...")
results2 = fz.fzr(
    "samples/NewtonCooling.mo",
    {"convection": [0.3, 0.5, 0.7, 0.9, 1.1]},  # Added 0.9 and 1.1
    "Modelica",
    calculators=["cache://results_cache_demo", "localhost"],
    results_dir="results_cache_demo2"
)

print(f"Second run completed: {len(results2)} cases")
print(results2[['convection', 'status', 'calculator']])

# Show which cases were from cache vs new calculations
print("\nCache statistics:")
cache_count = sum(results2['calculator'].str.contains('cache://'))
calc_count = len(results2) - cache_count
print(f"  From cache: {cache_count} cases")
print(f"  New calculations: {calc_count} cases")

print(f"\nResults saved in: results_cache_demo/ and results_cache_demo2/")
