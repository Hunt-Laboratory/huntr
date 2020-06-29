
# Compile Data ------------------------------------------------------------

tidyProblemNames = function(dt) {
    dt[dt == "Problem #1 - Foreign Fighters"] = "Foreign Fighters"
    dt[dt == "Problem #2 - Forecasting Piracy"] = "Forecasting Piracy"
    dt[dt == "Problem #3 - Corporate Espionage"] = "Corporate Espionage"
    dt[dt == "Problem #4 - The Park Young-min Case"] = "The Park Young-min Case"
    return(dt)
}

addRescaledEngagementMetrics = function(analytics) {
    as = c("report_count",
           "resource_count",
           "comment_count",
           "chat_count",
           "comment_vote_count",
           "resource_vote_count",
           "simple_rating",
           "partial_rating",
           "complete_rating")
    rescale = function(x) {
        ( x - min(x, na.rm = T) ) / ( max(x, na.rm = T) - min(x, na.rm = T ) )
    }
    for (a in as) {
        analytics[[paste0(a,"_scaled")]] = rescale(analytics[[a]])
    }
    analytics$engagement_scaled = 7*analytics$report_count_scaled +
        3*analytics$resource_count_scaled +
        3*analytics$complete_rating_scaled +
        2*analytics$comment_count_scaled + 
        analytics$chat_count_scaled +
        analytics$simple_rating_scaled +
        analytics$partial_rating_scaled +
        analytics$comment_vote_count_scaled +
        analytics$resource_vote_count_scaled
    
    return(analytics)
}

fetchPlatformData = function(path_to_data, instance_name) {
    path = paste0(path_to_data, instance_name, '/PlatformData/')
    
    # Initialise and populate list of instance data.
    instance_data = list()
    instance_data$analytics = fread(paste0(path, 'analytics/analytics.csv'))
    instance_data$authors = fread(paste0(path, 'authors/authors.csv'))
    instance_data$chat = fread(paste0(path, 'chat/chat.csv'))
    instance_data$comments = fread(paste0(path, 'comments/comments.csv'))
    instance_data$login = fread(paste0(path, 'login/login.csv'))
    instance_data$problems = fread(paste0(path, 'problems/problems.csv'))
    instance_data$ratings = fread(paste0(path, 'ratings/ratings.csv'))
    instance_data$relations = fread(paste0(path, 'relations/relations.csv'))
    instance_data$top_reports = fread(paste0(path, 'reports/top_reports.csv'))
    instance_data$responses = fread(paste0(path, 'responses/responses.csv'))
    instance_data$timeline = fread(paste0(path, 'timeline/timeline.csv'))
    
    # Improve consistency of column names.
    setnames(instance_data$problems, "problem_title", "problem")
    
    setnames(instance_data$analytics, "title", "problem")
    setnames(instance_data$analytics, "teamName", "team")
    setnames(instance_data$analytics, "userName", "user")
    setnames(instance_data$analytics, "teamId", "team_id")
    setnames(instance_data$analytics, "problemId", "problem_id")
    setnames(instance_data$analytics, "userId", "user_id")
    
    setnames(instance_data$authors, "team_name", "team")
    setnames(instance_data$authors, "author_id", "user_id")
    setnames(instance_data$authors, "author_name", "user")
    
    setnames(instance_data$chat, "author_name", "user")
    setnames(instance_data$chat, "author_id", "user_id")
    instance_data$chat$problem_title = NULL
    setnames(instance_data$chat, "team_name", "team")
    
    setnames(instance_data$comments, "team_name", "team")
    setnames(instance_data$comments, "author_name", "author")
    setnames(instance_data$comments, "commenter_name", "commenter")
    
    setnames(instance_data$login, "userName", "user")
    setnames(instance_data$login, "userId", "user_id")
    setnames(instance_data$login, "eventType", "event_type")
    setnames(instance_data$login, "timeStamp", "timestamp")
    
    setnames(instance_data$ratings, "author_name", "author")
    setnames(instance_data$ratings, "rater_name", "rater")
    
    setnames(instance_data$relations, "userName", "user")
    setnames(instance_data$relations, "title", "problem")
    setnames(instance_data$relations, "teamName", "team")
    setnames(instance_data$relations, "problemId", "problem_id")
    
    setnames(instance_data$top_reports, "title", "problem")
    setnames(instance_data$top_reports, "team_name", "team")
    
    setnames(instance_data$responses, "team_name", "team")
    
    setnames(instance_data$timeline, "userName", "user")
    setnames(instance_data$timeline, "title", "problem")
    setnames(instance_data$timeline, "tipe", "type")
    setnames(instance_data$timeline, "teamName", "team")
    setnames(instance_data$timeline, "chunkId", "chunk_id")
    setnames(instance_data$timeline, "parentId", "parent_id")
    setnames(instance_data$timeline, "problemId", "problem_id")
    setnames(instance_data$timeline, "teamId", "team_id")
    setnames(instance_data$timeline, "timeStamp", "timestamp")
    setnames(instance_data$timeline, "userId", "user_id")
    
    # Filter out dummy problems.
    dummy_problems = c("'Sandpit' Problem",
                       "Test Problem",
                       "Problem #1 Teaser - 'Foreign Fighters'",
                       "Problem #2 Teaser - 'Forecasting Piracy'",
                       "Problem #3 Teaser - 'Corporate Espionage'",
                       "Problem #4 Teaser - The Park Young-min Case")
    for (problem_name in dummy_problems) {
        instance_data$relations = instance_data$relations[problem != problem_name]   
        instance_data$timeline = instance_data$timeline[problem != problem_name]   
    }
    
    # Add problem title as variable to tables that only have problem ID.
    for (table_name in c("responses", "authors", "comments", "ratings", "chat")) {
        setDT(instance_data[[table_name]])[instance_data$problems, problem := i.problem, on = c(problem_id = "problem_id")]
    }
    
    # Tidy problem names.
    for (table_name in c("problems", "responses", "analytics", "relations", "timeline", "chat")) {
        instance_data[[table_name]] = tidyProblemNames(instance_data[[table_name]])
        
    }
    
    # Add normalised engagement metrics to analytics table.
    instance_data$analytics = addRescaledEngagementMetrics(instance_data$analytics)
    
    # Add misc. other metrics to analytics table.
    instance_data$analytics[,vote_count:=comment_vote_count + resource_vote_count]
    instance_data$analytics[,quick_rating:=simple_rating + partial_rating]
    
    return(instance_data)
}

# helper function: reverse-score a single column
# if a likert column with vals 1-5  is scored in reverse, then a 5 becomes a 1,
# a 4 becomes a 2, etc. So in this example the reverse-scored value is 6 minus 
# the original value. Generally, it's (max_value + 1) - original .
reverse_score_column = function(column_vector, max_val, reverse = F) {
    if (reverse == F) {
        return(column_vector)
    } else {
        return((max_val + 1) - column_vector)
    }
}

# score the whole psychological scale at once by specifying which columns are
# reverse-scored (FALSE means don't reverse), and the max value of each column
score_likert_scale = function(my_df, scale_col_names, scale_maxes, scale_reverses){
    mask = mapply(reverse_score_column, 
                  my_df[, scale_col_names], 
                  scale_maxes, scale_reverses)
    final_score = rowSums(mask)
    return(final_score)
}

computeAOMT = function(dt) {
    aomt_colnames = paste0('aomt', 1:11)
    aomt_max_vec = rep(7, length(aomt_colnames))
    aomt_reverse_vec <- c(FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, TRUE, FALSE, TRUE, FALSE, FALSE)
    dt$aomt = score_likert_scale(dt,
                                 aomt_colnames,
                                 aomt_max_vec,
                                 aomt_reverse_vec)
    
    return(dt)
}

