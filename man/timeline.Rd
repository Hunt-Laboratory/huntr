% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\name{timeline}
\alias{timeline}
\title{timeline}
\format{
\describe{
  \item{chunk_id}{Unique identifier for the artefact contributed (can be a report, resource, comment, rating, update)}
  \item{parent_id}{Unique identifier for the source the artefact was contributed to (a report or resource in case of a comment or update, a problem_id in case of a report or resource, a report in case of a rating)}
  \item{problem_id}{Unique identifier for the problem (e.g. in case the artefact is a report or resource parent and problem id are identical)}
  \item{team_id}{Unique identifier for team}
  \item{team}{Name of team}
  \item{timestamp}{Timestamp when artefact was contributed, for resources, reports and comments this is their first post, for ratings only the last update is stored}
  \item{type}{The artefact type, can be report, resource, comment, rating, update}
  \item{problem}{The problem title}
  \item{user_id}{Unique indentifier of the user contributing the artefact}
  \item{user}{Name of user}
}
}
\description{
Another handy table that stores actions on the platform. Collects timestamps for all resources and reports posted on the platform, timestamps for all comments made on the platform including on which report/resource, timestamp for ratings made including on which report and updates made to resources and reports. Caveat: updates are stored as single edits and have to be mangled to become useful (e.g. only count edits made at least 5 minutes apart as an actual update).
}
