renderPDF <- function(infile, outfile) {
    library(grImport2) ; library(grid)
    pic <- readPicture(infile)
    pdf(outfile)
    dev.hold()
    grid.picture(pic, clip = "bbox")
    dev.flush()
    dev.off()
}

