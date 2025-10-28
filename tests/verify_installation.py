#!/usr/bin/env python3
"""
Basic verification script for fz-modelica plugin.
Checks that all required files and configurations are present.
"""

import os
import sys
import json
from pathlib import Path


def check_file_exists(filepath, description):
    """Check if a file exists and report status."""
    if os.path.exists(filepath):
        print(f"✓ {description}: {filepath}")
        return True
    else:
        print(f"✗ {description}: {filepath} NOT FOUND")
        return False


def check_json_valid(filepath, description):
    """Check if a JSON file is valid."""
    try:
        with open(filepath, 'r') as f:
            json.load(f)
        print(f"✓ {description} is valid JSON")
        return True
    except Exception as e:
        print(f"✗ {description} JSON parsing error: {e}")
        return False


def check_executable(filepath, description):
    """Check if a file is executable."""
    if os.access(filepath, os.X_OK):
        print(f"✓ {description} is executable")
        return True
    else:
        print(f"✗ {description} is NOT executable")
        return False


def main():
    """Main verification function."""
    print("=" * 60)
    print("fz-modelica Plugin Verification")
    print("=" * 60)
    print()
    
    # Get repository root
    repo_root = Path(__file__).parent.parent
    os.chdir(repo_root)
    
    all_checks_passed = True
    
    # Check directory structure
    print("Checking directory structure...")
    dirs = [
        ".fz/models",
        ".fz/calculators",
        "examples",
        "tests"
    ]
    for d in dirs:
        all_checks_passed &= check_file_exists(d, f"Directory {d}")
    print()
    
    # Check model configuration
    print("Checking model configuration...")
    model_file = ".fz/models/Modelica.json"
    all_checks_passed &= check_file_exists(model_file, "Model configuration")
    if os.path.exists(model_file):
        all_checks_passed &= check_json_valid(model_file, "Model configuration")
    print()
    
    # Check calculator configuration
    print("Checking calculator configuration...")
    calc_config = ".fz/calculators/localhost.json"
    all_checks_passed &= check_file_exists(calc_config, "Calculator configuration")
    if os.path.exists(calc_config):
        all_checks_passed &= check_json_valid(calc_config, "Calculator configuration")
    print()
    
    # Check calculator script
    print("Checking calculator script...")
    calc_script = ".fz/calculators/Modelica.sh"
    all_checks_passed &= check_file_exists(calc_script, "Calculator script")
    if os.path.exists(calc_script):
        all_checks_passed &= check_executable(calc_script, "Calculator script")
    print()
    
    # Check example notebooks
    print("Checking example notebooks...")
    notebooks = [
        "examples/01_NewtonCooling_Parametric.ipynb",
        "examples/02_ProjectileMotion_Parametric.ipynb",
        "examples/03_ProjectileMotion_Advanced.ipynb"
    ]
    for nb in notebooks:
        all_checks_passed &= check_file_exists(nb, f"Notebook {os.path.basename(nb)}")
    print()
    
    # Check documentation
    print("Checking documentation...")
    docs = [
        "README.md",
        "MIGRATION.md",
        "INSTALL_OPENMODELICA.md",
        "CONTRIBUTING.md",
        "LICENSE"
    ]
    for doc in docs:
        all_checks_passed &= check_file_exists(doc, f"Documentation {doc}")
    print()
    
    # Verify model configuration content
    print("Verifying model configuration content...")
    try:
        with open(model_file, 'r') as f:
            model_config = json.load(f)
        
        required_keys = ['id', 'varprefix', 'delim', 'output']
        for key in required_keys:
            if key in model_config:
                print(f"✓ Model config has '{key}': {model_config[key] if key != 'output' else '...'}")
            else:
                print(f"✗ Model config missing '{key}'")
                all_checks_passed = False
    except Exception as e:
        print(f"✗ Error reading model config: {e}")
        all_checks_passed = False
    print()
    
    # Final result
    print("=" * 60)
    if all_checks_passed:
        print("✓ ALL CHECKS PASSED")
        print("=" * 60)
        print()
        print("Plugin is properly configured!")
        print("Next steps:")
        print("  1. Install OpenModelica (see INSTALL_OPENMODELICA.md)")
        print("  2. Install dependencies: pip install funz-fz pandas jupyter matplotlib scipy")
        print("  3. Run notebooks: jupyter notebook examples/")
        return 0
    else:
        print("✗ SOME CHECKS FAILED")
        print("=" * 60)
        print()
        print("Please fix the issues above before using the plugin.")
        return 1


if __name__ == "__main__":
    sys.exit(main())
