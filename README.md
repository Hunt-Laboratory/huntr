# huntr

This repository is an R package that contains:

- tidy data from Hunt Lab experiments
- documentation for the included datasets
- functions and scripts used to maintain the more comprehensive [experiment-data](https://github.com/Hunt-Laboratory/experiment-data) repository

The huntr package is the quickest and easiest way to get most experiment data into R.

## How to use this package

To install the huntr package, use the following line of code in R.

```R
devtools::install_github("Hunt-Laboratory/huntr")
```

Tidy data from each experiment is stored in a list called `repo`. The `repo` list follows the following heirarchical structure.

- repo
	- <experiment_label>
		- <folder_name>
			- <table_name>

The easiest way to extract a particular table from the `repo` object is to use RStudio's suggested autocomplete functionality, as illustrated in the following GIF.

![Example for repo object](/static/repo-example.gif)