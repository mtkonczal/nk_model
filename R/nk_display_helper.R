# Returns a named vector of colors for New Keynesian model variables.
get_nk_colors <- function() {
  colors <- c(
    "y"  = "#1f78b4",   # Output: cool blue
    "p"  = "#33a02c",   # Inflation: cool green
    "r"  = "#e31a1c",   # Real Interest Rate: cool red
    "vt" = "#6a3d9a",   # Supply Shock: cool purple
    "A"  = "#a6cee3",   # Autonomous Spending: light blue
    "pt" = "#b2df8a",   # Inflation Target: light green
    "ye" = "#fb9a99",   # Potential Output: light red/pink
    "rs" = "#cab2d6"    # Stabilising Interest Rate: lavender
  )
  colors
}

# Returns a named vector of descriptive labels for model variables.
get_nk_variable_labels <- function() {
  labels <- c(
    "y"  = "Output",
    "p"  = "Inflation",
    "r"  = "Real Interest Rate",
    "vt" = "Supply Shock",
    "A"  = "Autonomous Spending",
    "pt" = "Inflation Target",
    "ye" = "Potential Output",
    "rs" = "Stabilising Interest Rate"
  )
  labels
}

# Updated plotting function that facets by simulation and variable.
# It now uses get_nk_colors() for colors and get_nk_variable_labels() for facet labels.
plot_nk_output <- function(sim_data, vars, sims, scenario_titles = NULL) {
  # Filter the data to include only the specified simulations.
  df <- sim_data %>% filter(simulation %in% sims)
  
  # Pivot the selected variables into long format.
  df_long <- df %>% 
    pivot_longer(
      cols = all_of(vars), 
      names_to = "variable", 
      values_to = "value"
    ) %>% 
    mutate(
      simulation = factor(simulation),
      variable = factor(variable, levels = vars)
    )
  
  # Get descriptive labels from helper function.
  variable_labels <- get_nk_variable_labels()
  
  # Create simulation labels if scenario_titles are provided.
  if (!is.null(scenario_titles)) {
    sim_levels <- levels(df_long$simulation)
    if (length(scenario_titles) != length(sim_levels)) {
      warning("Length of scenario_titles does not match number of simulations. Using default simulation labels.")
      sim_labels <- waiver()
    } else {
      sim_labels <- setNames(scenario_titles, sim_levels)
    }
  } else {
    sim_labels <- waiver()
  }
  
  # Build the ggplot.
  p <- ggplot(df_long, aes(x = period, y = value, color = variable)) +
    geom_line(size = 1) +
    facet_grid(variable ~ simulation, scales = "free_y",
               labeller = labeller(variable = variable_labels, simulation = sim_labels)) +
    scale_color_manual(values = get_nk_colors()) +
    labs(title = "New Keynesian Model Simulation",
         x = "Period", y = "Value") +
    theme_minimal() +
    theme(
      strip.text.y = element_text(angle = 0, size = 16),
      strip.text.x = element_text(size = 16),
      panel.border = element_rect(color = "black", fill = NA, size = 1),
      panel.spacing = unit(0.5, "lines")
    ) +
    theme(legend.position = "none")
  
  p
}