compile_parts_2018_SwarmChallengeExp1 = function(path_to_data, instance_name) {
    path = paste0(path_to_data, instance_name, '/QualtricsData/')
    
    ES = fread(paste0(path, "ind_diffs_responses_no_scoring.csv"))
    
    colnames(ES) = c("startDate",
                     "endDate",
                     "status",
                     "IPaddress",
                     "progress",
                     "duration",
                     "finished",
                     "recordedDate",
                     "responseID",
                     "externalReference",
                     "latitude",
                     "longitude",
                     "distributionChannel",
                     "userLanguage",
                     
                     #"gaveConsent1", # Efficacy of the SWARM platform
                     
                     "yearsIntelAnalyticalExperience",
                     "yearsProfAnalyticalExperience",
                     "describeAnalyticalExperience",
                     "freeTime",
                     
                     "age",
                     "gender",
                     "education",
                     
                     "major1",
                     "major2",
                     "minor1",
                     "minor2",
                     
                     "englishProficiency",
                     "loteProficiency1",
                     "loteProficiencyText1",
                     "loteProficiency2",
                     "loteProficiencyText2",
                     "loteProficiency3",
                     "loteProficiencyText3",
                     "loteProficiency4",
                     "loteProficiencyText4",
                     "loteProficiency5",
                     "loteProficiencyText5",
                     "loteProficiency6",
                     "loteProficiencyText6",
                     
                     "enjoyLogicProbs",
                     "enjoyNumProbs",
                     
                     "exp1", # Math
                     "exp2", # Quant Model
                     "exp3", # Stats
                     "exp4", # Prob
                     "exp5", # Bayse Nets
                     "exp6", # Programming
                     "exp7", # Experimental Design
                     "exp8", # Risk Analysis
                     "exp9", # Forecasting
                     "exp10", # Decision Theory
                     "exp11", # Game Theory
                     "exp12", # SATs
                     "exp13", # Argument Mapping
                     "exp14", # Informal Logic
                     "exp15", # Sys Think
                     "exp16", # Image Analysis
                     "exp17", # Link Analysis
                     "exp18", # Graphic Design
                     "exp19", # Technical Writing
                     
                     "pc35Acomp",
                     "pc57A",
                     "pc14Acomp",
                     "pc60AUB",
                     "pc5AUB",
                     
                     "pr1",
                     "pr2",
                     "pr3",
                     "pr4",
                     "pr5",
                     "pr6",
                     "pr7",
                     "pr8",
                     "pr9",
                     "pr10",
                     "pr11",
                     "pr12",
                     "pr13",
                     "pr14",
                     "pr15",
                     "pr16",
                     
                     "mat1",
                     "mat2",
                     "mat3",
                     "mat4",
                     "mat5",
                     "mat6",
                     "mat7",
                     "mat8",
                     "mat9",
                     "mat10",
                     "mat11",
                     
                     "pc60Acomp",
                     "pc5Acomp",
                     "pc35A",
                     "pc57Acomp",
                     "pc14B",
                     
                     "crt1",
                     "crt2",
                     "crt3",
                     "crt4",
                     "crt5",
                     "crt6",
                     "crtSeenBefore",
                     
                     "aomt1",
                     "aomt2",
                     "aomt3",
                     "aomt4",
                     "aomt5",
                     "aomt6",
                     "aomt7",
                     "aomt8",
                     "aomt9",
                     "aomt10",
                     "aomt11",
                     
                     "bfi1",
                     "bfi2",
                     "bfi3",
                     "bfi4",
                     "bfi5",
                     "bfi6",
                     "bfi7",
                     "bfi8",
                     "bfi9",
                     "bfi10",
                     
                     "toa1",
                     "toa2",
                     "toa3",
                     "toa4",
                     "toa5",
                     "toa6",
                     "toa7",
                     "toa8",
                     "toa9",
                     "toa10",
                     "toa11",
                     "toa12",
                     "toa13",
                     "toa14",
                     "toa15",
                     "toa16",
                     
                     "pc14A",
                     "pc57AUB",
                     "pc5B",
                     "pc35AUB",
                     "pc60A",
                     
                     "rmePractice",
                     "rme1",
                     "rme2",
                     "rme3",
                     "rme4",
                     "rme5",
                     "rme6",
                     "rme7",
                     "rme8",
                     "rme9",
                     "rme10",
                     "rme11",
                     "rme12",
                     "rme13",
                     "rme14",
                     "rme15",
                     "rme16",
                     "rme17",
                     "rme18",
                     "rme19",
                     "rme20",
                     "rme21",
                     "rme22",
                     "rme23",
                     "rme24",
                     "rme25",
                     "rme26",
                     "rme27",
                     "rme28",
                     "rme29",
                     "rme30",
                     "rme31",
                     "rme32",
                     "rme33",
                     "rme34",
                     "rme35",
                     "rme36",
                     
                     "pc60B",
                     "pc57B",
                     "pc14AUB",
                     "pc5A",
                     "pc35B"
    )
    
    colsToRemove = c("startDate",
                     "endDate",
                     "status",
                     "IPaddress",
                     "duration",
                     "recordedDate",
                     "externalReference",
                     "latitude",
                     "longitude",
                     "distributionChannel",
                     "userLanguage"
    )
    ES = ES[,!..colsToRemove]
    
    ES[ES == ""] <- NA
    
    # ES[ES == "Not familiar with this domain"] <- 1
    # ES[ES == "Studied in school, but don't use it"] <- 2
    # ES[ES == "Use this knowledge occasionally"] <- 3
    # ES[ES == "Use this knowledge regularly"] <- 4
    # ES[ES == "I am a recognized expert"] <- 5
    # ES[ES == "I am an international authority"] <- 6
    
    # pcQs = c("pc5A",
    #          "pc5B",
    #          "pc5Acomp",
    #          "pc5AUB",
    #          "pc14A",
    #          "pc14B",
    #          "pc14Acomp",
    #          "pc14AUB",
    #          "pc35A",
    #          "pc35B",
    #          "pc35Acomp",
    #          "pc35AUB",
    #          "pc57A",
    #          "pc57B",
    #          "pc57Acomp",
    #          "pc57AUB",
    #          "pc60A",
    #          "pc60B",
    #          "pc60Acomp",
    #          "pc60AUB"
    # )
    
    ES[age >= 18 & age <= 25, agegroup := "18-25"]
    ES[age >= 26 & age <= 35, agegroup := "26-35"]
    ES[age >= 36 & age <= 45, agegroup := "36-45"]
    ES[age >= 46 & age <= 55, agegroup := "46-55"]
    ES[age >= 56 & age <= 65, agegroup := "56-65"]
    ES[age >= 66, agegroup := "over 65"]
    
    # Re-encode AOMT and BFI questions.
    # ES[ES == "Strongly Disagree"] <- 1
    # ES[ES == "Strongly disagree"] <- 1
    # ES[ES == "Disagree"] <- 2
    # ES[ES == "Somewhat disagree"] <- 3
    # ES[ES == "Neither agree nor disagree"] <- 4
    # ES[ES == "Somewhat agree"] <- 5
    # ES[ES == "Agree"] <- 6
    # ES[ES == "Strongly agree"] <- 7
    
    ES$finished = (ES$finished == 1)
    
    ES$user = NA
    ES$type = NA
    
    # Reorder columns.
    ES = ES[,.(
        responseID,
        progress,
        finished,
        type,
        
        user,
        
        age,
        agegroup,
        gender,
        education,

        major1,
        major2,
        minor1,
        minor2,
        
        yearsIntelAnalyticalExperience,
        yearsProfAnalyticalExperience,
        describeAnalyticalExperience,
        freeTime,
        
        englishProficiency,
        loteProficiency1,
        loteProficiencyText1,
        loteProficiency2,
        loteProficiencyText2,
        loteProficiency3,
        loteProficiencyText3,
        loteProficiency4,
        loteProficiencyText4,
        loteProficiency5,
        loteProficiencyText5,
        loteProficiency6,
        loteProficiencyText6,
         
        enjoyLogicProbs,
        enjoyNumProbs,
         
        exp1,
        exp2,
        exp3,
        exp4,
        exp5,
        exp6,
        exp7,
        exp8,
        exp9,
        exp10,
        exp11,
        exp12,
        exp13,
        exp14,
        exp15,
        exp16,
        exp17,
        exp18,
        exp19,
         
        pc5A,
        pc5B,
        pc5Acomp,
        pc5AUB,
        pc14A,
        pc14B,
        pc14Acomp,
        pc14AUB,
        pc35A,
        pc35B,
        pc35Acomp,
        pc35AUB,
        pc57A,
        pc57B,
        pc57Acomp,
        pc57AUB,
        pc60A,
        pc60B,
        pc60Acomp,
        pc60AUB,
         
        pr1,
        pr2,
        pr3,
        pr4,
        pr5,
        pr6,
        pr7,
        pr8,
        pr9,
        pr10,
        pr11,
        pr12,
        pr13,
        pr14,
        pr15,
        pr16,
         
        mat1,
        mat2,
        mat3,
        mat4,
        mat5,
        mat6,
        mat7,
        mat8,
        mat9,
        mat10,
        mat11,
         
        crt1,
        crt2,
        crt3,
        crt4,
        crt5,
        crt6,
        crtSeenBefore,
         
        aomt1,
        aomt2,
        aomt3,
        aomt4,
        aomt5,
        aomt6,
        aomt7,
        aomt8,
        aomt9,
        aomt10,
        aomt11,
         
        bfi1,
        bfi2,
        bfi3,
        bfi4,
        bfi5,
        bfi6,
        bfi7,
        bfi8,
        bfi9,
        bfi10,
         
        toa1,
        toa2,
        toa3,
        toa4,
        toa5,
        toa6,
        toa7,
        toa8,
        toa9,
        toa10,
        toa11,
        toa12,
        toa13,
        toa14,
        toa15,
        toa16,
         
        rme1,
        rme2,
        rme3,
        rme4,
        rme5,
        rme6,
        rme7,
        rme8,
        rme9,
        rme10,
        rme11,
        rme12,
        rme13,
        rme14,
        rme15,
        rme16,
        rme17,
        rme18,
        rme19,
        rme20,
        rme21,
        rme22,
        rme23,
        rme24,
        rme25,
        rme26,
        rme27,
        rme28,
        rme29,
        rme30,
        rme31,
        rme32,
        rme33,
        rme34,
        rme35,
        rme36
    )]
    
    # Populate user, team and type.
    lookup = fread(paste0(path_to_data, instance_name, '/AdminData/match_ind_diffs_response_to_swarm_username.csv'))
    for (k in 1:nrow(ES)) {
        if (ES$responseID[k] %in% lookup$IDS_ResponseId) {
            i = which(lookup$IDS_ResponseId == ES$responseID[k])
            ES$user[k] = lookup$username[i]
            ES$type[k] = lookup$Type.x[i]
        }
    }
    
    ES$user = tolower(ES$user)
    
    ES <- ES[ES$finished]
    ES = ES[!is.na(ES$user)]
    ES = as.data.frame(ES)
    
    # Compute AOMT construct.
    ES = computeAOMT(ES)
    
    return(setDT(ES))
}

