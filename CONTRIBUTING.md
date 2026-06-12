# Contributing to Jupyter MCP Skill

Thank you for your interest in contributing! This skill aims to provide comprehensive Jupyter notebook interaction for AI agents.

## How to Contribute

### Reporting Bugs

**Before submitting a bug report:**
- Check existing [GitHub Issues](https://github.com/tientruongminh/jupyter-mcp-skill/issues)
- Test with the latest version of jupyter-mcp-server
- Verify your Jupyter server is running correctly

**When reporting:**
```markdown
**Environment:**
- OpenClaw version: 
- Jupyter version: 
- jupyter-mcp-server version: 
- OS: 

**What happened:**
(Describe the issue)

**Expected behavior:**
(What should happen)

**Steps to reproduce:**
1. 
2. 
3. 

**Logs/Screenshots:**
(If applicable)
```

### Suggesting Features

Open an issue with:
- Clear use case description
- How it improves notebook interaction
- Examples of expected behavior
- Comparison with existing tools (if any)

### Pull Requests

**Before starting:**
1. Open an issue to discuss the change
2. Fork the repository
3. Create a feature branch: `git checkout -b feature/your-feature`

**Code guidelines:**
- Follow existing documentation style
- Add examples for new features
- Update CHANGELOG.md
- Update SKILL.md with new tools
- Test with real Jupyter notebooks

**PR checklist:**
- [ ] Documentation updated (SKILL.md, references/)
- [ ] Examples added (references/examples.md)
- [ ] CHANGELOG.md updated
- [ ] No sensitive data (tokens, keys) in commits
- [ ] Tested with Cursor/Codex/Claude Desktop (if applicable)

### Documentation Improvements

We especially welcome:
- Clarifications of existing docs
- More usage examples
- Agent prompt templates
- Troubleshooting tips
- Video/GIF demos

### Testing

Help us test by:
- Using the skill with different agents (Codex, Claude Code, etc.)
- Testing with various notebook types (data science, ML, reporting)
- Finding edge cases and reporting them
- Verifying examples work correctly

## Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Help others learn and grow
- Assume good intentions

## Questions?

- Open a [GitHub Discussion](https://github.com/tientruongminh/jupyter-mcp-skill/discussions)
- Check [OpenClaw Discord](https://discord.com/invite/clawd)
- Review [MCP Documentation](https://modelcontextprotocol.io/)

## Development Setup

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/jupyter-mcp-skill.git
cd jupyter-mcp-skill

# Install test dependencies
pip install jupyterlab==4.4.1 jupyter-collaboration==4.0.2 jupyter-mcp-tools>=0.1.4

# Start Jupyter for testing
jupyter lab --port 8888 --IdentityProvider.token test123

# Test connection
JUPYTER_URL=http://localhost:8888 JUPYTER_TOKEN=test123 bash scripts/test-connection.sh
```

## Release Process

(For maintainers)

1. Update CHANGELOG.md with new version
2. Update version in SKILL.md footer
3. Commit changes: `git commit -m "Release v1.x.x"`
4. Tag release: `git tag v1.x.x`
5. Push: `git push origin main --tags`
6. Create GitHub release with changelog notes
7. Publish to ClawHub (if applicable)

---

Thank you for contributing! 🚀
