################################################################################
# nprobust: R Comparison Script
#
# This script performs the same tests as the Python notebook for comparison.
# Run this script after running the Python notebook to compare results.
#
# Usage: source("comparison_test.R")
################################################################################

library(nprobust)

# Set seed (same as Python)
set.seed(42)

# Generate data (same as Python)
n <- 500
x <- runif(n, 0, 1)
y <- sin(2 * pi * x) + rnorm(n, 0, 0.5)

cat("Generated", n, "observations\n")
cat("x range: [", round(min(x), 4), ",", round(max(x), 4), "]\n")
cat("y range: [", round(min(y), 4), ",", round(max(y), 4), "]\n")
cat("\nFirst 5 observations:\n")
print(data.frame(x = x[1:5], y = y[1:5]))

# Save data
write.csv(data.frame(x = x, y = y), "test_data_r.csv", row.names = FALSE)
cat("\nData saved to test_data_r.csv\n")

################################################################################
# Define evaluation points (same as Python)
################################################################################
eval_points <- c(0.1, 0.25, 0.5, 0.75, 0.9)
eval_kd <- c(0.1, 0.3, 0.5, 0.7, 0.9)

################################################################################
# TEST 1: lprobust with Fixed Bandwidth
################################################################################
cat("\n", rep("=", 70), "\n", sep="")
cat("TEST 1: lprobust(y, x, eval=c(0.1,0.25,0.5,0.75,0.9), h=0.15, p=1)\n")
cat(rep("=", 70), "\n", sep="")

result_lp <- lprobust(y, x, eval = eval_points, h = 0.15, p = 1, kernel = "epa", vce = "nn")
print(result_lp)
cat("\nDetailed Estimates:\n")
print(result_lp$Estimate)

################################################################################
# TEST 2: lprobust with Uniform Kernel
################################################################################
cat("\n", rep("=", 70), "\n", sep="")
cat("TEST 2: lprobust with Uniform kernel\n")
cat(rep("=", 70), "\n", sep="")

result_lp_uni <- lprobust(y, x, eval = eval_points, h = 0.15, p = 1, kernel = "uni", vce = "nn")
print(result_lp_uni)
cat("\nDetailed Estimates:\n")
print(result_lp_uni$Estimate)

################################################################################
# TEST 3: lprobust with Triangular Kernel
################################################################################
cat("\n", rep("=", 70), "\n", sep="")
cat("TEST 3: lprobust with Triangular kernel\n")
cat(rep("=", 70), "\n", sep="")

result_lp_tri <- lprobust(y, x, eval = eval_points, h = 0.15, p = 1, kernel = "tri", vce = "nn")
print(result_lp_tri)
cat("\nDetailed Estimates:\n")
print(result_lp_tri$Estimate)

################################################################################
# TEST 4: lprobust with Higher Polynomial Order (p=2)
################################################################################
cat("\n", rep("=", 70), "\n", sep="")
cat("TEST 4: lprobust with p=2\n")
cat(rep("=", 70), "\n", sep="")

result_lp_p2 <- lprobust(y, x, eval = eval_points, h = 0.15, p = 2, kernel = "epa", vce = "nn")
print(result_lp_p2)
cat("\nDetailed Estimates:\n")
print(result_lp_p2$Estimate)

################################################################################
# TEST 5: lprobust Derivative Estimation (deriv=1)
################################################################################
cat("\n", rep("=", 70), "\n", sep="")
cat("TEST 5: lprobust with deriv=1 (first derivative)\n")
cat(rep("=", 70), "\n", sep="")

result_lp_d1 <- lprobust(y, x, eval = eval_points, h = 0.15, p = 2, deriv = 1, kernel = "epa", vce = "nn")
print(result_lp_d1)
cat("\nDetailed Estimates:\n")
print(result_lp_d1$Estimate)

################################################################################
# TEST 6: lpbwselect - MSE-DPI Bandwidth Selection
################################################################################
cat("\n", rep("=", 70), "\n", sep="")
cat("TEST 6: lpbwselect with MSE-DPI\n")
cat(rep("=", 70), "\n", sep="")

bw_mse <- lpbwselect(y, x, eval = eval_points, bwselect = "mse-dpi", p = 1, kernel = "epa")
print(bw_mse)
cat("\nBandwidths:\n")
print(bw_mse$bws)

