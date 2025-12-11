# Visualisation ------------------------------------------
## Description :: Create visualisation of human-neuroimaging 
## techniques over time

## Basic plot  -------------------------------------------
# Create basic plot to understand what the data looks like plotted
draft_plot <- ggplot(neuroimaging_final, aes(x = date_published, y = n, group = modalities)) +
  geom_line()

### View the draft plot
print(draft_plot)

## Adding layers -----------------------------------------
### Add geom_point so that each plot point stands out
### Label the axis and legend and provide a title
### Set the colour palette and add a custom theme
draft_plot <- ggplot(neuroimaging_final, mapping = aes(x = date_published, y = n)) +
  geom_line(aes(group = modalities, text = paste("Modality:", modalities), colour = as.factor(modalities))) +
  geom_point(aes(group = modalities, text = paste("Modality:", modalities), colour = as.factor(modalities))) +
  labs(x = "Year",
       y = "Frequency of modality use",
       title = "Frequency of different neuroimaging techniques used over time",
       colour = "Modality") +
  scale_colour_brewer(palette = "Set2") +
  theme_neuroimaging

### View the draft plot
print(draft_plot)

### Save draft plot as png for reference
ggsave(draft_plot,
       filename = "outputs/neuroimaging_visualisation.png",
       height = 6, width = 8)

## Make plot interactive -------------------------------
interactive_draft <- ggplotly(draft_plot, tooltip = c("x", "y", "text"))

## Save to environment as final visualisation ----------
neuroimaging_visualisation <- interactive_draft

### View the final visualisation
print(neuroimaging_visualisation)
