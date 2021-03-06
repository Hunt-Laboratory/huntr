% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\name{analytics}
\alias{analytics}
\title{analytics}
\format{
\describe{
  \item{team}{Name of team the user is in}
  \item{team_id}{Unique identifier of the team the user is in}
  \item{problem_id}{Unique identifier of the problem the team is working on}
  \item{user}{Name of user}
  \item{user_id}{Unique identifier of user}
  \item{report_count}{Number of reports user contributed to problem}
  \item{resource_count}{Number of resources user contributed to problem}
  \item{comment_count}{Number of comments user contributed in a problem}
  \item{chat_count}{Number of chat messages user contributed in a problem}
  \item{comment_vote_count}{Number of comment upvotes user contributed in a problem}
  \item{resource_vote_count}{Number of resource upvotes user contributed in a problem}
  \item{simple_rating}{Number of times a user contributed a simple (single number) rating}
  \item{partial_rating}{Number of times a user contributed a partial (some of the rubrics) rating}
  \item{complete_rating}{Number of times a user contributed a complete (all rubrics) rating}
  \item{problem}{Title of the problem}
  \item{engagement}{Engagement score calculated as a weighted sum of the various activity counts for the user on this problem. Reports have weight 7; resources and complete ratings have weight 3; comments have weight 2; chat messages, simple ratings, partial ratings, comment votes and resource votes have weight 1.}
  \item{report_count_scaled}{Number of reports user contributed to problem, scaled (within this platform instance) to range between 0 and 1}
  \item{resource_count_scaled}{Number of resources user contributed to problem, scaled (within this platform instance) to range between 0 and 1}
  \item{comment_count_scaled}{Number of comments user contributed in a problem, scaled (within this platform instance) to range between 0 and 1}
  \item{chat_count_scaled}{Number of chat messages user contributed in a problem, scaled (within this platform instance) to range between 0 and 1}
  \item{comment_vote_count_scaled}{Number of comment upvotes user contributed in a problem, scaled (within this platform instance) to range between 0 and 1}
  \item{resource_vote_count_scaled}{Number of resource upvotes user contributed in a problem, scaled (within this platform instance) to range between 0 and 1}
  \item{simple_rating_scaled}{Number of times a user contributed a simple (single number) rating, scaled (within this platform instance) to range between 0 and 1}
  \item{partial_rating_scaled}{Number of times a user contributed a partial (some of the rubrics) rating, scaled (within this platform instance) to range between 0 and 1}
  \item{complete_rating_scaled}{Number of times a user contributed a complete (all rubrics) rating, scaled (within this platform instance) to range between 0 and 1}
  \item{engagement_scaled}{Engagement score calculated as a weighted sum of the various scaled activity counts for the user on this problem. Reports have weight 7; resources and complete ratings have weight 3; comments have weight 2; chat messages, simple ratings, partial ratings, comment votes and resource votes have weight 1.}
  \item{vote_count}{comment_vote_count + resource_vote_count}
  \item{quick_rating}{simple_rating + partial_rating}
}
}
\description{
In this table we capture how many reports, resources, comments, resource_votes, comment_votes, single, partial or full ratings and chat messages each user makes for a specific problem in a specific group in one handy analytics file. We also calculate an engagement level. Engagement is measured by assigning 7 points for a report, 4 points for a resource, 3 points for a complete rating, 2 points for a comment, on point for a chat message, a single or partial rating or a comment vote.
}