################################################################################
# TEST 7: lpbwselect - IMSE-DPI Bandwidth Selection
################################################################################
cat("\n", rep("=", 70), "\n", sep="")
cat("TEST 7: lpbwselect with IMSE-DPI\n")
cat(rep("=", 70), "\n", sep="")

bw_imse <- lpbwselect(y, x, bwselect = "imse-dpi", p = 1, kernel = "epa")
print(bw_imse)
cat("\nBandwidths:\n")
print(bw_imse$bws)

################################################################################
# TEST 8: lprobust with Automatic Bandwidth Selection
################################################################################
cat("\n", rep("=", 70), "\n", sep="")
cat("TEST 8: lprobust with automatic bandwidth (MSE-DPI)\n")
cat(rep("=", 70), "\n", sep="")

result_lp_auto <- lprobust(y, x, eval = eval_points, p = 1, kernel = "epa", bwselect = "mse-dpi")
print(result_lp_auto)
cat("\nDetailed Estimates:\n")
print(result_lp_auto$Estimate)

################################################################################
# TEST 9: kdrobust - Kernel Density Estimation with Fixed Bandwidth
################################################################################
cat("\n", rep("=", 70), "\n", sep="")
cat("TEST 9: kdrobust(x, eval=c(0.1,0.3,0.5,0.7,0.9), h=0.1)\n")
cat(rep("=", 70), "\n", sep="")

result_kd <- kdrobust(x, eval = eval_kd, h = 0.1, kernel = "epa")
print(result_kd)
cat("\nDetailed Estimates:\n")
print(result_kd$Estimate)

################################################################################
# TEST 10: kdrobust with Gaussian Kernel
################################################################################
cat("\n", rep("=", 70), "\n", sep="")
cat("TEST 10: kdrobust with Gaussian kernel\n")
cat(rep("=", 70), "\n", sep="")

result_kd_gau <- kdrobust(x, eval = eval_kd, h = 0.1, kernel = "gau")
print(result_kd_gau)
cat("\nDetailed Estimates:\n")
print(result_kd_gau$Estimate)

################################################################################
# TEST 11: kdbwselect - Bandwidth Selection for KDE
################################################################################
cat("\n", rep("=", 70), "\n", sep="")
cat("TEST 11: kdbwselect with MSE-DPI\n")
cat(rep("=", 70), "\n", sep="")

bw_kd <- kdbwselect(x, eval = eval_kd, bwselect = "mse-dpi", kernel = "epa")
print(bw_kd)
cat("\nBandwidths:\n")
print(bw_kd$bws)

################################################################################
# TEST 12: kdrobust with Automatic Bandwidth
################################################################################
cat("\n", rep("=", 70), "\n", sep="")
cat("TEST 12: kdrobust with automatic bandwidth (MSE-DPI)\n")
cat(rep("=", 70), "\n", sep="")

result_kd_auto <- kdrobust(x, eval = eval_kd, kernel = "epa", bwselect = "mse-dpi")
print(result_kd_auto)
cat("\nDetailed Estimates:\n")
print(result_kd_auto$Estimate)

################################################################################
# TEST 13: lprobust with HC Variance Estimators
################################################################################
cat("\n", rep("=", 70), "\n", sep="")
cat("TEST 13a: lprobust with vce='hc0'\n")
cat(rep("=", 70), "\n", sep="")

result_hc0 <- lprobust(y, x, eval = eval_points, h = 0.15, p = 1, kernel = "epa", vce = "hc0")
print(result_hc0)

cat("\n", rep("=", 70), "\n", sep="")
cat("TEST 13b: lprobust with vce='hc1'\n")
cat(rep("=", 70), "\n", sep="")

result_hc1 <- lprobust(y, x, eval = eval_points, h = 0.15, p = 1, kernel = "epa", vce = "hc1")
print(result_hc1)

cat("\n", rep("=", 70), "\n", sep="")
cat("TEST 13c: lprobust with vce='hc2'\n")
cat(rep("=", 70), "\n", sep="")

result_hc2 <- lprobust(y, x, eval = eval_points, h = 0.15, p = 1, kernel = "epa", vce = "hc2")
print(result_hc2)

################################################################################
# SUMMARY TABLE
################################################################################
cat("\n", rep("=", 80), "\n", sep="")
cat("SUMMARY OF KEY RESULTS FOR PYTHON COMPARISON\n")
cat(rep("=", 80), "\n", sep="")

