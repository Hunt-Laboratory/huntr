
redact_column = function(column, patterns, instance_name, fldr, tbl, clm, redaction_log) {
    
    lowercase_column = tolower(column)
    
    for (k in 1:length(column)) {
        
        detected = stringr::str_detect(lowercase_column[k], patterns)

        if (sum(detected, na.rm = T) > 0) {
            
            message(paste0('The following patterns were detected:'))
            print(patterns[detected])
            message(paste0('...in the following content:'))
            print(column[k])
            clipr::write_clip(column[k])
            message('Enter redacted text below, or type \'none\' if there is no PII.')
            redactor_input = readline()
            if (redactor_input != 'none') {
                
                new_redaction = data.frame(
                    instance = instance_name,
                    folder = fldr,
                    table = tbl,
                    column = clm,
                    row = k,
                    GUID = NA,
                    replacement = redactor_input,
                    replacement_markdown = NA,
                    replacement_html = NA
                )
                redaction_log = rbind(redaction_log, new_redaction)
                
                column[k] = redactor_input
            }
        }
    }
    
    return(list(
        column,
        redaction_log
    ))
}

redact_file = function(path, instance_name, root, file_name, row_number, patterns, redaction_log) {
    
    file_name = substr(file_name, 1, 36)
    
    file_path = file.path(path, instance_name, 'noPII/PlatformData', paste0(root, 's'), 'text', paste0(file_name,'.md'))
    file_text = readtext::readtext(file_path, verbosity = 0)
    file_text = tolower(file_text)
    
    detected = stringr::str_detect(file_text, patterns)
    
    if (sum(detected) > 0) {
        
        message(paste0('The following patterns were detected in ', root, 's/', file_name, ':'))
        print(patterns[detected])
        clipr::write_clip(file_name)
        message('Please manually redact both the HTML and markdown files, then type \'DONE\' when you\'re done')
        redactor_input = readline()
        
        if (redactor_input != 'none') {
            
            file_path = file.path(path, instance_name, 'noPII/PlatformData', paste0(root, 's'), 'text', paste0(file_name,'.md'))
            file_md = paste(readLines(file_path), collapse="\n")
            file_path = file.path(path, instance_name, 'noPII/PlatformData', paste0(root, 's'), 'html', paste0(file_name,'.html'))
            file_html = paste(readLines(file_path), collapse="\n")
            
            new_redaction = data.frame(
                instance = instance_name,
                folder = 'PlatformData',
                table = paste0(root, 's'),
                column = NA,
                row = row_number,
                GUID = file_name,
                replacement = NA,
                replacement_markdown = file_md,
                replacement_html = file_html
            )
            redaction_log = rbind(redaction_log, new_redaction)
            
        }
    }
    
    return(redaction_log)
}

redact_files = function(repo, path, instance_name, root, patterns, redaction_log) {
    
    file_names = repo[[instance_name]][['PlatformData']][[paste0(root,'s')]][[paste0(root,'_text')]]
    
    for (k in 1:length(file_names)) {
        redaction_log = redact_file(path, instance_name, root, file_names[k], k, patterns, redaction_log)
    }
    
    return(redaction_log)
}

wait_for_done = function() {
    user_input = ""
    while (user_input != "DONE") {
        user_input = readline()
    }
}

#' @export
run_PII_redaction_session = function(repo, patterns, instances, path = 'experiment-data') {
    
    message('First step: for each of the instances you wish to redact,\ncopy their data from the \'tidy\' folder to the \'noPII\' folder.\nType DONE once you have done this.')
    
    wait_for_done()
    
    noPII = repo
    
    user_input_cols = c(
        "interestsOtherInput",
        "priOtherInput",
        "multidisciplinaryExperienceInput",
        "describeAnalyticalExperience",
        "bestThing",
        "worstThing",
        "pfComments",
        "mostValuable",
        "lkSuggestions",
        "ratingToolWhyNot",
        "featureRequests",
        "externalToolsComments",
        "bestQuestionNotAsked",
        "testimonial",
        "otherComments",
        "chat_text",
        "response_title"
    )
    
    
    
    for (instance_name in instances) {
        
        # INITIALISE RECORD OF INTERACTIVE REDACTION SESSION
        redaction_log = data.frame(
            instance = character(),
            folder = character(),
            table = character(),
            column = character(),
            row = integer(),
            GUID = character(),
            replacement = character(),
            replacement_markdown = character(),
            replacement_html = character()
        )
        
        # 1. REDACT COLUMNS FROM TABLES STORED IN REPO LIST
        
        fldrs = names(noPII[[instance_name]])
        for (fldr in fldrs) {
            
            tbls = names(noPII[[instance_name]][[fldr]])
            for (tbl in tbls) {
                
                clms = names(noPII[[instance_name]][[fldr]][[tbl]])
                for (clm in clms) {
                    
                    if (clm %in% user_input_cols) {
                        column = copy(noPII[[instance_name]][[fldr]][[tbl]][[clm]])
                        redaction = redact_column(
                            column,
                            patterns,
                            instance_name,
                            fldr,
                            tbl,
                            clm,
                            redaction_log
                        )
                        noPII[[instance_name]][[fldr]][[tbl]][[clm]] = redaction[[1]]
                        redaction_log = redaction[[2]]
                    }
                    
                }
            }
        }
        
        # 2. REDACT MARKDOWN AND HTML FILES.
        
        dirs = c('comment', 'response')
        for (dir in dirs) {
            redaction_log = redact_files(repo, path, instance_name, dir, patterns, redaction_log)
        }
        
        
        # SAVE REDACTION RECORD
        write.csv(redaction_log,
                  file = file.path(path, instance_name, 'redaction_log.csv'),
                  row.names = F,
                  na = "")
        
    }
    
    return(noPII)
    
}

#' @export
apply_previous_redactions = function(repo, instances, path = 'experiment-data') {
    
    for (instance_name in instances) {
        
        redactions = fread(file.path(path, instance_name, 'redaction_log.csv'))
        redactions[redactions == ""] = NA
        
        for (k in 1:nrow(redactions)) {
            
            fldr        = redactions$folder[k]
            tbl         = redactions$table[k]
            
            if (!is.na(redactions$column[k])) {
                # REDACT CELL IN A TABLE
                
                clm         = redactions$column[k]
                rw          = redactions$row[k]
                replacement = redactions$replacement[k]
                
                set(
                    x = repo[[instance_name]][[fldr]][[tbl]],
                    i = rw,
                    j = clm,
                    value = replacement
                )
                
            } else {
                # REDACT FILE(S)
                
                GUID = redactions$GUID[k]
                
                file_path = file.path(path, instance_name, 'tidy', fldr, tbl, 'text', paste0(GUID, '.md'))
                cat(
                    redactions$replacement_markdown[k],
                    file = file_path
                )
                
                file_path = file.path(path, instance_name, 'tidy', fldr, tbl, 'html', paste0(GUID, '.html'))
                cat(
                    redactions$replacement_html[k],
                    file = file_path
                )
                
            }

        }
    }
    
    return(repo)
    
}
