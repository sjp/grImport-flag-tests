# First start writing notes about each flag

ArizonaNotes <- paste(
'This cannot be parsed correctly in its SVG form because the red background',
'is "striped" because of the SVG attribute "stroke-dasharray". R\'s equivalent,',
'"lty" is too restrictive. See "Known Limitations".')

GeorgiaNotes <- OhioNotes <- "Features a non-rectangular clipping path."

KansasNotes <-
    "Features many linear gradients that comprise the centre of the flag."

NebraskaNotes <- paste(
'Features radial gradients, but they are so small that their effect',
'is negligible. gridSVG does use the gradients and exports them but',
'the flag appears fine with the radial gradients omitted.')

NevadaNotes <- SouthCarolinaNotes <-
    "grImport fails to import and render this flag."

indent <- "        "

tr <- function(rowContent) {
    indent <- "                "
    paste0(indent, "<tr>\n",
           paste0(rowContent, collapse = "\n"),
           indent, "</tr>\n")
}

td <- function(x) {
    indent <- "                    "
    paste0(indent, "<td>\n",
           indent, "    ", x, "\n",
           indent, "</td>\n")
}

anchor <- function(href, content) {
    paste0('<a href="', href, '" class="th">', content, "</a>")
}

imgtag <- function(src, width = 300) {
    paste0('<img src="', src, '"', ' width="', width, '"', ">")
}

textCell <- function(txt) {
    indent <- "                    "
    paste0(indent, "<td>", txt, "</td>\n")
}

imgCell <- function(href, img, width = 300) {
    td(anchor(href, imgtag(img, width)))
} 

stateToFile <- function(x) chartr(" ", "_", x)

stateNames <- c("Alabama", "Alaska", "Arizona", "Arkansas",
    "California", "Colorado", "Connecticut", "Delaware", "Florida",
    "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa",
    "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland",
    "Massachusetts", "Michigan", "Minnesota", "Mississippi",
    "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire",
    "New Jersey", "New Mexico", "New York", "North Carolina", 
    "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania",
    "Rhode Island", "South Carolina", "South Dakota", "Tennessee",
    "Texas", "Utah", "Vermont", "Virginia", "Washington",
    "West Virginia", "Wisconsin", "Wyoming")

allStateRows <- sapply(stateNames, function(state) {
    statefn <- stateToFile(state)
    thumbfn <- paste0(statefn, "-thumb")
    notes <-
        switch(state,
               Arizona = ArizonaNotes,
               Georgia = GeorgiaNotes,
               Kansas = KansasNotes,
               Nebraska = NebraskaNotes,
               Nevada = NevadaNotes,
               Ohio = OhioNotes,
               "South Carolina" = SouthCarolinaNotes,
               "")
    
    tr(paste0(textCell(state),
           imgCell(file.path("svg", paste0(statefn, ".svg")),
                   file.path("svg-thumbs", paste0(statefn, ".png"))),
           imgCell(file.path("cairosvg", paste0(statefn, ".svg")),
                   file.path("cairosvg-thumbs", paste0(statefn, ".png"))),
           imgCell(file.path("grImport", paste0(statefn, ".pdf")),
                   file.path("grImport-thumbs", paste0(statefn, ".png"))),
           imgCell(file.path("grImport-improved", paste0(statefn, ".pdf")),
                   file.path("grImport-improved-thumbs", paste0(statefn, ".png"))),
           imgCell(file.path("grImport2", paste0(statefn, ".pdf")),
                   file.path("grImport2-thumbs", paste0(statefn, ".png"))),
           imgCell(file.path("grImport2-gridSVG", paste0(statefn, ".svg")),
                   file.path("grImport2-gridSVG-thumbs", paste0(statefn, ".png"))),
           textCell(notes)))
})