cat("\n1. lprobust (h=0.15, p=1, epa, vce=nn):\n")
print(round(result_lp$Estimate, 6))

cat("\n2. lpbwselect (mse-dpi):\n")
print(round(bw_mse$bws, 6))

cat("\n3. kdrobust (h=0.1, epa):\n")
print(round(result_kd$Estimate, 6))

cat("\n4. kdbwselect (mse-dpi):\n")
print(round(bw_kd$bws, 6))

################################################################################
# Save R results to CSV for comparison
################################################################################
write.csv(result_lp$Estimate, "r_lprobust_results.csv", row.names = FALSE)
write.csv(bw_mse$bws, "r_lpbwselect_results.csv", row.names = FALSE)
write.csv(result_kd$Estimate, "r_kdrobust_results.csv", row.names = FALSE)
write.csv(bw_kd$bws, "r_kdbwselect_results.csv", row.names = FALSE)

cat("\nResults saved to:\n")
cat("  - r_lprobust_results.csv\n")
cat("  - r_lpbwselect_results.csv\n")
cat("  - r_kdrobust_results.csv\n")
cat("  - r_kdbwselect_results.csv\n")

################################################################################
# Create comparison plots (optional)
################################################################################
if (requireNamespace("ggplot2", quietly = TRUE)) {
  library(ggplot2)

  # Plot 1: Local polynomial regression
  eval_smooth <- seq(0.05, 0.95, length.out = 50)
  result_smooth <- lprobust(y, x, eval = eval_smooth, h = 0.15, p = 1, kernel = "epa")

  df_data <- data.frame(x = x, y = y)
  df_fit <- data.frame(
    x = result_smooth$Estimate[, "eval"],
    y = result_smooth$Estimate[, "tau.us"],
    ymin = result_smooth$Estimate[, "tau.bc"] - 1.96 * result_smooth$Estimate[, "se.rb"],
    ymax = result_smooth$Estimate[, "tau.bc"] + 1.96 * result_smooth$Estimate[, "se.rb"]
  )

  p1 <- ggplot() +
    geom_point(data = df_data, aes(x = x, y = y), alpha = 0.3, size = 1) +
    geom_ribbon(data = df_fit, aes(x = x, ymin = ymin, ymax = ymax), fill = "blue", alpha = 0.2) +
    geom_line(data = df_fit, aes(x = x, y = y), color = "blue", linewidth = 1) +
    stat_function(fun = function(x) sin(2*pi*x), color = "red", linetype = "dashed") +
    labs(title = "Local Polynomial Regression (p=1, h=0.15)", x = "x", y = "y") +
    theme_bw()

  # Plot 2: Kernel density estimation
  eval_kd_smooth <- seq(0.05, 0.95, length.out = 50)
  result_kd_smooth <- kdrobust(x, eval = eval_kd_smooth, h = 0.1, kernel = "epa")

  df_kd <- data.frame(
    x = result_kd_smooth$Estimate[, "eval"],
    y = result_kd_smooth$Estimate[, "tau.us"],
    ymin = result_kd_smooth$Estimate[, "tau.bc"] - 1.96 * result_kd_smooth$Estimate[, "se.rb"],
    ymax = result_kd_smooth$Estimate[, "tau.bc"] + 1.96 * result_kd_smooth$Estimate[, "se.rb"]
  )

  p2 <- ggplot() +
    geom_histogram(data = df_data, aes(x = x, y = after_stat(density)), bins = 30, fill = "gray", alpha = 0.3) +
    geom_ribbon(data = df_kd, aes(x = x, ymin = ymin, ymax = ymax), fill = "blue", alpha = 0.2) +
    geom_line(data = df_kd, aes(x = x, y = y), color = "blue", linewidth = 1) +
    geom_hline(yintercept = 1, color = "red", linetype = "dashed") +
    labs(title = "Kernel Density Estimation (h=0.1)", x = "x", y = "Density") +
    theme_bw()

  # Save plots
  ggsave("nprobust_r_lp.png", p1, width = 7, height = 5, dpi = 150)
  ggsave("nprobust_r_kd.png", p2, width = 7, height = 5, dpi = 150)

  cat("\nPlots saved to:\n")
  cat("  - nprobust_r_lp.png\n")
  cat("  - nprobust_r_kd.png\n")
}

cat("\n", rep("=", 80), "\n", sep="")
cat("R COMPARISON TESTS COMPLETE\n")
cat(rep("=", 80), "\n", sep="")
