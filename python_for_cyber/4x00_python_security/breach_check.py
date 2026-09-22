#!/usr/bin/env python3
import argparse

def main(): 
    """Parse les arguments et demarre l'outil"""
    parser = argparse.ArgumentParser(description="BreachCheck!")
    parser.add_argument("-f", "--file", required=True, type=str, help="Path to the input file to analyze")
    parser.add_argument("-v","--verbose", action="store_true", help="Enable verbose output")
    parser.add_argument("-o","--output", help="path to the output report file")
    args = parser.parse_args()
    print("BreachCheck v1.0 startup...")

if __name__ == "__main__":
    main()

