
# Compile Data ------------------------------------------------------------

tidyProblemNames = function(dt) {
    dt[dt == "Problem #1 - Foreign Fighters"] = "Foreign Fighters"
    dt[dt == "Problem #2 - Forecasting Piracy"] = "Forecasting Piracy"
    return(dt)
}

addNormalisedEngagementMetrics = function(analytics) {
    as = c("report_count",
           "resource_count",
           "comment_count",
           "chat_count",
           "comment_vote_count",
           "resource_vote_count",
           "simple_rating",
           "partial_rating",
           "complete_rating")
    normalise = function(x) {
        ( x - min(x, na.rm = T) ) / ( max(x, na.rm = T) - min(x, na.rm = T ) )
    }
    for (a in as) {
        analytics[[paste0(a,"_normed")]] = normalise(analytics[[a]])
    }
    analytics$engagement_normed = 7*analytics$report_count_normed +
        3*analytics$resource_count_normed +
        3*analytics$complete_rating_normed +
        2*analytics$comment_count_normed + 
        analytics$chat_count_normed +
        analytics$simple_rating_normed +
        analytics$partial_rating_normed +
        analytics$comment_vote_count_normed +
        analytics$resource_vote_count_normed
    
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
    setnames(instance_data$top_reports, "title", "problem")
    setnames(instance_data$analytics, "title", "problem")
    setnames(instance_data$relations, "title", "problem")
    setnames(instance_data$timeline, "title", "problem")
    setnames(instance_data$timeline, "tipe", "type")
    setnames(instance_data$top_reports, "team_name", "team")
    setnames(instance_data$responses, "team_name", "team")
    setnames(instance_data$authors, "team_name", "team")
    setnames(instance_data$comments, "team_name", "team")
    setnames(instance_data$analytics, "teamName", "team")
    setnames(instance_data$relations, "teamName", "team")
    setnames(instance_data$timeline, "teamName", "team")
    setnames(instance_data$login, "userName", "user")
    setnames(instance_data$analytics, "userName", "user")
    setnames(instance_data$relations, "userName", "user")
    setnames(instance_data$timeline, "userName", "user")
    
    # Add problem title as variable to tables that only have problem ID.
    for (table_name in c("responses", "authors", "comments", "ratings", "chat")) {
        setDT(instance_data[[table_name]])[instance_data$problems, problem := i.problem, on = c(problem_id = "problem_id")]
    }
    
    # Tidy problem names.
    for (table_name in c("responses", "analytics")) {
        instance_data[[table_name]] = tidyProblemNames(instance_data[[table_name]])
        
    }
    
    # Add normalised engagement metrics to analytics table.
    instance_data$analytics = addNormalisedEngagementMetrics(instance_data$analytics)
    
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
    final_score = rowSums(mask, na.rm = TRUE)
    return(final_score)
}

computeAOMT = function(dt) {
    aomt_colnames = grep("aomt", names(dt), value=T, fixed=T)
    aomt_max_vec = rep(max(dt[, aomt_colnames], na.rm=T), length(aomt_colnames))
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
    ES$team = NA
    ES$type = NA
    
    # Reorder columns.
    ES = ES[,.(
        responseID,
        progress,
        finished,
        type,
        
        user,
        team,
        
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
            ES$team[k] = lookup$Team[i]
            ES$type[k] = lookup$Type.x[i]
        }
    }
    
    ES <- ES[ES$finished]
    ES = ES[!is.na(ES$user)]
    ES = as.data.frame(ES)
    
    # Compute AOMT construct.
    ES = computeAOMT(ES)
    
    return(ES)
}

