### Generate a table of all events and their (local) hardware support
papi.avail.internal <- function()
{
  papi.init()
  
  ret <- .Call(papi_event_avail, NULL)
  ret <- as.data.frame(ret, stringsAsFactors=FALSE)
  colnames(ret) <- c("event","avail","desc")
  
  attr(x=ret, which="lib") <- whichlib()
  
  assign(".__pbdPAPI_avail", ret, envir=.__pbdPAPIEnv)
  
  invisible()
}



### Checks if event is available
counter.avail <- function(events)
{
  avail <- get(".__pbdPAPI_avail", envir=.__pbdPAPIEnv)
  
  if (missing(events))
    return(avail)
  
  events.all <- avail[, 1L]
  
  if (!all(events %in% events.all))
  {
    fail <- events[!(events %in% events.all)]
    stop(paste("Event(s)", paste(fail, collapse=", "), "is/are not recognized PAPI events"))
  }
  
  l <- sapply(events, function(i) which(i == events.all))
  
  ret <- avail[l, 2L]
  
  return( ret )
}



### Error checking for the higher interfaces
papi.avail.lookup <- function(events, shorthand=FALSE)
{
  check.avail <- try(counter.avail(events=events), silent=TRUE)
  
  if (class(check.avail) == "try-error")
    stop("Unknown hardware events; please report this bug to the pbdPAPI developers.")
  else if (!all(check.avail))
  {
    notavail <- -which(check.avail)
    
    if (length(events) - length(notavail) == 1)
    {
      event <- " event "
      tobe <- " is "
    }
    else
    {
      event <- " events "
      tobe <- " are "
    }
    
    events.fail <- if (length(notavail) == 0) events else events[notavail]
    events.fail <- paste(events.fail, collapse=", ")
    
    if (!is.logical(shorthand))
      stop(paste("Your platform does not support the hardware", event, "{", events.fail, "} which", tobe, "needed for events=\"", shorthand, "\".\n\nSee ?papi.avail for more information.", sep=""))
    else
      stop(paste("Your platform does not support the hardware", event, "{", events.fail, "}.\n\nSee ?papi.avail for more information.", sep=""))
  }
  
  invisible()
}





