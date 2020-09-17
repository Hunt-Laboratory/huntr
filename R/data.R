#' analytics
#'
#' In this table we capture how many reports, resources, comments, resource_votes, comment_votes, single, partial or full ratings and chat messages each user makes for a specific problem in a specific group in one handy analytics file. We also calculate an engagement level. Engagement is measured by assigning 7 points for a report, 4 points for a resource, 3 points for a complete rating, 2 points for a comment, on point for a chat message, a single or partial rating or a comment vote.
#'
#' @format
 #'\describe{
#'   \item{team}{Name of team the user is in}
#'   \item{team_id}{Unique identifier of the team the user is in}
#'   \item{problem_id}{Unique identifier of the problem the team is working on}
#'   \item{user}{Name of user}
#'   \item{user_id}{Unique identifier of user}
#'   \item{report_count}{Number of reports user contributed to problem}
#'   \item{resource_count}{Number of resources user contributed to problem}
#'   \item{comment_count}{Number of comments user contributed in a problem}
#'   \item{chat_count}{Number of chat messages user contributed in a problem}
#'   \item{comment_vote_count}{Number of comment upvotes user contributed in a problem}
#'   \item{resource_vote_count}{Number of resource upvotes user contributed in a problem}
#'   \item{simple_rating}{Number of times a user contributed a simple (single number) rating}
#'   \item{partial_rating}{Number of times a user contributed a partial (some of the rubrics) rating}
#'   \item{complete_rating}{Number of times a user contributed a complete (all rubrics) rating}
#'   \item{problem}{Title of the problem}
#'   \item{engagement}{Engagement score calculated as a weighted sum of the various activity counts for the user on this problem. Reports have weight 7; resources and complete ratings have weight 3; comments have weight 2; chat messages, simple ratings, partial ratings, comment votes and resource votes have weight 1.}
#'   \item{report_count_scaled}{Number of reports user contributed to problem, scaled (within this platform instance) to range between 0 and 1}
#'   \item{resource_count_scaled}{Number of resources user contributed to problem, scaled (within this platform instance) to range between 0 and 1}
#'   \item{comment_count_scaled}{Number of comments user contributed in a problem, scaled (within this platform instance) to range between 0 and 1}
#'   \item{chat_count_scaled}{Number of chat messages user contributed in a problem, scaled (within this platform instance) to range between 0 and 1}
#'   \item{comment_vote_count_scaled}{Number of comment upvotes user contributed in a problem, scaled (within this platform instance) to range between 0 and 1}
#'   \item{resource_vote_count_scaled}{Number of resource upvotes user contributed in a problem, scaled (within this platform instance) to range between 0 and 1}
#'   \item{simple_rating_scaled}{Number of times a user contributed a simple (single number) rating, scaled (within this platform instance) to range between 0 and 1}
#'   \item{partial_rating_scaled}{Number of times a user contributed a partial (some of the rubrics) rating, scaled (within this platform instance) to range between 0 and 1}
#'   \item{complete_rating_scaled}{Number of times a user contributed a complete (all rubrics) rating, scaled (within this platform instance) to range between 0 and 1}
#'   \item{engagement_scaled}{Engagement score calculated as a weighted sum of the various scaled activity counts for the user on this problem. Reports have weight 7; resources and complete ratings have weight 3; comments have weight 2; chat messages, simple ratings, partial ratings, comment votes and resource votes have weight 1.}
#'   \item{vote_count}{comment_vote_count + resource_vote_count}
#'   \item{quick_rating}{simple_rating + partial_rating}
#' }
#'
#' @name analytics
NULL

#' authors
#'
#' Responses (i.e. reports or ""resources"") can have multiple authors.  This table captures the authors of responses.
#'
#' @format
 #'\describe{
#'   \item{problem_id}{Unique identifier of the problem}
#'   \item{team_id}{Unique identifier for the team that produced the report}
#'   \item{team}{Name of the team that produced the report}
#'   \item{response_id}{Unique identifier for the a response}
#'   \item{user_id}{Unique identifier of a user who (co-)authored the response}
#'   \item{user}{The screen name of the (co-)author (at the time of response or comment creation)}
#'   \item{problem}{Short title of the problem}
#' }
#'
#' @name authors
NULL

#' chat
#'
#' Users can chat freely within each problem.  The following table captures the chat data.
#'
#' @format
 #'\describe{
#'   \item{id}{Unique identifier of the chat message}
#'   \item{problem_id}{Unique identifier of the problem}
#'   \item{created_at}{Timestamp when the comment was first created}
#'   \item{user}{Name of the author of the chat message}
#'   \item{chat_id}{Another unique (within this platform instance) identifier of the chat message}
#'   \item{chat_text}{The comment content in plain text format}
#'   \item{user_id}{Unique identifier of the author of the chat message}
#'   \item{team_id}{Unique identifier for the team that produced the report}
#'   \item{team}{Name of the team the author of the chat message was in}
#'   \item{problem}{Short title of the problem}
#' }
#'
#' @name chat
NULL

#' comments
#'
#' Users can comment on responses.  The following table captures these comments.
#'
#' @format
 #'\describe{
#'   \item{problem_id}{Unique identifier of the problem}
#'   \item{team_id}{Unique identifier for the team that produced the report}
#'   \item{team}{Name of the team that produced the report}
#'   \item{response_id}{Unique identifier for the a response}
#'   \item{author_id}{Unique identifier of the original author of the response}
#'   \item{author}{Name of the orginal author of the response}
#'   \item{comment_id}{Unique identifier for the comment}
#'   \item{commenter_id}{Unique identifier of a user who created the comment}
#'   \item{commenter_name}{Name of the commenter}
#'   \item{time_created}{Timestamp when the comment was first created}
#'   \item{time_last_changed}{Timestamp when the comment was last updated}
#'   \item{comment_text}{A unique filename of the comment content in markdown text format}
#'   \item{comment_file}{A unique filename in the 'Comments' subfolder that contains the HTML file of the comment}
#'   \item{problem}{Short title of the problem}
#' }
#'
#' @name comments
NULL

#' login
#'
#' We capture when users log in and out of the platform. A few caveats here: Since many users do not expressly logout but rather just close the browser window we can track far less logouts than logins (rougly a third). We have not attempted to estimate how long a user stays on platform. Also, we do not track which problem a user is looking at. This data can only be supplied on platform level. It includes all login/logouts to this environment, not scaled down to specific tests or exercises.  
#'
#' @format
 #'\describe{
#'   \item{user_id}{Unique identifier of the user who logs in/out}
#'   \item{user}{Name of user who logs in/out}
#'   \item{event_type}{Can either be login or logout}
#'   \item{timestamp}{Timestamp when login/logout occurred}
#' }
#'
#' @name login
NULL

#' problems
#'
#' The problems table uniquely identifies and describes the problem that SWARM users were working on.
#'
#' @format
 #'\describe{
#'   \item{problem_id}{Unique identifier of the problem}
#'   \item{problem}{Short title of the problem}
#'   \item{description}{}
#'   \item{start_date}{}
#'   \item{due_date}{}
#'   \item{problem_text}{A unique filename of the problem content in markdown text format}
#'   \item{problem_file}{A unique filename in the 'Problems' subfolder that contains the HTML file of the problem}
#'   \item{problem_template}{}
#'   \item{exercise}{}
#' }
#'
#' @name problems
NULL

#' ratings
#'
#' Users can rate the responses and comments of other users.  The following table captures these ratings.  Note that users can rate as many times as they like (each of which is captured in the table), but only the last ratings are used in calculating the aggregate rating.  In other words, the ""rating_total"" with the latest timestamp in the *Ratings* table should match the ""team_rating"" in the *TopReport* table.
#'
#' @format
 #'\describe{
#'   \item{problem_id}{Unique identifier of the problem}
#'   \item{team_id}{Unique identifier for the team that produced the report}
#'   \item{content_type}{'report', 'resource', or 'comment'. Other types may be added in future.}
#'   \item{content_id}{Unique identifier for the content (content can be response or comment)}
#'   \item{author_id}{Unique identifier of the original author of the response}
#'   \item{author}{Name of the user who originally authored the response}
#'   \item{rater_id}{Unique identifier of a user who rated the response}
#'   \item{rater}{Name of the user who rated the response}
#'   \item{last_edited}{Timestamp when the rating was last updated}
#'   \item{rating_type}{'thumbs', 'simple', 'detailed'}
#'   \item{rating_total}{1 or 0 for thumbs, number (0-100) for simple, aggregated number for detailed rating}
#'   \item{rating_sub_01_title}{The title of the ratings subfield}
#'   \item{rating_sub_01}{Number for detailed rating field 1}
#'   \item{rating_sub_02_title}{The title of the ratings subfield}
#'   \item{rating_sub_02}{Number for detailed rating field 2}
#'   \item{rating_sub_03_title}{The title of the ratings subfield}
#'   \item{rating_sub_03}{Number for detailed rating field 3}
#'   \item{rating_sub_04_title}{The title of the ratings subfield}
#'   \item{rating_sub_04}{Number for detailed rating field 4}
#'   \item{rating_sub_05_title}{The title of the ratings subfield}
#'   \item{rating_sub_05}{Number for detailed rating field 5}
#'   \item{rating_sub_06_title}{The title of the ratings subfield}
#'   \item{rating_sub_06}{Number for detailed rating field 6}
#'   \item{rating_sub_07_title}{The title of the ratings subfield}
#'   \item{rating_sub_07}{Number for detailed rating field 7}
#'   \item{rating_sub_08_title}{The title of the ratings subfield}
#'   \item{rating_sub_08}{Number for detailed rating field 8}
#'   \item{rating_sub_09_title}{The title of the ratings subfield}
#'   \item{rating_sub_09}{Number for detailed rating field 9}
#'   \item{problem}{Short title of the problem}
#' }
#'
#' @name ratings
NULL

#' relations
#'
#' A table collecting interaction between users. As an interaction counts if a user commented on another users' response, if a user is named as a contributor for a report or if a user mentions another user in the chat. The interactions are stored summed up per problem and per action.
#'
#' @format
 #'\describe{
#'   \item{addressant}{User addressed by the other user (e.g. mentioned in chat)}
#'   \item{problem_id}{Unique identifier of problem}
#'   \item{team}{Name of team both users are in}
#'   \item{user}{User who addresses another user ( e.g. writes a chat message that contains a name tag)}
#'   \item{problem}{Name of problem}
#'   \item{interaction}{Describes the interaction: 'comment', 'contributor' or 'chat'}
#'   \item{count}{Number of times this interaction happened}
#' }
#'
#' @name relations
NULL

#' responses
#'
#' Responses are text contributed by users in response to the problem.  Currently, responses can be ""reports"" or ""resources"", but more types are possible in future.
#'
#' @format
 #'\describe{
#'   \item{problem_id}{Unique identifier of the problem}
#'   \item{team_id}{Unique identifier for the team that produced the response}
#'   \item{team}{The name of the team that produced the response}
#'   \item{response_id}{Unique identifier for the a response}
#'   \item{time_created}{Timestamp when the response was first created}
#'   \item{time_last_changed}{Timestamp when the response was last updated}
#'   \item{response_title}{The beginning of the response in plain text format}
#'   \item{response_type}{Type of response, currently 'report' or 'resource'. More types may be added in future}
#'   \item{response_text}{A unique filename of the response content in markdown text format}
#'   \item{response_file}{A unique filename in the 'Responses' subfolder that contains the HTML file of the response}
#'   \item{problem}{Short title of the problem}
#' }
#'
#' @name responses
NULL

#' timeline
#'
#' Another handy table that stores actions on the platform. Collects timestamps for all resources and reports posted on the platform, timestamps for all comments made on the platform including on which report/resource, timestamp for ratings made including on which report and updates made to resources and reports. Caveat: updates are stored as single edits and have to be mangled to become useful (e.g. only count edits made at least 5 minutes apart as an actual update).
#'
#' @format
 #'\describe{
#'   \item{chunk_id}{Unique identifier for the artefact contributed (can be a report, resource, comment, rating, update)}
#'   \item{parent_id}{Unique identifier for the source the artefact was contributed to (a report or resource in case of a comment or update, a problem_id in case of a report or resource, a report in case of a rating)}
#'   \item{problem_id}{Unique identifier for the problem (e.g. in case the artefact is a report or resource parent and problem id are identical)}
#'   \item{team_id}{Unique identifier for team}
#'   \item{team}{Name of team}
#'   \item{timestamp}{Timestamp when artefact was contributed, for resources, reports and comments this is their first post, for ratings only the last update is stored}
#'   \item{type}{The artefact type, can be report, resource, comment, rating, update}
#'   \item{problem}{The problem title}
#'   \item{user_id}{Unique indentifier of the user contributing the artefact}
#'   \item{user}{Name of user}
#' }
#'
#' @name timeline
NULL

#' top_reports
#'
#' Top Reports are the reports that have the highest quality (readiness) rating at the time of the data dump. Of particular interest are ""final reports"" at the end of a test, but it is possible that an interim data dump is made, in which case the top report is the highest rated report at the time of the data set. Internally, it is also possible that such reports are identifiable through other data in the SWARM platform (such as a report submission event log), but only the basic information is captured in the table below.
#'
#' @format
 #'\describe{
