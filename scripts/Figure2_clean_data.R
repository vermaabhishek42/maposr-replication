# script : figure2_clean_data.R
# Purpose : clean and prepare data for Figure 2 replication

library(tidyverse)

# Load the data
maposr <- read_csv("data/mapOSR_data_V5_9_3_220419_coded_clean.csv")

# -------------------------
# Clean the Action column
# -------------------------

clean_data <- maposr %>%
  # keep only the columns we need for Figure 2
  select(`Publication Year`, Action) %>%
  
  # drop rows where year or action is missing
  filter(!is.na(`Publication Year`), !is.na(Action)) %>%
  
  # remove square brackets and quotes from the Action text
  mutate(Action = str_remove_all(Action, "\\[|\\]|'")) %>%
  
  # split entries like "openaccess, opendata" into separate rows
  separate_rows(Action, sep = ", ") %>%
  
  # trim extra spaces
  mutate(Action = str_trim(Action))

head(clean_data)

# make sure Action (subfield) has the correct order
# this controls the stacking order in the bar chart
clean_data$Action <- factor(
  clean_data$Action,
  levels = c(
    "openaccess",       # bottom (blue)
    "openpolicies",
    "openscience",
    "openmethod",
    "opendata",
    "openevaluation",
    "opentools",
    "openeducation",
    "opensoftware",
    "openparticipation" # top
  )
)


# ---------------------------------
# Count publications per year × subfield
# ---------------------------------
fig2_counts <- clean_data %>%
  filter(`Publication Year` >= 2000,
         `Publication Year` <= 2020) %>%
  group_by(`Publication Year`, Action) %>%
  summarise(n = n(), .groups = "drop")


# Look at the counts
head(fig2_counts)

# Column Publication Year = year of the studies
#Column Action = subfield (openaccess, opendata, etc.)
#Column n = number of publications in that year in that subfield


# ---------------------------------
# Plot Figure 2: stacked bar chart
# ---------------------------------

# setting the sub field order, so that the stacked order matches the paper

#fig2_counts$Action <- factor(
 # fig2_counts$Action,
  #levels = c(
  #  "openaccess",
   # "opendata",
#    "openpolicies",
 #   "openscience",
  #  "openmethod",
#    "openevaluation",
 #   "opentools",
#    "openeducation",
#    "opensoftware",
 #   "openparticipation"
#  )
#)


# defining the custom colours for the graph 

paper_colors <- c(
  openaccess       = "#1F77B4",   # dark blue
  openpolicies     = "#FF7F0E",   # orange
  openscience      = "#9467BD",   # purple
  openmethod       = "#E377C2",   # pink
  opendata         = "#2CA02C",   # green
  openevaluation   = "#BCBD22",   # yellowish
  opentools        = "#FFD700",   # gold yellow
  openeducation    = "#17BECF",   # teal
  opensoftware     = "#8C564B",   # brownish
  openparticipation = "#D62728"   # red
)


fig2_plot <- ggplot(fig2_counts,
                    aes(x = `Publication Year`,
                        y = n,
                        fill = Action)) +
  geom_col(color = "black", size = 0.2) +   # thin black borders
  scale_fill_manual(values = paper_colors) +
  scale_x_continuous(
    breaks = seq(2000, 2020, 5),    # ticks every 5 years
    limits = c(2000, 2020)          # show only 2000–2020
  )+
  scale_y_continuous(breaks = seq(0, 140, 20), limits = c(0, 160)) +
  
  theme_minimal(base_size = 13) +
  theme(
    panel.grid = element_blank(),            # remove gridlines
    axis.line = element_line(colour = "black"),
    axis.ticks = element_line(colour = "black"),
    legend.title = element_blank(),
    legend.position = c(0.18, 0.60),         # inside the plot, like the paper
    legend.background = element_rect(fill = "white", color = "black")
  ) +
  labs(
    x = "year of publication",
    y = "number of publications",
    caption = "Figure 2. Overview over the number of studies by Open Science subfield published between 2000 and 2020."
  )


fig2_plot

# save Figure 2 to the outputs folder
ggsave(
  filename = "outputs/figure2_replication.png",
  plot     = fig2_plot,
  width    = 8,      # inches
  height   = 4,      # adjust if you like
  dpi      = 300
)

ggsave(
  filename = "outputs/figure2_replication.pdf",
  plot     = fig2_plot,
  width    = 10,
  height   = 4
)

# save processed data used for Figure 2
write_csv(clean_data, "outputs/figure2_clean_data.csv")
write_csv(fig2_counts, "outputs/figure2_counts.csv")
