% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\name{teams}
\alias{teams}
\title{teams}
\format{
\describe{
  \item{team}{Team name.}
  \item{AOMT}{Median Actively Open-Minded Thinking score for team members. Missing values are excluded from the calculation. Note that this statistic even includes team members who may not have been active on a particular problem. For a problem-specific version, see the probteams table.}
  \item{divAOMT}{Average pairwise difference in AOMT scores across all team members for whom the AOMT score is available. Note that this statistic even includes team members who may not have been active on a particular problem. For a problem-specific version, see the probteams table.}
  \item{medianEdu}{Median education level for the team, where education levels are encoded as follows. 1 = ‘High School’; 2 = ‘Trade or Technical Qualification’; 3 = ‘Bachelors’; 4 = ‘Graduate Certificate, Diploma or equivalent’; 5 = ‘Masters’; 6 = ‘Phd’. Missing values excluded from calculation. Note that this statistic even includes team members who may not have been active on a particular problem. For a problem-specific version, see the probteams table.}
  \item{type}{Team type. PT = Public Team; ST = Superteam; OT = Organisational Team; AA = Agency Analyst (2018 SWARM Challenge); PA = Public Analyst (2018 SWARM Challenge); GP = General Public (2018 SWARM Challenge); UT = Undergraduate Team (Psychology Capstone).}
}
}
\description{
One row per team in the competition, with related attributes.
}