#'   \item{problem_id}{Unique identifier of the problem}
#'   \item{problem}{Short title of the problem}
#'   \item{team_id}{Unique identifier for the team that produced the report}
#'   \item{team}{Screen name for the team_id}
#'   \item{report_id}{Unique identifier for the report (response of type 'report')}
#'   \item{team_rating}{The aggregate rating of the report from the (internal) team at time of submission}
#'   \item{rating_count}{Number of received ratings}
#'   \item{origin_author_id}{Unique identifier of the user that first created the response that ultimately resulted in this top report}
#'   \item{origin_author_name}{Name of the author that first created the response}
#' }
#'
#' @name top_reports
NULL

#' parts
#'
#' One row per participant who was registered for this platform instance. Most of the columns in this table contain responses to questions on the entry and exit surveys.
#'
#' @format
 #'\describe{
#'   \item{user}{Username.}
#'   \item{isOrg}{Logical. Equals TRUE if user participated as part of an organisational team.}
#'   \item{gaveConsent2}{Gave consent to participate in the ‘Problem Solving In Online Groups’ experiment.}
#'   \item{gaveConsent3}{Gave consent to participate in the ‘Identifying and Rating Quality of Reasoning’ experiment.}
#'   \item{gaveConsent4}{Gave consent to proceed with the Entry Survey in the Psychology Capstone exercise.}
#'   \item{agreedToTerms}{}
#'   \item{agegroup}{Age group.}
#'   \item{gender}{Gender.}
#'   \item{occupation}{Occupation status.}
#'   \item{education}{Highest education level.}
#'   \item{major1, major2}{Subjects majored in.}
#'   \item{minor1, minor2}{Subjects minored in.}
#'   \item{studyarea}{Study area.}
#'   \item{studyareaOtherInput}{Free text input for ‘Other’ study area, if selected.}
#'   \item{deg}{Free text input for ‘What degree are you currently enrolled in?’}
#'   \item{degOther}{Free text input for ‘What other degrees/qualifications do you have?’}
#'   \item{workExp}{Free text input for ‘Do you have work experience that might have been helpful to complete the challenge questions?’}
#'   \item{englishProficiency}{Proficiency in English. Response options are: ‘No proficiency’, ‘Elementary proficiency’, ‘Limited working proficiency’, ‘Professional working proficiency’, ‘Full professional proficiency’, ‘Native or bilingual proficiency’}
#'   \item{loteProficiency1-6}{Specified proficiency levels in up to 6 languages other than English.}
#'   \item{loteProficiencyText1-6}{The languages for which the proficiency is specified in loteProficiency.}
#'   \item{enjoyLogicProbs}{Response to the prompt: ‘How enjoyable do you find logic problems?’ Response options are: ‘Note at all enjoyable’, ‘A little bit enjoyable’, ‘Slightly enjoyable’, ‘Somewhat enjoyable’, ‘Quite enjoyable’, ‘Very enjoyable’, ‘Extremely enjoyable’}
#'   \item{enjoyNumProbs}{Response to the prompt: ‘How enjoyable do you find number problems?’ Response options are: ‘Note at all enjoyable’, ‘A little bit enjoyable’, ‘Slightly enjoyable’, ‘Somewhat enjoyable’, ‘Quite enjoyable’, ‘Very enjoyable’, ‘Extremely enjoyable’}
#'   \item{exp1}{Numerical encoding of the participant’s response to the prompt: ‘Please rate your level of technical expertise in the following areas: Mathematics (generally)’. 1 = ‘Not familiar with this domain’, 2 = ‘Studied in school, but don’t use it’, 3 = ‘Use this knowledge occasionally’, 4 = ‘Use this knowledge regularly’, 5 = ‘I am a recognized expert’, 6 = ‘I am an international authority’.}
#'   \item{exp2}{Numerical encoding of the participant’s response to the prompt: ‘Please rate your level of technical expertise in the following areas: Quantitative  Modeling, Simulation’. 1 = ‘Not familiar with this domain’, 2 = ‘Studied in school, but don’t use it’, 3 = ‘Use this knowledge occasionally’, 4 = ‘Use this knowledge regularly’, 5 = ‘I am a recognized expert’, 6 = ‘I am an international authority’.}
#'   \item{exp3}{Numerical encoding of the participant’s response to the prompt: ‘Please rate your level of technical expertise in the following areas: Statistics’. 1 = ‘Not familiar with this domain’, 2 = ‘Studied in school, but don’t use it’, 3 = ‘Use this knowledge occasionally’, 4 = ‘Use this knowledge regularly’, 5 = ‘I am a recognized expert’, 6 = ‘I am an international authority’.}
#'   \item{exp4}{Numerical encoding of the participant’s response to the prompt: ‘Please rate your level of technical expertise in the following areas: Probability’. 1 = ‘Not familiar with this domain’, 2 = ‘Studied in school, but don’t use it’, 3 = ‘Use this knowledge occasionally’, 4 = ‘Use this knowledge regularly’, 5 = ‘I am a recognized expert’, 6 = ‘I am an international authority’.}
#'   \item{exp5}{Numerical encoding of the participant’s response to the prompt: ‘Please rate your level of technical expertise in the following areas: Bayes Nets’. 1 = ‘Not familiar with this domain’, 2 = ‘Studied in school, but don’t use it’, 3 = ‘Use this knowledge occasionally’, 4 = ‘Use this knowledge regularly’, 5 = ‘I am a recognized expert’, 6 = ‘I am an international authority’.}
#'   \item{exp6}{Numerical encoding of the participant’s response to the prompt: ‘Please rate your level of technical expertise in the following areas: Programming’. 1 = ‘Not familiar with this domain’, 2 = ‘Studied in school, but don’t use it’, 3 = ‘Use this knowledge occasionally’, 4 = ‘Use this knowledge regularly’, 5 = ‘I am a recognized expert’, 6 = ‘I am an international authority’.}
#'   \item{exp7}{Numerical encoding of the participant’s response to the prompt: ‘Please rate your level of technical expertise in the following areas: Experimental Design’. 1 = ‘Not familiar with this domain’, 2 = ‘Studied in school, but don’t use it’, 3 = ‘Use this knowledge occasionally’, 4 = ‘Use this knowledge regularly’, 5 = ‘I am a recognized expert’, 6 = ‘I am an international authority’.}
#'   \item{exp8}{Numerical encoding of the participant’s response to the prompt: ‘Please rate your level of technical expertise in the following areas: Risk Analysis’. 1 = ‘Not familiar with this domain’, 2 = ‘Studied in school, but don’t use it’, 3 = ‘Use this knowledge occasionally’, 4 = ‘Use this knowledge regularly’, 5 = ‘I am a recognized expert’, 6 = ‘I am an international authority’.}
#'   \item{exp9}{Numerical encoding of the participant’s response to the prompt: ‘Please rate your level of technical expertise in the following areas: Forecasting’. 1 = ‘Not familiar with this domain’, 2 = ‘Studied in school, but don’t use it’, 3 = ‘Use this knowledge occasionally’, 4 = ‘Use this knowledge regularly’, 5 = ‘I am a recognized expert’, 6 = ‘I am an international authority’.}
#'   \item{exp10}{Numerical encoding of the participant’s response to the prompt: ‘Please rate your level of technical expertise in the following areas: Decision Thoery (e.g. multi-attribute utility theory)’. 1 = ‘Not familiar with this domain’, 2 = ‘Studied in school, but don’t use it’, 3 = ‘Use this knowledge occasionally’, 4 = ‘Use this knowledge regularly’, 5 = ‘I am a recognized expert’, 6 = ‘I am an international authority’.}
#'   \item{exp11}{Numerical encoding of the participant’s response to the prompt: ‘Please rate your level of technical expertise in the following areas: Game Theory’. 1 = ‘Not familiar with this domain’, 2 = ‘Studied in school, but don’t use it’, 3 = ‘Use this knowledge occasionally’, 4 = ‘Use this knowledge regularly’, 5 = ‘I am a recognized expert’, 6 = ‘I am an international authority’.}
#'   \item{exp12}{Numerical encoding of the participant’s response to the prompt: ‘Please rate your level of technical expertise in the following areas: Structured Analytic Techniques’. 1 = ‘Not familiar with this domain’, 2 = ‘Studied in school, but don’t use it’, 3 = ‘Use this knowledge occasionally’, 4 = ‘Use this knowledge regularly’, 5 = ‘I am a recognized expert’, 6 = ‘I am an international authority’.}
#'   \item{exp13}{Numerical encoding of the participant’s response to the prompt: ‘Please rate your level of technical expertise in the following areas: Argument Mapping’. 1 = ‘Not familiar with this domain’, 2 = ‘Studied in school, but don’t use it’, 3 = ‘Use this knowledge occasionally’, 4 = ‘Use this knowledge regularly’, 5 = ‘I am a recognized expert’, 6 = ‘I am an international authority’.}
#'   \item{exp14}{Numerical encoding of the participant’s response to the prompt: ‘Please rate your level of technical expertise in the following areas: Informal Logic’. 1 = ‘Not familiar with this domain’, 2 = ‘Studied in school, but don’t use it’, 3 = ‘Use this knowledge occasionally’, 4 = ‘Use this knowledge regularly’, 5 = ‘I am a recognized expert’, 6 = ‘I am an international authority’.}
#'   \item{exp15}{Numerical encoding of the participant’s response to the prompt: ‘Please rate your level of technical expertise in the following areas: Systems Thinking or Cognitive Mapping’. 1 = ‘Not familiar with this domain’, 2 = ‘Studied in school, but don’t use it’, 3 = ‘Use this knowledge occasionally’, 4 = ‘Use this knowledge regularly’, 5 = ‘I am a recognized expert’, 6 = ‘I am an international authority’.}
#'   \item{exp16}{Numerical encoding of the participant’s response to the prompt: ‘Please rate your level of technical expertise in the following areas: Image Analysis’. 1 = ‘Not familiar with this domain’, 2 = ‘Studied in school, but don’t use it’, 3 = ‘Use this knowledge occasionally’, 4 = ‘Use this knowledge regularly’, 5 = ‘I am a recognized expert’, 6 = ‘I am an international authority’.}
#'   \item{exp17}{Numerical encoding of the participant’s response to the prompt: ‘Please rate your level of technical expertise in the following areas: Link Analysis’. 1 = ‘Not familiar with this domain’, 2 = ‘Studied in school, but don’t use it’, 3 = ‘Use this knowledge occasionally’, 4 = ‘Use this knowledge regularly’, 5 = ‘I am a recognized expert’, 6 = ‘I am an international authority’.}
#'   \item{exp18}{Numerical encoding of the participant’s response to the prompt: ‘Please rate your level of technical expertise in the following areas: Graphic Design’. 1 = ‘Not familiar with this domain’, 2 = ‘Studied in school, but don’t use it’, 3 = ‘Use this knowledge occasionally’, 4 = ‘Use this knowledge regularly’, 5 = ‘I am a recognized expert’, 6 = ‘I am an international authority’.}
#'   \item{exp19}{Numerical encoding of the participant’s response to the prompt: ‘Please rate your level of technical expertise in the following areas: Technical Writing’. 1 = ‘Not familiar with this domain’, 2 = ‘Studied in school, but don’t use it’, 3 = ‘Use this knowledge occasionally’, 4 = ‘Use this knowledge regularly’, 5 = ‘I am a recognized expert’, 6 = ‘I am an international authority’.}
#'   \item{pc…}{Probability coherence questions. The prompt is: ‘What is the probability that each of the following statements are true? If you are absolutely certain that the statement is true, you should enter 100. Likewise, if you are absolutely certain that the statement is false, you should enter 0. If you are uncertain, you should enter the probability that corresponds with what you think are the chances that the statement is true. When answering these questions, we ask that you do NOT consult with any outside sources.’ Respondents then select a probability as a percentage.}
#'   \item{pc5A}{'HA is the postal abbreviation for Hawaii.'}
#'   \item{pc5B}{'HI is the postal abbreviation for Hawaii.'}
#'   \item{pc5Acomp}{'HA is NOT the postal abbreviation for Hawaii.'}
#'   \item{pc5AUB}{'Either HA or HI is the postal abbreviation for Hawaii.'}
#'   \item{pc14A}{'Michaelangelo painted the Sistine Chapel.'}
#'   \item{pc14B}{'Raphael painted the Sistine Chapel.'}
#'   \item{pc14Acomp}{'Michaelangelo did NOT paint the Sistine Chapel.'}
#'   \item{pc14AUB}{'Either Michaelangelo or Raphael painted the Sistine Chapel.'}
#'   \item{pc35A}{'The Pacific Ocean is the largest of Earth’s oceans.'}
#'   \item{pc35B}{'The Indian Ocean is the largest of Earth’s oceans.'}
#'   \item{pc35Acomp}{'The Pacific Ocean is NOT the largest of the Earth’s oceans.'}
#'   \item{pc35AUB}{'Either the Pacific Ocean or the Indian Ocean is the largest of Earth’s oceans.'}
#'   \item{pc57A}{'The term 'bounded rationality' was coined by Herbert Simon.'}
#'   \item{pc57B}{'The term 'bounded rationality' was coined by Alan Turing.'}
#'   \item{pc57Acomp}{'The term 'bounded rationality' was NOT coined by Herbert Simon.'}
#'   \item{pc57AUB}{'The term 'bounded rationality' was coined either by Herbert Simon or Alan Turing.'}
#'   \item{pc60A}{'The oldest brother of famous philosopher William James was famous politician Walter James.'}
#'   \item{pc60B}{'The oldest brother of famous philosopher William James was famous writer Henry James.'}
#'   \item{pc60Acomp}{'The oldest brother of famous philosopher William James was NOT the famous politician Walter James.'}
#'   \item{pc60AUB}{'The oldest brother of famous philosopher William James was either famous politician Walter James or famous writer Henry James.'}
#'   \item{pr1}{Probabilistic reasoning item. Prompt: 'A ball was drawn from a bag ontaning 10 red, 30 white, 20 blue, and 15 yellow balls. What is the probability that it is neither red nor blue?' Response options: '30/75', '10/75', '45.75'.}
#'   \item{pr2}{Probabilistic reasoning item. Prompt: 'The proportion of left-handed people is 4 out of 100. In a school there are 300 students. How many left-handed students are there?' Response options: 20, 12, 25.}
#'   \item{pr3}{Probabilistic reasoning item. Prompt: 'Smokers are about 35\% of the population. At the airport in the waiting room there are 200 passengers. How many smokers are there?' Response options: 70, 35, 20.}
#'   \item{pr4}{Probabilistic reasoning item. Prompt: 'A fair coin is tossed nine times. Which of the following sequences of outcomes is a more likely result of nine flips of the fair coin? (H: Heads, T: Tails)'. Response options: 'THHTHTTHH', 'HTHTHTHTH', 'Both sequences are equally likely'}
#'   \item{pr5}{Probabilistic reasoning item. Prompt: 'Two containers, labelled A and B, are filled with red and yellow tokens in the following quantities. Container A contains 100 tokens, 65 red and 35 yellow. Container B contains 10 tokens, 6 red and 4 yellow. Each container is shaken vigorously. After choosing one of the containers, you must draw a token (without peeking, of course). Which container gives you a better chance of drawing a yellow token?' Response options: 'Container A (with 65 red and 35 yellow)', 'Container B (with 6 red and 4 yellow)', 'Equal chances from each container'.}
#'   \item{pr6}{Probabilistic reasoning item. Prompt: 'A marble bag contains 15 blue and 15 green marbles. After you drew 5 marbles (the marble draw was always put back into the bag), a sequence of five green marbles was obtained. What is the most likely outcome if a marble is drawn a sixth time?' Response options: 'A green marble', 'A blue marble', 'Blue and green are equally likely'.}
#'   \item{pr7}{Probabilistic reasoning item. Prompt: 'A bingo game is played with 25 numbers (from 1 to 25). At the first draw, which of the following results is the most likely?' Response options: 'It is more likely to be an even number', 'It is more likely to be an odd number', 'It is just as likely to be an even or an odd number'.}
#'   \item{pr8}{Probabilistic reasoning item. Prompt: 'Two decks, labelled A and B, are composed of cards with a star (star cards) and cards without any figure (white cards) on the reverse side. Deck A contains 100 cards, 80 white and 20 with a star. Deck B contains 10 cards, 8 white and 2 with a star. After choosing one of the decks, you must draw a card (without peeking, of course). Which deck gives you a better chance of drawing a star card?' Response options: 'Deck A (with 80 white and 20 star cards)', 'Deck B (with 8 white and 2 star cards', 'Equal chances from each deck'.}
#'   \item{pr9}{Probabilistic reasoning item. Prompt: 'A marble bag contains 10 blue and 20 green marbles. After you drew 5 marbles (the marble draw was always put back into the bag), a sequence of five green marbles was obtained. What is the most likely outcome if a marble is drawn a sixth time?' Response options: 'A green marble', 'A blue marble', 'Blue and green are equally likely'.}
#'   \item{pr10}{Probabilistic reasoning item. Prompt: '60\% of the population in a city are men and 40\% are women. 50\% of the men and 30\% of the women smoke. We select a person from the city at random. What is the probability that this person is a smoker?' Response options: 42\%, 50\%, 85\%.}
#'   \item{pr11}{Probabilistic reasoning item. Prompt: 'According to a recent survey, 90\% of the population in a city usually lie and 30\% of those usually lie about important matters. If we pick a person at random from this city, what is the probability that the person usually lies about important matters?' Response options: 60\%, 30\%, 27\%.}
#'   \item{pr12}{Probabilistic reasoning item. Prompt: 'In a choir there are 100 children: 30 boys and 70 girls. Half of the boys and 1 in 10 girls learn to play the piano. We select a child from the choir at random. What is the probability that he/she plays the piano?' Response options: '22 out of 100', '30 out of 100', '50 out of 100'.}
#'   \item{pr13}{Probabilistic reasoning item. Prompt: 'A village has 1000 inhabitants. 600 people own a pet, and amongst pet owners 1 in 3 owns more than one pet. If we select one person from this village at random, what is the probability that they own more than one pet' Response options: '333 out of 1000', '500 out of 1000', '200 out of 1000'.}
#'   \item{pr14}{Probabilistic reasoning item. Prompt: 'In a medical center a group of people were interviewed with the following results: (a table: ((,55 years old or younger,Over 55 years old, Total),(Previous heart attack, 29, 75, 104),(No previous heart attack, 401, 275, 676),(Total, 430, 350, 780))). Suppose we select a person from this group at random. Based on the table: What is the probability that the person has had a heart attack?' Response options: '104 out of 780', '104 out of 676', '390 out fo 780'.}
#'   \item{pr15}{Probabilistic reasoning item. Prompt: 'What is the probability that the person has had a heart attack and, at the same time is older than 55?' Response options: '104 out of 350', '75 out of 350', '75 out of 780'.}
#'   \item{pr16}{Probabilistic reasoning item. Prompt: 'When the person had a heart attack, what is the probability that they are over 55?' Response options: '75 out of 780', '75 out of 104', '104 out of 350'.}
#'   \item{mat1-mat11}{Responses to ICAR matrix reasoning questions.}
#'   \item{crt1}{Cognitive reflection task item. Prompt: 'A bat and a ball cost $1.10 in total. The bat costs a dollar more than the ball. How much does the ball cost? (Please enter a number in dollars, excluding the dollar sign.' }
#'   \item{crt2}{Cognitive reflection task item. Prompt: 'If it takes 5 machines 5 minutes to make 5 widgets, how long would it take for 100 machines to make 100 widgets? (Please enter a number in minutes)'}
#'   \item{crt3}{Cognitive reflection task item. Prompt: 'In a lake, there is a patch of lily pads. Every day, the patch doubles in size. If it takes 48 days for the patch to cover the entire lake, how long would it take for the patch to cover half the lake? (Please enter a number in days)'}
#'   \item{crt4}{Cognitive reflection task item. Prompt: 'If it takes 2 nurses 2 minutes to measure the blood pressure of 2 patients, how long would it take 200 nurses to measure the blood pressure of 200 patients? (Please enter a number in minutes)'}
#'   \item{crt5}{Cognitive reflection task item. Prompt: 'Soup and salad costs $5.50 in total. The soup costs a dollar more than the salad. How much does the salad cost? (Please enter a number in dollars, excluding the dollar sign)'}
#'   \item{crt6}{Cognitive reflection task item. Prompt: 'Sally is making sun tea. Every hour, the concentration of the tea doubles. If it takes 6 hours for the tea to be ready, how long would it take for the tea to reach half of the final concentration? (Please enter a number in hours)'}
#'   \item{crtSeenBefore}{Cognitive reflection task supplementary-item. 'Have you seen any of these 6 questions before?' Response options: Yes, No.}
#'   \item{crtSeenBeforeText}{Cognitive reflection task supplementary-item. 'Which ones?'}
#'   \item{bfi1}{10-item Big Five Inventory item. Prompt: 'Below are a number of characteristics that may or may not apply to you. For example, do you agree that you are someone who likes to spend time with others? Please rate the extent to which you agree or disagree with each statement. I am someone who is reserved.' 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{bfi2}{10-item Big Five Inventory item. Prompt: 'I am someone who is generally trusting.' 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{bfi3}{10-item Big Five Inventory item. Prompt: 'I am someone who tends to be lazy.' 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{bfi4}{10-item Big Five Inventory item. Prompt: 'I am someone who is relaxed, handles stress well.' 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{bfi5}{10-item Big Five Inventory item. Prompt: 'I am someone who has few artistic interests.' 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{bfi6}{10-item Big Five Inventory item. Prompt: 'I am someone who is outgoing, sociable.' 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{bfi7}{10-item Big Five Inventory item. Prompt: 'I am someone who tends to find faults with others.' 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{bfi8}{10-item Big Five Inventory item. Prompt: 'I am someone who does a thorough job.' 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{bfi9}{10-item Big Five Inventory item. Prompt: 'I am someone who gets nervous easily.' 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{bfi10}{10-item Big Five Inventory item. Prompt: 'I am someone who has an active imagination.' 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{BFI1}{BFI-2 scale item. Prompt: 'I am someone who… is outgoing, sociable' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI2}{BFI-2 scale item. Prompt: 'I am someone who… is compassionate, has a soft heart' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI3}{BFI-2 scale item. Prompt: 'I am someone who… tends to be disorganised' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI4}{BFI-2 scale item. Prompt: 'I am someone who… is relaxed, handles stress well' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI5}{BFI-2 scale item. Prompt: 'I am someone who… has few artistic interests' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI6}{BFI-2 scale item. Prompt: 'I am someone who… has an assertive personality' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI7}{BFI-2 scale item. Prompt: 'I am someone who… is respectful, treats others with respect' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI8}{BFI-2 scale item. Prompt: 'I am someone who… tends to be lazy' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI9}{BFI-2 scale item. Prompt: 'I am someone who… stays optimistic after experiencing a setback' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI10}{BFI-2 scale item. Prompt: 'I am someone who… is curious about many different things' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI11}{BFI-2 scale item. Prompt: 'I am someone who… rarely feels excited or eager' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI12}{BFI-2 scale item. Prompt: 'I am someone who… tends to find fault with others' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI13}{BFI-2 scale item. Prompt: 'I am someone who… is dependable, steady' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI14}{BFI-2 scale item. Prompt: 'I am someone who… is moody, has up and down mood swings' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI15}{BFI-2 scale item. Prompt: 'I am someone who… is inventive, finds clever ways to do things' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI16}{BFI-2 scale item. Prompt: 'I am someone who… tends to be quiet' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI17}{BFI-2 scale item. Prompt: 'I am someone who… feels little sympathy for others' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI18}{BFI-2 scale item. Prompt: 'I am someone who… is systematic, likes to keep things in order' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI19}{BFI-2 scale item. Prompt: 'I am someone who… can be tense' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI20}{BFI-2 scale item. Prompt: 'I am someone who… is fascinated by art, music, or literature' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI21}{BFI-2 scale item. Prompt: 'I am someone who… is dominant, acts as a leader' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI22}{BFI-2 scale item. Prompt: 'I am someone who… starts arguments with others' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI23}{BFI-2 scale item. Prompt: 'I am someone who… has difficulty getting started on tasks' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI24}{BFI-2 scale item. Prompt: 'I am someone who… feels secure, comfortable with self' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI25}{BFI-2 scale item. Prompt: 'I am someone who… avoids intellectual, philosophical discussions' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI26}{BFI-2 scale item. Prompt: 'I am someone who… is less active than other people' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI27}{BFI-2 scale item. Prompt: 'I am someone who… has a forgiving nature' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI28}{BFI-2 scale item. Prompt: 'I am someone who… can be somewhat careless' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI29}{BFI-2 scale item. Prompt: 'I am someone who… is emotionally stable, not easily upset' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI30}{BFI-2 scale item. Prompt: 'I am someone who… has little creativity' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI31}{BFI-2 scale item. Prompt: 'I am someone who… is sometimes shy, introverted' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI32}{BFI-2 scale item. Prompt: 'I am someone who… is helpful and unselfish with others' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI33}{BFI-2 scale item. Prompt: 'I am someone who… keeps things neat and tidy' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI34}{BFI-2 scale item. Prompt: 'I am someone who… worries a lot' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI35}{BFI-2 scale item. Prompt: 'I am someone who… values art and beauty' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI36}{BFI-2 scale item. Prompt: 'I am someone who… finds it hard to influence people' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI37}{BFI-2 scale item. Prompt: 'I am someone who… is sometimes rude to others' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI38}{BFI-2 scale item. Prompt: 'I am someone who… is efficient, gets things done' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI39}{BFI-2 scale item. Prompt: 'I am someone who… often feels sad' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI40}{BFI-2 scale item. Prompt: 'I am someone who… is complex, a deep thinker' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI41}{BFI-2 scale item. Prompt: 'I am someone who… is full of energy' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI42}{BFI-2 scale item. Prompt: 'I am someone who… is suspicious of others’ intentions' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI43}{BFI-2 scale item. Prompt: 'I am someone who… is reliable, can always be counted on' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI44}{BFI-2 scale item. Prompt: 'I am someone who… keeps their emotions under control' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI45}{BFI-2 scale item. Prompt: 'I am someone who… has difficulty imagining things' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI46}{BFI-2 scale item. Prompt: 'I am someone who… is talkative' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI47}{BFI-2 scale item. Prompt: 'I am someone who… can be cold and uncaring' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI48}{BFI-2 scale item. Prompt: 'I am someone who… leaves a mess, doesn’t clean up' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI49}{BFI-2 scale item. Prompt: 'I am someone who… rarely feels anxious or afraid' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI50}{BFI-2 scale item. Prompt: 'I am someone who… thinks poetry and plays are boring' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI51}{BFI-2 scale item. Prompt: 'I am someone who… prefers to have others take charge' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI52}{BFI-2 scale item. Prompt: 'I am someone who… is polite, courteous to others' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI53}{BFI-2 scale item. Prompt: 'I am someone who… is persistent, works until the task is finished' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI54}{BFI-2 scale item. Prompt: 'I am someone who… tends to feel depressed, blue' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI55}{BFI-2 scale item. Prompt: 'I am someone who… has little interest in abstract ideas' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI56}{BFI-2 scale item. Prompt: 'I am someone who… shows a lot of enthusiasm' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI57}{BFI-2 scale item. Prompt: 'I am someone who… assumes the best about people' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI58}{BFI-2 scale item. Prompt: 'I am someone who… sometimes behaves irresponsibly' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI59}{BFI-2 scale item. Prompt: 'I am someone who… is temperamental, gets emotional easily' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{BFI60}{BFI-2 scale item. Prompt: 'I am someone who… is original, comes up with new ideas' 1 = ‘Disagree strongly’, 2 = ‘Disagree a little’, 3 = ‘Neutral; no opinion’, 4 = ‘Agree a little’, 5 = ‘Agree strongly’.}
#'   \item{tp1}{Teamwork Perceptions item. Prompt: 'I have found working as part of a team in my classes to be a valuable experience.' 1 = ‘Strongly disagree’, 2 = ‘Somewhat disagree’, 3 = ‘Neither agree nor disagree’, 4 = ‘Somewhat agree’, 5 = ‘Strongly agree’.}
#'   \item{tp2}{Teamwork Perceptions item. Prompt: 'In most of the teams I have been on, the other team members have generally contributed as much as I have.' 1 = ‘Strongly disagree’, 2 = ‘Somewhat disagree’, 3 = ‘Neither agree nor disagree’, 4 = ‘Somewhat agree’, 5 = ‘Strongly agree’.}
#'   \item{tp3}{Teamwork Perceptions item. Prompt: 'In most of the teams I have been on, I felt the other team members respected me.' 1 = ‘Strongly disagree’, 2 = ‘Somewhat disagree’, 3 = ‘Neither agree nor disagree’, 4 = ‘Somewhat agree’, 5 = ‘Strongly agree’.}
#'   \item{tp4}{Teamwork Perceptions item. Prompt: 'In most of the teams I have been on, the team has worked well together.' 1 = ‘Strongly disagree’, 2 = ‘Somewhat disagree’, 3 = ‘Neither agree nor disagree’, 4 = ‘Somewhat agree’, 5 = ‘Strongly agree’.}
#'   \item{tp5}{Teamwork Perceptions item. Prompt: 'I have found teamwork to be a productive use of course time.' 1 = ‘Strongly disagree’, 2 = ‘Somewhat disagree’, 3 = ‘Neither agree nor disagree’, 4 = ‘Somewhat agree’, 5 = ‘Strongly agree’.}
#'   \item{tp6}{Teamwork Perceptions item. Prompt: 'I have found that teams help me learn course material more than if I just studied alone.' 1 = ‘Strongly disagree’, 2 = ‘Somewhat disagree’, 3 = ‘Neither agree nor disagree’, 4 = ‘Somewhat agree’, 5 = ‘Strongly agree’.}
#'   \item{tp7}{Teamwork Perceptions item. Prompt: 'I have learned more in courses where I have been a member of a team.' 1 = ‘Strongly disagree’, 2 = ‘Somewhat disagree’, 3 = ‘Neither agree nor disagree’, 4 = ‘Somewhat agree’, 5 = ‘Strongly agree’.}
#'   \item{tp8}{Teamwork Perceptions item. Prompt: 'I have found being part of a team improved my course grades.' 1 = ‘Strongly disagree’, 2 = ‘Somewhat disagree’, 3 = ‘Neither agree nor disagree’, 4 = ‘Somewhat agree’, 5 = ‘Strongly agree’.}
#'   \item{tp9}{Teamwork Perceptions item. Prompt: 'I have found that working with a team helps me develop skills in working with others.' 1 = ‘Strongly disagree’, 2 = ‘Somewhat disagree’, 3 = ‘Neither agree nor disagree’, 4 = ‘Somewhat agree’, 5 = ‘Strongly agree’.}
#'   \item{tp10}{Teamwork Perceptions item. Prompt: 'I have found that working with a team has helped me develop cooperative leadership skills.' 1 = ‘Strongly disagree’, 2 = ‘Somewhat disagree’, 3 = ‘Neither agree nor disagree’, 4 = ‘Somewhat agree’, 5 = ‘Strongly agree’.}
#'   \item{tp11}{Teamwork Perceptions item. Prompt: 'I have found that working with a team has helped me develop more respect for the opinion of others.' 1 = ‘Strongly disagree’, 2 = ‘Somewhat disagree’, 3 = ‘Neither agree nor disagree’, 4 = ‘Somewhat agree’, 5 = ‘Strongly agree’.}
#'   \item{tp12}{Teamwork Perceptions item. Prompt: 'I have found that working with a team has enhanced my sense of who I am.' 1 = ‘Strongly disagree’, 2 = ‘Somewhat disagree’, 3 = ‘Neither agree nor disagree’, 4 = ‘Somewhat agree’, 5 = ‘Strongly agree’.}
#'   \item{tp13}{Teamwork Perceptions item. Prompt: 'I have found that teams make good decisions.' 1 = ‘Strongly disagree’, 2 = ‘Somewhat disagree’, 3 = ‘Neither agree nor disagree’, 4 = ‘Somewhat agree’, 5 = ‘Strongly agree’.}
#'   \item{tp14}{Teamwork Perceptions item. Prompt: 'I have found that being on a team has helped me become better at problem solving.' 1 = ‘Strongly disagree’, 2 = ‘Somewhat disagree’, 3 = ‘Neither agree nor disagree’, 4 = ‘Somewhat agree’, 5 = ‘Strongly agree’.}
#'   \item{tp15}{Teamwork Perceptions item. Prompt: 'Being part of a team discussion has improved my ability to think through a problem.' 1 = ‘Strongly disagree’, 2 = ‘Somewhat disagree’, 3 = ‘Neither agree nor disagree’, 4 = ‘Somewhat agree’, 5 = ‘Strongly agree’.}
#'   \item{tp16}{Teamwork Perceptions item. Prompt: 'I feel that team-based learning has improved my reasoning skills.' 1 = ‘Strongly disagree’, 2 = ‘Somewhat disagree’, 3 = ‘Neither agree nor disagree’, 4 = ‘Somewhat agree’, 5 = ‘Strongly agree’.}
#'   \item{tps1}{Teamwork Perceptions on SWARM item. Prompt: 'With reference to your experience working in Capstone on the SWARM platform: I have found working as part of a team in my Capstone to be a valuable experience.' 1 = ‘Strongly disagree’, 2 = ‘Somewhat disagree’, 3 = ‘Neither agree nor disagree’, 4 = ‘Somewhat agree’, 5 = ‘Strongly agree’.}
#'   \item{tps2}{Teamwork Perceptions on SWARM item. Prompt: 'With reference to your experience working in Capstone on the SWARM platform: The other team members on SWARM have generally contributed as much as I have.' 1 = ‘Strongly disagree’, 2 = ‘Somewhat disagree’, 3 = ‘Neither agree nor disagree’, 4 = ‘Somewhat agree’, 5 = ‘Strongly agree’.}
#'   \item{tps3}{Teamwork Perceptions on SWARM item. Prompt: 'With reference to your experience working in Capstone on the SWARM platform: I felt the other team members respected me.' 1 = ‘Strongly disagree’, 2 = ‘Somewhat disagree’, 3 = ‘Neither agree nor disagree’, 4 = ‘Somewhat agree’, 5 = ‘Strongly agree’.}
#'   \item{tps4}{Teamwork Perceptions on SWARM item. Prompt: 'With reference to your experience working in Capstone on the SWARM platform: The team worked well together on SWARM.' 1 = ‘Strongly disagree’, 2 = ‘Somewhat disagree’, 3 = ‘Neither agree nor disagree’, 4 = ‘Somewhat agree’, 5 = ‘Strongly agree’.}
#'   \item{tps5}{Teamwork Perceptions on SWARM item. Prompt: 'With reference to your experience working in Capstone on the SWARM platform: I have found teamwork on SWARM to be a productive use of course time.' 1 = ‘Strongly disagree’, 2 = ‘Somewhat disagree’, 3 = ‘Neither agree nor disagree’, 4 = ‘Somewhat agree’, 5 = ‘Strongly agree’.}
#'   \item{tps6}{Teamwork Perceptions on SWARM item. Prompt: 'With reference to your experience working in Capstone on the SWARM platform: The SWARM team help me learn course material more than if I just studied alone.' 1 = ‘Strongly disagree’, 2 = ‘Somewhat disagree’, 3 = ‘Neither agree nor disagree’, 4 = ‘Somewhat agree’, 5 = ‘Strongly agree’.}
#'   \item{tps7}{Teamwork Perceptions on SWARM item. Prompt: 'With reference to your experience working in Capstone on the SWARM platform: I have learned more in courses as a result of being a member of a SWARM team.' 1 = ‘Strongly disagree’, 2 = ‘Somewhat disagree’, 3 = ‘Neither agree nor disagree’, 4 = ‘Somewhat agree’, 5 = ‘Strongly agree’.}
#'   \item{tps8}{Teamwork Perceptions on SWARM item. Prompt: 'With reference to your experience working in Capstone on the SWARM platform: Being part of a SWARM team improved my course grades.' 1 = ‘Strongly disagree’, 2 = ‘Somewhat disagree’, 3 = ‘Neither agree nor disagree’, 4 = ‘Somewhat agree’, 5 = ‘Strongly agree’.}
#'   \item{tps9}{Teamwork Perceptions on SWARM item. Prompt: 'With reference to your experience working in Capstone on the SWARM platform: Working with the SWARM team helped me develop skills in working with others.' 1 = ‘Strongly disagree’, 2 = ‘Somewhat disagree’, 3 = ‘Neither agree nor disagree’, 4 = ‘Somewhat agree’, 5 = ‘Strongly agree’.}
#'   \item{tps10}{Teamwork Perceptions on SWARM item. Prompt: 'With reference to your experience working in Capstone on the SWARM platform: I have found that working with a SWARM team has helped me develop cooperative leadership skills.' 1 = ‘Strongly disagree’, 2 = ‘Somewhat disagree’, 3 = ‘Neither agree nor disagree’, 4 = ‘Somewhat agree’, 5 = ‘Strongly agree’.}
#'   \item{tps11}{Teamwork Perceptions on SWARM item. Prompt: 'With reference to your experience working in Capstone on the SWARM platform: Working with a team has helped me develop more respect for the opinion of others.' 1 = ‘Strongly disagree’, 2 = ‘Somewhat disagree’, 3 = ‘Neither agree nor disagree’, 4 = ‘Somewhat agree’, 5 = ‘Strongly agree’.}
#'   \item{tps12}{Teamwork Perceptions on SWARM item. Prompt: 'With reference to your experience working in Capstone on the SWARM platform: Working with a team has enhanced my sense of who I am.' 1 = ‘Strongly disagree’, 2 = ‘Somewhat disagree’, 3 = ‘Neither agree nor disagree’, 4 = ‘Somewhat agree’, 5 = ‘Strongly agree’.}
#'   \item{tps13}{Teamwork Perceptions on SWARM item. Prompt: 'With reference to your experience working in Capstone on the SWARM platform: Teams on SWARM make good decisions.' 1 = ‘Strongly disagree’, 2 = ‘Somewhat disagree’, 3 = ‘Neither agree nor disagree’, 4 = ‘Somewhat agree’, 5 = ‘Strongly agree’.}
#'   \item{tps14}{Teamwork Perceptions on SWARM item. Prompt: 'With reference to your experience working in Capstone on the SWARM platform: Being on a team on the SWARM platform has helped me become better at problem solving.' 1 = ‘Strongly disagree’, 2 = ‘Somewhat disagree’, 3 = ‘Neither agree nor disagree’, 4 = ‘Somewhat agree’, 5 = ‘Strongly agree’.}
#'   \item{tps15}{Teamwork Perceptions on SWARM item. Prompt: 'With reference to your experience working in Capstone on the SWARM platform: Being part of a team discussion on the SWARM platform improved my ability to think through a problem.' 1 = ‘Strongly disagree’, 2 = ‘Somewhat disagree’, 3 = ‘Neither agree nor disagree’, 4 = ‘Somewhat agree’, 5 = ‘Strongly agree’.}
#'   \item{tps16}{Teamwork Perceptions on SWARM item. Prompt: 'With reference to your experience working in Capstone on the SWARM platform: The SWARM team-based learning has improved my reasoning skills.' 1 = ‘Strongly disagree’, 2 = ‘Somewhat disagree’, 3 = ‘Neither agree nor disagree’, 4 = ‘Somewhat agree’, 5 = ‘Strongly agree’.}
#'   \item{tmcoh1}{Anderson Team Cohesiveness item. Prompt: ‘When working with my team on the SWARM problems: The team members got along well with each other.’ 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{tmcoh2}{Anderson Team Cohesiveness item. Prompt: ‘When working with my team on the SWARM problems: The team members cooperated and helped each other during the process.’ 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{tmcoh3}{Anderson Team Cohesiveness item. Prompt: ‘When working with my team on the SWARM problems: The relationships between team members were positive and rewarding.’ 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{tmcoh4}{Anderson Team Cohesiveness item. Prompt: ‘When working with my team on the SWARM problems: The team members had a strong feeling of fellowship/camaraderie among each other.’ 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{swed1}{Prompt: ‘Compared to your normal group assignment collaboration, do you think the SWARM Platform...’. 3 = Improved collaboration, 2 = ‘Made no difference’, 1 = ‘Hampered collaboration’}
#'   \item{swed2}{Prompt: ‘Compared to your normal group assignment processes, do you think the SWARM Platform...’. 3 = Increased engagement, 2 = ‘Made no difference’, 1 = ‘Hampered engagement’}
#'   \item{jpc1}{Jackson et al. Psychological Collectivism item. Prompt: ‘I preferred to work in those groups rather than working alone.’ 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{jpc2}{Jackson et al. Psychological Collectivism item. Prompt: ‘Working in those groups was better than working alone.’ 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{jpc3}{Jackson et al. Psychological Collectivism item. Prompt: ‘I wanted to work with those groups as opposed to working alone.’ 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{jpc4}{Jackson et al. Psychological Collectivism item. Prompt: ‘I felt comfortable counting on group members to do their part.’ 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{jpc5}{Jackson et al. Psychological Collectivism item. Prompt: ‘I was not bothered by the need to rely on group members.’ 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{jpc6}{Jackson et al. Psychological Collectivism item. Prompt: ‘I felt comfortable trusting group members to handle their tasks.’ 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{jpc7}{Jackson et al. Psychological Collectivism item. Prompt: ‘The health of those groups was important to me.’ 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{jpc8}{Jackson et al. Psychological Collectivism item. Prompt: ‘I cared about the well-being of those groups.’ 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{jpc9}{Jackson et al. Psychological Collectivism item. Prompt: ‘I was concerned about the needs of those groups.’ 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{jpc10}{Jackson et al. Psychological Collectivism item. Prompt: ‘I followed the norms of those groups.’ 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{jpc11}{Jackson et al. Psychological Collectivism item. Prompt: ‘I followed the procedures used by those groups.’ 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{jpc12}{Jackson et al. Psychological Collectivism item. Prompt: ‘I accepted the rules of those groups.’ 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{jpc13}{Jackson et al. Psychological Collectivism item. Prompt: ‘I cared more about the goals of those groups than my own goals.’ 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{jpc14}{Jackson et al. Psychological Collectivism item. Prompt: ‘I emphasized the goals of those groups more than my individual goals.’ 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{jpc15}{Jackson et al. Psychological Collectivism item. Prompt: ‘Group goals were more important to me than my personal goals.’ 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{int1}{Logical. Indicates whether the participant selected ‘What the problems will be like’ among their responses to the prompt: ‘Thinking about the Hunt Challenge, what are you most interested in?’.}
#'   \item{int2}{Logical. Indicates whether the participant selected ‘Platform functionality’ among their responses to the prompt: ‘Thinking about the Hunt Challenge, what are you most interested in?’.}
#'   \item{int3}{Logical. Indicates whether the participant selected ‘How reports are created’ among their responses to the prompt: ‘Thinking about the Hunt Challenge, what are you most interested in?’.}
#'   \item{int4}{Logical. Indicates whether the participant selected ‘Team collaboration experience’ among their responses to the prompt: ‘Thinking about the Hunt Challenge, what are you most interested in?’.}
#'   \item{int5}{Logical. Indicates whether the participant selected ‘The structured training available’ among their responses to the prompt: ‘Thinking about the Hunt Challenge, what are you most interested in?’.}
#'   \item{int6}{Logical. Indicates whether the participant selected ‘The tools in the Lens Kit’ among their responses to the prompt: ‘Thinking about the Hunt Challenge, what are you most interested in?’.}
#'   \item{int7}{Logical. Indicates whether the participant selected ‘The Contending Analyses methodology’ among their responses to the prompt: ‘Thinking about the Hunt Challenge, what are you most interested in?’.}
#'   \item{int8}{Logical. Indicates whether the participant selected ‘The evaluation methods’ among their responses to the prompt: ‘Thinking about the Hunt Challenge, what are you most interested in?’.}
#'   \item{int9}{Logical. Indicates whether the participant selected ‘How my team performs’ among their responses to the prompt: ‘Thinking about the Hunt Challenge, what are you most interested in?’.}
#'   \item{int10}{Logical. Indicates whether the participant selected ‘Whether the public do as well as the professionals’ among their responses to the prompt: ‘Thinking about the Hunt Challenge, what are you most interested in?’.}
#'   \item{int11}{Logical. Indicates whether the participant selected ‘Other’ among their responses to the prompt: ‘Thinking about the Hunt Challenge, what are you most interested in?’.}
#'   \item{interestsOtherInput}{If the team selected ‘Other’ among their responses to the prompt ‘Thinking about the Hunt Challenge, what are you most interested in?’, this field contains their free text response.}
#'   \item{enExpct1}{Numerical encoding of the participants' response to the prompt: ‘What are your expectations for your Challenge experience?: Interesting problems’. 1 = ‘I don’t expect this’, 2 = ‘Neutral’, 3 = ‘I do expect this’.}
#'   \item{enExpct2}{Numerical encoding of the participants' response to the prompt: ‘What are your expectations for your Challenge experience?: Reasonable time commitment’. 1 = ‘I don’t expect this’, 2 = ‘Neutral’, 3 = ‘I do expect this’.}
#'   \item{enExpct3}{Numerical encoding of the participants' response to the prompt: ‘What are your expectations for your Challenge experience?: Difficult problems’. 1 = ‘I don’t expect this’, 2 = ‘Neutral’, 3 = ‘I do expect this’.}
#'   \item{enExpct4}{Numerical encoding of the participants' response to the prompt: ‘What are your expectations for your Challenge experience?: I will learn new skills and tools’. 1 = ‘I don’t expect this’, 2 = ‘Neutral’, 3 = ‘I do expect this’.}
#'   \item{enExpct5}{Numerical encoding of the participants' response to the prompt: ‘What are your expectations for your Challenge experience?: Problems are achievable, for a team’. 1 = ‘I don’t expect this’, 2 = ‘Neutral’, 3 = ‘I do expect this’.}
#'   \item{enExpct6}{Numerical encoding of the participants' response to the prompt: ‘What are your expectations for your Challenge experience?: The platform will be a productive work space’. 1 = ‘I don’t expect this’, 2 = ‘Neutral’, 3 = ‘I do expect this’.}
#'   \item{enExpct7}{Numerical encoding of the participants' response to the prompt: ‘What are your expectations for your Challenge experience?: Training in analytical techniques’. 1 = ‘I don’t expect this’, 2 = ‘Neutral’, 3 = ‘I do expect this’.}
#'   \item{enExpct8}{Numerical encoding of the participants' response to the prompt: ‘What are your expectations for your Challenge experience?: Positive team working experience’. 1 = ‘I don’t expect this’, 2 = ‘Neutral’, 3 = ‘I do expect this’.}
#'   \item{enExpct9}{Numerical encoding of the participants' response to the prompt: ‘What are your expectations for your Challenge experience?: An effective collaboration, compared to my normal methods’. 1 = ‘I don’t expect this’, 2 = ‘Neutral’, 3 = ‘I do expect this’.}
#'   \item{enExpct10}{Numerical encoding of the participants' response to the prompt: ‘What are your expectations for your Challenge experience?: What I learn from the challenge can be applied in my workplace’. 1 = ‘I don’t expect this’, 2 = ‘Neutral’, 3 = ‘I do expect this’.}
#'   \item{pri1}{Numerical encoding of the participants' response to the prompt: ‘How important to you are the following reasons for taking part in the Challenge? - Seeing how my team performs against the others’. 1 = ‘Not important’, 2 = ‘Neutral’, 3 = ‘Important’.}
#'   \item{pri2}{Numerical encoding of the participants' response to the prompt: ‘How important to you are the following reasons for taking part in the Challenge? - Testing my own skills and abilities’. 1 = ‘Not important’, 2 = ‘Neutral’, 3 = ‘Important’.}
#'   \item{pri3}{Numerical encoding of the participants' response to the prompt: ‘How important to you are the following reasons for taking part in the Challenge? - I think it will be fun’. 1 = ‘Not important’, 2 = ‘Neutral’, 3 = ‘Important’.}
#'   \item{pri4}{Numerical encoding of the participants' response to the prompt: ‘How important to you are the following reasons for taking part in the Challenge? - Developing my overall analytic skills’. 1 = ‘Not important’, 2 = ‘Neutral’, 3 = ‘Important’.}
#'   \item{pri5}{Numerical encoding of the participants' response to the prompt: ‘How important to you are the following reasons for taking part in the Challenge? - Learning how the SWARM Platform works’. 1 = ‘Not important’, 2 = ‘Neutral’, 3 = ‘Important’.}
#'   \item{pri6}{Numerical encoding of the participants' response to the prompt: ‘How important to you are the following reasons for taking part in the Challenge? - Learning about Contending Analyses’. 1 = ‘Not important’, 2 = ‘Neutral’, 3 = ‘Important’.}
#'   \item{pri7}{Numerical encoding of the participants' response to the prompt: ‘How important to you are the following reasons for taking part in the Challenge? - Trying a new style of team collaboration’. 1 = ‘Not important’, 2 = ‘Neutral’, 3 = ‘Important’.}
#'   \item{pri8}{Numerical encoding of the participants' response to the prompt: ‘How important to you are the following reasons for taking part in the Challenge? - Contributing to research in intelligence analysis’. 1 = ‘Not important’, 2 = ‘Neutral’, 3 = ‘Important’.}
#'   \item{pri9}{Numerical encoding of the participants' response to the prompt: ‘How important to you are the following reasons for taking part in the Challenge? - Getting selected for a Super Team’. 1 = ‘Not important’, 2 = ‘Neutral’, 3 = ‘Important’.}
#'   \item{pri10}{Numerical encoding of the participants' response to the prompt: ‘How important to you are the following reasons for taking part in the Challenge? - Exploring the Lens Kit’. 1 = ‘Not important’, 2 = ‘Neutral’, 3 = ‘Important’.}
#'   \item{pri11}{Numerical encoding of the participants' response to the prompt: ‘How important to you are the following reasons for taking part in the Challenge? - Participating in crowd sourced intelligence analysis’. 1 = ‘Not important’, 2 = ‘Neutral’, 3 = ‘Important’.}
#'   \item{priOther}{Numerical encoding of the participants' response to the prompt: ‘How important to you are the following reasons for taking part in the Challenge? - Other’. 1 = ‘Not important’, 2 = ‘Neutral’, 3 = ‘Important’.}
#'   \item{priOtherInput}{Specified ‘Other’ priority referred to by priOther (if applicable)}
#'   \item{aomt1}{Numerical encoding of the participants' response to the prompt: ‘Allowing oneself to be convinced by an opposing argument is a sign of good character.’. 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{aomt2}{Numerical encoding of the participants' response to the prompt: ‘People should take into consideration evidence that goes against their beliefs.’. 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{aomt3}{Numerical encoding of the participants' response to the prompt: ‘People should revise their beliefs in light of new information or evidence.’. 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{aomt4}{Numerical encoding of the participants' response to the prompt: ‘Changing your mind is a sign of weakness.’. 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{aomt5}{Numerical encoding of the participants' response to the prompt: ‘Intuition is the best guide in making decisions.’. 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{aomt6}{Numerical encoding of the participants' response to the prompt: ‘It is important to persevere in your beliefs even when evidence is brought to bear against them.’. 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{aomt7}{Numerical encoding of the participants' response to the prompt: ‘One should disregard evidence that conflicts with one's established beliefs.’. 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{aomt8}{Numerical encoding of the participants' response to the prompt: ‘People should search actively for reasons why their beliefs might be wrong.’. 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{aomt9}{Numerical encoding of the participants' response to the prompt: ‘When we are faced with a new question, the first answer that occurs to us is usually best.’. 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{aomt10}{Numerical encoding of the participants' response to the prompt: ‘When faced with a new question, we should consider more than one possible answer before reaching a conclusion.’. 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{aomt11}{Numerical encoding of the participants' response to the prompt: ‘When faced with a new question, we should look for reasons why our first answer might be wrong, before deciding on an answer.’. 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{enCap1}{Numerical encoding of the participants' response to the prompt: ‘How would you assess your current capability in the follow areas? This may be from your job, from studies, or from other activities. - Analytic report writing’. 1 = ‘None’, 2 = ‘Low’, 3 = ‘Moderate’, 4 = ‘High’.}
#'   \item{enCap2}{Numerical encoding of the participants' response to the prompt: ‘How would you assess your current capability in the follow areas? This may be from your job, from studies, or from other activities. - Using structured analytic techniques’. 1 = ‘None’, 2 = ‘Low’, 3 = ‘Moderate’, 4 = ‘High’.}
#'   \item{enCap3}{Numerical encoding of the participants' response to the prompt: ‘How would you assess your current capability in the follow areas? This may be from your job, from studies, or from other activities. - Using OSINT tools and resources’. 1 = ‘None’, 2 = ‘Low’, 3 = ‘Moderate’, 4 = ‘High’.}
#'   \item{enCap4}{Numerical encoding of the participants' response to the prompt: ‘How would you assess your current capability in the follow areas? This may be from your job, from studies, or from other activities. - Applying strategic thinking frameworks’. 1 = ‘None’, 2 = ‘Low’, 3 = ‘Moderate’, 4 = ‘High’.}
#'   \item{enCap5}{Numerical encoding of the participants' response to the prompt: ‘How would you assess your current capability in the follow areas? This may be from your job, from studies, or from other activities. - Identifying and analysing assumptions’. 1 = ‘None’, 2 = ‘Low’, 3 = ‘Moderate’, 4 = ‘High’.}
#'   \item{enCap6}{Numerical encoding of the participants' response to the prompt: ‘How would you assess your current capability in the follow areas? This may be from your job, from studies, or from other activities. - Evaluating quality of analytic reasoning’. 1 = ‘None’, 2 = ‘Low’, 3 = ‘Moderate’, 4 = ‘High’.}
#'   \item{enCap7}{Numerical encoding of the participants' response to the prompt: ‘How would you assess your current capability in the follow areas? This may be from your job, from studies, or from other activities. - Using decision making frameworks’. 1 = ‘None’, 2 = ‘Low’, 3 = ‘Moderate’, 4 = ‘High’.}
#'   \item{yearsWorkExperience}{Response to the prompt: ‘How many years work experience do you have?’}
#'   \item{yearsAnalyticalExperience}{Response to the prompt: ‘How many years experience do you have analysing complex problems or data?’}
#'   \item{ae1}{Logical. Indicates whether the participant selected ‘No direct experience’ among their responses to the prompt: ‘Do you have experience analysing complex problems or data? Please select all applicable.’.}
#'   \item{ae2}{Logical. Indicates whether the participant selected ‘Yes, in an intelligence or related field’ among their responses to the prompt: ‘Do you have experience analysing complex problems or data? Please select all applicable.’.}
#'   \item{ae3}{Logical. Indicates whether the participant selected ‘Yes, in a scientific field’ among their responses to the prompt: ‘Do you have experience analysing complex problems or data? Please select all applicable.’.}
#'   \item{ae4}{Logical. Indicates whether the participant selected ‘Yes, in another field’ among their responses to the prompt: ‘Do you have experience analysing complex problems or data? Please select all applicable.’.}
#'   \item{ae5}{Logical. Indicates whether the participant selected ‘Prefer not to say’ among their responses to the prompt: ‘Do you have experience analysing complex problems or data? Please select all applicable.’.}
#'   \item{hasMultidisciplinaryExperience}{Logical. Indicates whether the participant responded ‘Yes’ to the prompt: ‘Have you had experience working in a multidisciplinary team? (i.e. composed of members with varied but complementary experience, qualifications, and skills that contribute to the achievement of a specific objective)’}
#'   \item{multidisciplinaryExperienceInput}{Response to the prompt: ‘Please describe your experience working in a multidisciplinary team:’}
#'   \item{starRating}{Integer. Number of stars selected in response to the prompt: ‘Please rate your overall Challenge experience out of 5 stars:’}
#'   \item{timeWellSpent}{Numerical encoding of the participants' response to the prompt: ‘Did you feel that your participation was time well spent?’. 1 = ‘No’, 2 = ‘Unsure’, 3 = ‘Yes’}
#'   \item{bestThing}{Response to the prompt: ‘What was the one BEST thing about your Challenge experience?’}
#'   \item{worstThing}{Response to the prompt: ‘What was the one WORST thing about your Challenge experience?’}
#'   \item{hoursPerWeek}{Response to the prompt: ‘How many hours did your organisation allow for your participation during work hours per week? Please enter the number, 1, 2, 3, etc...’}
#'   \item{enoughtTime}{Numerical encoding of the participants' response to the prompt: ‘Did your organisation allow you enough time off regular duties to participate fully?’. 1 = ‘No’, 2 = ‘Yes’}
#'   \item{proportionOwnTime}{Response to the prompt: ‘What proportion of your participation was done in your own time? (outside of work hours)? Please enter the number, 10, 25, 50, etc...’}
#'   \item{rate1}{Numerical encoding of the participants' response to the prompt: ‘How do you rate these aspects of the Challenge? - The onboarding process’. 1 = ‘Poor’, 2 = ‘Average’, 3 = ‘Good’}
#'   \item{rate2}{Numerical encoding of the participants' response to the prompt: ‘How do you rate these aspects of the Challenge? - Our communication with you’. 1 = ‘Poor’, 2 = ‘Average’, 3 = ‘Good’}
#'   \item{rate3}{Numerical encoding of the participants' response to the prompt: ‘How do you rate these aspects of the Challenge? - The training’. 1 = ‘Poor’, 2 = ‘Average’, 3 = ‘Good’}
#'   \item{rate4}{Numerical encoding of the participants' response to the prompt: ‘How do you rate these aspects of the Challenge? - The feedback’. 1 = ‘Poor’, 2 = ‘Average’, 3 = ‘Good’}
#'   \item{rate5}{Numerical encoding of the participants' response to the prompt: ‘How do you rate these aspects of the Challenge? - The Help Center’. 1 = ‘Poor’, 2 = ‘Average’, 3 = ‘Good’}
#'   \item{exExpct1}{Numerical encoding of the participant’s response to the prompt: ‘Given your expectations prior to the Challenge, how did we do?: Interesting problems’. 1 = ‘Below’, 2 = ‘Met’, 3 = ‘Exceeded’, 4 = ‘I had no expectations’.}
#'   \item{exExpct2}{Numerical encoding of the participant’s response to the prompt: ‘Given your expectations prior to the Challenge, how did we do?: Reasonable time commitment’. 1 = ‘Below’, 2 = ‘Met’, 3 = ‘Exceeded’, 4 = ‘I had no expectations’.}
#'   \item{exExpct3}{Numerical encoding of the participant’s response to the prompt: ‘Given your expectations prior to the Challenge, how did we do?: Difficult problems’. 1 = ‘Below’, 2 = ‘Met’, 3 = ‘Exceeded’, 4 = ‘I had no expectations’.}
#'   \item{exExpct4}{Numerical encoding of the participant’s response to the prompt: ‘Given your expectations prior to the Challenge, how did we do?: I will learn new skills and tools’. 1 = ‘Below’, 2 = ‘Met’, 3 = ‘Exceeded’, 4 = ‘I had no expectations’.}
#'   \item{exExpct5}{Numerical encoding of the participant’s response to the prompt: ‘Given your expectations prior to the Challenge, how did we do?: Problems are achievable, for a team’. 1 = ‘Below’, 2 = ‘Met’, 3 = ‘Exceeded’, 4 = ‘I had no expectations’.}
#'   \item{exExpct6}{Numerical encoding of the participant’s response to the prompt: ‘Given your expectations prior to the Challenge, how did we do?: The platform will be a productive work space’. 1 = ‘Below’, 2 = ‘Met’, 3 = ‘Exceeded’, 4 = ‘I had no expectations’.}
#'   \item{exExpct7}{Numerical encoding of the participant’s response to the prompt: ‘Given your expectations prior to the Challenge, how did we do?: Training in analytical techniques’. 1 = ‘Below’, 2 = ‘Met’, 3 = ‘Exceeded’, 4 = ‘I had no expectations’.}
#'   \item{exExpct8}{Numerical encoding of the participant’s response to the prompt: ‘Given your expectations prior to the Challenge, how did we do?: Positive team working experience’. 1 = ‘Below’, 2 = ‘Met’, 3 = ‘Exceeded’, 4 = ‘I had no expectations’.}
#'   \item{exExpct9}{Numerical encoding of the participant’s response to the prompt: ‘Given your expectations prior to the Challenge, how did we do?: An effective collaboration, compared to my normal methods’. 1 = ‘Below’, 2 = ‘Met’, 3 = ‘Exceeded’, 4 = ‘I had no expectations’.}
#'   \item{exExpct10}{Numerical encoding of the participant’s response to the prompt: ‘Given your expectations prior to the Challenge, how did we do?: What I learn from the challenge can be applied in my workplace’. 1 = ‘Below’, 2 = ‘Met’, 3 = ‘Exceeded’, 4 = ‘I had no expectations’.}
#'   \item{tw1}{Numerical encoding of the participant’s response to the prompt: ‘Thinking about the teamwork aspect of the Challenge, do you agree or disagree with the following statements? - I enjoyed the team social experience’. 1 = ‘Disagree’, 2 = ‘Neutral’, 3 = ‘Agree’.}
#'   \item{tw2}{Numerical encoding of the participant’s response to the prompt: ‘Thinking about the teamwork aspect of the Challenge, do you agree or disagree with the following statements? - I enjoyed the team collaboration experience’. 1 = ‘Disagree’, 2 = ‘Neutral’, 3 = ‘Agree’.}
#'   \item{tw3}{Numerical encoding of the participant’s response to the prompt: ‘Thinking about the teamwork aspect of the Challenge, do you agree or disagree with the following statements? - I could positively contirbute to my team’. 1 = ‘Disagree’, 2 = ‘Neutral’, 3 = ‘Agree’.}
#'   \item{tw4}{Numerical encoding of the participant’s response to the prompt: ‘Thinking about the teamwork aspect of the Challenge, do you agree or disagree with the following statements? - My efforts were recognised by other team members’. 1 = ‘Disagree’, 2 = ‘Neutral’, 3 = ‘Agree’.}
#'   \item{tw5}{Numerical encoding of the participant’s response to the prompt: ‘Thinking about the teamwork aspect of the Challenge, do you agree or disagree with the following statements? - I found it easy to keep track of my team’s contrbutions’. 1 = ‘Disagree’, 2 = ‘Neutral’, 3 = ‘Agree’.}
#'   \item{tw6}{Numerical encoding of the participant’s response to the prompt: ‘Thinking about the teamwork aspect of the Challenge, do you agree or disagree with the following statements? - I felt that some team members were too dominant’. 1 = ‘Disagree’, 2 = ‘Neutral’, 3 = ‘Agree’.}
#'   \item{tw7}{Numerical encoding of the participant’s response to the prompt: ‘Thinking about the teamwork aspect of the Challenge, do you agree or disagree with the following statements? - I felt that I had to lead to get the job done’. 1 = ‘Disagree’, 2 = ‘Neutral’, 3 = ‘Agree’.}
#'   \item{pf1}{Numerical encoding of the participant’s response to the prompt: ‘Do you think the Platform supported you in the following areas? - Developing a shared mission amongst team members’. 1 = ‘No’, 2 = ‘Yes’, 3 = ‘Not sure’.}
#'   \item{pf2}{Numerical encoding of the participant’s response to the prompt: ‘Do you think the Platform supported you in the following areas? - Working towards a unified goal’. 1 = ‘No’, 2 = ‘Yes’, 3 = ‘Not sure’.}
#'   \item{pf3}{Numerical encoding of the participant’s response to the prompt: ‘Do you think the Platform supported you in the following areas? - Managing contributions’. 1 = ‘No’, 2 = ‘Yes’, 3 = ‘Not sure’.}
#'   \item{pf4}{Numerical encoding of the participant’s response to the prompt: ‘Do you think the Platform supported you in the following areas? - Keeping track of team decisions’. 1 = ‘No’, 2 = ‘Yes’, 3 = ‘Not sure’.}
#'   \item{pf5}{Numerical encoding of the participant’s response to the prompt: ‘Do you think the Platform supported you in the following areas? - Working in a flexible and agile way as analysis progressed’. 1 = ‘No’, 2 = ‘Yes’, 3 = ‘Not sure’.}
#'   \item{pf6}{Numerical encoding of the participant’s response to the prompt: ‘Do you think the Platform supported you in the following areas? - Innovative problem solving’. 1 = ‘No’, 2 = ‘Yes’, 3 = ‘Not sure’.}
#'   \item{pf7}{Numerical encoding of the participant’s response to the prompt: ‘Do you think the Platform supported you in the following areas? - Enabling an efficient workflow’. 1 = ‘No’, 2 = ‘Yes’, 3 = ‘Not sure’.}
#'   \item{pf8}{Numerical encoding of the participant’s response to the prompt: ‘Do you think the Platform supported you in the following areas? - Meeting deadlines’. 1 = ‘No’, 2 = ‘Yes’, 3 = ‘Not sure’.}
#'   \item{pf9}{Numerical encoding of the participant’s response to the prompt: ‘Do you think the Platform supported you in the following areas? - Clear communication amongst team members’. 1 = ‘No’, 2 = ‘Yes’, 3 = ‘Not sure’.}
#'   \item{pf10}{Numerical encoding of the participant’s response to the prompt: ‘Do you think the Platform supported you in the following areas? - Ability to move easily between engaging with others, or disengaging for independent work’. 1 = ‘No’, 2 = ‘Yes’, 3 = ‘Not sure’.}
#'   \item{pf11}{Numerical encoding of the participant’s response to the prompt: ‘Do you think the Platform supported you in the following areas? - Information sharing amongst team members’. 1 = ‘No’, 2 = ‘Yes’, 3 = ‘Not sure’.}
#'   \item{pf12}{Numerical encoding of the participant’s response to the prompt: ‘Do you think the Platform supported you in the following areas? - Worked together positively’. 1 = ‘No’, 2 = ‘Yes’, 3 = ‘Not sure’.}
#'   \item{pf13}{Numerical encoding of the participant’s response to the prompt: ‘Do you think the Platform supported you in the following areas? - Making decisions’. 1 = ‘No’, 2 = ‘Yes’, 3 = ‘Not sure’.}
#'   \item{pf14}{Numerical encoding of the participant’s response to the prompt: ‘Do you think the Platform supported you in the following areas? - Production of useful output’. 1 = ‘No’, 2 = ‘Yes’, 3 = ‘Not sure’.}
#'   \item{pfComments}{Response to the prompt: ‘Any additional comments about how the Platform affected teamwork and collaboration?’}
#'   \item{fb1}{Numerical encoding of the participant’s response to the prompt: ‘Thinking about the feedback you received on your team’s submitted reports, do you agree or disagree with the following statements - The feedback accurately reflected the quality of our reports’. 1 = ‘Disagree’, 2 = ‘Neutral’, 3 = ‘Agree’.}
#'   \item{fb2}{Numerical encoding of the participant’s response to the prompt: ‘Thinking about the feedback you received on your team’s submitted reports, do you agree or disagree with the following statements - The feedback helped me understand the strengths and weaknesses of our reports’. 1 = ‘Disagree’, 2 = ‘Neutral’, 3 = ‘Agree’.}
#'   \item{fb3}{Numerical encoding of the participant’s response to the prompt: ‘Thinking about the feedback you received on your team’s submitted reports, do you agree or disagree with the following statements - The feedback helped me build expertise in analytic reasoning’. 1 = ‘Disagree’, 2 = ‘Neutral’, 3 = ‘Agree’.}
#'   \item{fb4}{Numerical encoding of the participant’s response to the prompt: ‘Thinking about the feedback you received on your team’s submitted reports, do you agree or disagree with the following statements - My team used the feedback to improve their submitted reports’. 1 = ‘Disagree’, 2 = ‘Neutral’, 3 = ‘Agree’.}
#'   \item{exCap1}{Numerical encoding of the participant’s response to the prompt: ‘After participating in the Challenge, do you think your capability has improved in the following areas? - Analytic report writing’. 1 = ‘No’, 2 = ‘Somewhat’, 3 = ‘Significantly’.}
#'   \item{exCap2}{Numerical encoding of the participant’s response to the prompt: ‘After participating in the Challenge, do you think your capability has improved in the following areas? - Using structured analytic techniques’. 1 = ‘No’, 2 = ‘Somewhat’, 3 = ‘Significantly’.}
#'   \item{exCap3}{Numerical encoding of the participant’s response to the prompt: ‘After participating in the Challenge, do you think your capability has improved in the following areas? - Using OSINT tools and resources’. 1 = ‘No’, 2 = ‘Somewhat’, 3 = ‘Significantly’.}
#'   \item{exCap4}{Numerical encoding of the participant’s response to the prompt: ‘After participating in the Challenge, do you think your capability has improved in the following areas? - Applying strategic thinking frameworks’. 1 = ‘No’, 2 = ‘Somewhat’, 3 = ‘Significantly’.}
#'   \item{exCap5}{Numerical encoding of the participant’s response to the prompt: ‘After participating in the Challenge, do you think your capability has improved in the following areas? - Identifying and analysing assumptions’. 1 = ‘No’, 2 = ‘Somewhat’, 3 = ‘Significantly’.}
#'   \item{exCap6}{Numerical encoding of the participant’s response to the prompt: ‘After participating in the Challenge, do you think your capability has improved in the following areas? - Evaluating quality of analytic reasoning’. 1 = ‘No’, 2 = ‘Somewhat’, 3 = ‘Significantly’.}
#'   \item{exCap7}{Numerical encoding of the participant’s response to the prompt: ‘After participating in the Challenge, do you think your capability has improved in the following areas? - Using decision making frameworks’. 1 = ‘No’, 2 = ‘Somewhat’, 3 = ‘Significantly’.}
#'   \item{mostValuable}{Response to the prompt: ‘What was the one most valuable thing you learned in the HC2020?’}
#'   \item{cha1}{Numerical encoding of the participant’s response to the prompt: ‘If you consider participating in an exercise like the HC2020 as analytical skills training, how does it compare with more typical training methods? - A Challenge exercise is more effective’. 1 = ‘Disagree’, 2 = ‘Neutral’, 3 = ‘Agree’.}
#'   \item{cha2}{Numerical encoding of the participant’s response to the prompt: ‘If you consider participating in an exercise like the HC2020 as analytical skills training, how does it compare with more typical training methods? - A Challenge exercise is more engaging’. 1 = ‘Disagree’, 2 = ‘Neutral’, 3 = ‘Agree’.}
#'   \item{cha3}{Numerical encoding of the participant’s response to the prompt: ‘If you consider participating in an exercise like the HC2020 as analytical skills training, how does it compare with more typical training methods? - A Challenge exercise works better for some people, but not as well for others’. 1 = ‘Disagree’, 2 = ‘Neutral’, 3 = ‘Agree’.}
#'   \item{career1}{Numerical encoding of the participant’s response to the prompt: ‘How has participating in the Challenge changed your interest in an intelligence analysis career? My interest has:’. 1 = ‘Not changed’, 2 = ‘Increased’}
#'   \item{ca1}{Numerical encoding of the participant’s response to the prompt: ‘Thinking about Contending Analyses, do you agree or disagree with the following statements? - I understood what Contending Analyses is’. 1 = ‘No’, 2 = ‘Yes’, 3 = ‘Not sure’}
#'   \item{ca2}{Numerical encoding of the participant’s response to the prompt: ‘Thinking about Contending Analyses, do you agree or disagree with the following statements? - My team used Contending Analyses’. 1 = ‘No’, 2 = ‘Yes’, 3 = ‘Not sure’}
#'   \item{ca3}{Numerical encoding of the participant’s response to the prompt: ‘Thinking about Contending Analyses, do you agree or disagree with the following statements? - Using Contending Analyses helped improve the quality of reasoning in reports’. 1 = ‘No’, 2 = ‘Yes’, 3 = ‘Not sure’}
#'   \item{ca4}{Numerical encoding of the participant’s response to the prompt: ‘Thinking about Contending Analyses, do you agree or disagree with the following statements? - I intend to apply Contending Analyses in my work’. 1 = ‘No’, 2 = ‘Yes’, 3 = ‘Not sure’}
#'   \item{swarm1}{Numerical encoding of the participant’s response to the prompt: ‘Thinking about the Platform, do you agree or disagree with the following statements? - Working on the Platform produced better reasoned reports than my normal methods’. 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Neutral’, 4 = ‘Agree’, 5 = ‘Strongly agree’}
#'   \item{swarm2}{Numerical encoding of the participant’s response to the prompt: ‘Thinking about the Platform, do you agree or disagree with the following statements? - My team’s reports were better than I could have produced on my own’. 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Neutral’, 4 = ‘Agree’, 5 = ‘Strongly agree’}
#'   \item{swarm3}{Numerical encoding of the participant’s response to the prompt: ‘Thinking about the Platform, do you agree or disagree with the following statements? - Using a Platform like this would improve intelligence analysis in my organisation’. 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Neutral’, 4 = ‘Agree’, 5 = ‘Strongly agree’}
#'   \item{swarm4}{Numerical encoding of the participant’s response to the prompt: ‘Thinking about the Platform, do you agree or disagree with the following statements? - If my organisation introduced a Platform like this, I would want to use it’. 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Neutral’, 4 = ‘Agree’, 5 = ‘Strongly agree’}
#'   \item{lk1}{Numerical encoding of the participant’s response to the prompt: ‘Thinking about the Lens Kit, do you agree or disagree with the following statements? - It was easy to find the relevant tools’. 1 = ‘Disagree’, 2 = ‘Neutral’, 3 = ‘Agree’}
#'   \item{lk2}{Numerical encoding of the participant’s response to the prompt: ‘Thinking about the Lens Kit, do you agree or disagree with the following statements? - The tools were well explained’. 1 = ‘Disagree’, 2 = ‘Neutral’, 3 = ‘Agree’}
#'   \item{lk3}{Numerical encoding of the participant’s response to the prompt: ‘Thinking about the Lens Kit, do you agree or disagree with the following statements? - Overall, the Lens Kit was very helpful’. 1 = ‘Disagree’, 2 = ‘Neutral’, 3 = ‘Agree’}
#'   \item{lk4}{Numerical encoding of the participant’s response to the prompt: ‘Thinking about the Lens Kit, do you agree or disagree with the following statements? - I preferred the tools already known to me’. 1 = ‘Disagree’, 2 = ‘Neutral’, 3 = ‘Agree’}
#'   \item{lk5}{Numerical encoding of the participant’s response to the prompt: ‘Thinking about the Lens Kit, do you agree or disagree with the following statements? - The Lens Kit was difficult to navigate’. 1 = ‘Disagree’, 2 = ‘Neutral’, 3 = ‘Agree’}
#'   \item{lk6}{Numerical encoding of the participant’s response to the prompt: ‘Thinking about the Lens Kit, do you agree or disagree with the following statements? - I personally used it often’. 1 = ‘Disagree’, 2 = ‘Neutral’, 3 = ‘Agree’}
#'   \item{lkSuggestions}{Response to the prompt: ‘Do you have any suggestions to improve the Lens Kit?’}
#'   \item{res1}{Logical. Indicates whether the participant selected ‘The resources were an important contribution to problem solving’ among their responses to the prompt: ‘Thinking about creating responses (both Resources and Reports) on the platform, Please select all that apply:’.}
#'   \item{res2}{Logical. Indicates whether the participant selected ‘It was easy to keep track of all the resources posted on the Platform’ among their responses to the prompt: ‘Thinking about creating responses (both Resources and Reports) on the platform, Please select all that apply:’.}
#'   \item{res3}{Logical. Indicates whether the participant selected ‘My team created a lot of resources’ among their responses to the prompt: ‘Thinking about creating responses (both Resources and Reports) on the platform, Please select all that apply:’.}
#'   \item{res4}{Logical. Indicates whether the participant selected ‘It was too time consuming to read through everyone's resources’ among their responses to the prompt: ‘Thinking about creating responses (both Resources and Reports) on the platform, Please select all that apply:’.}
#'   \item{whyRate1}{Logical. Indicates whether the participant selected ‘I used rating to fairly indicate the readiness or quality of a report’ among their responses to the prompt: ‘When you used the Report rating tool, which of the following was your primary purpose?  You can select more than one.’.}
#'   \item{whyRate2}{Logical. Indicates whether the participant selected ‘I used rating to give guidance to the author’ among their responses to the prompt: ‘When you used the Report rating tool, which of the following was your primary purpose?  You can select more than one.’.}
#'   \item{whyRate3}{Logical. Indicates whether the participant selected ‘I used rating to push my prefered report to the top’ among their responses to the prompt: ‘When you used the Report rating tool, which of the following was your primary purpose?  You can select more than one.’.}
#'   \item{ratingTool}{Numerical encoding of the participant’s response to the prompt: ‘Did you use the Report rating tool to rate the Reports your team created?’. 1 = ‘No’, 2 = ‘Yes’}
#'   \item{ratingToolWhyNot}{Response to the prompt: ‘If you tended not to rate Reports, can you say why?’}
#'   \item{featureRequests}{Response to the prompt: ‘What additional features or tools would you like to see implemented on the Platform?’}
#'   \item{externalTools}{Numerical encoding of the participant’s response to the prompt: ‘Did you use any tools to support your work on the Challenge problems that were not included on the Platform?  (eg other software such as Excel, Google Docs, Mapping tools, Chat, Conferencing, etc…)’. 1 = ‘No’, 2 = ‘Yes’}
#'   \item{externalToolsComments}{Response to the prompt: ‘Please briefly describe these tools and your main reason for using them.’}
#'   \item{bestQuestionNotAsked}{Response to the prompt: ‘What's the best question that wasn't asked on this survey?’}
#'   \item{testimonial}{Response to the prompt: ‘Do you have a testimonial about your experience in the HC2020 that you would be happy for us to share publicly? We’ll maintain your anonymity by using your username.’}
#'   \item{otherComments}{Response to the prompt: ‘Anything else that you would like to say?’}
#'   \item{aomt}{Actively Open-Minded Thinking score. Formula: aomt1 + aomt2 + aomt3 + (8 - aomt4) + (8 - aomt5) + (8 - aomt6) + (8 - aomt7) + aomt8 + (8 - aomt9) + aomt10 + aomt11}
#' }
#'
#' @name parts
NULL

