#Project Title: RFL R Production
#File Title: Try-Catch-Log
#File Purpose: These functions should be used within any R scripts being triggered by the warehouse to run regularly, to log failures.
#Author: Edward Watkinson (edward.watkinson@nhs.net)
#Team: Performance and Analytics RFL

#' Log Errors
#' @param out A string or R error, the thing you want to log.
#' @param RProcessName A string, the name of the RFL proccess the function is being run.
#' @param RScriptName A string, the script file being run.
#' @param RScriptLocation A string, where the file is stored
#' @param RErrorLogName A string, the log of the run
#' @param RErrorLogLocation A string, the log location
#' @return Success if no errors, or failure and failure logged in the data warehouse
#' @examples rfl_logRunError(
#' RProcessName = "PerformancePulse",
#' RScriptName = "deploy_app.R",
#' RScriptLocation = "\\\\rfh-information\\G$\\RScripts\\PerformancePulse",
#' RErrorLogName	=	"deploy_app_outfile.ROut",
#' RErrorLogLocation = "\\\\rfh-information\\G$\\RScripts\\PerformancePulse\\logs"
#' )

rfl_logRunError <- function(out, ...) {
  con <- dbConnect(
    odbc(),
    Driver = "SQL Server",
    Server = "rfh-information",
    Database = "RF_Common",
    Trusted_Connection = "True"
  )
    log_content <- data.frame(...,
                              Run_DateTime = Sys.time(),
                              RErrorContent = as.character(out))
  message("Something failed - writing error log to data warehouse...")
  dbWriteTable(con, "RErrorLog", log_content, append = TRUE)
  dbDisconnect(con)
}


#' Try to Run A Function, log if There's an Error
#'
#' @param fun A function to run,
#' @param RProcessName A string, the name of the RFL proccess the function is being run.
#' @param RScriptName A string, the script file being run.
#' @param RScriptLocation A string, where the file is stored
#' @param RErrorLogName A string, the log of the run
#' @param RErrorLogLocation A string, the log location
#' @return Success if no errors, or failure and failure logged in the data warehouse
#' @examples rfl_tryCatchLog(
#' sum(c(1,2)),
#' RProcessName = "PerformancePulse",
#' RScriptName = "deploy_app.R",
#' RScriptLocation = "\\\\rfh-information\\G$\\RScripts\\PerformancePulse",
#' RErrorLogName	=	"deploy_app_outfile.ROut",
#' RErrorLogLocation = "\\\\rfh-information\\G$\\RScripts\\PerformancePulse\\logs"
#' )

rfl_tryCatchLog <- function(fun,
                            RProcessName,
                            RScriptName,
                            RScriptLocation,
                            RErrorLogName,
                            RErrorLogLocation) {
  tryCatch(fun, error = function(out) {
    con <- dbConnect(
      odbc(),
      Driver = "SQL Server",
      Server = "rfh-information",
      Database = "RF_Common",
      Trusted_Connection = "True"
    )
    log_content <- data.frame(
      RProcessName = RProcessName,
      RScriptName = RScriptName,
      RScriptLocation = RScriptLocation,
      RErrorLogName	=	RErrorLogName,
      RErrorLogLocation = RErrorLogLocation,
      Run_DateTime = Sys.time(),
      RErrorContent = as.character(out)
    )

    message("Something failed - writing error log to data warehouse...")
    dbWriteTable(con, "RErrorLog", log_content, append = TRUE)
    dbDisconnect(con)
  })
}
