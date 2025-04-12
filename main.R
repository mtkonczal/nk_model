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
  Q = 12,
  shock_period = c(5, 6),
  shock_value  = c(1, 1),
  shock_type   = c("A", "A"),
  fed_response = 0
)

# Plot output for key variables: output (y), inflation (p), and real interest rate (r)
plot1 <- plot_nk_output(sim_data = sim_single, vars = c("y", "p", "r", "A"), sims = 1)
print(plot1)

# -----------------------
# Example 2: Multiple Simulations
# -----------------------

# Define simulation configurations with different Fed response setups.
sim_configs <- list(
  list(
    shock_period = c(5, 6),
    shock_value  = c(4, -4),
    shock_type   = c("vt", "vt"),
    fed_response = 0  # Full Fed response
  ),
  list(
    shock_period = c(5, 6),
    shock_value  = c(4, -4),
    shock_type   = c("vt", "vt"),
    fed_response = 1  # Full Fed response
  )
)

# Run multiple simulations using the configurations above.
sim_multiple <- simulate_multiple_nk(sim_configs, Q = 20)

# Plot selected variables ("y", "p", "r") for simulation 1 and 2
plot2 <- plot_nk_output(sim_data = sim_multiple, vars = c("vt", "r", "y", "p"), sims = c(1, 2), scenario_titles = c("Fed Response", "No Fed Response"))
plot2 <- plot2 + labs(title = "Figure 4: Supply Shocks That Reverse Themselves")
print(plot2)


# -----------------------
# Example 3: Multiple Simulations
# -----------------------

# Define simulation configurations with different Fed response setups.
sim_configs <- list(
  list(
    shock_period = c(5,6),
    shock_value  = c(4,-4),
    shock_type   = c("vt", "vt"),
    fed_response = 0  # Full Fed response
  ),
  list(
    shock_period = c(5),
    shock_value  = c(4),
    shock_type   = c("vt"),
    fed_response = 0  # Full Fed response
  )
)

# Run multiple simulations using the configurations above.
sim_multiple <- simulate_multiple_nk(sim_configs, Q = 20)

# Plot selected variables ("y", "p", "r") for simulation 1 and 2
plot2 <- plot_nk_output(sim_data = sim_multiple, vars = c("vt", "r", "y", "p"), sims = c(1, 2), scenario_titles = c("Reversed Shock", "Permanent Shock"))
plot2 <- plot2 + labs(title = "Figure 5: Fed Looks Through Two Shocks: One to the Level, One to the Rate") +
  theme(plot.title.position = "plot")
print(plot2)

