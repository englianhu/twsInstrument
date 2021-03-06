#' At-the-money quote
#' 
#' Returns quotes for at-the-money options on a given stock
#' 
#' Makes a call to getOptionChain and getQuote.  Returns quotes for options
#' struck at the price that is closest to the last quoted price of the
#' underlying. Does not support multiple expiration months.  ALPHA code.
#' 
#' @param symbol yahoo stock symbol
#' @param Exp Expiration dates; YYYY-MM
#' @return xts object
#' @author Garrett See
#' @seealso ATM_k, getOptionChain, getQuote
#' @examples
#' 
#' \dontrun{
#' ATMQuote('SPY')
#' }
#' @export
ATMQuote <- function(symbol, Exp) {
    underlying <- symbol
    if (length(underlying) > 1) {
        warning(paste('More than one symbol given. ',
                        'Finding At-The-Money strike for ',
                        underlying[1], sep=""))
    }
    underlying <- underlying[1]   
#    if (length(Exp) > 1) stop('multiple expiries not yet supported.')

#    if (verbose) cat(paste('Finding At-The-Money strike of the ', 
#                    Exp, ' options on ', underlying, '\n', sep="")) 
    uLast <- getQuote(underlying)$Last
    chain <- getOptionChain(underlying)
    strikes <- unique(c(chain$calls[,1],chain$puts[,1]))    
    k <- strikes[which.min(abs(uLast-strikes))]
    rbind(chain$calls[chain$calls[,1]==k,], chain$puts[chain$puts[,1]==k,])
}

