#!/usr/bin/env python3
import argparse
import os
import subprocess
import sys


def run_command(command, working_dir):
    result = subprocess.run(command, cwd=working_dir, check=False)
    if result.returncode != 0:
        raise RuntimeError(f"Command failed: {' '.join(command)}")


def parse_args():
    parser = argparse.ArgumentParser(
        description="Run Maven build/test steps for a Java application."
    )
    parser.add_argument(
        "--maven-project",
        required=True,
        help="Path to the Maven project (directory containing pom.xml).",
    )
    parser.add_argument(
        "--skip-tests",
        action="store_true",
        help="Skip unit tests during the Maven build.",
    )
    return parser.parse_args()


def main():
    args = parse_args()
    project_path = os.path.abspath(args.maven_project)

    if not os.path.isdir(project_path):
        raise FileNotFoundError(f"Project path not found: {project_path}")

    pom_path = os.path.join(project_path, "pom.xml")
    if not os.path.isfile(pom_path):
        raise FileNotFoundError(f"pom.xml not found in: {project_path}")

    maven_command = ["mvn", "clean", "package"]
    if args.skip_tests:
        maven_command.append("-DskipTests")

    print(f"Running Maven build in {project_path}...")
    run_command(maven_command, working_dir=project_path)

    print("Build completed successfully.")


if __name__ == "__main__":
    try:
        main()
    except Exception as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        sys.exit(1)
