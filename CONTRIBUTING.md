# Contributing to fz-modelica

Thank you for your interest in contributing to fz-modelica!

## How to Contribute

### Reporting Issues

If you encounter any bugs or have feature requests:

1. Check if the issue already exists in the [issue tracker](https://github.com/Funz/fz-modelica/issues)
2. If not, create a new issue with:
   - A clear, descriptive title
   - Detailed description of the problem or feature
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - Your environment (OS, Python version, OpenModelica version)

### Submitting Changes

1. Fork the repository
2. Create a new branch for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. Make your changes
4. Test your changes thoroughly
5. Commit with clear, descriptive messages
6. Push to your fork
7. Submit a pull request

## Development Setup

### Prerequisites

- Python 3.7+
- OpenModelica (omc)
- Git

### Setting up Development Environment

1. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/fz-modelica.git
   cd fz-modelica
   ```

2. Install fz framework:
   ```bash
   pip install funz-fz
   # or for development:
   pip install -e git+https://github.com/Funz/fz.git
   ```

3. Install dependencies:
   ```bash
   pip install pandas matplotlib
   ```

4. Test the examples:
   ```bash
   python examples/run_single.py
   ```

## Testing

Before submitting a pull request:

1. Test with the provided examples:
   ```bash
   cd examples
   python run_single.py
   python run_parametric.py
   python run_with_cache.py
   ```

2. Test with your own Modelica models if applicable

3. Ensure the calculator script works correctly:
   ```bash
   cd samples
   bash ../.fz/calculators/Modelica.sh NewtonCooling.mo
   # Should generate output files
   ```

## Code Style

- Follow Python PEP 8 style guide for Python code
- Use clear, descriptive variable names
- Add comments for complex logic
- Keep functions focused and modular

## Adding New Features

When adding new features:

1. **New Modelica Models**: Add to `samples/` directory with documentation
2. **Enhanced Calculator Script**: Maintain backward compatibility
3. **Configuration Changes**: Update both `.fz/` files and documentation
4. **Examples**: Add example scripts to `examples/` directory

## Documentation

When making changes:

1. Update README.md if user-facing functionality changes
2. Add inline comments for complex code
3. Update examples if the API changes
4. Include usage examples in pull request description

## Pull Request Guidelines

A good pull request:

- Addresses a single concern
- Includes clear description of changes
- References related issues (if any)
- Includes examples or tests
- Updates documentation as needed
- Follows existing code style

## Questions?

If you have questions:

- Check the [fz documentation](https://github.com/Funz/fz)
- Review existing issues and pull requests
- Create a new issue with the "question" label

## License

By contributing, you agree that your contributions will be licensed under the same BSD 3-Clause License that covers the project.

Thank you for contributing! 🎉