compile_parts_2020_HuntChallenge = function(path_to_data, instance_name) {
    path = paste0(path_to_data, instance_name, '/QualtricsData/')
    
    entrySurveyPub = fread(paste0(path, "HC2020_EntrySurvey_Public.csv"))
    entrySurveyOrg = fread(paste0(path, "HC2020_EntrySurvey_Organisations.csv"))
    exitSurveyPub = fread(paste0(path, "HC2020_ExitSurvey_Public.csv"))
    exitSurveyOrg = fread(paste0(path, "HC2020_ExitSurvey_Organisations.csv"))
    
    entrySurveyPub = entrySurveyPub[3:nrow(entrySurveyPub)]
    entrySurveyOrg = entrySurveyOrg[3:nrow(entrySurveyOrg)]
    exitSurveyPub = exitSurveyPub[3:nrow(exitSurveyPub)]
    exitSurveyOrg = exitSurveyOrg[3:nrow(exitSurveyOrg)]
    
    exitSurveyPub = exitSurveyPub[,1:101]
    
    colnames(entrySurveyPub) <- c("startDate",
                                  "endDate",
                                  "status",
                                  "IPaddress",
                                  "progress",
                                  "duration",
                                  "finished",
                                  "recordedDate",
                                  "responseID",
                                  "recipientLastName",
                                  "recipientFirstName",
                                  "recipientEmail",
                                  "externalReference",
                                  "latitude",
                                  "longitude",
                                  "distributionChannel",
                                  "userLanguage",
                                  
                                  "reservedPlace",
                                  "gaveConsent2", # Problem Solving in Online Groups
                                  "nickname",
                                  "email",
                                  "agreedToTerms",
                                  
                                  "interests",
                                  "interestsOtherInput",
                                  
                                  "enExpct1", # InterestingProblems
                                  "enExpct2", # TimeCommitment
                                  "enExpct3", # DifficultProblems
                                  "enExpct4", # LearnSkills
                                  "enExpct5", # AchievableProblems
                                  "enExpct6", # ProductivePlatform
                                  "enExpct7", # AnalyticalTraining
                                  "enExpct8", # PositiveExperience
                                  "enExpct9", # EffectiveCollaboration
                                  "enExpct10", # ApplicableToWork
                                  
                                  "pri1", # BenchmarkTeam
                                  "pri2", # TestSkills
                                  "pri3", # Fun
                                  "pri4", # DevelopSkills
                                  "pri5", # LearnPlatform
                                  "pri6", # LearnCA
                                  "pri7", # NewCollaborationStyle
                                  "pri8", # ResearchContribution
                                  "pri9", # SuperTeam
                                  "pri10", # LensKit
                                  "pri11", # Crowdsource
                                  "priOther", # Other
                                  "priOtherInput",
                                  
                                  "aomt1",
                                  "aomt2",
                                  "aomt3",
                                  "aomt4",
                                  "aomt5",
                                  "aomt6",
                                  "aomt7",
                                  "aomt8",
                                  "aomt9",
                                  "aomt10",
                                  "aomt11",
                                  
                                  "agegroup",
                                  "gender",
                                  "occupation",
                                  "education",
                                  "studyarea",
                                  "studyareaOtherInput",
                                  "yearsWorkExperience",
                                  "typeAnalyticalExperience",
                                  "yearsAnalyticalExperience",
                                  
                                  "enCap1", # ReportWriting
                                  "enCap2", # UsingSATs
                                  "enCap3", # OSINT
                                  "enCap4", # Frameworks
                                  "enCap5", # Assumptions
                                  "enCap6", # EvaluatingQoR
                                  "enCap7", # DecisionMaking
                                  
                                  "hasMultidisciplinaryExperience",
                                  "multidisciplinaryExperienceInput",
                                  
                                  "user",
                                  "team"
    )
    
    colnames(entrySurveyOrg) <- c("startDate",
                                  "endDate",
                                  "status",
                                  "IPaddress",
                                  "progress",
                                  "duration",
                                  "finished",
                                  "recordedDate",
                                  "responseID",
                                  "recipientLastName",
                                  "user",
                                  "recipientEmail",
                                  "externalReference",
                                  "latitude",
                                  "longitude",
                                  "distributionChannel",
                                  "userLanguage",
                                  
                                  "gaveConsent1", # Problem Solving in Online Groups
                                  "gaveConsent3", # Identifying and Rating Quality of Reasoning
                                  
                                  "interests",
                                  "interestsOtherInput",
                                  
                                  "enExpct1", # InterestingProblems
                                  "enExpct2", # TimeCommitment
                                  "enExpct3", # DifficultProblems
                                  "enExpct4", # LearnSkills
                                  "enExpct5", # AchievableProblems
                                  "enExpct6", # ProductivePlatform
                                  "enExpct7", # AnalyticalTraining
                                  "enExpct8", # PositiveExperience
                                  "enExpct9", # EffectiveCollaboration
                                  "enExpct10", # ApplicableToWork
                                  
                                  "pri1", # BenchmarkTeam
                                  "pri2", # TestSkills
                                  "pri3", # Fun
                                  "pri4", # DevelopSkills
                                  "pri5", # LearnPlatform
                                  "pri6", # LearnCA
                                  "pri7", # NewCollaborationStyle
                                  "pri8", # ResearchContribution
                                  "pri9", # SuperTeam
                                  "pri10", # LensKit
                                  "pri11", # Crowdsource
                                  "priOther", # Other
                                  "priOtherInput",
                                  
                                  "aomt1",
                                  "aomt2",
                                  "aomt3",
                                  "aomt4",
                                  "aomt5",
                                  "aomt6",
                                  "aomt7",
                                  "aomt8",
                                  "aomt9",
                                  "aomt10",
                                  "aomt11",
                                  
                                  "agegroup",
                                  "gender",
                                  "occupation",
                                  "education",
                                  "studyarea",
                                  "studyareaOtherInput",
                                  "yearsWorkExperience",
                                  "typeAnalyticalExperience",
                                  "yearsAnalyticalExperience",
                                  
                                  "enCap1", # ReportWriting
                                  "enCap2", # UsingSATs
                                  "enCap3", # OSINT
                                  "enCap4", # Frameworks
                                  "enCap5", # Assumptions
                                  "enCap6", # EvaluatingQoR
                                  "enCap7", # DecisionMaking
                                  
                                  "hasMultidisciplinaryExperience",
                                  "multidisciplinaryExperienceInput"
    )
    
    colnames(exitSurveyOrg) = c(
        "startDate",
        "endDate",
        "status",
        "IPaddress",
        "progress",
        "duration",
        "finished",
        "recordedDate",
        "responseID",
        "recipientLastName",
        "user",
        "recipientEmail",
        "externalReference",
        "latitude",
        "longitude",
        "distributionChannel",
        "userLanguage",
        "recaptcha",
        
        "username",
        "starRating",
        "timeWellSpent",
        "bestThing",
        "worstThing",
        
        "rate1", # onboarding process
        "rate2", # our communication
        "rate3", # the training
        "rate4", # the feedback
        "rate5", # the help center
        
        "exExpct1", # interesting problems
        "exExpct2", # reasonable time commitment
        "exExpct3", # difficult problems
        "exExpct4", # learning new skills and tools
        "exExpct5", # achievable problems
        "exExpct6", # platform will be productive work space
        "exExpct7", # training in OSINT tools
        "exExpct8", # positive team working experience
        "exExpct9", # effective collaboration, compared to normal methods
        "exExpct10", # can be applied in my workplace
        
        "hoursPerWeek",
        "enoughTime",
        "proportionOwnTime",
        
        "tw1", # enjoyed the team social experience
        "tw2", # enjoyed the team collaboration experience
        "tw3", # could positively contribute
        "tw4", # efforts recognised
        "tw5", # easy to keep track
        "tw6", # too dominant
        "tw7", # had to lead
        
        "pf1", # shared mission
        "pf2", # unified goal
        "pf3", # managing contributions
        "pf4", # keeping track
        "pf5", # flexible and agile
        "pf6", # innovative problem solving
        "pf7", # enabling efficient workflow
        "pf8", # meeting deadlines
        "pf9", # clear communication
        "pf10", # engaging/disengaging
        "pf11", # information sharing
        "pf12", # working together positively
        "pf13", # making decisions
        "pf14", # production of useful output
        "pfComments",
        
        "fb1", # accurately reflected
        "fb2", # understand strengths and weeknesses
        "fb3", # build expertise
        "fb4", # used feedback
        
        "exCap1", # analytic report writing
        "exCap2", # using SATs
        "exCap3", # using OSINT tools
        "exCap4", # applying strategic thinking
        "exCap5", # identifying and analysing assumptions
        "exCap6", # evaluating QoR
        "exCap7", # using decision making frameworks
        
        "mostValuable",
        "cha1", # more effective
        "cha2", # more engaging
        "cha3", # some people but not others
        
        "career1",
        "career2",
        
        "ca1", # understood CA
        "ca2", # used CA
        "ca3", # understoodimproved QoR
        "ca4", # intend to apply
        
        "swarm1", # better reasoned reports
        "swarm2", # team > individual
        "swarm3", # would improve intelligence analysis in org
        "swarm4", # would use it
        
        "lk1", # easy to find relevant tools
        "lk2", # tools were well explained
        "lk3", # was helpful
        "lk4", # preferred existing tools
        "lk5", # difficult to navigate
        "lk6", # used it often
        "lkSuggestions",
        
        "responseStatements",
        
        "ratingTool",
        "ratingToolWhyNot",
        "ratingToolPurpose",
        
        "featureRequests",
        "externalTools",
        "externalToolsComments",
        
        "bestQuestionNotAsked",
        
        "testimonial",
        "otherComments"
    )
    
    colnames(exitSurveyPub) = c(
        "startDate",
        "endDate",
        "status",
        "IPaddress",
        "progress",
        "duration",
        "finished",
        "recordedDate",
        "responseID",
        "recipientLastName",
        "recipientFirstName",
        "recipientEmail",
        "externalReference",
        "latitude",
        "longitude",
        "distributionChannel",
        "userLanguage",
        "recaptcha",
        
        "username",
        "starRating",
        "timeWellSpent",
        "bestThing",
        "worstThing",
        
        "rate1", # onboarding process
        "rate2", # our communication
        "rate3", # the training
        "rate4", # the feedback
        "rate5", # the help center
        
        "exExpct1", # interesting problems
        "exExpct2", # reasonable time commitment
        "exExpct3", # difficult problems
        "exExpct4", # learning new skills and tools
        "exExpct5", # achievable problems
        "exExpct6", # platform will be productive work space
        "exExpct7", # training in OSINT tools
        "exExpct8", # positive team working experience
        "exExpct9", # effective collaboration, compared to normal methods
        "exExpct10", # can be applied in my workplace
        
        # "hoursPerWeek",
        # "enoughTime",
        # "proportionOwnTime",
        
        "tw1", # enjoyed the team social experience
        "tw2", # enjoyed the team collaboration experience
        "tw3", # could positively contribute
        "tw4", # efforts recognised
        "tw5", # easy to keep track
        "tw6", # too dominant
        "tw7", # had to lead
        
        "pf1", # shared mission
        "pf2", # unified goal
        "pf3", # managing contributions
        "pf4", # keeping track
        "pf5", # flexible and agile
        "pf6", # innovative problem solving
        "pf7", # enabling efficient workflow
        "pf8", # meeting deadlines
        "pf9", # clear communication
        "pf10", # engaging/disengaging
        "pf11", # information sharing
        "pf12", # working together positively
        "pf13", # making decisions
        "pf14", # production of useful output
        "pfComments",
        
        "fb1", # accurately reflected
        "fb2", # understand strengths and weeknesses
        "fb3", # build expertise
        "fb4", # used feedback
        
        "exCap1", # analytic report writing
        "exCap2", # using SATs
        "exCap3", # using OSINT tools
        "exCap4", # applying strategic thinking
        "exCap5", # identifying and analysing assumptions
        "exCap6", # evaluating QoR
        "exCap7", # using decision making frameworks
        
        "mostValuable",
        "cha1", # more effective
        "cha2", # more engaging
        "cha3", # some people but not others
        
        "career1",
        
        "ca1", # understood CA
        "ca2", # used CA
        "ca3", # understoodimproved QoR
        "ca4", # intend to apply
        
        "swarm1", # better reasoned reports
        "swarm2", # team > individual
        "swarm3", # would improve intelligence analysis in org
        "swarm4", # would use it
        
        "lk1", # easy to find relevant tools
        "lk2", # tools were well explained
        "lk3", # was helpful
        "lk4", # preferred existing tools
        "lk5", # difficult to navigate
        "lk6", # used it often
        "lkSuggestions",
        
        "responseStatements",
        
        "ratingTool",
        "ratingToolWhyNot",
        "ratingToolPurpose",
        
        "featureRequests",
        "externalTools",
        "externalToolsComments",
        
        "bestQuestionNotAsked",
        
        "testimonial",
        "otherComments"
    )
    
    entrySurveyPub$isOrg = FALSE;
    entrySurveyOrg$isOrg = TRUE;
    exitSurveyPub$isOrg = FALSE;
    exitSurveyOrg$isOrg = TRUE;
    
    
    ES = rbind(entrySurveyPub,
               entrySurveyOrg,
               use.names = TRUE,
               fill = TRUE)
    ExS = rbind(exitSurveyPub,
               exitSurveyOrg,
               use.names = TRUE,
               fill = TRUE)
    
    for (k in 1:nrow(ExS)) {
        if (!ExS$isOrg[k]) {
            ExS$user[k] = as.character(ES[recipientEmail == ExS$recipientEmail[k]]$user[1])
        }
    }
    
    colsToRemove <- c("startDate",
                      "endDate",
                      "status",
                      "IPaddress",
                      "duration",
                      "recordedDate",
                      "responseID",
                      "recipientLastName",
                      "recipientFirstName",
                      "recipientEmail",
                      "externalReference",
                      "latitude",
                      "longitude",
                      "distributionChannel",
                      "userLanguage",
                      "reservedPlace",
                      "nickname",
                      "email",
                      "team"
    )
    ES = ES[,!..colsToRemove]
    
    colsToRemove <- c("startDate",
                      "endDate",
                      "status",
                      "IPaddress",
                      "duration",
                      "recordedDate",
                      "responseID",
                      "recipientLastName",
                      "recipientFirstName",
                      "recipientEmail",
                      "externalReference",
                      "latitude",
                      "longitude",
                      "distributionChannel",
                      "userLanguage",
                      "recaptcha",
                      "username",
                      "career2"
    )
    ExS = ExS[,!..colsToRemove]
    
    ES[ES == ""] <- NA
    
    for (cl in paste0('pri', 1:11)) {
        ES[get(cl) == "Not important", (cl) := 1]
        ES[get(cl) == "Neutral", (cl) := 2]
        ES[get(cl) == "Important", (cl) := 3]
    }
    
    ES[ES == "I don't expect this"] <- 1
    ES[ES == "Neutral"] <- 2
    ES[ES == "I do expect this"] <- 3
    
    # ES[ES == "Not important"] <- 1
    # ES[ES == "Important"] <- 2
    
    ES[ES == "Strongly Disagree"] <- 1
    ES[ES == "Strongly disagree"] <- 1
    ES[ES == "Disagree"] <- 2
    ES[ES == "Somewhat disagree"] <- 3
    ES[ES == "Neither agree nor disagree"] <- 4
    ES[ES == "Somewhat agree"] <- 5
    ES[ES == "Agree"] <- 6
    ES[ES == "Strongly agree"] <- 7
    for (i in 1:11) {
        ES[[paste0("aomt", i)]] = as.numeric(ES[[paste0("aomt", i)]])
    }
    
    ES[ES == "prefer not to say"] <- "Prefer not to say"
    ES[ES == "Other (please describe)"] <- "Other"
    
    ES[ES == "None"] <- 1
    ES[ES == "Low"] <- 2
    ES[ES == "Moderate"] <- 3
    ES[ES == "High"] <- 4
    
    ES[,`:=`(progress = as.numeric(progress),
             finished = (finished == "True"),
             gaveConsent2 = (gaveConsent2 == "Yes"),
             gaveConsent3 = (gaveConsent3 == "Yes"),
             agreedToTerms = (nchar(agreedToTerms) > 10),
             interests = lapply(strsplit(interests, ","), trimws),
             interestsOtherInput = ifelse(interestsOtherInput == "", NA, interestsOtherInput),
             studyarea = trimws(studyarea),
             hasMultidisciplinaryExperience = (hasMultidisciplinaryExperience == "Yes")
    )]
    
    # Separate out interests into own column.
    suppressWarnings(ES[,`:=`(
        int1 = stringr::str_detect(interests, "What the problems will be like"),
        int2 = stringr::str_detect(interests, "Platform functionality"),
        int3 = stringr::str_detect(interests, "How reports are created"),
        int4 = stringr::str_detect(interests, "Team collaboration experience"),
        int5 = stringr::str_detect(interests, "The structured training available"),
        int6 = stringr::str_detect(interests, "The tools in the Lens Kit"),
        int7 = stringr::str_detect(interests, "The Contending Analyses methodology"),
        int8 = stringr::str_detect(interests, "The evaluation methods"),
        int9 = stringr::str_detect(interests, "How my team performs"),
        int10 = stringr::str_detect(interests, "Whether the public do as well as the professionals"),
        int11 = stringr::str_detect(interests, "Other")
    )])
    
    # Seperate out analytical experience into own column.
    ES[,`:=`(
        ae1 = stringr::str_detect(typeAnalyticalExperience, "No direct experience"),
        ae2 = stringr::str_detect(typeAnalyticalExperience, "Yes, in an intelligence or related field"),
        ae3 = stringr::str_detect(typeAnalyticalExperience, "Yes, in a scientific field"),
        ae4 = stringr::str_detect(typeAnalyticalExperience, "Yes, in another field"),
        ae5 = stringr::str_detect(typeAnalyticalExperience, "Prefer not to say")
    )]
    
    colsToRemove = c("interests",
                     "typeAnalyticalExperience")
    ES = ES[,!..colsToRemove]
    
    ExS[ExS == ""] <- NA
    ExS[timeWellSpent == "No", timeWellSpent := 1]
    ExS[timeWellSpent == "Unsure", timeWellSpent := 2]
    ExS[timeWellSpent == "Yes", timeWellSpent := 3]
    
    for (cl in paste0('rate', 1:5)) {
        ExS[get(cl) == "Poor", (cl) := 1]
        ExS[get(cl) == "Average", (cl) := 2]
        ExS[get(cl) == "Good", (cl) := 3]
    }
    
    for (cl in paste0('exExpct', 1:10)) {
        ExS[get(cl) == "Below", (cl) := 1]
        ExS[get(cl) == "Below ", (cl) := 1]
        ExS[get(cl) == "Met", (cl) := 2]
        ExS[get(cl) == "Exceeded", (cl) := 3]
        ExS[get(cl) == "I had no expectations", (cl) := 4]
    }
    
    for (cl in paste0('tw', 1:7)) {
        ExS[get(cl) == "Disagree", (cl) := 1]
        ExS[get(cl) == "Neutral", (cl) := 2]
        ExS[get(cl) == "Agree", (cl) := 3]
    }
    
    for (cl in paste0('pf', 1:14)) {
        ExS[get(cl) == "No", (cl) := 1]
        ExS[get(cl) == "Yes", (cl) := 2]
        ExS[get(cl) == "Not sure", (cl) := 3]
    }
    
    for (cl in paste0('fb', 1:4)) {
        ExS[get(cl) == "Disagree", (cl) := 1]
        ExS[get(cl) == "Neutral", (cl) := 2]
        ExS[get(cl) == "Agree", (cl) := 3]
    }
    
    for (cl in paste0('exCap', 1:7)) {
        ExS[get(cl) == "No", (cl) := 1]
        ExS[get(cl) == "Somewhat", (cl) := 2]
        ExS[get(cl) == "Significantly", (cl) := 3]
    }
    
    for (cl in paste0('cha', 1:3)) {
        ExS[get(cl) == "Disagree", (cl) := 1]
        ExS[get(cl) == "Neutral", (cl) := 2]
        ExS[get(cl) == "Agree", (cl) := 3]
    }
    
    for (cl in paste0('career', 1)) {
        ExS[get(cl) == "No change", (cl) := 1]
        ExS[get(cl) == "Not changed", (cl) := 1]
        ExS[get(cl) == "No change\t", (cl) := 1]
        ExS[get(cl) == "Positively\t", (cl) := 2]
        ExS[get(cl) == "Increased", (cl) := 2]
    }
    
    for (cl in paste0('ca', 1:4)) {
        ExS[get(cl) == "No", (cl) := 1]
        ExS[get(cl) == "Yes", (cl) := 2]
        ExS[get(cl) == "Not Sure", (cl) := 3]
    }
    
    for (cl in paste0('swarm', 1:4)) {
        ExS[get(cl) == "Strongly disagree", (cl) := 1]
        ExS[get(cl) == "Disagree", (cl) := 2]
        ExS[get(cl) == "Neutral", (cl) := 3]
        ExS[get(cl) == "Agree", (cl) := 4]
        ExS[get(cl) == "Strongly agree", (cl) := 5]
    }
    
    for (cl in paste0('lk', 1:6)) {
        ExS[get(cl) == "Disagree", (cl) := 1]
        ExS[get(cl) == "Neutral", (cl) := 2]
        ExS[get(cl) == "Agree", (cl) := 3]
    }
    
    ExS[ratingTool == "No", ratingTool := 1]
    ExS[ratingTool == "Yes", ratingTool := 2]
    
    ExS[externalTools == "No", externalTools := 1]
    ExS[externalTools == "Yes", externalTools := 2]
    
    ExS[enoughTime == "No", enoughTime := 1]
    ExS[enoughTime == "Yes", enoughTime := 2]
    
    ExS[,`:=`(progress = as.numeric(progress),
              finished = (finished == "True"),
              starRating = as.integer(substr(starRating,1,1)),
              responseStatements = lapply(strsplit(responseStatements, ","), trimws),
              ratingToolPurpose = lapply(strsplit(ratingToolPurpose, ","), trimws)
    )]
    
    # Separate out responseStatements into own column.
    suppressWarnings(ExS[,`:=`(
        res1 = stringr::str_detect(responseStatements, "The resources were an important contribution to problem solving"),
        res2 = stringr::str_detect(responseStatements, "It was easy to keep track of all the resources posted on the Platform"),
        res3 = stringr::str_detect(responseStatements, "My team created a lot of resources"),
        res4 = stringr::str_detect(responseStatements, "It was too time consuming to read through everyone's resources.")
    )])
    
    # Seperate out analytical experience into own column.
    suppressWarnings(ExS[,`:=`(
        whyRate1 = stringr::str_detect(ratingToolPurpose, "I used rating to fairly indicate the readiness or quality of a report"),
        whyRate2 = stringr::str_detect(ratingToolPurpose, "I used rating to give guidance to the author"),
        whyRate3 = stringr::str_detect(ratingToolPurpose, "I used rating to push my prefered report to the top")
    )])
    
    colsToRemove = c("responseStatements",
                     "ratingToolPurpose")
    ExS = ExS[,!..colsToRemove]
    
    
    # REORDER COLUMNS
    ES = ES[, .(
        progress,
        finished,
        gaveConsent2,
        gaveConsent3,
        agreedToTerms,
        user,
        agegroup,
        gender,
        occupation,
        isOrg,
        education,
        studyarea,
        studyareaOtherInput,
        int1,
        int2,
        int3,
        int4,
        int5,
        int6,
        int7,
        int8,
        int9,
        int10,
        int11,
        interestsOtherInput,
        enExpct1,
        enExpct2,
        enExpct3,
        enExpct4,
        enExpct5,
        enExpct6,
        enExpct7,
        enExpct8,
        enExpct9,
        enExpct10,
        pri1,
        pri2,
        pri3,
        pri4,
        pri5,
        pri6,
        pri7,
        pri8,
        pri9,
        pri10,
        pri11,
        priOther,
        priOtherInput,
        aomt1,
        aomt2,
        aomt3,
        aomt4,
        aomt5,
        aomt6,
        aomt7,
        aomt8,
        aomt9,
        aomt10,
        aomt11,
        enCap1,
        enCap2,
        enCap3,
        enCap4,
        enCap5,
        enCap6,
        enCap7,
        yearsWorkExperience,
        yearsAnalyticalExperience,
        ae1,
        ae2,
        ae3,
        ae4,
        ae5,
        hasMultidisciplinaryExperience,
        multidisciplinaryExperienceInput
    )]
    
    ExS = ExS[, .(
        progress,
        finished,
        isOrg,
        user,
        starRating,
        timeWellSpent,
        bestThing,
        worstThing,
        
        hoursPerWeek,
        enoughTime,
        proportionOwnTime,
        
        rate1,
        rate2,
        rate3,
        rate4,
        rate5,
        
        exExpct1,
        exExpct2,
        exExpct3,
        exExpct4,
        exExpct5,
        exExpct6,
        exExpct7,
        exExpct8,
        exExpct9,
        exExpct10,
        
        tw1,
        tw2,
        tw3,
        tw4,
        tw5,
        tw6,
        tw7,
        
        pf1,
        pf2,
        pf3,
        pf4,
        pf5,
        pf6,
        pf7,
        pf8,
        pf9,
        pf10,
        pf11,
        pf12,
        pf13,
        pf14,
        pfComments,
        
        fb1,
        fb2,
        fb3,
        fb4,
        
        exCap1,
        exCap2,
        exCap3,
        exCap4,
        exCap5,
        exCap6,
        exCap7,
        
        mostValuable,
        
        cha1,
        cha2,
        cha3,
        
        career1,
        
        ca1,
        ca2,
        ca3,
        ca4,
        
        swarm1,
        swarm2,
        swarm3,
        swarm4,
        
        lk1,
        lk2,
        lk3,
        lk4,
        lk5,
        lk6,
        lkSuggestions,
        
        res1,
        res2,
        res3,
        res4,
        
        whyRate1,
        whyRate2,
        whyRate3,
        
        ratingTool,
        ratingToolWhyNot,
        featureRequests,
        externalTools,
        externalToolsComments,
        bestQuestionNotAsked,
        testimonial,
        otherComments
    )]

    ES <- ES[finished & ((gaveConsent3 == TRUE) | is.na(gaveConsent3))]
    ES = ES[!is.na(ES$user)]
    
    ExS <- ExS[(finished)]
    ExS = ExS[!is.na(ExS$user)]
    
    ES = merge(ES, ExS, by = c("user", "isOrg"), all = T)
    ES = as.data.frame(ES)
    
    ES$user = tolower(ES$user)
    
    colsToRemove = c('finished.x', 'progress.x',
                     'finished.y', 'progress.y')
    for (cl in colsToRemove) {
        ES[[cl]] = NULL
    }
    
    # Compute AOMT construct.
    ES = computeAOMT(ES)
    
    return(setDT(ES))
}

