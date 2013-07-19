renderSVG <- function(infile, outfile) {
    library(grImport2) ; library(gridSVG)
    pdf(file = NULL)
    gridSVG.newpage()
    pic <- readPicture(infile)
    grid.draw(grobify(pic, clip = "gridSVG", usegridSVG = TRUE))
    grid.force()
    grid.export(outfile)
    dev.off()
}

