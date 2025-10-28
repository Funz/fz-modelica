# Migration from Old Plugin

This document describes the migration from the [old Modelica plugin](https://github.com/Funz/plugin-modelica) to the new fz-modelica plugin for the [fz framework](https://github.com/Funz/fz).

## Structure Comparison

### Old Plugin (plugin-modelica)

```
plugin-modelica/
├── src/
│   ├── main/
│   │   ├── io/
│   │   │   └── Modelica.ioplugin       # Model configuration
│   │   ├── scripts/
│   │   │   ├── Modelica.sh             # Unix execution script
│   │   │   └── Modelica.bat            # Windows execution script
│   │   └── samples/
│   │       ├── NewtonCooling.mo        # Sample model
│   │       └── NewtonCooling.mo.par    # Sample with variables
│   └── test/
│       └── cases/
│           └── NewtonCooling.mo/       # Test case
└── build.xml                           # Ant build file
```

### New Plugin (fz-modelica)

```
fz-modelica/
├── .fz/
│   ├── models/
│   │   └── Modelica.json               # Model configuration (replaces .ioplugin)
│   └── calculators/
│       ├── localhost.json              # Calculator configuration
│       └── Modelica.sh                 # Execution script (Unix only)
├── samples/
│   └── NewtonCooling.mo                # Sample model with variables
├── examples/
│   ├── run_single.py                   # Example: single case
│   ├── run_parametric.py               # Example: parametric study
│   └── run_with_cache.py               # Example: using cache
├── README.md                           # Documentation
├── CONTRIBUTING.md                     # Contribution guidelines
├── LICENSE                             # BSD 3-Clause license
└── .gitignore                          # Git ignore rules
```

## Configuration Migration

### Old: Modelica.ioplugin

```
variableStartSymbol=$
variableLimit=(...)
formulaStartSymbol=@
formulaLimit={...}
commentLineChar=*

datasetFilter=contains("(.*)","model") && contains("(.*)","parameter") && contains("(.*)","equation")

outputlist=time `grep("(.*)\\.mo(.*)","^(\\s*)Real")>>trim()>>cut("\\s",2)`

output.???.get=lines("(.*)_res.csv")>>CSV(",","???")>>asNumeric1DArray()

output.time.if=true
output.time.get=lines("(.*)_res.csv")>>CSV(",","time")
output.time.default=1:10
```

### New: .fz/models/Modelica.json

```json
{
    "id": "Modelica",
    "varprefix": "$",
    "formulaprefix": "@",
    "delim": "{}",
    "commentline": "//",
    "output": {
        "res": "python -c 'import pandas;import glob;import json;print(json.dumps({f.split(\"_res.csv\")[0]:pandas.read_csv(f).to_dict() for f in glob.glob(\"*_res.csv\")}))'"
    }
}
```

## Key Changes

### 1. Configuration Format

| Old                   | New           | Notes                                    |
|-----------------------|---------------|------------------------------------------|
| `variableStartSymbol` | `varprefix`   | Variable prefix                          |
| `variableLimit`       | `delim`       | Delimiter for formulas                   |
| `formulaStartSymbol`  | `formulaprefix` | Formula prefix                        |
| `formulaLimit`        | `delim`       | Same as variable delimiter               |
| `commentLineChar`     | `commentline` | Changed from `*` to `//` (Modelica std)  |

### 2. Output Parsing

**Old approach:**
- Used custom DSL with `>>` operators
- Separate configuration for each output variable
- Complex pattern matching

**New approach:**
- Uses shell commands directly
- Python/pandas for CSV parsing
- Returns entire result as nested dictionary
- More flexible and powerful

### 3. Variable Syntax

**Old:**
```modelica
parameter Real h=$(convection~0.7)
```

**New:**
```modelica
parameter Real h=${convection~0.7}
```

Both support default values with `~` syntax.

### 4. Script Enhancements

The new `Modelica.sh` script includes:
- Directory input support (like Telemac example)
- Multiple file handling
- Better error messages
- Consistent with fz patterns

### 5. Calculator Configuration

**New feature:** `.fz/calculators/localhost.json`
```json
{
    "uri": "sh://",
    "models": {
      "Modelica":"bash .fz/calculators/Modelica.sh"
    }
}
```

This allows:
- Named calculator aliases
- Multiple calculators
- Remote execution via SSH

## Usage Comparison

### Old Plugin Usage (with original Funz framework)

```java
// Java code
Funz.setDesignDriver("GradientDescent");
Funz.setModel("Modelica");
Funz.setInputFile("NewtonCooling.mo");
Funz.setInputVariables("convection", new double[]{0.5, 0.7, 0.9});
Funz.runDesign();
```

### New Plugin Usage (with fz framework)

```python
# Python code
import fz

results = fz.fzr(
    "samples/NewtonCooling.mo",
    {"convection": [0.5, 0.7, 0.9]},
    "Modelica",
    calculators="localhost",
    results_dir="results"
)
```

## Benefits of New Approach

1. **Simpler Configuration**: JSON instead of custom DSL
2. **More Powerful Output Parsing**: Full Python/shell capabilities
3. **Better Documentation**: Comprehensive README and examples
4. **Modern Tooling**: Python-based instead of Java
5. **Easier Testing**: Command-line examples
6. **Cache Support**: Built-in result caching
7. **Parallel Execution**: Native support for parallel calculations
8. **Remote Execution**: SSH support out of the box

## Migration Checklist for Users

If you're migrating from the old plugin:

- [ ] Update variable syntax from `$(var)` to `${var}` (optional, both work)
- [ ] Update comment lines from `*` to `//` if needed
- [ ] Install fz framework: `pip install funz-fz`
- [ ] Install Python dependencies: `pip install pandas`
- [ ] Convert Java code to Python using fz API
- [ ] Update output parsing from old DSL to shell commands
- [ ] Test with provided examples

## Backward Compatibility

The new plugin maintains compatibility with:
- ✅ Modelica `.mo` file format
- ✅ Variable syntax `${var}` or `${var~default}`
- ✅ OpenModelica compiler (omc)
- ✅ CSV output format from simulations

## Additional Resources

- [fz Framework Documentation](https://github.com/Funz/fz)
- [OpenModelica Documentation](https://openmodelica.org/doc/)
- [Old Plugin Repository](https://github.com/Funz/plugin-modelica)
