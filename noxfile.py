import nox


@nox.session(python=["3.8", "3.9", "3.10", "3.11", "3.12", "3.13", "pypy3.8", "pypy3.9", "pypy3.10", "pypy3.11"])
def tests(session):
    session.install("pytest", "testfixtures", "pytest-xdist", "pip")
    session.run("uv", "pip", "install", ".")
    session.run("pytest", "-n", "4", *session.posargs)
