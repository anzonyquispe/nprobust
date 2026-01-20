# R script to generate reference values for comparison with Python implementation
# Run this script in R to create reference CSV files

library(nprobust)

# Set seed and generate data (same as Python test)
set.seed(42)
n <- 200
x <- runif(n, 0, 1)
y <- sin(2 * pi * x) + rnorm(n, 0, 0.5)

# Save the data for reference
write.csv(data.frame(x=x, y=y), "test_data.csv", row.names=FALSE)

# Test 1: lprobust with fixed bandwidth
cat("Running lprobust with h=0.2, p=1, kernel=epa...\n")
result_lp <- lprobust(y, x, h=0.2, p=1, kernel="epa", neval=10)
write.csv(result_lp$Estimate, "r_lprobust_h02_p1_epa.csv", row.names=FALSE)
cat("Saved to r_lprobust_h02_p1_epa.csv\n")

# Test 2: lprobust with different kernel
cat("\nRunning lprobust with h=0.2, kernel=uni...\n")
result_lp_uni <- lprobust(y, x, h=0.2, kernel="uni", neval=10)
write.csv(result_lp_uni$Estimate, "r_lprobust_h02_uni.csv", row.names=FALSE)

# Test 3: lprobust with derivative
cat("\nRunning lprobust with deriv=1...\n")
result_lp_d1 <- lprobust(y, x, h=0.2, p=2, deriv=1, neval=10)
write.csv(result_lp_d1$Estimate, "r_lprobust_deriv1.csv", row.names=FALSE)

# Test 4: lpbwselect MSE-DPI
cat("\nRunning lpbwselect mse-dpi...\n")
result_bw <- lpbwselect(y, x, bwselect="mse-dpi", neval=5)
write.csv(result_bw$bws, "r_lpbwselect_msedpi.csv", row.names=FALSE)

# Test 5: lpbwselect IMSE-DPI
cat("\nRunning lpbwselect imse-dpi...\n")
result_bw_imse <- lpbwselect(y, x, bwselect="imse-dpi")
write.csv(result_bw_imse$bws, "r_lpbwselect_imsedpi.csv", row.names=FALSE)

# Test 6: kdrobust
cat("\nRunning kdrobust h=0.2...\n")
result_kd <- kdrobust(x, h=0.2, neval=10)
write.csv(result_kd$Estimate, "r_kdrobust_h02.csv", row.names=FALSE)

# Test 7: kdrobust with different kernel
cat("\nRunning kdrobust h=0.2, kernel=gau...\n")
result_kd_gau <- kdrobust(x, h=0.2, kernel="gau", neval=10)
write.csv(result_kd_gau$Estimate, "r_kdrobust_h02_gau.csv", row.names=FALSE)

# Test 8: kdbwselect
cat("\nRunning kdbwselect mse-dpi...\n")
result_kdbw <- kdbwselect(x, bwselect="mse-dpi", neval=5)
write.csv(result_kdbw$bws, "r_kdbwselect_msedpi.csv", row.names=FALSE)

# Test 9: kdbwselect IMSE
cat("\nRunning kdbwselect imse-dpi...\n")
result_kdbw_imse <- kdbwselect(x, bwselect="imse-dpi")
write.csv(result_kdbw_imse$bws, "r_kdbwselect_imsedpi.csv", row.names=FALSE)

cat("\n\nAll reference files created successfully!\n")
cat("Files created:\n")
cat("  - test_data.csv\n")
cat("  - r_lprobust_h02_p1_epa.csv\n")
cat("  - r_lprobust_h02_uni.csv\n")
cat("  - r_lprobust_deriv1.csv\n")
cat("  - r_lpbwselect_msedpi.csv\n")
cat("  - r_lpbwselect_imsedpi.csv\n")
cat("  - r_kdrobust_h02.csv\n")
cat("  - r_kdrobust_h02_gau.csv\n")
cat("  - r_kdbwselect_msedpi.csv\n")
cat("  - r_kdbwselect_imsedpi.csv\n")

# Print summary of results for quick comparison
cat("\n\n========== REFERENCE VALUES SUMMARY ==========\n")

cat("\n--- lprobust (h=0.2, p=1, epa) first 5 rows ---\n")
print(head(result_lp$Estimate, 5))

cat("\n--- lpbwselect (mse-dpi) ---\n")
print(result_bw$bws)

cat("\n--- kdrobust (h=0.2) first 5 rows ---\n")
print(head(result_kd$Estimate, 5))

cat("\n--- kdbwselect (mse-dpi) ---\n")
print(result_kdbw$bws)
