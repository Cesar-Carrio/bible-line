# Contributing to Bible Line

Thank you for your interest in contributing to Bible Line! We welcome contributions from the community.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Making Changes](#making-changes)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)
- [Style Guidelines](#style-guidelines)

## Code of Conduct

This project and everyone participating in it is governed by our commitment to creating a welcoming and inclusive environment. Please be respectful and professional in all interactions.

## Getting Started

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/your-username/bible-line.git
   cd bible-line
   ```
3. Add the upstream repository:
   ```bash
   git remote add upstream https://github.com/cesar-carrio/bible-line.git
   ```

## Development Setup

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Build the project:**
   ```bash
   npm run build
   ```

3. **Test the application:**
   ```bash
   npm start
   # or
   npm link && bible-line
   ```

4. **Test setup scripts:**
   ```bash
   ./setup-autorun.sh --help
   ```

## Making Changes

1. **Create a feature branch:**
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/your-bug-fix
   ```

2. **Make your changes:**
   - Edit files in the `src/` directory
   - Update documentation if needed
   - Add tests if applicable

3. **Build and test:**
   ```bash
   npm run build
   npm start
   ```

4. **Commit your changes:**
   ```bash
   git add .
   git commit -m "feat: add your feature description"
   # or
   git commit -m "fix: fix your bug description"
   ```

## Testing

- **Manual testing:** Run `npm start` or `bible-line` to test functionality
- **Setup scripts:** Test `./setup-autorun.sh` and `./uninstall-autorun.sh`
- **Cross-platform:** Test on different shells (zsh, bash, fish) if possible
- **Build verification:** Ensure `npm run build` completes without errors

## Submitting Changes

1. **Push to your fork:**
   ```bash
   git push origin feature/your-feature-name
   ```

2. **Create a Pull Request:**
   - Go to GitHub and create a pull request
   - Use the pull request template
   - Provide a clear description of your changes
   - Link any related issues

3. **Respond to feedback:**
   - Address any review comments
   - Make additional commits if needed
   - Keep the conversation professional and constructive

## Style Guidelines

### Code Style

- **TypeScript:** Follow standard TypeScript conventions
- **Formatting:** Use consistent indentation (2 spaces)
- **Naming:** Use descriptive variable and function names
- **Comments:** Add comments for complex logic

### Commit Messages

Use conventional commit format:
- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation changes
- `refactor:` for code refactoring
- `test:` for adding tests
- `chore:` for maintenance tasks

Examples:
- `feat: add support for custom Bible versions`
- `fix: resolve terminal crash on macOS`
- `docs: update installation instructions`

### Shell Scripts

- **Compatibility:** Ensure scripts work on bash, zsh, and fish
- **Error handling:** Include proper error checking
- **Safety:** Prevent terminal crashes and data loss
- **Documentation:** Include help text and comments

## Types of Contributions

We welcome various types of contributions:

- **Bug fixes:** Fix issues with the application or scripts
- **Features:** Add new functionality (Bible versions, formatting options, etc.)
- **Documentation:** Improve README, add examples, fix typos
- **Scripts:** Enhance setup/uninstall scripts, add new platform support
- **Testing:** Add test cases, improve CI/CD
- **Performance:** Optimize code, reduce startup time
- **Accessibility:** Improve usability across different environments

## Questions?

If you have questions about contributing, please:
1. Check existing issues and discussions
2. Create a new issue with the "question" label
3. Be specific about what you need help with

Thank you for contributing to Bible Line! 🙏
