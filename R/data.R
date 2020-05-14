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
#'   \item{comment_file}{A unique filename in the ""Comments"" subfolder that contains the HTML file of the comment}
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
#'   \item{problem_file}{A unique filename in the ""Problems"" subfolder that contains the HTML file of the problem}
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
#'   \item{content_type}{""report"", ""resource"", or ""comment"". Other types may be added in future.}
#'   \item{content_id}{Unique identifier for the content (content can be response or comment)}
#'   \item{author_id}{Unique identifier of the original author of the response}
#'   \item{author}{Name of the user who originally authored the response}
#'   \item{rater_id}{Unique identifier of a user who rated the response}
#'   \item{rater}{Name of the user who rated the response}
#'   \item{last_edited}{Timestamp when the rating was last updated}
#'   \item{rating_type}{""thumbs"", ""simple"", ""detailed""}
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
#'   \item{response_type}{Type of response, currently ""report"" or ""resource"". More types may be added in future}
#'   \item{response_text}{A unique filename of the response content in markdown text format}
#'   \item{response_file}{A unique filename in the ""Responses"" subfolder that contains the HTML file of the response}
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
#'   \item{report_id}{Unique identifier for the report (response of type ""report"")}
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
#'   \item{agreedToTerms}{}
#'   \item{agegroup}{Age group.}
#'   \item{gender}{Gender.}
#'   \item{occupation}{Occupation status.}
#'   \item{education}{Highest education level.}
#'   \item{studyarea}{Study area.}
#'   \item{studyareaOtherInput}{Free text input for ‘Other’ study area, if selected.}
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
#'   \item{enExpct1}{Numerical encoding of the participants response to the prompt: ‘What are your expectations for your Challenge experience?: Interesting problems’. 1 = ‘I don’t expect this’, 2 = ‘Neutral’, 3 = ‘I do expect this’.}
#'   \item{enExpct2}{Numerical encoding of the participants response to the prompt: ‘What are your expectations for your Challenge experience?: Reasonable time commitment’. 1 = ‘I don’t expect this’, 2 = ‘Neutral’, 3 = ‘I do expect this’.}
#'   \item{enExpct3}{Numerical encoding of the participants response to the prompt: ‘What are your expectations for your Challenge experience?: Difficult problems’. 1 = ‘I don’t expect this’, 2 = ‘Neutral’, 3 = ‘I do expect this’.}
#'   \item{enExpct4}{Numerical encoding of the participants response to the prompt: ‘What are your expectations for your Challenge experience?: I will learn new skills and tools’. 1 = ‘I don’t expect this’, 2 = ‘Neutral’, 3 = ‘I do expect this’.}
#'   \item{enExpct5}{Numerical encoding of the participants response to the prompt: ‘What are your expectations for your Challenge experience?: Problems are achievable, for a team’. 1 = ‘I don’t expect this’, 2 = ‘Neutral’, 3 = ‘I do expect this’.}
#'   \item{enExpct6}{Numerical encoding of the participants response to the prompt: ‘What are your expectations for your Challenge experience?: The platform will be a productive work space’. 1 = ‘I don’t expect this’, 2 = ‘Neutral’, 3 = ‘I do expect this’.}
#'   \item{enExpct7}{Numerical encoding of the participants response to the prompt: ‘What are your expectations for your Challenge experience?: Training in analytical techniques’. 1 = ‘I don’t expect this’, 2 = ‘Neutral’, 3 = ‘I do expect this’.}
#'   \item{enExpct8}{Numerical encoding of the participants response to the prompt: ‘What are your expectations for your Challenge experience?: Positive team working experience’. 1 = ‘I don’t expect this’, 2 = ‘Neutral’, 3 = ‘I do expect this’.}
#'   \item{enExpct9}{Numerical encoding of the participants response to the prompt: ‘What are your expectations for your Challenge experience?: An effective collaboration, compared to my normal methods’. 1 = ‘I don’t expect this’, 2 = ‘Neutral’, 3 = ‘I do expect this’.}
#'   \item{enExpct10}{Numerical encoding of the participants response to the prompt: ‘What are your expectations for your Challenge experience?: What I learn from the challenge can be applied in my workplace’. 1 = ‘I don’t expect this’, 2 = ‘Neutral’, 3 = ‘I do expect this’.}
#'   \item{pri1}{Numerical encoding of the participants response to the prompt: ‘How important to you are the following reasons for taking part in the Challenge? - Seeing how my team performs against the others’. 1 = ‘Not important’, 2 = ‘Neutral’, 3 = ‘Important’.}
#'   \item{pri2}{Numerical encoding of the participants response to the prompt: ‘How important to you are the following reasons for taking part in the Challenge? - Testing my own skills and abilities’. 1 = ‘Not important’, 2 = ‘Neutral’, 3 = ‘Important’.}
#'   \item{pri3}{Numerical encoding of the participants response to the prompt: ‘How important to you are the following reasons for taking part in the Challenge? - I think it will be fun’. 1 = ‘Not important’, 2 = ‘Neutral’, 3 = ‘Important’.}
#'   \item{pri4}{Numerical encoding of the participants response to the prompt: ‘How important to you are the following reasons for taking part in the Challenge? - Developing my overall analytic skills’. 1 = ‘Not important’, 2 = ‘Neutral’, 3 = ‘Important’.}
#'   \item{pri5}{Numerical encoding of the participants response to the prompt: ‘How important to you are the following reasons for taking part in the Challenge? - Learning how the SWARM Platform works’. 1 = ‘Not important’, 2 = ‘Neutral’, 3 = ‘Important’.}
#'   \item{pri6}{Numerical encoding of the participants response to the prompt: ‘How important to you are the following reasons for taking part in the Challenge? - Learning about Contending Analyses’. 1 = ‘Not important’, 2 = ‘Neutral’, 3 = ‘Important’.}
#'   \item{pri7}{Numerical encoding of the participants response to the prompt: ‘How important to you are the following reasons for taking part in the Challenge? - Trying a new style of team collaboration’. 1 = ‘Not important’, 2 = ‘Neutral’, 3 = ‘Important’.}
#'   \item{pri8}{Numerical encoding of the participants response to the prompt: ‘How important to you are the following reasons for taking part in the Challenge? - Contributing to research in intelligence analysis’. 1 = ‘Not important’, 2 = ‘Neutral’, 3 = ‘Important’.}
#'   \item{pri9}{Numerical encoding of the participants response to the prompt: ‘How important to you are the following reasons for taking part in the Challenge? - Getting selected for a Super Team’. 1 = ‘Not important’, 2 = ‘Neutral’, 3 = ‘Important’.}
#'   \item{pri10}{Numerical encoding of the participants response to the prompt: ‘How important to you are the following reasons for taking part in the Challenge? - Exploring the Lens Kit’. 1 = ‘Not important’, 2 = ‘Neutral’, 3 = ‘Important’.}
#'   \item{pri11}{Numerical encoding of the participants response to the prompt: ‘How important to you are the following reasons for taking part in the Challenge? - Participating in crowd sourced intelligence analysis’. 1 = ‘Not important’, 2 = ‘Neutral’, 3 = ‘Important’.}
#'   \item{priOther}{Numerical encoding of the participants response to the prompt: ‘How important to you are the following reasons for taking part in the Challenge? - Other’. 1 = ‘Not important’, 2 = ‘Neutral’, 3 = ‘Important’.}
#'   \item{priOtherInput}{Specified ‘Other’ priority referred to by priOther (if applicable)}
#'   \item{aomt1}{Numerical encoding of the participants response to the prompt: ‘Allowing oneself to be convinced by an opposing argument is a sign of good character.’. 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{aomt2}{Numerical encoding of the participants response to the prompt: ‘People should take into consideration evidence that goes against their beliefs.’. 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{aomt3}{Numerical encoding of the participants response to the prompt: ‘People should revise their beliefs in light of new information or evidence.’. 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{aomt4}{Numerical encoding of the participants response to the prompt: ‘Changing your mind is a sign of weakness.’. 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{aomt5}{Numerical encoding of the participants response to the prompt: ‘Intuition is the best guide in making decisions.’. 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{aomt6}{Numerical encoding of the participants response to the prompt: ‘It is important to persevere in your beliefs even when evidence is brought to bear against them.’. 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{aomt7}{Numerical encoding of the participants response to the prompt: ‘One should disregard evidence that conflicts with one's established beliefs.’. 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{aomt8}{Numerical encoding of the participants response to the prompt: ‘People should search actively for reasons why their beliefs might be wrong.’. 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{aomt9}{Numerical encoding of the participants response to the prompt: ‘When we are faced with a new question, the first answer that occurs to us is usually best.’. 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{aomt10}{Numerical encoding of the participants response to the prompt: ‘When faced with a new question, we should consider more than one possible answer before reaching a conclusion.’. 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{aomt11}{Numerical encoding of the participants response to the prompt: ‘When faced with a new question, we should look for reasons why our first answer might be wrong, before deciding on an answer.’. 1 = ‘Strongly disagree’, 2 = ‘Disagree’, 3 = ‘Somewhat disagree’, 4 = ‘Neither agree nor disagree’, 5 = ‘Somewhat agree’, 6 = ‘Agree’, 7 = ‘Strongly agree’.}
#'   \item{enCap1}{Numerical encoding of the participants response to the prompt: ‘How would you assess your current capability in the follow areas? This may be from your job, from studies, or from other activities. - Analytic report writing’. 1 = ‘None’, 2 = ‘Low’, 3 = ‘Moderate’, 4 = ‘High’.}
#'   \item{enCap2}{Numerical encoding of the participants response to the prompt: ‘How would you assess your current capability in the follow areas? This may be from your job, from studies, or from other activities. - Using structured analytic techniques’. 1 = ‘None’, 2 = ‘Low’, 3 = ‘Moderate’, 4 = ‘High’.}
#'   \item{enCap3}{Numerical encoding of the participants response to the prompt: ‘How would you assess your current capability in the follow areas? This may be from your job, from studies, or from other activities. - Using OSINT tools and resources’. 1 = ‘None’, 2 = ‘Low’, 3 = ‘Moderate’, 4 = ‘High’.}
#'   \item{enCap4}{Numerical encoding of the participants response to the prompt: ‘How would you assess your current capability in the follow areas? This may be from your job, from studies, or from other activities. - Applying strategic thinking frameworks’. 1 = ‘None’, 2 = ‘Low’, 3 = ‘Moderate’, 4 = ‘High’.}
#'   \item{enCap5}{Numerical encoding of the participants response to the prompt: ‘How would you assess your current capability in the follow areas? This may be from your job, from studies, or from other activities. - Identifying and analysing assumptions’. 1 = ‘None’, 2 = ‘Low’, 3 = ‘Moderate’, 4 = ‘High’.}
#'   \item{enCap6}{Numerical encoding of the participants response to the prompt: ‘How would you assess your current capability in the follow areas? This may be from your job, from studies, or from other activities. - Evaluating quality of analytic reasoning’. 1 = ‘None’, 2 = ‘Low’, 3 = ‘Moderate’, 4 = ‘High’.}
#'   \item{enCap7}{Numerical encoding of the participants response to the prompt: ‘How would you assess your current capability in the follow areas? This may be from your job, from studies, or from other activities. - Using decision making frameworks’. 1 = ‘None’, 2 = ‘Low’, 3 = ‘Moderate’, 4 = ‘High’.}
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
#'   \item{timeWellSpent}{Numerical encoding of the participants response to the prompt: ‘Did you feel that your participation was time well spent?’. 1 = ‘No’, 2 = ‘Unsure’, 3 = ‘Yes’}
#'   \item{bestThing}{Response to the prompt: ‘What was the one BEST thing about your Challenge experience?’}
#'   \item{worstThing}{Response to the prompt: ‘What was the one WORST thing about your Challenge experience?’}
#'   \item{hoursPerWeek}{Response to the prompt: ‘How many hours did your organisation allow for your participation during work hours per week? Please enter the number, 1, 2, 3, etc...’}
#'   \item{enoughtTime}{Numerical encoding of the participants response to the prompt: ‘Did your organisation allow you enough time off regular duties to participate fully?’. 1 = ‘No’, 2 = ‘Yes’}
#'   \item{proportionOwnTime}{Response to the prompt: ‘What proportion of your participation was done in your own time? (outside of work hours)? Please enter the number, 10, 25, 50, etc...’}
#'   \item{rate1}{Numerical encoding of the participants response to the prompt: ‘How do you rate these aspects of the Challenge? - The onboarding process’. 1 = ‘Poor’, 2 = ‘Average’, 3 = ‘Good’}
#'   \item{rate2}{Numerical encoding of the participants response to the prompt: ‘How do you rate these aspects of the Challenge? - Our communication with you’. 1 = ‘Poor’, 2 = ‘Average’, 3 = ‘Good’}
#'   \item{rate3}{Numerical encoding of the participants response to the prompt: ‘How do you rate these aspects of the Challenge? - The training’. 1 = ‘Poor’, 2 = ‘Average’, 3 = ‘Good’}
#'   \item{rate4}{Numerical encoding of the participants response to the prompt: ‘How do you rate these aspects of the Challenge? - The feedback’. 1 = ‘Poor’, 2 = ‘Average’, 3 = ‘Good’}
#'   \item{rate5}{Numerical encoding of the participants response to the prompt: ‘How do you rate these aspects of the Challenge? - The Help Center’. 1 = ‘Poor’, 2 = ‘Average’, 3 = ‘Good’}
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
#'   \item{type}{Team type. PT = Public Team; ST = Superteam; OT = Organisational Team;}
#'   \item{avgIC}{Quality of reasoning score on the IC Rating Scale for the team’s top report. This is usually the average of independent ratings by at least 3 external raters.}
#'   \item{nIC}{Number of external raters who independently rated the report on the IC Rating Scale.}
#'   \item{rankIC}{The teams rank on this problem, when all teams who submitted a report for the problem are ranked from best to worst by avgIC. If there are ties, all tied teams receive the best (lowest integer) rank applicable.}
#'   \item{nGeoCorrect}{Number of geolocation challenges successfully solved (if applicable to the problem).}
#'   \item{probabilityEstimate}{The team’s probability estimate as stated in their top-rated report (if applicable to the problem).}
#'   \item{tightness}{The score on a tightness redaction test for the team’s top-rated report (if applicable to the problem).}
#'   \item{nBayesCorrect}{Number of Bayesian probability puzzles correctly solved (if applicable to the problem).}
#'   \item{nFlawsDetected}{Number or reasoning flaws correctly detected (if applicable to the problem).}
#'   \item{activeUsersSq}{Square of the number of users who had a (strictly) positive engagement score (according to the probparts table).}
#'   \item{textSim}{Average pairwise cosine test similarity between all responses of type ‘report’ created by the team on the platform for this problem. Higher values indicate more similar reports. If there were no reports or only 1 report, textSim = 1.}
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
#'   \item{ODNI}{Total score on the IC Rating Scale (c1 + c2 + c3 + c4 + c5 + c6 + c7 + c8).}
#'   \item{geo1score}{Numerical score for geolocation problem 1 (Yes, Partial Credit = 1, No = 0).}
#'   \item{geo2score}{Numerical score for geolocation problem 2 (Yes, Partial Credit = 1, No = 0).}
#'   \item{geo3score}{Numerical score for geolocation problem 3 (Yes, Partial Credit = 1, No = 0).}
#'   \item{geo4score}{Numerical score for geolocation problem 4 (Yes, Partial Credit = 1, No = 0).}
#'   \item{geoOverall}{geo1score + geo2score + geo3score + geo4score}
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
#'   \item{AOMT}{Median Actively Open-Minded Thinking score for team members. Missing values are excluded from the calculation.}
#'   \item{divAOMT}{Average pairwise difference in AOMT scores across all team members for whom the AOMT score is available.}
#'   \item{medianEdu}{Median education level for the team, where education levels are encoded as follows. 1 = ‘High School’; 2 = ‘Trade or Technical Qualification’; 3 = ‘Bachelors’; 4 = ‘Graduate Certificate, Diploma or equivalent’; 5 = ‘Masters’; 6 = ‘Phd’. Missing values excluded from calculation.}
#'   \item{type}{Team type. PT = Public Team; ST = Superteam; OT = Organisational Team;}
#' }
#'
#' @name teams
NULL

