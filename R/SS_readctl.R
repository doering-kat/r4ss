#' read control file from SS
#'
#' Read Stock Synthesis control file into list object in R. This function is a
#' wrapper which calls either SS_readctl_3.24 or SS_readctl_3.30 (not yet written).
#' This setup allows those functions to be cleaner (if somewhat redundant)
#' than a single function that attempts to do everything.
#'
#'
#' @param file Filename either with full path or relative to working directory.
#' @param version SS version number. Currently only "3.24" or "3.30" are supported,
#' either as character or numeric values (noting that numeric 3.30  = 3.3).
#' @param verbose Should there be verbose output while running the file?
#' Default=TRUE.
#' @param echoall Debugging tool (not fully implemented) of echoing blocks of
#' data as it is being read.
#' @param nseas number of season in the model. This information is not
#'  explicitly available in control file
#' @param N_areas number of spatial areas in the model. This information is also not
#'  explicitly available in control file
#' @param Nages oldest age in the model. This information is also not
#'  explicitly available in control file
#' @param Ngenders number of genders in the model. This information is also not
#'  explicitly available in control file
#' @param Npopbins number of population bins in the model. This information is
#' also not explicitly available in control file and this information is only
#' required if length based
#'  maturity vector is directly supplied (Maturity option of 6), and not yet tested
#' @param Nfleet number of fisheries in the model. This information is also not
#'  explicitly available in control file
#' @param Nsurveys number of survey fleets in the model. This information is also not
#'  explicitly available in control file
#' @param N_tag_groups number of tag release groups in the model.
#' This information is also not explicitly available in control file.
#' @param N_CPUE_obs number of CPUE observations.
#' @param use_datlist LOGICAL if TRUE, use datlist to derive parameters which can not be
#'  determined from control file
#' @param datlist list or character. if list : produced from SS_writedat
#'  or character : file name of dat file.
#' @param ptype include a column in the output indicating parameter type?
#'  (Can be useful, but causes problems for SS_writectl.) Only possible to use
#'  for 3.24 control files.
#' @author Ian G. Taylor, Yukio Takeuchi, Neil L Klaer
#' @export
#' @seealso \code{\link{SS_readctl_3.24}}, \code{\link{SS_readdat}},
#' \code{\link{SS_readdat_3.24}}

SS_readctl <- function(file, version=NULL, verbose=TRUE,echoall=FALSE,
                       ## Parameters that are not defined in control file
                       nseas=4,
                       N_areas=1,
                       Nages=20,
                       Ngenders=1,
                       Npopbins=NA,
                       Nfleet=2,
                       Nsurveys=2,
                       N_tag_groups=NA,
                       N_CPUE_obs=NA,
                       use_datlist=FALSE,
                       datlist=NULL,
                       ptype=TRUE){

  # wrapper function to call old or new version of SS_readctl

  # automatic testing of version number
  if(is.null(version)) {
    # look for 3.24 or 3.30 at the top of the chosen file
    version <- scan(file, what=character(), nlines=1, quiet=!verbose)
    version <- substring(version,3,6)
    # if that fails, look for data.ss_new file in the same directory
    if(version %in% c("3.24", "3.30")){
      if(verbose)cat("assuming version", version, "based on first line of control file\n")
    }else{
      newfile <- file.path(dirname(file), "control.ss_new")
      if(file.exists(newfile)){
        version <- scan(newfile, what=character(), nlines=1, quiet=!verbose)
        version <- substring(version,3,6)
        if(verbose)cat("assuming version", version, "based on first line of control.ss_new\n")
      }else{
        stop("input 'version' required due to missing value at top of", file)
      }
    }
  }

  nver=as.numeric(substring(version,1,4))

  if(verbose) cat("Char version is ", version, "\n")
  if(verbose) cat("Numeric version is ", nver, "\n")

  # call function for SS version 2.00
  if(nver<3){

    stop("Function SS_readctl_2.00 has not been written yet")

  }

  # call function for SS version 3.00
  if((nver>=3)&&(nver<3.2)){

    stop("Function SS_readctl_3.00 has not been written yet")

  }

  # call function for SS version 3.24
  if((nver>=3.2)&&(nver<3.3)){

    ctllist <- SS_readctl_3.24(file         = file,
                               version   = version,
                               verbose      = verbose,
                               echoall      = echoall,
                               nseas        = nseas,
                               N_areas      = N_areas,
                               Nages        = Nages,
                               Ngenders     = Ngenders,
                               Npopbins     = Npopbins,
                               Nfleet       = Nfleet,
                               Nsurveys     = Nsurveys,
                               N_tag_groups = N_tag_groups,
                               N_CPUE_obs   = N_CPUE_obs,
                               use_datlist  = use_datlist,
                               datlist      = datlist,
                               ptype        = ptype)
  }

  # call function for SS version 3.30
  if(nver>=3.3){

    ctllist <- SS_readctl_3.30(file         = file,
                               version   = version,
                               verbose      = verbose,
                               echoall      = echoall,
                               nseas        = nseas,
                               N_areas      = N_areas,
                               Nages        = Nages,
                               Ngenders     = Ngenders,
                               Npopbins     = Npopbins,
                               Nfleet       = Nfleet,
                               Nsurveys     = Nsurveys,
                               N_tag_groups = N_tag_groups,
                               N_CPUE_obs   = N_CPUE_obs,
                               use_datlist  = use_datlist,
                               datlist      = datlist)
  }

  # return the result
  return(ctllist)
}
