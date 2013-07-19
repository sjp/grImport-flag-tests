renderPDF <- function(infile, outfile) {
    library(grImport)
    rgml <- paste0(infile, ".xml")
    PostScriptTrace(infile, rgml)
    pdf(outfile)
    dev.hold()
    try(grid.draw(grid:::force(pictureGrob(readPicture(rgml)))))
    dev.flush()
    dev.off()
    unlink(rgml)
    unlink(paste0("capture",
                  substring(outfile, nchar("grImport/") + 1, nchar(outfile) - 3),
                  "ps"))
}