#' Events
#' 
#' PAPI events.
#' 
#' To determine which counters are available on the target platform, the
#' \code{papi.avail()} function is provided. If no arguments are provided, a
#' complete list of PAPI events and their availability will be returned.
#' Otherwise, the list will be limited to the specified events.
#' 
#' There is a physical limitation to the number of counters that any given
#' analysis may profile, and whence an events counter vector must be no larger
#' than the total number of hardware counters.  You can see how many counters
#' are available by calling \code{system.ncounters()}.
#' 
#' The complete list of possible hardware events that one can profile with
#' pbdPAPI is given below.  Note that not all counters will be available on any
#' given platform.
#' 
#' Cache misses: \tabular{ll}{ 
#' "PAPI_L1_DCM" \tab Level 1 data cache misses \cr
#' "PAPI_L1_ICM" \tab Level 1 instruction cache misses \cr
#' "PAPI_L1_TCM" \tab Level 1 total cache misses \cr
#' "PAPI_L2_DCM" \tab Level 2 data cache misses \cr
#' "PAPI_L2_ICM" \tab Level 2 instruction cache misses \cr
#' "PAPI_L2_TCM" \tab Level 2 total cache misses \cr
#' "PAPI_L3_DCM" \tab Level 3 data cache misses \cr
#' "PAPI_L3_ICM" \tab Level 3 instruction cache misses \cr
#' "PAPI_L3_TCM" \tab Level 3 total cache misses }
#' 
#' Cache hits: \tabular{ll}{ 
#' "PAPI_L1_DCH" \tab L1 data Cache Hit \cr
#' "PAPI_L1_ICH" \tab L1 instruction cache hits \cr
#' "PAPI_L1_TCH" \tab L1 total cache hits \cr
#' "PAPI_L2_DCH" \tab L2 data Cache Hit \cr
#' "PAPI_L2_ICH" \tab L2 instruction cache hits \cr
#' "PAPI_L2_TCH" \tab L2 total cache hits \cr
#' "PAPI_L3_DCH" \tab L3 Data Cache Hit \cr
#' "PAPI_L3_ICH" \tab L3 instruction cache hits \cr
#' "PAPI_L3_TCH" \tab L3 total cache hits }
#' 
#' Cache accesses: \tabular{ll}{ 
#' "PAPI_L1_DCA" \tab L1 data Cache Access \cr
#' "PAPI_L1_ICA" \tab L1 instruction cache accesses \cr
#' "PAPI_L1_TCA" \tab L1 total cache accesses \cr
#' "PAPI_L2_DCA" \tab L2 data Cache Access \cr
#' "PAPI_L2_ICA" \tab L2 instruction cache accesses \cr
#' "PAPI_L2_TCA" \tab L2 total cache accesses \cr
#' "PAPI_L3_DCA" \tab L3 data Cache Access \cr
#' "PAPI_L3_ICA" \tab L3 instruction cache accesses \cr
#' "PAPI_L3_TCA" \tab L3 total cache accesses }
#' 
#' Cache reads: \tabular{ll}{ 
#' "PAPI_L1_DCR" \tab L1 data Cache Read \cr
#' "PAPI_L1_ICR" \tab L1 instruction cache reads \cr
#' "PAPI_L1_TCR" \tab L1 total cache reads \cr
#' "PAPI_L2_DCR" \tab L2 data Cache Read \cr
#' "PAPI_L2_ICR" \tab L2 instruction cache reads \cr
#' "PAPI_L2_TCR" \tab L2 total cache reads \cr
#' "PAPI_L3_DCR" \tab L3 data Cache Read \cr
#' "PAPI_L3_ICR" \tab L3 instruction cache reads \cr
#' "PAPI_L3_TCR" \tab L3 total cache reads }
#' 
#' Cache writes: \tabular{ll}{ 
#' "PAPI_L1_DCW" \tab L1 data Cache Write \cr
#' "PAPI_L1_ICW" \tab L1 instruction cache writes \cr
#' "PAPI_L1_TCW" \tab L1 total cache writes \cr
#' "PAPI_L2_DCW" \tab L2 data Cache Write \cr
#' "PAPI_L2_ICW" \tab L2 instruction cache writes \cr
#' "PAPI_L2_TCW" \tab L2 total cache writes \cr
#' "PAPI_L3_DCW" \tab L3 data Cache Write \cr
#' "PAPI_L3_ICW" \tab L3 instruction cache writes \cr
#' "PAPI_L3_TCW" \tab L3 total cache writes }
#' 
#' Instructions executed: \tabular{ll}{ 
#' "PAPI_BR_UCN" \tab Unconditional branch instructions executed \cr
#' "PAPI_BR_CN" \tab Conditional branch instructions executed \cr
#' "PAPI_TOT_INS" \tab Total instructions executed \cr
#' "PAPI_INT_INS" \tab Integer instructions executed \cr
#' "PAPI_FP_INS" \tab Floating point instructions executed \cr
#' "PAPI_LD_INS" \tab Load instructions executed \cr
#' "PAPI_SR_INS" \tab Store instructions executed \cr
#' "PAPI_BR_INS" \tab Total branch instructions executed \cr
#' "PAPI_VEC_INS" \tab Vector/SIMD instructions executed \cr
#' "PAPI_LST_INS" \tab Total load/store instructions executed \cr
#' "PAPI_SYC_INS" \tab Synchronization instructions executed }
#' 
#' Stalls: \tabular{ll}{ 
#' "PAPI_MEM_SCY" \tab Cycles Stalled Waiting for Memory Access \cr
#' "PAPI_MEM_RCY" \tab Cycles Stalled Waiting for Memory Read \cr
#' "PAPI_MEM_WCY" \tab Cycles Stalled Waiting for Memory Write \cr
#' "PAPI_RES_STL" \tab Cycles processor is stalled on resource \cr
#' "PAPI_FP_STAL" \tab FP units are stalled }
#' 
#' Cycles: \tabular{ll}{ 
#' "PAPI_BRU_IDL" \tab Cycles branch units are idle \cr
#' "PAPI_FXU_IDL" \tab Cycles integer units are idle \cr
#' "PAPI_FPU_IDL" \tab Cycles floating point units are idle \cr
#' "PAPI_LSU_IDL" \tab Cycles load/store units are idle \cr
#' "PAPI_STL_ICY" \tab Cycles with No Instruction Issue \cr
#' "PAPI_FUL_ICY" \tab Cycles with Maximum Instruction Issue \cr
#' "PAPI_STL_CCY" \tab Cycles with No Instruction Completion \cr
#' "PAPI_FUL_CCY" \tab Cycles with Maximum Instruction Completion \cr
#' "PAPI_TOT_CYC" \tab Total cycles }
#' 
#' \tabular{ll}{ 
#' "PAPI_CA_SNP" \tab Snoops \cr
#' "PAPI_CA_SHR" \tab Request for access to shared cache line (SMP) \cr
#' "PAPI_CA_CLN" \tab Request for access to clean cache line (SMP) \cr
#' "PAPI_CA_INV" \tab Cache Line Invalidation (SMP) \cr
#' "PAPI_CA_ITV" \tab Cache Line Intervention (SMP) \cr
#' "PAPI_TLB_DM" \tab Data translation lookaside buffer misses \cr
#' "PAPI_TLB_IM" \tab Instruction translation lookaside buffer misses \cr
#' "PAPI_TLB_TL" \tab Total translation lookaside buffer misses \cr
#' "PAPI_L1_LDM" \tab Level 1 load misses \cr
#' "PAPI_L1_STM" \tab Level 1 store misses \cr
#' "PAPI_L2_LDM" \tab Level 2 load misses \cr
#' "PAPI_L2_STM" \tab Level 2 store misses \cr
#' "PAPI_L3_LDM" \tab Level 3 load misses \cr
#' "PAPI_L3_STM" \tab Level 3 store misses \cr
#' "PAPI_BTAC_M" \tab BTAC miss \cr
#' "PAPI_PRF_DM" \tab Prefetch data instruction caused a miss \cr
#' "PAPI_TLB_SD" \tab Translation lookaside buffer shootdowns (SMP) \cr
#' "PAPI_CSR_FAL" \tab Failed store conditional instructions \cr
#' "PAPI_CSR_SUC" \tab Successful store conditional instructions \cr
#' "PAPI_CSR_TOT" \tab Total store conditional instructions \cr
#' "PAPI_HW_INT" \tab Hardware interrupts \cr
#' "PAPI_BR_TKN" \tab Conditional branch instructions taken \cr
#' "PAPI_BR_NTK" \tab Conditional branch instructions not taken \cr
#' "PAPI_BR_MSP" \tab Conditional branch instructions mispredicted \cr
#' "PAPI_BR_PRC" \tab Conditional branch instructions correctly predicted \cr
#' "PAPI_FMA_INS" \tab FMA instructions completed \cr
#' "PAPI_TOT_IIS" \tab Total instructions issued \cr
#' "PAPI_FML_INS" \tab FM ins \cr
#' "PAPI_FAD_INS" \tab FA ins \cr
#' "PAPI_FDV_INS" \tab FD ins \cr
#' "PAPI_FSQ_INS" \tab FSq ins \cr
#' "PAPI_FNV_INS" \tab Finv ins 
#' }
#' 
#' If pbdPAPI is built using Intel PCM, pbdPAPI understands only the following
#' counters. A subset of these will be available depending on your platform.
#' 
#' \tabular{ll}{
#' "IPCM_L2_TCM" \tab Level 2 cache misses \cr
#' "IPCM_L2_TCH" \tab Level 2 cache hits \cr
#' "IPCM_INS_RET" \tab Instructions retired \cr
#' "IPCM_CYC" \tab Cycles used \cr
#' "IPCM_L3_TCH_NS" \tab Level 3 cache hits without snooping on level 2 cache \cr
#' "IPCM_L3_TCH_S" \tab Level 3 cache hits with snooping on level 2 cache \cr
#' "IPCM_L3_TCH" \tab Level 3 cache hits \cr
#' "IPCM_L3_TCM" \tab Level 3 cache misses \cr
#' }
#' 
#' @aliases papi.avail ipcm.avail
#' @param events 
#' A vector of PAPI events (as strings).  See details section for
#' more information.
#' 
#' @return 
#' If no argument is specified, then a dataframe detailing all events,
#' event names, and platform support is returned.  If an events vector is
#' passed, then a logical vector is returned.
#' 
#' @examples
#' \dontrun{
#' library(pbdPAPI)
#' 
#' ### Check all events
#' system.avail()
#' 
#' ### Check an events vector of events
#' events <- c("PAPI_L1_DCM", "PAPI_L2_DCM")
#' system.event(events)
#' }
#' 
#' @rdname event
#' @export
papi.avail <- function(events)
{
  if (whichlib() != "PAPI")
    warning("you should not be using the PAPI interface for IPCM")
  
  ret <- counter.avail(events=events)
  
  return( ret )
}



#' @rdname event
#' @export
ipcm.avail <- function(events)
{
  if (whichlib() != "IPCM")
    warning("you should not be using the IPCM interface for PAPI")
  
  ret <- counter.avail(events=events)
  
  return( ret )
}