compile_parts = function(path_to_data, instance_name) {
    
    # Lookup table for relevant functions. This is required because demographic surveys differ
    # syntactically across different experiements, and so each require custom code to tidy the
    # data into a consistent format.
    compile_parts = list(
        "2018_SwarmChallengeExp1" = compile_parts_2018_SwarmChallengeExp1,
        "2020_HuntChallenge" = compile_parts_2020_HuntChallenge
    )
    
    if (instance_name %in% names(compile_parts)) {
        return(compile_parts[[instance_name]](path_to_data, instance_name))
    } else {
        return(NULL)
    }
}


compile_teamparts_2018_SwarmChallengeExp1 = function(repo, path_to_data, instance_name) {
    path = paste0(path_to_data, instance_name, '/QualtricsData/')
    
    parts = repo[[instance_name]]$CoreData$parts
    tmprt = data.table(
        user = parts$user,
        team = rep(NA, nrow(parts))
    )

    # Populate team.
    lookup = fread(paste0(path_to_data, instance_name, '/AdminData/match_ind_diffs_response_to_swarm_username.csv'))
    lookup$username = tolower(lookup$username)
    for (k in 1:nrow(tmprt)) {
        if (tmprt$user[k] %in% lookup$username) {
            i = which(lookup$username == tmprt$user[k])
            tmprt$team[k] = lookup$Team[i]
        }
    }
    
    tmprt = tmprt[!is.na(tmprt$team)]
    tmprt = as.data.frame(tmprt)
    
    return(setDT(tmprt))
}

