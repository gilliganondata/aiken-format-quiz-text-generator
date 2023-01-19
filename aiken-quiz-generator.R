if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse,
               googlesheets4)

gs4_auth()

# The ID of the Google Sheet that has the quiz details
sheets_id <- "15ikE6F653z7j7-B7P3wbWohh9nshfFBTLWaQjLF0lG4"
sheet_name <- "Machine Learning Features"
start_row <- 9
end_row <- 30

quiz_df <- read_sheet(sheets_id,
                      sheet = sheet_name,
                      range = paste0("A", start_row, ":H", end_row))

output_df <- quiz_df |> 
  mutate(`Option 1` = as.character(`Option 1`),
         `Option 2` = as.character(`Option 2`),
         `Option 3` = as.character(`Option 3`),
         `Option 4` = as.character(`Option 4`)) |> 
  mutate(ANSWER = case_when(
    `Correct Answer` == `Option 1` ~ "A",
    `Correct Answer` == `Option 2` ~ "B",
    `Correct Answer` == `Option 3` ~ "C",
    `Correct Answer` == `Option 4` ~ "D",
    TRUE ~ "Error"
  )) |> 
  mutate(`Option 1` = ifelse(is.na(`Option 1`), "", paste0("A. ", `Option 1`, "\n")),
         `Option 2` = ifelse(is.na(`Option 2`), "", paste0("B. ", `Option 2`, "\n")),
         `Option 3` = ifelse(is.na(`Option 3`), "", paste0("C. ", `Option 3`, "\n")),
         `Option 4` = ifelse(is.na(`Option 4`), "", paste0("D. ", `Option 4`, "\n"))) |> 
  mutate(out = paste0(`Question`, "\n",
                      `Option 1`,
                      `Option 2`,
                      `Option 3`,
                      `Option 4`,
                      "ANSWER: ", ANSWER, "\n"))

write_file(paste(output_df$out, collapse = "\n"), "quiz_out.txt")