renderPDF <- function(infile, outfile) {
    library(grImport)
    rgml <- paste0(infile, ".xml")
    PostScriptTrace(infile, rgml)
    pdf(outfile)
    dev.hold()
    grid.draw(pictureGrob(readPicture(rgml), exp = 0))
    dev.flush()
    dev.off()
    unlink(rgml)
    unlink(paste0("capture",
                  substring(outfile,
                            nchar("grImport-improved/") + 1,
                            nchar(outfile) - 3),
                  "ps"))


}