compile_teamparts_2020_HuntChallenge = function(repo, path_to_data, instance_name) {
    path = paste0(path_to_data, instance_name, '/QualtricsData/')
    
    parts = repo[[instance_name]]$CoreData$parts
    
    pubLookup = fread(paste0(path, "HC2020_EntrySurvey_Public.csv"))
    supLookup = fread(paste0(path_to_data, instance_name, '/AdminData/Superteams.csv'))
    orgLookup = fread(paste0(path_to_data, instance_name, '/AdminData/OrgMaster.csv'))
    
    pubLookup = pubLookup[,user:team]
    supLookup = supLookup[,.(username, group_code)]
    supLookup = supLookup[, `:=`(
        user = username,
        team = group_code
    )]
    supLookup = supLookup[,user:team]
    orgLookup = orgLookup[,.(username, group_code)]
    orgLookup = orgLookup[, `:=`(
        user = username,
        team = group_code
    )]
    orgLookup = orgLookup[,user:team]
    
    orgLookup$user = tolower(orgLookup$user)
    pubLookup$user = tolower(pubLookup$user)
    supLookup$user = tolower(supLookup$user)
    
    pubLookup = pubLookup[user %in% parts$user]
    supLookup = supLookup[user %in% parts$user]
    orgLookup = orgLookup[user %in% parts$user]
    
    supLookup$team = sapply(strsplit(supLookup$team, ','), function(x) {return(x[2])})
    
    tmprt = rbind(
        pubLookup,
        supLookup,
        orgLookup
    )
    
    tmprt = tmprt[!is.na(tmprt$team)]
    tmprt = as.data.frame(tmprt)
    
    return(setDT(tmprt))
}

compile_teamparts = function(repo, path_to_data, instance_name) {
    
    # Lookup table for relevant functions. This is required because demographic surveys differ
    # syntactically across different experiements, and so each require custom code to tidy the
    # data into a consistent format.
    compile_teamparts = list(
        "2018_SwarmChallengeExp1" = compile_teamparts_2018_SwarmChallengeExp1,
        "2020_HuntChallenge" = compile_teamparts_2020_HuntChallenge
    )
    
    if (instance_name %in% names(compile_teamparts)) {
        return(compile_teamparts[[instance_name]](repo, path_to_data, instance_name))
    } else {
        return(NULL)
    }
}


compile_teams_2018_SwarmChallengeExp1 = function(repo, path_to_data, instance_name) {
    
    path = paste0(path_to_data, instance_name, "/KnackData/products.csv")
    
    K = as.data.frame(fread(path))
    colnames(K) <- c("reportCode",
                     "problem",
                     "nRatings",
                     "avgIC",
                     "min",
                     "max",
                     "range",
                     "username",
                     "team_alt",
                     "team",
                     "week",
                     "submitted")
    
    parts = repo[[instance_name]]$CoreData$parts
    teamparts = repo[[instance_name]]$CoreData$teamparts
    parts = merge(teamparts, parts, by = c("user"))
    
    # Create teams table.
    
    tms = unique(teamparts$team)
    teams = data.frame(team = tms,
                       AOMT = NA,
                       divAOMT = NA,
                       medianEdu = NA,
                       type = NA)
    
    getDivAOMT = function(tm) {
        scores = parts[parts$team == tm,]$aomt
        scores = scores[!is.na(scores)]
        return(mean(c(dist(scores))))
    }
    
    getMedianEdu = function(tm) {
        eds = parts[parts$team == tm,]$education
        eds[eds == "High School or GED Equivalency"] = 1
        eds[eds == "Some College"] = 2
        eds[eds == "Bachelor's Degree"] = 3
        eds[eds == "Associate's Degree"] = 4
        eds[eds == "Master's Degree"] = 5
        eds[eds == "Professional or Doctoral Degree (e.g. MD, JD, PhD)"] = 6
        eds = as.numeric(eds)
        
        return(median(eds, na.rm = T))
    }
    
    for (k in 1:nrow(teams)) {
        teams$AOMT[k] = median(parts[parts$team == teams$team[k],]$aomt, na.rm = T)
        teams$divAOMT[k] = getDivAOMT(teams$team[k])
        teams$medianEdu[k] = getMedianEdu(teams$team[k])
        teams$type[k] = parts[parts$team == teams$team[k],]$type[1]
    }
    
    return(setDT(teams))
}

compile_teams_2020_HuntChallenge = function(repo, path_to_data, instance_name) {
    
    path = paste0(path_to_data, instance_name, "/KnackData/teams2020challenge.csv")
    
    K = as.data.frame(fread(path))
    colnames(K) <- c("team",
                     "avgAll",
                     "type",
                     "points",
                     "avg2",
                     "avg3",
                     "avg4",
                     "avg1",
                     "nRatings1",
                     "nRatings2",
                     "nRatings3",
                     "nRatings4",
                     "nRatings2020",
                     "nGeoCorrect")
    K = K[K$type != "Calibration",]
    
    parts = repo[[instance_name]]$CoreData$parts
    teamparts = repo[[instance_name]]$CoreData$teamparts
    parts = merge(teamparts, parts, by = c("user"))
    
    # Create teams table.
    
    # tms = unique(repo[[instance_name]]$PlatformData$analytics$team)
    tms = unique(teamparts$team)
    tms = tms[tms != "melcreate"]
    teams = data.frame(team = tms,
                       AOMT = NA,
                       divAOMT = NA,
                       medianEdu = NA,
                       type = NA)
    
    getDivAOMT = function(tm) {
        scores = parts[parts$team == tm,]$aomt
        scores = scores[!is.na(scores)]
        return(mean(c(dist(scores))))
    }
    
    getMedianEdu = function(tm) {
        eds = parts[parts$team == tm,]$education
        eds[eds == "High School"] = 1
        eds[eds == "Trade or Technical Qualification"] = 2
        eds[eds == "Bachelors"] = 3
        eds[eds == "Graduate Certificate, Diploma or equivalent"] = 4
        eds[eds == "Masters"] = 5
        eds[eds == "Phd"] = 6
        eds[eds == "Prefer not to say"] = NA
        eds = as.numeric(eds)
        
        return(median(eds, na.rm = T))
    }
    
    OTs = c("kosciuszko00219",
            "otway00219",
            "noosa00219",
            "uluru00219",
            "kakadu00219",
            "grampians00219",
            "daintree00219")
    STs = c("tongariro00311",
            "joondalup00311",
            "murramang00311",
            "warrumbungle00311",
            "aoraki00311")
    
    for (k in 1:nrow(teams)) {
        teams$AOMT[k] = median(parts[parts$team == teams$team[k],]$aomt, na.rm = T)
        teams$divAOMT[k] = getDivAOMT(teams$team[k])
        teams$medianEdu[k] = getMedianEdu(teams$team[k])
        if (teams$team[k] %in% STs) {
            teams$type[k] = 'ST'
        } else if (teams$team[k] %in% OTs) {
            teams$type[k] = 'OT'
        } else {
            teams$type[k] = 'PT'
        }
    }
    
    return(setDT(teams))
}

