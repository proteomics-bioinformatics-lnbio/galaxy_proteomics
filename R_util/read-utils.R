# Helper script to facilitate the read
require('getopt', quietly=TRUE);

# Function to use the getopt and return the set of options from the read
get_cmd_options <- function (has_type) {
  if (has_type == TRUE) {
    opt <- matrix(c(
        'inputfile_name', 'i', 1, 'character',
        'type', 't', 1, 'character',
        'outputfile_name', 'o', 1, 'character'
      ),byrow=TRUE, ncol=4);
  } else {
    opt <- matrix(c(
        'inputfile_name', 'i', 1, 'character',
        'outputfile_name', 'o', 1, 'character'
      ),byrow=TRUE, ncol=4);
  }

  options <- getopt(opt);

  table <- read.delim(options$inputfile_name, header=TRUE, fill=TRUE);
  if (has_type == TRUE) {
    if (options$type == "lfqlog2") {
      regexpr <- "LFQ[.]intensity[.]([^[:digit:]]+)[[:digit:]]+";
      code <- "LFQ";
    } else if (options$type == "intensity") {
      regexpr <- "Intensity[.]([^[:digit:]]+)[[:digit:]]+";
      code <- "INT";
    } else {
      regexpr <- "MS[.]MS[.]Count[.]([^[:digit:]]+)[[:digit:]]+";
      code <- "MS";
    }
    if (!(TRUE %in% grepl(regexpr, colnames(table)))) {
      sprintf("Error: No columns of type %s in input table", code);
      return(NA);
    } else {
      entry.names <- c('options', 'table', 'regexpr', 'code');
      entry <-vector('list', length(entry.names));
      names(entry) <- entry.names;
      entry[[1]] <- options;
      entry[[2]] <- table;
      entry[[3]] <- regexpr;
      entry[[4]] <- code;
      return(invisible(entry))
    }
  } else {
    entry.names <- c('options', 'table');
    entry <- vector('list', length(entry.names))
    names(entry) <- entry.names;
    entry[[1]] <- options;
    entry[[2]] <- table;
    return(invisible(entry))
  }
}