#' probparts
#'
#' One row per participant-problem pairing (instance of a participant being a member of a team attempting a particular problem), with related attributes.
#'
#' @format
 #'\describe{
#'   \item{team}{Name of team the user is in}
#'   \item{user}{Name of user}
#'   \item{report_count}{Number of reports user contributed to problem}
#'   \item{resource_count}{Number of resources user contributed to problem}
#'   \item{comment_count}{Number of comments user contributed in a problem}
#'   \item{chat_count}{Number of chat messages user contributed in a problem}
#'   \item{comment_vote_count}{Number of comment upvotes user contributed in a problem}
#'   \item{resource_vote_count}{Number of resource upvotes user contributed in a problem}
#'   \item{simple_rating}{Number of times a user contributed a simple (single number) rating}
#'   \item{partial_rating}{Number of times a user contributed a partial (some of the rubrics) rating}
#'   \item{complete_rating}{Number of times a user contributed a complete (all rubrics) rating}
#'   \item{problem}{Title of the problem}
#'   \item{engagement}{Calculated number of overall engagement of one user to a problem}
#'   \item{report_count_scaled}{Number of reports user contributed to problem, scaled (within this platform instance) to range between 0 and 1}
#'   \item{resource_count_scaled}{Number of resources user contributed to problem, scaled (within this platform instance) to range between 0 and 1}
#'   \item{comment_count_scaled}{Number of comments user contributed in a problem, scaled (within this platform instance) to range between 0 and 1}
#'   \item{chat_count_scaled}{Number of chat messages user contributed in a problem, scaled (within this platform instance) to range between 0 and 1}
#'   \item{comment_vote_count_scaled}{Number of comment upvotes user contributed in a problem, scaled (within this platform instance) to range between 0 and 1}
#'   \item{resource_vote_count_scaled}{Number of resource upvotes user contributed in a problem, scaled (within this platform instance) to range between 0 and 1}
#'   \item{simple_rating_scaled}{Number of times a user contributed a simple (single number) rating, scaled (within this platform instance) to range between 0 and 1}
#'   \item{partial_rating_scaled}{Number of times a user contributed a partial (some of the rubrics) rating, scaled (within this platform instance) to range between 0 and 1}
#'   \item{complete_rating_scaled}{Number of times a user contributed a complete (all rubrics) rating, scaled (within this platform instance) to range between 0 and 1}
#'   \item{engagement_scaled}{Calculated number of overall engagement of one user to a problem, using scaled engagement scores as inputs}
#'   \item{vote_count}{comment_vote_count + resource_vote_count}
#'   \item{quick_rating}{simple_rating + partial_rating}
#'   \item{cluster}{Integer ID for the nearest ‘user role’ cluster}
#'   \item{clusterLabel}{Descriptive label for the nearest ‘user role’ cluster}
#' }
#'
#' @name probparts
NULL

