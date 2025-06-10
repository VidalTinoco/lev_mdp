# utils.R

## Purpose
Provide general-purpose data‐cleaning utilities for the StatsBomb pipeline:
1. **`all_na(df)`**: Remove any column in `df` that consists entirely of `NA`.
2. **`scale_if_needed(df)`**: Detect if `x` or `y` coordinates exceed the normalized range [0,1] and, if so, rescale them from [0,100] down to [0,1].

These functions are used by `01_data_loading_cleaning.R` to produce a streamlined, normalized dataset.

## Dependencies
- **R packages**:
  - `dplyr`    (for column selection and mutation)
  - `stringr`  (if any string utilities are needed)

## Inputs
- **`all_na(df)`**:
  - `df` (data frame): Any R data frame potentially containing columns with only `NA`.
- **`scale_if_needed(df)`**:
  - `df` (data frame): Must contain numeric columns `x` and `y` if rescaling is to be applied.

## Outputs
- **`all_na(df)`** returns:
  - A data frame identical to `df` but with all-`NA` columns dropped.
- **`scale_if_needed(df)`** returns:
  - A data frame where:
    - If `max(x)` or `max(y)` > 1, then `x` and `y` are divided by 100.
    - Otherwise, the data frame is returned unchanged.
