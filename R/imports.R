
# Compile Data ------------------------------------------------------------

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

    # LOAD PLATFORM DATA
    
    platform_path = paste0(path, "PlatformData/HC2020/")
    
    problems  <- fread(paste0(platform_path, "problems/problems.csv"))
    responses <- fread(paste0(platform_path, "responses/responses.csv"))
    authors   <- fread(paste0(platform_path, "authors/authors.csv"))
    relations <- fread(paste0(platform_path, "relations/relations.csv"))
    analytics <- fread(paste0(platform_path, "analytics/analytics.csv"))
    timeline  <- fread(paste0(platform_path, "timeline/timeline.csv"))
    
    responses$problem = rep(NA, nrow(responses))
    for (k in 1:nrow(responses)) {
        responses$problem[k] = problems[problem_id == responses$problem_id[k]]$problem_title
    }
    responses[responses == "Problem #1 - Foreign Fighters"] = "Foreign Fighters"
    responses[responses == "Problem #2 - Forecasting Piracy"] = "Forecasting Piracy"
    
    as = c("report_count",
          "resource_count",
          "comment_count",
          "chat_count",
          "comment_vote_count",
          "resource_vote_count",
          "simple_rating",
          "partial_rating",
          "complete_rating")
    normalise<-function(x){(x-min(x,na.rm=T))/(max(x,na.rm=T)-min(x,na.rm=T))}
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
    analytics[analytics == "Problem #1 - Foreign Fighters"] = "Foreign Fighters"
    analytics[analytics == "Problem #2 - Forecasting Piracy"] = "Forecasting Piracy"
    
    
    
    # LOAD (and tidy) QUALTRICS DATA
    
    qualtrics_path <- paste0(path, "QualtricsData/")
    
    entrySurveyPub = fread(paste0(qualtrics_path, "HC2020_EntrySurvey_Public.csv"))
    entrySurveyOrg = fread(paste0(qualtrics_path, "HC2020_EntrySurvey_Organisations.csv"))
    
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
                                  "gaveConsent1", # Problem Solving in Online Groups
                                  "nickname",
                                  "email",
                                  "agreedToTerms",
                                  
                                  "interests",
                                  "interestsOtherInput",
                                  
                                  "exp1", # InterestingProblems
                                  "exp2", # TimeCommitment
                                  "exp3", # DifficultProblems
                                  "exp4", # LearnSkills
                                  "exp5", # AchievableProblems
                                  "exp6", # ProductivePlatform
                                  "exp7", # AnalyticalTraining
                                  "exp8", # PositiveExperience
                                  "exp9", # EffectiveCollaboration
                                  "exp10", # ApplicableToWork
                                  
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
                       "gaveConsent2", # Identifying and Rating Quality of Reasoning
                       
                       "interests",
                       "interestsOtherInput",
                       
                       "exp1", # InterestingProblems
                       "exp2", # TimeCommitment
                       "exp3", # DifficultProblems
                       "exp4", # LearnSkills
                       "exp5", # AchievableProblems
                       "exp6", # ProductivePlatform
                       "exp7", # AnalyticalTraining
                       "exp8", # PositiveExperience
                       "exp9", # EffectiveCollaboration
                       "exp10", # ApplicableToWork
                       
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
    
    expOpts = list(
        "I don't expect this" = 1,
        "Neutral" = 1,
        "I do expect this" = 2
    )
    
    ES[,`:=`(progress = as.numeric(progress),
             finished = (finished == "True"),
             gaveConsent1 = (gaveConsent1 == "Yes"),
             gaveConsent2 = (gaveConsent2 == "Yes"),
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
        gaveConsent1,
        gaveConsent2,
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
    
    orgs = fread(paste0(path,"OtherData/OrgMaster.csv"))
    
    for (k in 1:nrow(ES)) {
        if (ES$isOrg[k]) {
            team = orgs$group_code[which(orgs$username == ES$user[k])][1]
            ES$team[k] = team
        }
    }
    
    ES <- ES[finished & ((gaveConsent2 == TRUE) | is.na(gaveConsent2))]
    ES = ES[!is.na(ES$user)]
    ES = as.data.frame(ES)
    
    # Compute AOMT
    
    ################################################################################
    # Score tests with Likert scales
    
    # helper function: reverse-score a single column
    # if a likert column with vals 1-5  is scored in reverse, then a 5 becomes a 1,
    # a 4 becomes a 2, etc. So in this example the reverse-scored value is 6 minus 
    # the original value. Generally, it's (max_value + 1) - original .
    reverse_score_column <- function(column_vector, max_val, reverse=FALSE){
        if (reverse==FALSE) {
            return(column_vector)
        } else {
            return((max_val + 1) - column_vector)
        }
    }
    
    # score the whole psychological scale at once by specifying which columns are
    # reverse-scored (FALSE means don't reverse), and the max value of each column
    score_likert_scale <- function(my_df, scale_col_names, 
                                   scale_maxes, scale_reverses){
        mask <- mapply(reverse_score_column, 
                       my_df[, scale_col_names], 
                       scale_maxes, scale_reverses)
        final_score <- rowSums(mask, na.rm = TRUE)
        return(final_score)
    }
    
    # Score the Actively Open-Minded Thinking Test
    aomt_colnames <- grep("aomt", names(ES), value=T, fixed=T)
    aomt_max_vec <- rep(max(ES[, aomt_colnames], na.rm=T), length(aomt_colnames))
    aomt_reverse_vec <- c(FALSE, FALSE, FALSE, TRUE, TRUE, TRUE,
                          TRUE, FALSE, TRUE, FALSE, FALSE)
    ES$aomt = score_likert_scale(ES,
                                 aomt_colnames,
                                 aomt_max_vec,
                                 aomt_reverse_vec)

    # LOAD KNACK DATA
    
    K <- as.data.frame(fread(paste0(path, "KnackData/teams2020challenge.csv")))
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
    
    # Create teams table.
    
    tms = unique(ES$team)
    teams = data.frame(team = tms,
                       AOMT = NA,
                       divAOMT = NA,
                       medianEdu = NA,
                       isOrg = NA)
    
    getDivAOMT = function(tm) {
        scores = ES[ES$team == tm,]$aomt
        scores = scores[!is.na(scores)]
        return(mean(c(dist(scores))))
    }
    
    getMedianEdu = function(tm) {
        eds = ES[ES$team == tm,]$education
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
        teams$AOMT[k] = median(ES[ES$team == teams$team[k],]$aomt, na.rm = T)
        teams$divAOMT[k] = getDivAOMT(teams$team[k])
        teams$medianEdu[k] = getMedianEdu(teams$team[k])
        teams$isOrg[k] = ES[ES$team == teams$team[k],]$isOrg[1]
    }
    
    
    
    
    # Create probteam table.
    
    problems = c("Foreign Fighters", "Forecasting Piracy")
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
        team_members = analytics[teamName == tm & title == pr]
        nActive = sum(team_members$engagement_normed > 0)
        nActiveSq = nActive ^ 2
    }
    
    getTextSim = function(tm, pr) {
        file_names = responses[team_name == tm & problem == pr & response_type == "report"]$response_text
        
        if (length(file_names) > 1) {
            reports = suppressWarnings(readtext(paste0(platform_path,"responses/text/",file_names[1])))  # surpress "*.md" warnings
            
            for (j in 2:length(file_names)) {
                reports = rbind(reports, suppressWarnings(readtext(paste0(platform_path,"responses/text/",file_names[j]))))
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
    
    # Rename ES to parts (participants).
    parts = ES
    
    save(problems,
         responses,
         authors,
         relations,
         analytics,
         timeline,
         parts,
         teams,
         probteam,
         file="HuntLab/R/sysdata.rda")
    remove(problems,
           responses,
           authors,
           relations,
           analytics,
           timeline,
           ES,
           K,
           parts,
           teams,
           probteam)
    
    message("Reloading package...")
    devtools::load_all("HuntLab")
    
}