#' probteams
#'
#' One row per team-problem pairing (instance of a team attempting a problem), with related attributes.
#'
#' @format
 #'\describe{
#'   \item{team}{Team name.}
#'   \item{problem}{Problem title.}
#'   \item{probNum}{Position of the problem in the sequence of problems attempted by this team in this exercise.}
#'   \item{type}{Team type. PT = Public Team; ST = Superteam; OT = Organisational Team; AA = Agency Analyst (2018 SWARM Challenge); PA = Public Analyst (2018 SWARM Challenge); GP = General Public (2018 SWARM Challenge); UT = Undergraduate Team (Psychology Capstone).}
#'   \item{avgIC}{Quality of reasoning score on the IC Rating Scale for the team’s top report. This is usually the average of independent ratings by at least 3 external raters.}
#'   \item{nIC}{Number of external raters who independently rated the report on the IC Rating Scale.}
#'   \item{rankIC}{The teams rank on this problem, when all teams who submitted a report for the problem are ranked from best to worst by avgIC. If there are ties, all tied teams receive the best (lowest integer) rank applicable.}
#'   \item{nGeoCorrect}{Number of geolocation challenges successfully solved (if applicable to the problem).}
#'   \item{probabilityEstimate}{The team’s probability estimate as stated in their top-rated report (if applicable to the problem).}
#'   \item{tightness}{The score on a tightness redaction test for the team’s top-rated report (if applicable to the problem).}
#'   \item{nBayesCorrect}{Number of Bayesian probability puzzles correctly solved (if applicable to the problem).}
#'   \item{nFlawsDetected}{Number or reasoning flaws correctly detected (if applicable to the problem).}
#'   \item{activeUsers}{The number of users who had a (strictly) positive engagement score (according to the probparts table).}
#'   \item{textSimReports}{Average pairwise cosine test similarity between all responses of type ‘report’ created by the team on the platform for this problem. Higher values indicate more similar reports. If there were no reports or only 1 report, textSimReports = 1.}
#'   \item{textSimResponses}{Average pairwise cosine test similarity between all responses (both ‘reports’ and ‘resources’) created by the team on the platform for this problem. Higher values indicate more similar reports. If there were no responses or only 1 response, textSimResponses = 1.}
#'   \item{AOMT}{Median Actively Open-Minded Thinking score for team members who were active on this problem. Missing values are excluded from the calculation.}
#'   \item{divAOMT}{Average pairwise difference in AOMT scores across all team members who were active on this problem, and for whom the AOMT score is available.}
#'   \item{medianEdu}{Median education level for the team members who were active on this problem, where education levels are encoded as follows. 1 = ‘High School’; 2 = ‘Trade or Technical Qualification’; 3 = ‘Bachelors’; 4 = ‘Graduate Certificate, Diploma or equivalent’; 5 = ‘Masters’; 6 = ‘Phd’. Missing values excluded from calculation.}
#' }
#'
#' @name probteams
NULL

