renderPDF <- function(infile, outfile) {
    library(grImport2) ; library(grid)
    pic <- readPicture(infile)
    pdf(outfile)
    dev.hold()
    grid.draw(grid:::force(grobify(pic, clip = "bbox")))
    dev.flush()
    dev.off()
}

