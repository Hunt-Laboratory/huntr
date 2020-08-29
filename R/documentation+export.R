
#' @export
generate_documentation = function(path = "huntr/") {
    
    library(data.table)
    
    dupe = function(c, n) {
        return( paste0(rep(c, n), collapse = '') )
    }
    
    introductions = list(
        'PlatformData' = "This document describes a set of datatables that provide a basic, relatively complete dataset of a SWARM test. The idea is that most quantitative and qualitative analysis of user interaction with SWARM and its outcomes is captured with these tables. The data tables are structured in (mostly) normalised relational form, so that it is easy to process with most analytical tools. The only data relating to user interaction with the SWARM platform that is missing is the very finegrained on-platform behaviour by users such as click patterns, including edits made to content (only the final text is captured here).
        
We emphasise that the data collected here is _only_ that data captured by the SWARM platform. There is data from external sources, such as the complete lists of all participants and teams, external ratings for quality of reasoning, and the responses of individual users to the entry and exit surveys, that is often required to perform analyses of interest. Such data that, for the most part, doesn't originate on the platform, can be found in the 'CoreData' folder.

The remainder of this document is a list of data tables, each of which captures key elements of the overall data that is captured when SWARM is used in a test or experiment.

If interacting with this data via the `huntr` R package, you will find the tables described in this document under `repo$<platform_instance>$PlatformData`. If interacting with the data via CSV files, you will presumably have already found them in the relevant folder of the Hunt Lab GitHub repository for our experimental data.

The folder has subfolders for each major component of the data model: authors, chat, comments, media, problems, ratings, reports and responses.

In the subfolders, tables are provided in CSV format, where each row is a record of data, with columns for fields. If a column contains free-form text, then the content is delimited with double-quotes (note that use of double quotes inside a text field needs to be 'escaped' with paired double quotes).  Where the data includes 'rich text' content, there will be a file reference field in the table, which points to a unique filename in a subfolder.  For example, the 'problems' table may contain a field called 'problem_file', where the value in that field may be '319e76a.html', which refers to a file in the html subfolder. The file itself may contain further links to other files (e.g. images), which may be stored in further subfolders, if the HTML file is not self-contained.

Note-1: 'Unique identifier' means unique to an instance of the SWARM platform unless otherwise specified.  The identifiers may be unique more broadly (e.g. uuid) but the minimum level is unique within the instance of SWARM.

Note-2: Timestamps are in UTC with a format of YYYY-MM-DD HH:MM:SS",
        'CoreData' = "This document describes a set of data tables containing key data relating to experiments run on the SWARM platform. In particular, the tables described here supplement the relatively raw platform data (found under PlatformData) with data collected outside the platform, such as from external raters or via participant surveys."
    )
    
    authors = list(
        'PlatformData' = 'Richard de Rozario & Luke Thorburn',
        'CoreData' = 'Luke Thorburn'
    )
    
    schema = fread(paste0(path,'static/variable-descriptions.csv'))
    table_descriptions = fread(paste0(path,'static/table-descriptions.csv'))
    
    folders = unique(schema$folder)
    
    m = ""
    
    for (fldr in folders) {
        
        v = "---\n"
        v = paste0(v, "title: '", fldr, " Dictionary'\n")
        v = paste0(v, "author: '", authors[[fldr]], "'\n")
        v = paste0(v, "date: '", Sys.Date(), "'\n")
        v = paste0(v, "output: rmarkdown::html_vignette\n")
        v = paste0(v, "vignette: >\n")
        v = paste0(v, "    %\\VignetteIndexEntry{",fldr," Dictionary}\n")
        v = paste0(v, "    %\\VignetteEngine{knitr::rmarkdown}\n")
        v = paste0(v, "    \\usepackage[utf8]{inputenc}\n")
        v = paste0(v, "---\n\n")

        v = paste0(v, "## Introduction\n\n")
        v = paste0(v, introductions[[fldr]], '\n\n')
        
        tables = sort(unique(schema[folder == fldr]$table))
        
        for (tbl in tables) {
            
            v = paste0(v, "## Table Name: ", tbl, "\n\n")
            
            v = paste0(v, table_descriptions[folder == fldr & table == tbl]$description[1], '\n\n')
            
            colWidth1 = max(nchar(schema[folder == fldr & table == tbl]$variable))
            colWidth2 = max(nchar(schema[folder == fldr & table == tbl]$description))
            
            v = paste0(v, "ColumnName", dupe(' ', max(colWidth1 - 10, 0) + 6), "Description\n")
            v = paste0(v, dupe('-', colWidth1), dupe(' ', 6), dupe('-', 30), "\n")
            
            m = paste0(m, "#' ", tbl, "\n#'\n")
            m = paste0(m, "#' ", table_descriptions[folder == fldr & table == tbl]$description[1], "\n#'\n#' @format\n #'\\describe{\n")
            
            variables = unique(schema[folder == fldr & table == tbl]$variable)
            
            for (vrbl in variables) {
                description = schema[folder == fldr & table == tbl & variable == vrbl]$description[1]
                v = paste0(v, vrbl, dupe(' ', colWidth1 - nchar(vrbl) + 6), description, "\n")
                m = paste0(m, "#'   \\item{", vrbl, "}{", description, "}\n")
            }
            
            v = paste0(v, "\n\n")
            
            m = paste0(m, "#' }\n#'\n#' @name ", tbl, "\nNULL\n\n")
            
            
        }
        
        cat(v,
            file = paste0(path, 'vignettes/', fldr, '.Rmd'))
    }
    
    cat(m,
        file = paste0(path, 'R/data.R'))
    
    devtools::document("huntr")
    devtools::build_vignettes('huntr')
    
    # Store copy of compiled .html vignettes in experiment-data repository
    
    for (fldr in folders) {
        file.copy(
            from = paste0(path, 'doc/', fldr, '.html'),
            to = paste0('experiment-data/docs/', fldr, '.html'),
        )
    }
    
    message("Reloading package...")
    devtools::load_all("huntr")
    
}


#' @export
export_repo_to_CSV = function(repo, data_version, path = 'experiment-data') {
    
    instances = names(repo)
    
    for (inst in instances) {
        
        dir.create(file.path(path, inst), showWarnings = F)
        dir.create(file.path(path, inst, data_version), showWarnings = F)
        folders = names(repo[[inst]])
        
        for (fldr in folders) {
            
            dir.create(file.path(path, inst, data_version, fldr), showWarnings = F)
            tables = names(repo[[inst]][[fldr]])
            
            for (tbl in tables) {
                
                dir.create(file.path(path, inst, data_version, fldr, tbl), showWarnings = F)
                write.csv(repo[[inst]][[fldr]][[tbl]],
                          file = paste0(file.path(path, inst, data_version, fldr, tbl), '/', tbl, '.csv'),
                          row.names = F, na = "")
                
            }
        }
    }
    
}