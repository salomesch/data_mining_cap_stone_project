
# media coverage by country -----------------------------------------------

endo_df_preprocessed <- readRDS("data_preprocessed/endo_df_preprocessed.rds")



# sentiment analysis ------------------------------------------------------

#load data 
timeline_df_preprocessed <- readRDS("data_preprocessed/timeline_df_preprocessed.rds")


timeline_df_preprocessed |> summary()

timeline_df_preprocessed$value

# compute average sentiment score for articles per year
average_sentiments_yearly <- timeline_df_preprocessed |> 
  group_by(year) |> 
  summarise(sentiment = mean(value, na.rm=T))

# create a bar plot of the average sentiment score per year
sentiment_plot_yearly <- ggplot(average_sentiments_yearly, aes(x = factor(year), y = sentiment)) +
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
print(sentiment_plot_yearly)


# create a bar plot of average sentiment score per month for all years
average_sentiments_month_yearly <- timeline_df_preprocessed |> 
  group_by(year, month) |> 
  summarise(sentiment = mean(value, na.rm=T), .groups = "drop")

# the score has become slightly less negative over the years


# plot
sentiment_plot_monthly <- ggplot(average_sentiments_month_yearly, aes(x = factor(month), y = sentiment)) +
  geom_bar(stat = "identity", fill = "#6BAED6", color = "black", alpha = 0.7) +
  facet_wrap(~ year, ncol = 2) +
  ggtitle("Average Sentiment Score per Month over the Years") +
  xlab("Month") +
  ylab("Average Sentiment Score") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), 
        axis.text.x = element_text(size = 12),
        axis.title.x = element_text(size = 14),
        axis.title.y = element_text(size = 14)) +
  scale_x_discrete(labels = month.abb)

sentiment_plot_monthly

# no clear pattern


