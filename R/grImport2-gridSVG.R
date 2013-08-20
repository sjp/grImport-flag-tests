renderSVG <- function(infile, outfile) {
    library(grImport2) ; library(gridSVG)
    pdf(file = NULL)
    gridSVG.newpage()
    pic <- readPicture(infile)
    grid.picture(pic, clip = "gridSVG", gridSVG = TRUE)
    grid.force()
    grid.export(outfile)
    dev.off()
}