compile_teams = function(repo, path_to_data, instance_name) {
    
    # Lookup table for relevant functions. This is required because demographic surveys differ
    # syntactically across different experiements, and so each require custom code to tidy the
    # data into a consistent format.
    compile_teams = list(
        "2018_SwarmChallengeExp1" = compile_teams_2018_SwarmChallengeExp1,
        "2020_HuntChallenge" = compile_teams_2020_HuntChallenge
    )
    
    if (instance_name %in% names(compile_teams)) {
        dt = 
        return(compile_teams[[instance_name]](repo, path_to_data, instance_name))
    } else {
        return(NULL)
    }
}

compile_probteams_2018_SwarmChallengeExp1 = function(repo, path_to_data, instance_name) {
    
    path = paste0(path_to_data, instance_name, "/KnackData/products.csv")
    
    K = as.data.frame(fread(path))
    colnames(K) <- c("reportCode",
                     "problem",
                     "nRatings",
                     "avgIC",
                     "min",
                     "max",
                     "range",
                     "username",
                     "team_alt",
                     "team",
                     "week",
                     "submitted")
    
    # Correct typos in team names in K.
    K[K$team == "Witjirra4","team"] = "Witjira4"
    K[K$team == "Garawilla1","team"] = "Garrawilla1"
    
    parts = repo[[instance_name]]$CoreData$parts
    teams = repo[[instance_name]]$CoreData$teams
    tms = unique(teams$team)
    problems = c("How Did Arthur Allen Die?", "Kalukistan", "Three Nations", "Drug Interdiction")
    analytics = repo[[instance_name]]$PlatformData$analytics
    responses = repo[[instance_name]]$PlatformData$responses
    
    response_path = paste0(path_to_data,instance_name,"/PlatformData/responses/text/")
    
    probteam = data.frame(team = rep(tms, length(problems)),
                          problem = rep(problems, each = length(tms)),
                          probNum = NA,
                          type = NA,
                          avgIC = NA,
                          nIC = NA,
                          rankIC = NA,
                          activeUsersSq = NA,
                          textSim = NA,
                          AOMT = NA,
                          divAOMT = NA,
                          medianEdu = NA)
    
    getActiveUsersSq = function(tm, pr) {
        team_members = analytics[team == tm & problem == pr]
        nActive = sum(team_members$engagement_scaled > 0)
        nActiveSq = nActive ^ 2
    }
    
    getTextSim = function(tm, pr) {
        file_names = responses[team == tm & problem == pr & response_type == "report"]$response_text
        
        if (length(file_names) > 1) {
            reports = suppressWarnings(readtext::readtext(paste0(response_path,file_names[1])))  # surpress "*.md" warnings
            
            for (j in 2:length(file_names)) {
                reports = rbind(reports, suppressWarnings(readtext::readtext(paste0(response_path,file_names[j]))))
            }
            
            CORPUS = quanteda::corpus(reports)
            DFM = quanteda::dfm(CORPUS,
                                remove = quanteda::stopwords("english"),
                                stem = TRUE, remove_punct = TRUE, remove_numbers = TRUE)
            DistMat = quanteda::textstat_simil(DFM, method="cosine")
            Distances = DistMat[lower.tri(DistMat)]
        } else {
            Distances = c(1) # If 1 or 0 reports, assign similarity of 1.
        }
        
        mean(Distances)
    }
    
    getAOMT = function(tm, pr) {
        active_team_members = analytics[team == tm & problem == pr & engagement_scaled > 0]$user
        return( median(parts[parts$user %in% active_team_members,]$aomt, na.rm = T) )
    }
    
    getDivAOMT = function(tm, pr) {
        active_team_members = analytics[team == tm & problem == pr & engagement_scaled > 0]$user
        scores = parts[parts$user %in% active_team_members,]$aomt
        # scores = scores[!is.na(scores)]
        # rval = mean(c(dist(scores)))
        n = length(scores) * (length(scores) - 1) / 2 # Number of unique pairs.
        rval = sum(dist(scores), na.rm = T) / n
        if (is.na(rval)) {
            rval = NA
        }
        return(rval)
    }
    
    getMedianEdu = function(tm, pr) {
        active_team_members = analytics[team == tm & problem == pr & engagement_scaled > 0]$user
        eds = parts[parts$user %in% active_team_members,]$education
        eds[eds == "High School or GED Equivalency"] = 1
        eds[eds == "Some College"] = 2
        eds[eds == "Bachelor's Degree"] = 3
        eds[eds == "Associate's Degree"] = 4
        eds[eds == "Master's Degree"] = 5
        eds[eds == "Professional or Doctoral Degree (e.g. MD, JD, PhD)"] = 6
        eds = as.numeric(eds)
        
        return(median(eds, na.rm = T))
    }
    
    for (k in 1:nrow(probteam)) {
        i = intersect( which(K$team == probteam$team[k]), which(K$problem == probteam$problem[k]))
        l = which(K[K$problem == probteam$problem[k] & nchar(K$team) > 0,]$team == probteam$team[k])
        if (length(i) == 0) {
            next
        }
        j = which(teams$team == probteam$team[k])
        probteam$probNum[k] = K$week[i]
        probteam$type[k] = teams$type[j]
        probteam$avgIC[k] = K$avgIC[i]
        probteam$nIC[k] = K$nRatings[i]
        probteam$rankIC[k] = rank(-K[K$problem == probteam$problem[k] & nchar(K$team) > 0,]$avgIC, ties.method = "min")[l]
        probteam$activeUsersSq[k] = getActiveUsersSq(probteam$team[k], probteam$problem[k])
        probteam$textSim[k] = getTextSim(probteam$team[k], probteam$problem[k])
        probteam$AOMT[k] = getAOMT(probteam$team[k], probteam$problem[k])
        probteam$divAOMT[k] = getDivAOMT(probteam$team[k], probteam$problem[k])
        probteam$medianEdu[k] = getMedianEdu(probteam$team[k], probteam$problem[k])
    }
    
    probteam = probteam[!is.na(probteam$avgIC),]
    
    return(setDT(probteam))
}

