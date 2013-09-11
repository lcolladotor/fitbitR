#' Reproduce the analysis
#'
#' Reproduces all the analysis steps for Russo's JHSPH Biostat Qualifying exam 2013. To do so it will create a directory called \code{fitbitResults} in your working directory.
#'
#' @param step If \code{all} then it reproduces all the steps. Other options are \code{EDA}, \code{pred}, \code{Q1}, \code{Q2} and \code{Q3}.
#' @param verbose If \code{TRUE} then progress messages will be printed along the way.
#' @param browse If \code{TRUE} browser windows are opened after the completition of each step.
#'
#' @details For maximum cool factor, this package requires the version of \code{markdown} that is available from GitHub, which sadly has the same version number as the version from CRAN so it won't be detected through the usual means.
#'
#' @return The directory \code{fitbitResults} inside your working directory with all the analysis steps reproduced.
#'
#'
#' @examples 
#' ## Reproduce the EDA portion
#' reproduceAnalysis(step="EDA")
#' 
#' \dontrun{
#' ## Reproduce the entire analysis
#' reproduceAnalysis(step="all")
#' }
#' @export
#' @references knitr bootstrap html format from https://github.com/jimhester/knitr_bootstrap

reproduceAnalysis <- function(step="all", verbose=TRUE, browse=TRUE) {
	if(!step %in% c("all", "EDA", "pred", "Q1", "Q2", "Q3")) stop("'step' is not a recognized option.")
		
	## Save start time for getting the total processing time
	startTime <- Sys.time()
	
	if(verbose) message("Setting up.")
	# Required packages	
	library(knitr)
	library(markdown)
	library(knitrBootstrap)
			
	## For super-coolness, make sure that the user has the correct version of the markdown package.
	if(!"header" %in% formalArgs(markdownToHTML)) {
		stop("Your version of the markdown package is outdated. Please updated it using: library(devtools); install_github(username='rstudio', repo='markdown')")
	}	
	
	## Save the working directory
	wdir <- getwd()
			
	## Build folder structure
	root <- "fitbitResults"
	if(step == "all") {
		steps <- c("EDA", "pred", "Q1", "Q2", "Q3")
	} else {
		steps <- step
	}
	for(i in steps) {
		dir.create(file.path(root, i), showWarnings=FALSE, recursive=TRUE)
	}
	
	## Identify srcdir
	srcdir <- system.file(root, package="fitbitR")
	
	## EDA
	if(step %in% c("EDA", "all")) {
		.runStep("EDA", verbose, wdir, root, browse, srcdir)
	}
	
	## Pred
	if(step %in% c("pred", "all")) {
		.runStep("pred", verbose, wdir, root, browse, srcdir)
	}
	
	## Question 1
	if(step %in% c("Q1", "all")) {
		.runStep("Q1", verbose, wdir, root, browse, srcdir)
	}
	
	## Question 2
	if(step %in% c("Q2", "all")) {
		.runStep("Q2", verbose, wdir, root, browse, srcdir)
	}
	
	## Question 3
	if(step %in% c("Q3", "all")) {
		.runStep("Q3", verbose, wdir, root, browse, srcdir)
	}

	
	## Change back to the working directory
	setwd(wdir)	
	
	## Done =)
	if(verbose)	{
		message("Done!")
		totalTime <- diff(c(startTime, Sys.time()))
		print("Total time spent reproducing the analysis:")
		print(totalTime)
	}
	
	
	return(invisible(NULL))
}
## Helper function that knits a specific part of the analysis
.runStep <- function(curstep, verbose, wdir, root, browse, srcdir) {
	if(verbose) message(paste("Running", curstep, "step."))
	
	
	## Move to the correct directory and locate the subdir with the file to knit
	setwd(wdir)	
	runDir <- file.path(wdir, root, curstep)
	setwd(runDir)
	
	## Identify Rmd file to use
	input <- paste0(file.path(srcdir, curstep, curstep), ".Rmd")
	
	## Knit and be done
	knit_bootstrap(input=input, code_style='Brown Paper', chooser=c('boot', 'code'), show_code=FALSE)
	if (browse) browseURL(paste0(curstep, ".html"))
}
