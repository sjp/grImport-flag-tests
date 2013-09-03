renderPDF <- function(infile, outfile) {
    library(grImport2) ; library(grid)
    pic <- readPicture(infile)
    pdf(outfile)
    dev.hold()
    grid.picture(pic, expansion = 0, clip = "bbox")
    dev.flush()
    dev.off()
}