#' rates
#'
#' One row per external rating, with related attributes. Contains raw quality of reasoning scores and other ratings such as on the redaction test for tightness.
#'
#' @format
 #'\describe{
#'   \item{problem}{Problem title.}
#'   \item{team}{Team name.}
#'   \item{rater}{Rater’s name.}
#'   \item{c1}{Score (Poor, Fair, Good, Excellent) assigned by rater on the IC Rating Scale Criterion 1.}
#'   \item{c1comment}{Rater’s comment associated with the score on criterion 1.}
#'   \item{c2}{Score (Poor, Fair, Good, Excellent) assigned by rater on the IC Rating Scale Criterion 2.}
#'   \item{c2comment}{Rater’s comment associated with the score on criterion 2.}
#'   \item{c3}{Score (Poor, Fair, Good, Excellent) assigned by rater on the IC Rating Scale Criterion 3.}
#'   \item{c3comment}{Rater’s comment associated with the score on criterion 3.}
#'   \item{c4}{Score (Poor, Fair, Good, Excellent) assigned by rater on the IC Rating Scale Criterion 4.}
#'   \item{c4comment}{Rater’s comment associated with the score on criterion 4.}
#'   \item{c5}{Score (Poor, Fair, Good, Excellent) assigned by rater on the IC Rating Scale Criterion 5.}
#'   \item{c5comment}{Rater’s comment associated with the score on criterion 5.}
#'   \item{c6}{Score (Poor, Fair, Good, Excellent) assigned by rater on the IC Rating Scale Criterion 6.}
#'   \item{c6comment}{Rater’s comment associated with the score on criterion 6.}
#'   \item{c7}{Score (Poor, Fair, Good, Excellent) assigned by rater on the IC Rating Scale Criterion 7.}
#'   \item{c7comment}{Rater’s comment associated with the score on criterion 7.}
#'   \item{c8}{Score (Poor, Fair, Good, Excellent) assigned by rater on the IC Rating Scale Criterion 8.}
#'   \item{c8comment}{Rater’s comment associated with the score on criterion 8.}
#'   \item{geo1}{Rater’s determination of whether the team successfully identified the geolocation problem 1 (Yes, Partial Credit, No).}
#'   \item{geo2}{Rater’s determination of whether the team successfully identified the geolocation problem 2 (Yes, Partial Credit, No).}
#'   \item{geo3}{Rater’s determination of whether the team successfully identified the geolocation problem 3 (Yes, Partial Credit, No).}
#'   \item{geo4}{Rater’s determination of whether the team successfully identified the geolocation problem 4 (Yes, Partial Credit, No).}
#'   \item{IC}{Total score on the IC Rating Scale (c1 + c2 + c3 + c4 + c5 + c6 + c7 + c8).}
#'   \item{geo1score}{Numerical score for geolocation problem 1 (Yes, Partial Credit = 1, No = 0).}
#'   \item{geo2score}{Numerical score for geolocation problem 2 (Yes, Partial Credit = 1, No = 0).}
#'   \item{geo3score}{Numerical score for geolocation problem 3 (Yes, Partial Credit = 1, No = 0).}
#'   \item{geo4score}{Numerical score for geolocation problem 4 (Yes, Partial Credit = 1, No = 0).}
#'   \item{nGeoCorrect}{geo1score + geo2score + geo3score + geo4score}
#'   \item{isRedactionTestRating}{Yes/No indicating whether the rating is a redaction test rating for tightness (rather than, say, a quality of reasoning rating using the IC Rating Scale).}
#'   \item{raterProbabilityEstimate}{The rater’s probability estimate in a redaction test to measure tightness.}
#'   \item{estTimeTaken}{Rater’s estimate of the time it took them to estimate the probability in a redaction test for tightness.}
#'   \item{estJustification}{Rater’s justification for their probability estimate in a redaction test for tightness.}
#'   \item{estComments}{Rater’s comments about the process of estimating the probability in a redaction test for tightness.}
#'   \item{bayes1}{Yes/No indicating whether the team successfully solved Bayesian probability problem 1.}
#'   \item{bayes2}{Yes/No indicating whether the team successfully solved Bayesian probability problem 2.}
#'   \item{bayes3}{Yes/No indicating whether the team successfully solved Bayesian probability problem 3.}
#'   \item{bayes1score}{Numerical score for Bayesian problem 1 (Yes = 1, No = 0).}
#'   \item{bayes2score}{Numerical score for Bayesian problem 2 (Yes = 1, No = 0).}
#'   \item{bayes3score}{Numerical score for Bayesian problem 3 (Yes = 1, No = 0).}
#'   \item{nBayesCorrect}{bayes1score + bayes2score + bayes3score}
#'   \item{flaw1}{Rater’s determination of whether the team successfully identified reasoning flaw 1 (Yes/No).}
#'   \item{flaw2}{Rater’s determination of whether the team successfully identified reasoning flaw 2 (Yes/No).}
#'   \item{flaw3}{Rater’s determination of whether the team successfully identified reasoning flaw 3 (Yes/No).}
#'   \item{flaw4}{Rater’s determination of whether the team successfully identified reasoning flaw 4 (Yes/No).}
#' }
#'
#' @name rates
NULL

