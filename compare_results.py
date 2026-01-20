"""
Compare Python and R nprobust results side by side.

Run this script after:
1. Running the Python notebook (comparison_test.ipynb)
2. Running the R script (comparison_test.R)

Usage: python compare_results.py
"""

import pandas as pd
import numpy as np
import os

def compare_files(python_file, r_file, name):
    """Compare Python and R result files."""
    print(f"\n{'='*70}")
    print(f"COMPARISON: {name}")
    print('='*70)

    if not os.path.exists(python_file):
        print(f"  Python file not found: {python_file}")
        print("  Run the Python notebook first.")
        return

    if not os.path.exists(r_file):
        print(f"  R file not found: {r_file}")
        print("  Run the R script first.")
        return

    # Load files
    df_py = pd.read_csv(python_file)
    df_r = pd.read_csv(r_file)

    print("\n--- Python Results ---")
    print(df_py.round(6).to_string(index=False))

    print("\n--- R Results ---")
    print(df_r.round(6).to_string(index=False))

    # Compute differences
    print("\n--- Absolute Differences ---")

    # Ensure same columns
    common_cols = list(set(df_py.columns) & set(df_r.columns))

    if len(df_py) == len(df_r):
        diff = np.abs(df_py[common_cols].values - df_r[common_cols].values)
        df_diff = pd.DataFrame(diff, columns=common_cols)
        print(df_diff.round(6).to_string(index=False))

        print("\n--- Summary Statistics ---")
        print(f"  Max absolute difference: {diff.max():.6f}")
        print(f"  Mean absolute difference: {diff.mean():.6f}")

        # Relative differences (avoiding division by zero)
        denom = np.abs(df_r[common_cols].values)
        denom[denom < 1e-10] = 1e-10
        rel_diff = diff / denom
        print(f"  Max relative difference: {rel_diff.max():.4%}")
        print(f"  Mean relative difference: {rel_diff.mean():.4%}")

        if diff.max() < 0.01:
            print("\n  [PASS] Results are very similar (max diff < 0.01)")
        elif diff.max() < 0.1:
            print("\n  [OK] Results are reasonably similar (max diff < 0.1)")
        else:
            print("\n  [WARN] Results show notable differences")
    else:
        print(f"  Different number of rows: Python={len(df_py)}, R={len(df_r)}")


def main():
    print("="*70)
    print("nprobust: Python vs R Comparison Report")
    print("="*70)

    # Compare lprobust results
    compare_files(
        "python_lprobust_results.csv",
        "r_lprobust_results.csv",
        "lprobust (h=0.15, p=1, epa)"
    )

    # Compare lpbwselect results
    compare_files(
        "python_lpbwselect_results.csv",
        "r_lpbwselect_results.csv",
        "lpbwselect (MSE-DPI)"
    )

    # Compare kdrobust results
    compare_files(
        "python_kdrobust_results.csv",
        "r_kdrobust_results.csv",
        "kdrobust (h=0.1, epa)"
    )

    # Compare kdbwselect results
    compare_files(
        "python_kdbwselect_results.csv",
        "r_kdbwselect_results.csv",
        "kdbwselect (MSE-DPI)"
    )

    # Compare test data
    print(f"\n{'='*70}")
    print("DATA COMPARISON")
    print('='*70)

    if os.path.exists("test_data_python.csv") and os.path.exists("test_data_r.csv"):
        df_py_data = pd.read_csv("test_data_python.csv")
        df_r_data = pd.read_csv("test_data_r.csv")

        print(f"\nPython data shape: {df_py_data.shape}")
        print(f"R data shape: {df_r_data.shape}")

        # Check if data matches
        if len(df_py_data) == len(df_r_data):
            x_diff = np.abs(df_py_data['x'].values - df_r_data['x'].values).max()
            y_diff = np.abs(df_py_data['y'].values - df_r_data['y'].values).max()

            print(f"\nMax difference in x: {x_diff:.10f}")
            print(f"Max difference in y: {y_diff:.10f}")

            if x_diff < 1e-6 and y_diff < 1e-6:
                print("\n[PASS] Data is identical (using same random seed)")
            else:
                print("\n[WARN] Data differs - random number generation may differ between Python and R")
                print("       This is expected as numpy and R use different RNG algorithms.")
    else:
        print("\nData files not found. Run both Python notebook and R script first.")

    print(f"\n{'='*70}")
    print("COMPARISON COMPLETE")
    print('='*70)


if __name__ == "__main__":
    main()
