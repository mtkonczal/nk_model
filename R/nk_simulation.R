# nk_model.R
# New Keynesian Model Simulation, Plotting, and Documentation
# ------------------------------------------------------------

library(tidyverse)


# Function to simulate one run of the New Keynesian model with general shocks.
simulate_nk_model <- function(Q = 50, 
                              shock_period = numeric(0),
                              shock_value = numeric(0),
                              shock_type = character(0),
                              fed_response = 1,
                              a1 = 0.3, a2 = 0.7, b = 1,
                              A_val = 10, pt_val = 2, ye_val = 2) {
  
  # Validate that if shocks are provided they have the same length.
  if(!(length(shock_period) == length(shock_value) && length(shock_value) == length(shock_type))){
    stop("shock_period, shock_value, and shock_type must have the same length.")
  }
  
  # Calculate the default policy parameter for the monetary rule.
  a3_default <- (a1 * (1/(b * a2) + a2))^(-1)
  
  # Create a tibble with baseline values for each period.
  # A, pt, and ye are constant over time unless shocked; vt defaults to zero.
  df <- tibble(
    period = 1:Q,
    A = A_val,
    pt = pt_val,
    ye = ye_val,
    vt = 0,       # Baseline: no supply shock.
    y = NA_real_,
    p = NA_real_,
    rs = NA_real_,
    r = NA_real_
  )
  
  # Apply shocks: each shock specification modifies the chosen variable at the specified period.
  for(i in seq_along(shock_period)) {
    t_idx <- shock_period[i]
    if(t_idx >= 1 && t_idx <= Q) {
      var_name <- shock_type[i]
      if(!(var_name %in% c("A", "pt", "ye", "vt"))) {
        stop("shock_type must be one of 'A', 'pt', 'ye', or 'vt'")
      }
      # Add the shock value to the baseline value at the specified period.
      df[[var_name]][t_idx] <- df[[var_name]][t_idx] + shock_value[i]
    }
  }
  
  # Set initial conditions (period 1, at equilibrium).
  df <- df %>%
    mutate(
      y = replace(y, 1, ye[1]),
      p = replace(p, 1, pt[1]),
      rs = replace(rs, 1, (A[1] - ye[1]) / a1),
      r = replace(r, 1, (A[1] - ye[1]) / a1)
    )
  
  # Run the simulation for periods 2 to Q.
  for(t in 2:Q) {
    # IS curve: output determined by autonomous spending and lagged real interest rate.
    df$y[t] <- df$A[t] - a1 * df$r[t - 1]
    # Phillips curve: inflation adjusts based on the output gap and any supply shock.
    df$p[t] <- df$p[t - 1] + a2 * (df$y[t] - df$ye[t]) + df$vt[t]
    # Stabilising (neutral) interest rate.
    df$rs[t] <- (df$A[t] - df$ye[t]) / a1
    # Monetary policy rule: the Fed adjusts the real rate in response to the inflation gap.
    # The strength of the Fed's reaction is set by fed_response (1 = full response, 0 = no response).
    df$r[t] <- df$rs[t] + fed_response * a3_default * (df$p[t] - df$pt[t])
  }
  
  # Ensure a simulation column exists.
  df <- df %>% mutate(simulation = 1)
  # Make culminative inflation and output
  df <- compute_culminations(df)
  
  
  df
}

# Function to run multiple simulations. Each simulation is defined by its own shock specification.
simulate_multiple_nk <- function(simulations,
                                 Q = 50,
                                 a1 = 0.3, a2 = 0.7, b = 1,
                                 A_val = 10, pt_val = 2, ye_val = 2) {
  map_dfr(seq_along(simulations), function(i) {
    sim_conf <- simulations[[i]]
    shock_period <- if (!is.null(sim_conf$shock_period)) sim_conf$shock_period else numeric(0)
    shock_value  <- if (!is.null(sim_conf$shock_value))  sim_conf$shock_value  else numeric(0)
    shock_type   <- if (!is.null(sim_conf$shock_type))   sim_conf$shock_type   else character(0)
    fed_response <- if (!is.null(sim_conf$fed_response)) sim_conf$fed_response else 1
    
    df_sim <- simulate_nk_model(Q = Q,
                                shock_period = shock_period,
                                shock_value = shock_value,
                                shock_type = shock_type,
                                fed_response = fed_response,
                                a1 = a1, a2 = a2, b = b,
                                A_val = A_val, pt_val = pt_val, ye_val = ye_val)
    df_sim <- df_sim %>% mutate(simulation = i)
    df_sim
  })
}


compute_culminations <- function(sim_df) {
  sim_df %>%
    mutate(
      culminate_inflation = (cumprod((p / 100) + 1)),
      culminate_growth = (cumprod((y / 100) + 1)),
    ) %>%
    ungroup()
}