compile_probteams_2020_HuntChallenge = function(repo, path_to_data, instance_name) {
    
    path = paste0(path_to_data, instance_name, "/KnackData/")
    
    K = as.data.frame(fread(paste0(path, "teams2020challenge.csv")))
    colnames(K) <- c("team",
                     "avgAll",
                     "inRound1",
                     "inRound2",
                     "type",
                     "points",
                     "avg2",
                     "avg3",
                     "avg4",
                     "avg1",
                     "nRatings1",
                     "nRatings2",
                     "nRatings3",
                     "nRatings4",
                     "nRatings2020",
                     "nGeoCorrect",
                     "tightness",
                     "nRedactionEstimates",
                     "probabilityEstimate",
                     "misc1",
                     "misc2")
    K = K[K$type != "Calibration",]
    for (k in 1:4) {
        if (sum( !is.na(K[[paste0('avg',k)]]) & K[[paste0('avg',k)]] == 0 ) > 0) {
            K[!is.na(K[[paste0('avg',k)]]) & K[[paste0('avg',k)]] == 0,][[paste0('avg',k)]] = NA
        }
    }
    
    ratings = fread(paste0(path, "ratings2020challenge.csv"))
    colnames(ratings) = c(
        "reportID",
        "password1",
        "password2",
        "password3",
        "problem",
        "team",
        "participant",
        "created",
        "rater",
        "c1", "c1comment", "c1distinction",
        "c2", "c2comment", "c2distinction",
        "c3", "c3distinction", "c3comment",
        "c4", "c4comment",
        "c5", "c5comment",
        "c6", "c6comment",
        "c7", "c7comment",
        "c8",
        "geo1",
        "geo2",
        "geo3",
        "geo4",
        "c8comment",
        "c1score",
        "c2score",
        "c3score",
        "c4score",
        "c5score",
        "c6score",
        "c7score",
        "c8score",
        "IC",
        "c1na",
        "c2na",
        "c3na",
        "c4na",
        "c5na",
        "c6na",
        "c7na",
        "c8na",
        "ruleBased",
        "ruleBasedScore",
        "ruleBaseAlexAns",
        "c4distinction",
        "c5distinction",
        "c6distinction",
        "c7distinction",
        "c8distinction",
        "lensKit",
        "geo1score",
        "geo2score",
        "geo3score",
        "geo4score",
        "geoOverall",
        "isRedactionTestRating",
        "raterProbabilityEstimate",
        "estTimeTaken",
        "estJustification",
        "estComments",
        "bayes1",
        "bayes2",
        "bayes3",
        "bayes1score",
        "bayes2score",
        "bayes3score",
        "flaw1",
        "flaw2",
        "flaw3",
        "flaw4"
    )
    ratings[ratings == ""] = NA
    ratings[IC == 0,"IC"] = NA
    ratings = ratings[,.(
        problem,
        team,
        participant,
        rater,
        geo1,
        geo2,
        geo3,
        geo4,
        IC,
        geo1score,
        geo2score,
        geo3score,
        geo4score,
        geoOverall,
        isRedactionTestRating,
        raterProbabilityEstimate,
        estTimeTaken,
        estJustification,
        estComments,
        bayes1,
        bayes2,
        bayes3,
        bayes1score,
        bayes2score,
        bayes3score,
        flaw1,
        flaw2,
        flaw3,
        flaw4
    )]
    ratings[,bayesScore := bayes1score + bayes2score + bayes3score]
    
    # RFDratings = fread(paste0(path, "extraRFDratings.csv"))
    # RFDratings[,nFlawsDetected := flaw1 + flaw2 + flaw3 + flaw4]
    
    parts = repo[[instance_name]]$CoreData$parts
    teams = repo[[instance_name]]$CoreData$teams
    tms = unique(teams$team)
    problems = c("Foreign Fighters", "Forecasting Piracy", "Corporate Espionage", "The Park Young-min Case")
    analytics = repo[[instance_name]]$PlatformData$analytics
    responses = repo[[instance_name]]$PlatformData$responses
    
    response_path = paste0(path_to_data,instance_name,"/PlatformData/responses/text/")
    
    probteam = data.frame(team = rep(tms, length(problems)),
                          problem = rep(problems, each = length(tms)),
                          probNum = rep(1:length(problems), each = length(tms)),
                          type = NA,
                          avgIC = NA,
                          nIC = NA,
                          rankIC = NA,
                          nGeoCorrect = NA,
                          probabilityEstimate = NA,
                          tightness = NA,
                          nBayesCorrect = NA,
                          nFlawsDetected = NA,
                          activeUsersSq = NA,
                          textSim = NA,
                          AOMT = NA,
                          divAOMT = NA,
                          medianEdu = NA)
    
    getActiveUsersSq = function(tm, pr) {
        team_members = analytics[team == tm & problem == pr]
        nActive = sum(team_members$engagement_scaled > 0)
        nActiveSq = nActive ^ 2
    }
    
    getTextSim = function(tm, pr) {
        file_names = responses[team == tm & problem == pr & response_type == "report"]$response_text
        
        if (length(file_names) > 1) {
            reports = suppressWarnings(readtext::readtext(paste0(response_path,file_names[1])))  # surpress "*.md" warnings
            
            for (j in 2:length(file_names)) {
                reports = rbind(reports, suppressWarnings(readtext::readtext(paste0(response_path,file_names[j]))))
            }
            
            CORPUS = quanteda::corpus(reports)
            DFM = quanteda::dfm(CORPUS,
                      remove = quanteda::stopwords("english"),
                      stem = TRUE, remove_punct = TRUE, remove_numbers = TRUE)
            DistMat = quanteda::textstat_simil(DFM, method="cosine")
            Distances = DistMat[lower.tri(DistMat)]
        } else {
            Distances = c(1) # If 1 or 0 reports, assign similarity of 1.
        }
        
        mean(Distances)
    }
    
    getAOMT = function(tm, pr) {
        active_team_members = analytics[team == tm & problem == pr & engagement_scaled > 0]$user
        return( median(parts[parts$user %in% active_team_members,]$aomt, na.rm = T) )
    }
    
    getDivAOMT = function(tm, pr) {
        active_team_members = analytics[team == tm & problem == pr & engagement_scaled > 0]$user
        scores = parts[parts$user %in% active_team_members,]$aomt
        # scores = scores[!is.na(scores)]
        # rval = mean(c(dist(scores)))
        n = length(scores) * (length(scores) - 1) / 2 # Number of unique pairs.
        rval = sum(dist(scores), na.rm = T) / n
        if (is.na(rval)) {
            rval = NA
        }
        return(rval)
    }
    
    getMedianEdu = function(tm, pr) {
        active_team_members = analytics[team == tm & problem == pr & engagement_scaled > 0]$user
        eds = parts[parts$user %in% active_team_members,]$education
        eds[eds == "High School"] = 1
        eds[eds == "Trade or Technical Qualification"] = 2
        eds[eds == "Bachelors"] = 3
        eds[eds == "Graduate Certificate, Diploma or equivalent"] = 4
        eds[eds == "Masters"] = 5
        eds[eds == "Phd"] = 6
        eds[eds == "Prefer not to say"] = NA
        eds = as.numeric(eds)
        
        return(median(eds, na.rm = T))
    }
    
    getNumFlawsDetected = function(tm) {
        rts = ratings[team == tm & problem == "Park Young-min Case",.(flaw1, flaw2, flaw3, flaw4)]
        rts[rts == "Yes"] = 1
        rts[rts == "No"] = 0

        flaw1 = round(mean(as.numeric(rts$flaw1)))
        flaw2 = round(mean(as.numeric(rts$flaw2)))
        flaw3 = round(mean(as.numeric(rts$flaw3)))
        flaw4 = round(mean(as.numeric(rts$flaw4)))

        return(flaw1 + flaw2 + flaw3 + flaw4)
    }
    
    getTightness = function(tm, k) {
        i = which(probteam$team == tm & probteam$problem == "Forecasting Piracy")
        team_prob = probteam$probabilityEstimate[k]
        rater_probs = ratings[team == tm & isRedactionTestRating == "Yes"]$raterProbabilityEstimate/100
        tightness = mean((rater_probs - team_prob)^2)
        return(tightness)
    }
    
    OTs = c("kosciuszko00219","otway00219","noosa00219","uluru00219","kakadu00219","grampians00219","daintree00219")
    STs = c("tongariro00311",
            "joondalup00311",
            "murramang00311",
            "warrumbungle00311",
            "aoraki00311")
    
    for (k in 1:nrow(probteam)) {
        i = which(K$team == probteam$team[k])
        if (probteam$team[k] %in% OTs) {
            probteam$type[k] = "OT"
        } else if (probteam$team[k] %in% STs) {
            probteam$type[k] = "ST"
        } else {
            probteam$type[k] = "PT"
        }
        probteam$avgIC[k] = K[[paste0("avg", probteam$probNum[k])]][i]
        probteam$nIC[k] = K[[paste0("nRatings", probteam$probNum[k])]][i]
        probteam$rankIC[k] = rank(-K[[paste0("avg", probteam$probNum[k])]], ties.method = "min")[i]
        if (probteam$problem[k] == "Foreign Fighters") {
            probteam$nGeoCorrect[k] = K$nGeoCorrect[i]
        }
        if (probteam$problem[k] == "Forecasting Piracy" & !is.na(probteam$avgIC[k])) {
            probteam$probabilityEstimate[k] = K$probabilityEstimate[i]/100
            probteam$tightness[k] = getTightness(probteam$team[k], k)
        }
        if (probteam$problem[k] == "Corporate Espionage" & !is.na(probteam$avgIC[k])) {
            probteam$nBayesCorrect[k] = round(mean(ratings[team == probteam$team[k] & problem == "Corporate Espionage"]$bayesScore))
        }
        if (probteam$problem[k] == "The Park Young-min Case" & !is.na(probteam$avgIC[k])) {
            probteam$nFlawsDetected[k] = getNumFlawsDetected(probteam$team[k])
            
        }
        probteam$activeUsersSq[k] = getActiveUsersSq(probteam$team[k], probteam$problem[k])
        probteam$textSim[k] = getTextSim(probteam$team[k], probteam$problem[k])
        probteam$AOMT[k] = getAOMT(probteam$team[k], probteam$problem[k])
        probteam$divAOMT[k] = getDivAOMT(probteam$team[k], probteam$problem[k])
        probteam$medianEdu[k] = getMedianEdu(probteam$team[k], probteam$problem[k])
    }
    
    probteam = probteam[!is.na(probteam$avgIC),]
    
    return(setDT(probteam))
}



compile_probteams = function(repo, path_to_data, instance_name) {
    
    # Lookup table for relevant functions. This is required because demographic surveys differ
    # syntactically across different experiements, and so each require custom code to tidy the
    # data into a consistent format.
    compile_probteams = list(
        "2018_SwarmChallengeExp1" = compile_probteams_2018_SwarmChallengeExp1,
        "2020_HuntChallenge" = compile_probteams_2020_HuntChallenge
    )
    
    if (instance_name %in% names(compile_probteams)) {
        return(compile_probteams[[instance_name]](repo, path_to_data, instance_name))
    } else {
        return(NULL)
    }
}