compile_parts_2020_HuntChallenge = function(path_to_data, instance_name) {
    path = paste0(path_to_data, instance_name, '/QualtricsData/')
    
    entrySurveyPub = fread(paste0(path, "HC2020_EntrySurvey_Public.csv"))
    entrySurveyOrg = fread(paste0(path, "HC2020_EntrySurvey_Organisations.csv"))
    
    entrySurveyPub = entrySurveyPub[3:nrow(entrySurveyPub)]
    entrySurveyOrg = entrySurveyOrg[3:nrow(entrySurveyOrg)]
    
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
                                  
                                  "expct1", # InterestingProblems
                                  "expct2", # TimeCommitment
                                  "expct3", # DifficultProblems
                                  "expct4", # LearnSkills
                                  "expct5", # AchievableProblems
                                  "expct6", # ProductivePlatform
                                  "expct7", # AnalyticalTraining
                                  "expct8", # PositiveExperience
                                  "expct9", # EffectiveCollaboration
                                  "expct10", # ApplicableToWork
                                  
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
                                  
                                  "cap1", # ReportWriting
                                  "cap2", # UsingSATs
                                  "cap3", # OSINT
                                  "cap4", # Frameworks
                                  "cap5", # Assumptions
                                  "cap6", # EvaluatingQoR
                                  "cap7", # DecisionMaking
                                  
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
                                  
                                  "expct1", # InterestingProblems
                                  "expct2", # TimeCommitment
                                  "expct3", # DifficultProblems
                                  "expct4", # LearnSkills
                                  "expct5", # AchievableProblems
                                  "expct6", # ProductivePlatform
                                  "expct7", # AnalyticalTraining
                                  "expct8", # PositiveExperience
                                  "expct9", # EffectiveCollaboration
                                  "expct10", # ApplicableToWork
                                  
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
                                  
                                  "cap1", # ReportWriting
                                  "cap2", # UsingSATs
                                  "cap3", # OSINT
                                  "cap4", # Frameworks
                                  "cap5", # Assumptions
                                  "cap6", # EvaluatingQoR
                                  "cap7", # DecisionMaking
                                  
                                  "hasMultidisciplinaryExperience",
                                  "multidisciplinaryExperienceInput"
    )
    
    entrySurveyPub$isOrg = FALSE;
    entrySurveyOrg$isOrg = TRUE;
    
    ES = rbind(entrySurveyPub,
               entrySurveyOrg,
               use.names = TRUE,
               fill = TRUE)
    
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
                      "email"
    )
    ES = ES[,!..colsToRemove]
    
    ES[ES == ""] <- NA
    
    ES[ES == "I don't expect this"] <- 1
    ES[ES == "Neutral"] <- 2
    ES[ES == "I do expect this"] <- 3
    
    ES[ES == "Not important"] <- 1
    ES[ES == "Important"] <- 2
    
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
    
    # REORDER COLUMNS
    ES = ES[, .(
        progress,
        finished,
        gaveConsent2,
        gaveConsent3,
        agreedToTerms,
        user,
        team,
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
        expct1,
        expct2,
        expct3,
        expct4,
        expct5,
        expct6,
        expct7,
        expct8,
        expct9,
        expct10,
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
        cap1,
        cap2,
        cap3,
        cap4,
        cap5,
        cap6,
        cap7,
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
    
    orgs = fread(paste0(path_to_data, instance_name, '/AdminData/OrgMaster.csv'))
    
    for (k in 1:nrow(ES)) {
        if (ES$isOrg[k]) {
            team = orgs$group_code[which(orgs$username == ES$user[k])][1]
            ES$team[k] = team
        }
    }
    
    ES <- ES[finished & ((gaveConsent3 == TRUE) | is.na(gaveConsent3))]
    ES = ES[!is.na(ES$user)]
    ES = as.data.frame(ES)
    
    # Compute AOMT construct.
    ES = computeAOMT(ES)
    
    return(ES)
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

compile_teams_2018_SwarmChallengeExp1 = function(repo, path_to_data, instance_name) {
    
    path = paste0(path_to_data, instance_name, "/KnackData/products.csv")
    
    K = as.data.frame(fread(path))
    colnames(K) <- c("reportCode",
                     "problem",
                     "nRatings",
                     "avgODNI",
                     "min",
                     "max",
                     "range",
                     "username",
                     "team_alt",
                     "team",
                     "week",
                     "submitted")
    
    parts = repo[[instance_name]]$OtherData$parts
    
    # Create teams table.
    
    tms = unique(parts$team)
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
    
    return(teams)
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
    
    parts = repo[[instance_name]]$OtherData$parts
    
    # Create teams table.
    
    tms = unique(parts$team)
    teams = data.frame(team = tms,
                       AOMT = NA,
                       divAOMT = NA,
                       medianEdu = NA,
                       isOrg = NA)
    
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
    
    for (k in 1:nrow(teams)) {
        teams$AOMT[k] = median(parts[parts$team == teams$team[k],]$aomt, na.rm = T)
        teams$divAOMT[k] = getDivAOMT(teams$team[k])
        teams$medianEdu[k] = getMedianEdu(teams$team[k])
        teams$isOrg[k] = parts[parts$team == teams$team[k],]$isOrg[1]
    }
    
    return(teams)
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
                     "avgODNI",
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
    
    parts = repo[[instance_name]]$OtherData$parts
    teams = repo[[instance_name]]$OtherData$teams
    tms = unique(parts$team)
    problems = c("How Did Arthur Allen Die?", "Kalukistan", "Three Nations", "Drug Interdiction")
    analytics = repo[[instance_name]]$PlatformData$analytics
    responses = repo[[instance_name]]$PlatformData$responses
    
    response_path = paste0(path_to_data,instance_name,"/PlatformData/responses/text/")
    
    probteam = data.frame(team = rep(tms, length(problems)),
                          problem = rep(problems, each = length(tms)),
                          probNum = NA,
                          type = NA,
                          avgODNI = NA,
                          nODNI = NA,
                          rankODNI = NA,
                          activeUsersSq = NA,
                          textSim = NA)
    
    getActiveUsersSq = function(tm, pr) {
        team_members = analytics[team == tm & problem == pr]
        nActive = sum(team_members$engagement_normed > 0)
        nActiveSq = nActive ^ 2
    }
    
    getTextSim = function(tm, pr) {
        file_names = responses[team == tm & problem == pr & response_type == "report"]$response_text
        
        if (length(file_names) > 1) {
            reports = suppressWarnings(readtext(paste0(response_path,file_names[1])))  # surpress "*.md" warnings
            
            for (j in 2:length(file_names)) {
                reports = rbind(reports, suppressWarnings(readtext(paste0(response_path,file_names[j]))))
            }
            
            CORPUS = corpus(reports)
            DFM = dfm(CORPUS,
                      remove = stopwords("english"),
                      stem = TRUE, remove_punct = TRUE, remove_numbers = TRUE)
            DistMat = textstat_simil(DFM, method="cosine")
            Distances = DistMat[lower.tri(DistMat)]
        } else {
            Distances = c(1) # If 1 or 0 reports, assign similarity of 1.
        }
        
        mean(Distances)
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
        probteam$avgODNI[k] = K$avgODNI[i]
        probteam$nODNI[k] = K$nRatings[i]
        probteam$rankODNI[k] = rank(-K[K$problem == probteam$problem[k] & nchar(K$team) > 0,]$avgODNI, ties.method = "min")[l]
        probteam$activeUsersSq[k] = getActiveUsersSq(probteam$team[k], probteam$problem[k])
        probteam$textSim[k] = getTextSim(probteam$team[k], probteam$problem[k])
    }
    
    probteam = probteam[!is.na(probteam$avgODNI),]
    
    return(probteam)
}

compile_probteams_2020_HuntChallenge = function(repo, path_to_data, instance_name) {
    
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
    
    parts = repo[[instance_name]]$OtherData$parts
    teams = repo[[instance_name]]$OtherData$teams
    tms = unique(parts$team)
    problems = c("Foreign Fighters", "Forecasting Piracy")
    analytics = repo[[instance_name]]$PlatformData$analytics
    responses = repo[[instance_name]]$PlatformData$responses
    
    response_path = paste0(path_to_data,instance_name,"/PlatformData/responses/text/")
    
    probteam = data.frame(team = rep(tms, length(problems)),
                          problem = rep(problems, each = length(tms)),
                          probNum = rep(1:length(problems), each = length(tms)),
                          type = NA,
                          avgODNI = NA,
                          nODNI = NA,
                          rankODNI = NA,
                          nGeoCorrect = NA,
                          activeUsersSq = NA,
                          textSim = NA)
    
    getActiveUsersSq = function(tm, pr) {
        team_members = analytics[team == tm & problem == pr]
        nActive = sum(team_members$engagement_normed > 0)
        nActiveSq = nActive ^ 2
    }
    
    getTextSim = function(tm, pr) {
        file_names = responses[team == tm & problem == pr & response_type == "report"]$response_text
        
        if (length(file_names) > 1) {
            reports = suppressWarnings(readtext(paste0(response_path,file_names[1])))  # surpress "*.md" warnings
            
            for (j in 2:length(file_names)) {
                reports = rbind(reports, suppressWarnings(readtext(paste0(response_path,file_names[j]))))
            }
            
            CORPUS = corpus(reports)
            DFM = dfm(CORPUS,
                      remove = stopwords("english"),
                      stem = TRUE, remove_punct = TRUE, remove_numbers = TRUE)
            DistMat = textstat_simil(DFM, method="cosine")
            Distances = DistMat[lower.tri(DistMat)]
        } else {
            Distances = c(1) # If 1 or 0 reports, assign similarity of 1.
        }
        
        mean(Distances)
    }
    
    orgTeams = c("kosciuszko00219","otway00219","noosa00219","uluru00219","kakadu00219","grampians00219","daintree00219")
    
    for (k in 1:nrow(probteam)) {
        i = which(K$team == probteam$team[k])
        if (probteam$team[k] %in% orgTeams) {
            probteam$type[k] = "OT"
        } else {
            probteam$type[k] = "PT"
        }
        probteam$avgODNI[k] = K[[paste0("avg", probteam$probNum[k])]][i]
        probteam$nODNI[k] = K[[paste0("nRatings", probteam$probNum[k])]][i]
        probteam$rankODNI[k] = rank(-K[[paste0("avg", probteam$probNum[k])]], ties.method = "min")[i]
        if (probteam$problem[k] == "Foreign Fighters") {
            probteam$nGeoCorrect[k] = K$nGeoCorrect[i]
        }
        probteam$activeUsersSq[k] = getActiveUsersSq(probteam$team[k], probteam$problem[k])
        probteam$textSim[k] = getTextSim(probteam$team[k], probteam$problem[k])
    }
    
    return(probteam)
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
        dt = 
            return(compile_probteams[[instance_name]](repo, path_to_data, instance_name))
    } else {
        return(NULL)
    }
}

compile_probparts = function(repo, nClusters, generatePlots = F) {
    
    anal = repo[[1]]$PlatformData$analytics
    anal$probteam = NA
    anal$teamFinished = NA
    anal = anal[0,]
    
    for (nm in names(repo)) {
        analytics = repo[[nm]]$PlatformData$analytics
        probteams = repo[[nm]]$OtherData$probteams
        
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
        select(team, problem, user, report_count, resource_count, comment_count, vote_count,
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
    p = fviz_silhouette(sil, print.summary = FALSE) +
        theme_minimal()+
        theme(axis.text.x = element_blank(), axis.ticks.x = element_blank())
    if (generatePlots) {
        print(p)
    }
    
    # Now use centers as starting points for k-means clustering.
    set.seed(42)
    fit.km = kmeans(scanal[,4:10], centers = centers[, 2:8], nstart = 1)
    
    # Silhouette width now increased to 0.3
    sil = silhouette(fit.km$cluster, d)
    p = fviz_silhouette(sil, print.summary = FALSE) +
        theme_minimal()+
        theme(axis.text.x = element_blank(), axis.ticks.x = element_blank())  
    if (generatePlots) {
        print(p)
    }
    
    # Stripcharts for k-means: 
    anal[['cluster']] = factor(fit.km$cluster)
    anal[['clusterLabel']] = character(nrow(anal))
    anal[anal$cluster == 1,]$clusterLabel = 'Talkative Multi-talent'
    anal[anal$cluster == 2,]$clusterLabel = 'Slow-rating Multi-talent (Tier 1)'
    anal[anal$cluster == 3,]$clusterLabel = 'Speed-rating Multi-talent (Tier 1)'
    anal[anal$cluster == 4,]$clusterLabel = 'Allrounder (Tier 1)'
    anal[anal$cluster == 5,]$clusterLabel = 'Slow-rating Multi-talent (Tier 2)'
    anal[anal$cluster == 6,]$clusterLabel = 'Report Guru'
    anal[anal$cluster == 7,]$clusterLabel = 'Allrounder (Tier 2)'
    anal[anal$cluster == 8,]$clusterLabel = 'Speed-rating Multi-talent (Tier 2)'
    anal[anal$cluster == 9,]$clusterLabel = 'Single-minded Raters'
    anal[anal$cluster == 10,]$clusterLabel = 'Drop In'
    
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
                 subtitle = D[cluster == p]$clusterLabel[1]) +
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
        
        repo[[nm]]$OtherData$probparts = probparts
    }
    
    return(repo)
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
compile_data = function(path = "data/") {
    
    require(data.table)
    
    instances = list.files(path)
    
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
        repo[[instance_name]][['OtherData']] = list()
        repo[[instance_name]][['OtherData']]$parts = compile_parts(path, instance_name)
        repo[[instance_name]][['OtherData']]$teams = compile_teams(repo, path, instance_name)
        repo[[instance_name]][['OtherData']]$probteams = compile_probteams(repo, path, instance_name)
    }
    repo = compile_probparts(repo, nClusters = 10)
    
    # Save compiled data to package, tidy environment, and reload the package.
    save(repo,
         file="huntr/data/repo.RData")
    remove(repo)
    message("Reloading package...")
    devtools::load_all("huntr")
    
}






