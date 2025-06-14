# src/models/04_fit_policy.R

# Parallel and backend setup 
library(parallel)
library(future)

# detect available cores
n_cores <- parallel::detectCores()  # 8 cores detected

# use all cores for brms/rstan
options(mc.cores = n_cores)

# set up future plan for Windows multisession
plan(multisession, workers = n_cores)

# Try to switch to cmdstanr if installed, otherwise fall back to rstan
if (requireNamespace("cmdstanr", quietly = TRUE)) {
  options(brms.backend = "cmdstanr")
  message("Using cmdstanr backend")
} else {
  options(brms.backend = "rstan")
  message("cmdstanr not found; using rstan backend")
}

# 01 – Libraries ----------------------------------------------------------------
library(here)
library(dplyr)
library(brms)
library(ggplot2)

# 02 – Read plays_dest and prepare data -----------------------------------------
plays_dest <- readRDS(here("data/derived/plays_dest.rds"))

policy_data <- plays_dest |>
  filter(
    !is.na(start_state),
    type.name %in% c("Pass", "Carry", "Dribble", "Shot")
  ) |>
  mutate(
    state_id = start_state,
    response = if_else(type.name == "Shot", 1L, 0L)
  ) |>
  select(state_id, response)

# 03 – Define and fit the hierarchical Bernoulli model --------------------------
formula_pi <- bf(response ~ 1 + (1 | state_id), family = bernoulli())

priors_pi <- c(
  prior(normal(0, 1.5), class = "Intercept"),             # weak prior on logit scale
  prior(exponential(1), class = "sd", group = "state_id") # SD of random intercepts
)

fit_policy <- brm(
  formula = formula_pi,
  data    = policy_data,
  prior   = priors_pi,
  chains  = 4,
  cores   = n_cores,
  iter    = 2000,
  control = list(adapt_delta = 0.95),
  seed    = 123
)

# 04 – Convergence diagnostics -------------------------------------------------
rhats <- rhat(fit_policy)
if (any(rhats > 1.05)) {
  warning("Some parameters have Rhat > 1.05; consider increasing iter or adapt_delta")
} else {
  message("All Rhat < 1.05")
}

# 05 – Extract posterior mean π̂ for each state_id ------------------------------
state_grid <- tibble(state_id = sort(unique(policy_data$state_id)))

post_probs   <- posterior_epred(fit_policy, newdata = state_grid)
policy_means <- colMeans(post_probs)

policy_df <- state_grid |>
  mutate(pi_hat = policy_means)

saveRDS(policy_df, here("data/derived/policy_vec.rds"))
message("Saved policy vector to data/derived/policy_vec.rds")

# 06 Quick posterior check ---------------------------------------------------
ggplot(policy_df, aes(x = pi_hat)) +
  geom_histogram(bins = 20, boundary = 0) +
  labs(
    title = "Posterior Mean of pi(shoot | state)",
    x = expression(hat(pi)[state]),
    y = "Count of States"
  ) +
  theme_minimal()
