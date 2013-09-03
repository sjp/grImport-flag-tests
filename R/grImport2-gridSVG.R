renderSVG <- function(infile, outfile) {
    library(grImport2) ; library(gridSVG)
    pdf(file = NULL)
    gridSVG.newpage()
    pic <- readPicture(infile)
    grid.picture(pic, expansion = 0, clip = "gridSVG", gridSVG = TRUE)
    grid.export(outfile)
    dev.off()
}

