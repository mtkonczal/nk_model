# main.R
# Main driver script for the New Keynesian Model Simulation Project

# Clear the workspace
rm(list = ls())

# Source the necessary function files
source("R/nk_simulation.R")  # Contains simulate_nk_model() and simulate_multiple_nk()
source("R/nk_display_helper.R")
# Print explanations of model variables
explain_nk_variables()

# -----------------------
# Example 1: Single Simulation
# -----------------------

# Run a single simulation with a supply shock (vt) of +1 at period 5 and a reversal (-1) at period 6,
# with full Fed response.
sim_single <- simulate_nk_model(
  Q = 50,
  shock_period = c(5, 6),
  shock_value  = c(1, -1),
  shock_type   = c("vt", "vt"),
  fed_response = 1
)

# Plot output for key variables: output (y), inflation (p), and real interest rate (r)
plot1 <- plot_nk_output(sim_data = sim_single, vars = c("y", "p", "r"), sims = 1)
print(plot1)

# -----------------------
# Example 2: Multiple Simulations
# -----------------------

# Define simulation configurations with different Fed response setups.
sim_configs <- list(
  list(
    shock_period = c(5, 6),
    shock_value  = c(3, -3),
    shock_type   = c("vt", "vt"),
    fed_response = 0  # Full Fed response
  ),
  list(
    shock_period = 5,
    shock_value  = 1,
    shock_type   = "vt",
    fed_response = 0  # No Fed response
  )
)

# Run multiple simulations using the configurations above.
sim_multiple <- simulate_multiple_nk(sim_configs, Q = 12)

# Plot selected variables ("y", "p", "r") for simulation 1 and 2
plot2 <- plot_nk_output(sim_data = sim_multiple, vars = c("vt", "y", "p", "r"), sims = c(1, 2), scenario_titles = c("Test 1", "A second"))
print(plot2)
