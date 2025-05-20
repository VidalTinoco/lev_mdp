# lev_mdp

**Markov Decision Processes & Bayesian Modelling of Bayer Leverkusen's 2023-24 Season**

This project adapts the Markov-based framework from *Van Roy et al. (2023)* to analyze strategic behaviors of Bayer Leverkusen under Xabi Alonso. Using StatsBomb Open Data (event data + 360 frames), we model offensive and defensive sequences through MDPs and Bayesian inference, aiming to evaluate spatial decision-making and tactical effectiveness.

## 🔧 Tools & Dependencies

The project is implemented in **R** using:

- [`tidyverse`](https://www.tidyverse.org/) – data wrangling & visualization
- [`StatsBombR`](https://github.com/statsbomb/StatsBombR) – loading and cleaning StatsBomb JSON data
- [`cmdstanr`](https://mc-stan.org/cmdstanr/) or [`brms`](https://paul-buerkner.github.io/brms/) – Bayesian models
- [`xgboost`](https://xgboost.readthedocs.io/) – auxiliary classification tasks
- [`Matrix`](https://cran.r-project.org/web/packages/Matrix/) – sparse matrix handling
- [`SBpitch`](https://github.com/FCrSTATS/SBpitch) – pitch plotting

## 📁 Project Structure

- `data/` — raw and processed StatsBomb data
- `scripts/` — cleaning, MDP estimation, Bayesian models
- `models/` — saved MDP transition matrices and Stan models
- `outputs/` — reports, figures, and dashboards
- `docs/` — references and research notes

## 📈 Objective

To enable tactical reasoning under uncertainty by learning spatial strategies and transition probabilities directly from event data. Our final aim is to:

- Model offensive strategies as Markov policies
- Evaluate defensive disruptions using probabilistic model checking
- Quantify decision trade-offs (e.g. pass vs. shot) in context

## 📚 Reference

> Van Roy, M., Robberechts, P., Yang, W.-C., De Raedt, L., & Davis, J. (2023). *A Markov Framework for Learning and Reasoning About Strategies in Professional Soccer*. Journal of Artificial Intelligence Research, 77, 517–562.