#' teamparts
#'
#' One row per team-participant pairing. Useful for pairing participants with teams. Participants can be members of multiple teams over the course of an experiment. For example, a user may be a member of a generic public team in the beginning, and then be selected for a super team later on.
#'
#' @format
 #'\describe{
#'   \item{user}{Username.}
#'   \item{team}{A team of which the user was a member. (Users may be members of multiple teams over the course of an exercise. For example, they may be in an ordinary public team early on, and then get selected for a superteam later. In such a case, there would be two rows in this table, one for each pairing of a user with a team.)}
#' }
#'
#' @name teamparts
NULL

#' teams
#'
#' One row per team in the competition, with related attributes.
#'
#' @format
 #'\describe{
#'   \item{team}{Team name.}
#'   \item{AOMT}{Median Actively Open-Minded Thinking score for team members. Missing values are excluded from the calculation. Note that this statistic even includes team members who may not have been active on a particular problem. For a problem-specific version, see the probteams table.}
#'   \item{divAOMT}{Average pairwise difference in AOMT scores across all team members for whom the AOMT score is available. Note that this statistic even includes team members who may not have been active on a particular problem. For a problem-specific version, see the probteams table.}
#'   \item{medianEdu}{Median education level for the team, where education levels are encoded as follows. 1 = ‘High School’; 2 = ‘Trade or Technical Qualification’; 3 = ‘Bachelors’; 4 = ‘Graduate Certificate, Diploma or equivalent’; 5 = ‘Masters’; 6 = ‘Phd’. Missing values excluded from calculation. Note that this statistic even includes team members who may not have been active on a particular problem. For a problem-specific version, see the probteams table.}
#'   \item{type}{Team type. PT = Public Team; ST = Superteam; OT = Organisational Team; AA = Agency Analyst (2018 SWARM Challenge); PA = Public Analyst (2018 SWARM Challenge); GP = General Public (2018 SWARM Challenge); UT = Undergraduate Team (Psychology Capstone).}
#' }
#'
#' @name teams
NULL

