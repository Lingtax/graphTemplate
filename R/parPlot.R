#' parPlot
#'
#' Generates a ggplot of a parallel analysis
#'
#' @param x a list of output from the psych::fa.parallel function
#'
#' @examples
#'df <- psych::bfi
#'parallel <- psych::fa.parallel(df, fa= "fa", quant = .95)
#'p <- parPlot(parallel)
#'p
#'ggsave('parallel.png', p, width=6, height=6, unit='in', dpi=300)

#'@export
parPlot <- function(x){
  if(!is.list(x)){stop("parPlot() expects list of output from parallel analysis")}

  pos <- seq_along(x$fa.values)
  len <-  length(x$fa.values)

  eigendat <- data.frame(
    eigenvalue = c(x$fa.values, x$fa.sim),
    type = as.character(c(rep("Actual Data",len), rep("Simulated Data",len))),
    num = c(pos,pos),
    stringsAsFactors = FALSE
  )

  ggplot(eigendat, aes(x=num, y=eigenvalue, shape=type)) +
    #Add lines connecting data points
    geom_line() +
    #Add the data points.
    geom_point(size=4) +
    #Label the y-axis 'Eigenvalue'
    scale_y_continuous(name='Eigenvalue') +
    #Label the x-axis 'Factor Number', and ensure that it ranges from 1-max # of factors, increasing by one with each 'tick' mark.
    scale_x_continuous(name='Factor Number', breaks=min(eigendat$num):max(eigendat$num)) +
    #Manually specify the different shapes to use for actual and simulated data, in this case, white and black circles.
    scale_shape_manual(values=c(16,1)) +
    #Add vertical line indicating parallel analysis suggested max # of factors to retain
    geom_vline(xintercept = x$nfact, linetype = 'dashed') +
    #Apply our apa-formatting theme
    apatheme
}
