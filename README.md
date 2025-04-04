# New Keynesian Model Simulation

This project implements a basic 3-equation New Keynesian model in R. It simulates the economy's response to various exogenous shocks using a modular approach. The model includes:

-   **IS Curve:** Determines output based on autonomous spending and lagged real interest rates.
-   **Phillips Curve:** Captures the evolution of inflation based on the output gap and supply shocks.
-   **Monetary Policy Rule:** Adjusts the real interest rate in response to deviations from the inflation target, with a configurable Fed response.

## Features

-   **Single Simulation:**\
    Run one simulation with customizable shocks using `simulate_nk_model()`. You can specify shocks (period, value, and variable) and adjust the Fed's response.

-   **Multiple Simulations:**\
    Compare different scenarios by running several simulations with varying configurations using `simulate_multiple_nk()`.

-   **Plotting:**\
    Visualize key model outputs—such as output, inflation, and real interest rate—with `plot_nk_output()`, which generates faceted ggplot charts.

-   **Documentation Helper:**\
    Use `explain_nk_variables()` to print a summary of the key variables and parameters used in the model.

## Getting Started

### Running the Simulation

The `main.R` file ties together all the necessary functions and demonstrates how to run both single and multiple simulations of the New Keynesian model.

## Example Usage

### Single Simulation Example

This example runs a single simulation where a supply shock (`vt`) of +1 occurs at period 5 and is reversed (-1) at period 6. The Fed responds fully to the inflation gap (i.e., `fed_response = 1`). The output variables — output (`y`), inflation (`p`), and real interest rate (`r`) — are then plotted.

```         
# Run a single simulation with a supply shock (vt) of +1 at period 5 and -1 at period 6, \# with full Fed response.
sim_single <- simulate_nk_model( Q = 50, shock_period = c(5, 6), shock_value = c(1, -1), shock_type = c("vt", "vt"), fed_response = 1 )

# Plot key variables: output (y), inflation (p), and real interest rate (r)
plot1 <- plot_nk_output(sim_data = sim_single, vars = c("y", "p", "r"), sims = 1)
print(plot1)
```

### Multiple Simulation Example

This example runs two simulations with different configurations. The first simulation applies a supply shock and its reversal with full Fed response. The second simulation applies a supply shock with no Fed response. The resulting plots allow you to compare these scenarios side-by-side.

```         
# Define configurations for two simulations:
sim_configs <- list(
  list(
    shock_period = c(5, 6),
    shock_value  = c(1, -1),
    shock_type   = c("vt", "vt"),
    fed_response = 1   # Full Fed response.
  ),
  list(
    shock_period = 5,
    shock_value  = 1,
    shock_type   = "vt",
    fed_response = 0   # No Fed response.
  )
)
```

# Run multiple simulations using the configurations.

```         
sim_multiple <- simulate_multiple_nk(sim_configs, Q = 50)
# Plot key variables ("y", "p", "r") for simulation 1 and simulation 2.
plot2 <- plot_nk_output(sim_data = sim_multiple, vars = c("y", "p", "r"), sims = c(1, 2))
print(plot2)`
```

## Reference for Inspiration

This project is a refactoring of the base code made available at [macrosimulation.org](https://macrosimulation.org/a_new_keynesian_3_equation_model).

## Last Updated

Last updated: April 4, 2025

## Author

By Mike Konczal