compile_probparts = function(repo, nClusters, generatePlots = F) {
    
    set.seed(5678)
    
    anal = repo[[1]]$PlatformData$analytics
    anal$probteam = NA
    anal$teamFinished = NA
    anal = anal[0,]
    
    for (nm in names(repo)) {
        analytics = repo[[nm]]$PlatformData$analytics
        probteams = repo[[nm]]$CoreData$probteams
        
        analytics$probteam = paste0(analytics$team, analytics$problem)
        probteams$probteam = paste0(probteams$team, probteams$problem)
        
        teamFinished = function(pt) {
            return(pt %in% probteams$probteam)
        }
        analytics$teamFinished = sapply(analytics$probteam, teamFinished)
        analytics = analytics[analytics$teamFinished,]
        
        anal = rbind(anal, analytics)
    }
    
    # Select contributions for each user instance.
    anal = anal %>%
        dplyr::select(team, problem, user, report_count, resource_count, comment_count, vote_count,
               quick_rating, complete_rating, chat_count)
    
    # Remove outliers: artificially capping chat counts to 100 so they don't cause outliers.
    anal[anal$chat_count >= 100,]$chat_count = 100
    
    # Scale data to a mean of 0 and a standard dev of 1 (relativates high number of chat messages etc.)
    scanal = apply(anal[, 4:10], 2, function(x) {(x-mean(x))/sd(x)})
    scanal = cbind(anal[,1:3], scanal)
    
    # Get Euclidean distances 
    d = dist(scanal[, 4:10]) 
    
    # Consult multiple criteria to decide on number of clusters (commented out because takes longer).
    # nc = NbClust::NbClust(scanal[,4:10], distance = "euclidean", min.nc = 2, max.nc = 15, method = "ward.D")
    # table(nc$Best.nc[1,])
    # We want a bit of distinction so we look for larger number of clusters
    # Try 10 (3 criteria)
    
    # Run hierarchical clustering with Ward method to determine the centers
    fit.ward = hclust(d, method = "ward.D")
    clusters = cutree(fit.ward, k = nClusters) # ward results are much more promising
    
    # Plot dendrogram.
    if (generatePlots) {
        plot(fit.ward, hang = -1, cex = 0.6, main = "Ward Linkage Clustering\n10 Cluster Solution")
        rect.hclust(fit.ward, k = nClusters)
    }
    centers = aggregate(scanal[,4:10], list(clusters), median)
    
    # Test hierarchical with silhouette method.
    sil = cluster::silhouette(clusters, d)
    # Nice visualisation of the silhouette width.
    p = factoextra::fviz_silhouette(sil, print.summary = FALSE) +
        theme_minimal()+
        theme(axis.text.x = element_blank(), axis.ticks.x = element_blank())
    if (generatePlots) {
        print(p)
    }
    
    # Now use centers as starting points for k-means clustering.
    set.seed(42)
    fit.km = kmeans(scanal[,4:10], centers = centers[, 2:8], nstart = 1)
    
    # Silhouette width now increased to 0.3
    sil = cluster::silhouette(fit.km$cluster, d)
    p = factoextra::fviz_silhouette(sil, print.summary = FALSE) +
        theme_minimal()+
        theme(axis.text.x = element_blank(), axis.ticks.x = element_blank())  
    if (generatePlots) {
        print(p)
    }
    
    # Stripcharts for k-means: 
    anal[['cluster']] = factor(fit.km$cluster)
    anal[['clusterLabel']] = character(nrow(anal))
    anal[anal$cluster == 1,]$clusterLabel = 'Talkative Multi-talent (Tier 2)'
    anal[anal$cluster == 2,]$clusterLabel = 'Talkative Multi-talent (Tier 1)' # 'Slow-rating Multi-talent (Tier 1)'
    anal[anal$cluster == 3,]$clusterLabel = 'Resource Guru' # 'Speed-rating Multi-talent (Tier 1)'
    anal[anal$cluster == 4,]$clusterLabel = 'Speed-rating Multi-talent (Tier 1)' # 'Allrounder (Tier 1)'
    anal[anal$cluster == 5,]$clusterLabel = 'Report Guru' # 'Slow-rating Multi-talent (Tier 2)'
    anal[anal$cluster == 6,]$clusterLabel = 'Allrounder' # 'Report Guru'
    anal[anal$cluster == 7,]$clusterLabel = 'Slow-rating Multi-talent (Tier 1)' # 'Allrounder (Tier 2)'
    anal[anal$cluster == 8,]$clusterLabel = 'Drop In' # 'Speed-rating Multi-talent (Tier 2)'
    anal[anal$cluster == 9,]$clusterLabel = 'Speed-rating Multi-talent (Tier 2)' # 'Single-minded Raters'
    anal[anal$cluster == 10,]$clusterLabel = 'Slow-rating Multi-talent (Tier 2)' # 'Drop In'
    
    D = anal
    for (cn in colnames(D)[4:10]) {
        D[[cn]] = D[[cn]]/max(D[[cn]])
    }
    D = melt(D, id.vars = c("team","problem","user","cluster","clusterLabel"))
    P = list()
    for (p in 1:10) {
        P[[p]] = ggplot(D[D$cluster == p,], aes(x = variable, y = value)) +
            geom_jitter(aes(colour = variable), alpha = 0.3) + ylim(0,1) +
            coord_flip() +
            guides(color = FALSE) +
            theme_linedraw() +
            labs(x = "",
                 y = "Percentile",
                 title = paste("Cluster", p),
                 subtitle = D[D$cluster == p,]$clusterLabel[1]) +
            theme(panel.grid.major = element_blank(), panel.grid.minor.y = element_line(colour="grey", size=0.2))
    }
    pw = P[[1]] + P[[2]] + P[[3]] + P[[4]] + P[[5]] + P[[6]] + P[[7]] + P[[8]] + P[[9]] + P[[10]]
    
    if (generatePlots) {
        ggexport(pw,
                 filename = "Cluster Overview.png",
                 width = 4181,
                 height = 2000,
                 pointsize = 11,
                 res = 300)
        message(paste0("Exported 'Cluster Overview.png'"))
    }
    
    # Create probparts tables.
    for (nm in names(repo)) {
        probparts = repo[[nm]]$PlatformData$analytics
        probparts$cluster = NA
        probparts$clusterLabel = NA
        
        for (k in 1:nrow(probparts)) {
            i = which((anal$problem == probparts$problem[k]) & (anal$user == probparts$user[k]))[1]
            probparts$cluster[k] = as.character(anal$cluster[i])
            probparts$clusterLabel[k] = as.character(anal$clusterLabel[i])
        }
        
        probparts$team_id = NULL
        probparts$problem_id = NULL
        probparts$user_id = NULL
        
        repo[[nm]]$CoreData$probparts = probparts
    }
    
    return(repo)
}

compile_rates_2020_HuntChallenge = function(repo, path_to_data, instance_name) {
    
    path = paste0(path_to_data, instance_name, "/KnackData/")
    
    ratings = fread(paste0(path, "ratings2020challenge.csv"))
    colnames(ratings) = c(
        "reportID",
        "password1",
        "password2",
        "password3",
        "problem",
        "team",
        "participant",
        "created",
        "rater",
        "c1", "c1comment", "c1distinction",
        "c2", "c2comment", "c2distinction",
        "c3", "c3distinction", "c3comment",
        "c4", "c4comment",
        "c5", "c5comment",
        "c6", "c6comment",
        "c7", "c7comment",
        "c8",
        "geo1",
        "geo2",
        "geo3",
        "geo4",
        "c8comment",
        "c1score",
        "c2score",
        "c3score",
        "c4score",
        "c5score",
        "c6score",
        "c7score",
        "c8score",
        "IC",
        "c1na",
        "c2na",
        "c3na",
        "c4na",
        "c5na",
        "c6na",
        "c7na",
        "c8na",
        "ruleBased",
        "ruleBasedScore",
        "ruleBaseAlexAns",
        "c4distinction",
        "c5distinction",
        "c6distinction",
        "c7distinction",
        "c8distinction",
        "lensKit",
        "geo1score",
        "geo2score",
        "geo3score",
        "geo4score",
        "geoOverall",
        "isRedactionTestRating",
        "raterProbabilityEstimate",
        "estTimeTaken",
        "estJustification",
        "estComments",
        "bayes1",
        "bayes2",
        "bayes3",
        "bayes1score",
        "bayes2score",
        "bayes3score",
        "flaw1",
        "flaw2",
        "flaw3",
        "flaw4"
    )
    ratings[ratings == ""] = NA
    ratings[IC == 0,"IC"] = NA
    ratings = ratings[,.(
        problem,
        team,
        rater,
        c1, c1comment,
        c2, c2comment,
        c3, c3comment,
        c4, c4comment,
        c5, c5comment,
        c6, c6comment,
        c7, c7comment,
        c8, c8comment,
        geo1,
        geo2,
        geo3,
        geo4,
        IC,
        geo1score,
        geo2score,
        geo3score,
        geo4score,
        geoOverall,
        isRedactionTestRating,
        raterProbabilityEstimate,
        estTimeTaken,
        estJustification,
        estComments,
        bayes1,
        bayes2,
        bayes3,
        bayes1score,
        bayes2score,
        bayes3score,
        flaw1,
        flaw2,
        flaw3,
        flaw4
    )]
    
    ratings$raterProbabilityEstimate = ratings$raterProbabilityEstimate/100
    
    return(ratings)
}

compile_rates = function(repo, path_to_data, instance_name) {
    
    # Lookup table for relevant functions. This is required because ratings format differ
    # syntactically across different experiements, and so each require custom code to tidy the
    # data into a consistent format.
    compile_rates = list(
        "2020_HuntChallenge" = compile_rates_2020_HuntChallenge
    )
    
    if (instance_name %in% names(compile_rates)) {
        return(compile_rates[[instance_name]](repo, path_to_data, instance_name))
    } else {
        return(NULL)
    }
}

#' Compile data from 'raw' SWARM, Qualtrics & Knack CSVs
#'
#' \code{compile_data} Compiles data from 'raw' CSVs exported from the various
#' platforms used (SWARM, Qualtrics, Knack) for the Hunt Challenge 2020,
#' and saves tidied versions of them to the package data file, overwriting any
#' that were already saved.
#'
#' Use this function to refresh the tidied versions of the data whenever the
#' raw data is updated.
#'
#' @export
#' 
#' @examples
#' \dontrun{
#' # (re-)compile data
#' compile_data()
#' }
compile_data = function(path = "data/",
                        use_previous_redactions = TRUE,
                        redaction_patterns = c()) {
    
    require(dplyr)
    require(data.table)
    
    instances = c(
        '2020_HuntChallenge',
        '2018_SwarmChallengeExp1'
    )
    
    # Initialise repo list.
    repo = list()
    for (instance_name in instances) {
        repo[[instance_name]] = list()
    }
    
    # Populate repo with platform data.
    for (instance_name in instances) {
        repo[[instance_name]][['PlatformData']] = fetchPlatformData(path, instance_name)
    }
    
    # Compile useful tables.
    for (instance_name in instances) {
        repo[[instance_name]][['CoreData']] = list()
        repo[[instance_name]][['CoreData']]$parts = compile_parts(path, instance_name)
        repo[[instance_name]][['CoreData']]$teamparts = compile_teamparts(repo, path, instance_name)
        repo[[instance_name]][['CoreData']]$teams = compile_teams(repo, path, instance_name)
        repo[[instance_name]][['CoreData']]$probteams = compile_probteams(repo, path, instance_name)
        repo[[instance_name]][['CoreData']]$rates = compile_rates(repo, path, instance_name)
    }
    repo = compile_probparts(repo, nClusters = 10)
    
    # Reorder folders.
    for (instance_name in instances) {
        repo[[instance_name]] = list(
            CoreData = repo[[instance_name]][['CoreData']],
            PlatformData = repo[[instance_name]][['PlatformData']]
        )
    }
    
    if (use_previous_redactions) {
        repo = apply_previous_redactions(
            repo,
            instances = c('2020_HuntChallenge'),
            path = 'experiment-data'
        )
    } else {
        patterns = c(redaction_patterns,
                 'phone number', 'my number is',
                 "[[:alnum:]._-]+@[[:alnum:].-]+", # basic regex for email addresses
                 "(^| |\\+)[0-9]{3,}( |-)[0-9]{3}( |-)[0-9]{3}( |$)"    # basic regex for phone numbers
                 )
        repo = run_PII_redaction_session(
            repo,
            patterns,
            c('2020_HuntChallenge'),
            path = 'experiment-data'
        )
    }
    
    
    # Anonymise real names of raters.
    for (instance_name in instances) {
        if ('rates' %in% names(repo[[instance_name]]$CoreData)) {
            rates = repo[[instance_name]]$CoreData$rates
            rates$rater = as.integer(factor(rates$rater))
            repo[[instance_name]]$CoreData$rates$rater = rates$rater
        }
    }
    
    # Save copy of 'tidy' repo version to experiment-data repository.
    export_repo_to_CSV(repo, 'tidy')
    
    # Remove columns that contain free-text user input.
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
        fldrs = names(repo[[instance_name]])
        for (fldr in fldrs) {
            tbls = names(repo[[instance_name]][[fldr]])
            for (tbl in tbls) {
                cols = names(repo[[instance_name]][[fldr]][[tbl]])
                for (user_input_col in user_input_cols) {
                    if (user_input_col %in% cols) {
                        repo[[instance_name]][[fldr]][[tbl]][[user_input_col]] = NULL
                    }
                }
            }
        }
    }
    
    # Save 'noPII' repo version to experiment-data repository.
    export_repo_to_CSV(repo, 'noPII')
    
    # Save compiled data to package, tidy environment, and reload the package.
    save(repo,
         file="huntr/data/repo.RData")
    remove(repo)
    message("Reloading package...")
    devtools::load_all("huntr")
    
}
