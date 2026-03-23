#load data 
timeline_df_preprocessed <- readRDS("data_preprocessed/timeline_df_preprocessed.rds")


timeline_df_preprocessed |> summary()

timeline_df_preprocessed$value

# compute average sentiment score for articles per year
average_sentiments_yearly <- timeline_df_preprocessed |> 
  group_by(year) |> 
  summarise(sentiment = mean(value, na.rm=T))

# create a bar plot of the average sentiment score per year
sentiment_plot <- ggplot(average_sentiments_yearly, aes(x = factor(year), y = sentiment)) +
  geom_bar(stat = "identity", colour = "black", fill = "#2171B5", alpha = 0.7) +
  geom_text(
    aes(label = round(sentiment, 2)), 
    vjust  = -1,
    colour = "white",
    size   = 5,
    fontface = "bold"
  ) +
  theme_minimal() +
  ggtitle("Average Sentiment Score of Articles about Endometriosis per Year") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"),
        axis.text.x = element_text(size = 14),
        axis.text.y = element_text(size = 14)) +
  labs(x = "", y = "") +
  scale_x_discrete(position = "top")


# display the plot
print(sentiment_plot)



