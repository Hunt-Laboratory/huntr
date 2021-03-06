% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\name{rates}
\alias{rates}
\title{rates}
\format{
\describe{
  \item{problem}{Problem title.}
  \item{team}{Team name.}
  \item{rater}{Rater’s name.}
  \item{c1}{Score (Poor, Fair, Good, Excellent) assigned by rater on the IC Rating Scale Criterion 1.}
  \item{c1comment}{Rater’s comment associated with the score on criterion 1.}
  \item{c2}{Score (Poor, Fair, Good, Excellent) assigned by rater on the IC Rating Scale Criterion 2.}
  \item{c2comment}{Rater’s comment associated with the score on criterion 2.}
  \item{c3}{Score (Poor, Fair, Good, Excellent) assigned by rater on the IC Rating Scale Criterion 3.}
  \item{c3comment}{Rater’s comment associated with the score on criterion 3.}
  \item{c4}{Score (Poor, Fair, Good, Excellent) assigned by rater on the IC Rating Scale Criterion 4.}
  \item{c4comment}{Rater’s comment associated with the score on criterion 4.}
  \item{c5}{Score (Poor, Fair, Good, Excellent) assigned by rater on the IC Rating Scale Criterion 5.}
  \item{c5comment}{Rater’s comment associated with the score on criterion 5.}
  \item{c6}{Score (Poor, Fair, Good, Excellent) assigned by rater on the IC Rating Scale Criterion 6.}
  \item{c6comment}{Rater’s comment associated with the score on criterion 6.}
  \item{c7}{Score (Poor, Fair, Good, Excellent) assigned by rater on the IC Rating Scale Criterion 7.}
  \item{c7comment}{Rater’s comment associated with the score on criterion 7.}
  \item{c8}{Score (Poor, Fair, Good, Excellent) assigned by rater on the IC Rating Scale Criterion 8.}
  \item{c8comment}{Rater’s comment associated with the score on criterion 8.}
  \item{geo1}{Rater’s determination of whether the team successfully identified the geolocation problem 1 (Yes, Partial Credit, No).}
  \item{geo2}{Rater’s determination of whether the team successfully identified the geolocation problem 2 (Yes, Partial Credit, No).}
  \item{geo3}{Rater’s determination of whether the team successfully identified the geolocation problem 3 (Yes, Partial Credit, No).}
  \item{geo4}{Rater’s determination of whether the team successfully identified the geolocation problem 4 (Yes, Partial Credit, No).}
  \item{IC}{Total score on the IC Rating Scale (c1 + c2 + c3 + c4 + c5 + c6 + c7 + c8).}
  \item{geo1score}{Numerical score for geolocation problem 1 (Yes, Partial Credit = 1, No = 0).}
  \item{geo2score}{Numerical score for geolocation problem 2 (Yes, Partial Credit = 1, No = 0).}
  \item{geo3score}{Numerical score for geolocation problem 3 (Yes, Partial Credit = 1, No = 0).}
  \item{geo4score}{Numerical score for geolocation problem 4 (Yes, Partial Credit = 1, No = 0).}
  \item{nGeoCorrect}{geo1score + geo2score + geo3score + geo4score}
  \item{isRedactionTestRating}{Yes/No indicating whether the rating is a redaction test rating for tightness (rather than, say, a quality of reasoning rating using the IC Rating Scale).}
  \item{raterProbabilityEstimate}{The rater’s probability estimate in a redaction test to measure tightness.}
  \item{estTimeTaken}{Rater’s estimate of the time it took them to estimate the probability in a redaction test for tightness.}
  \item{estJustification}{Rater’s justification for their probability estimate in a redaction test for tightness.}
  \item{estComments}{Rater’s comments about the process of estimating the probability in a redaction test for tightness.}
  \item{bayes1}{Yes/No indicating whether the team successfully solved Bayesian probability problem 1.}
  \item{bayes2}{Yes/No indicating whether the team successfully solved Bayesian probability problem 2.}
  \item{bayes3}{Yes/No indicating whether the team successfully solved Bayesian probability problem 3.}
  \item{bayes1score}{Numerical score for Bayesian problem 1 (Yes = 1, No = 0).}
  \item{bayes2score}{Numerical score for Bayesian problem 2 (Yes = 1, No = 0).}
  \item{bayes3score}{Numerical score for Bayesian problem 3 (Yes = 1, No = 0).}
  \item{nBayesCorrect}{bayes1score + bayes2score + bayes3score}
  \item{flaw1}{Rater’s determination of whether the team successfully identified reasoning flaw 1 (Yes/No).}
  \item{flaw2}{Rater’s determination of whether the team successfully identified reasoning flaw 2 (Yes/No).}
  \item{flaw3}{Rater’s determination of whether the team successfully identified reasoning flaw 3 (Yes/No).}
  \item{flaw4}{Rater’s determination of whether the team successfully identified reasoning flaw 4 (Yes/No).}
}
}
\description{
One row per external rating, with related attributes. Contains raw quality of reasoning scores and other ratings such as on the redaction test for tightness.
}
