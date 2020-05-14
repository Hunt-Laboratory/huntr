# huntr

This repository is an R package that contains:

- tidy data from Hunt Lab experiments
- documentation for the included datasets
- functions and scripts used to maintain the more comprehensive [experiment-data](https://github.com/Hunt-Laboratory/experiment-data) repository

The huntr package is the quickest and easiest way to get most experiment data into R.

## How to use this package

To install the huntr package, use the following line of code in R (you will need to have the `devtools` package already installed).

```R
devtools::install_github("Hunt-Laboratory/huntr")
```

Tidy data from each experiment is stored in a list called `repo`. The `repo` list follows the following heirarchical structure.

```
repo
   <experiment_label>
      <folder_name>
         <table_name>
```

The easiest way to extract a particular table from the `repo` list is to use RStudio's suggested autocomplete functionality, as illustrated in the following GIF.

![Example for repo object](/static/repo-example.gif)

Each table is of type `data.table`, a high-performance alternative to R's inbuilt `data.frame` type. If you are not familiar with `data.table`, then you can either read up on it [here](https://cloud.r-project.org/web/packages/data.table/vignettes/datatable-intro.html), or coerce the tables into type `data.frame` using the function `as.data.frame()`.

Documentation for all of the datasets is included in the package. You can view a data dictionary for a given table by using R's inbuilt help system, as shown below.

![Example for accessing data dictionaries](/static/help-example.gif)

Alternatively, you can also open a vignette that contains data dictionaries for every table within a given folder. For example, to open the documentation for all tables within the `PlatformData` folder, you would use the following line of code.

```R
vignette("PlatformData", package = "huntr")
```

## Getting help

If you need help with any aspect of this package, or want to suggest an improvement, please either open an issue on this GitHub repository, or send an email to Luke Thorburn at luke.thorburn@unimelb.edu.au.

