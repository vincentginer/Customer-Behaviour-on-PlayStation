# Customer-Behaviour-on-PlayStation
Data Analysis project on PlayStation users using SQL, BigQuery, Looker and Python


## Summary 
The goal of the project was to analyse customer behaviour on the PlayStation environment. We played the role of a data analyst team in a publishing company, advising the CEO of the company on which type of games to invest in. 

## Business Problem
In our exploratory analysis, we realised that the number of games sold were decreasing, while the churn rate was increasing. 
To optimize the sales of the future game and increase the ROI, we decided to dig deeper and determine what PlayStation gamers loved and wanted to invest in.

<img width="771" alt="Image" src="https://github.com/user-attachments/assets/e385b77d-2793-4735-b918-68eb5a7ec54d" />
<img width="773" alt="Image" src="https://github.com/user-attachments/assets/776b39d9-7faf-4205-9a82-44a2b141ec97" />

## Dataset
We used the [Gaming Profiles 2025 (Steam, PlayStation, Xbox)](https://www.kaggle.com/datasets/artyomkruglov/gaming-profiles-2025-steam-playstation-xbox?resource=download), from Kaggle, and focused on PlayStation only. 
This dataset contains 6 tables (achievements, games, prices, purchased_games, history and players) and more than 19 million rows. 
The key features are: 
* The history table:
Contains all the achievements a player obtained on a game 
An achievement is a in-game trophy a player gain for doing a specific action (like finishing the storyline)
We lacked the date of purchased for each game, so we assumed that the first achievement acquired corresponded to the date of purchase
* The achievement table:
Contains all the achievements in one game. 
Achievements are based on a rarity level (Bronze, Silver, Gold and Platinum). The color is based on how hard it is to get.
The Platinum trophy means you acquired all the other ones
We assumed that getting the Platinum trophy meant finishing the game
* The prices table:
Contains the prices of the games, in 2025. 
For better accuracy, we decided to only focus on PS4 and PS5 games in our analysis. 

## Methodology

We started by cleaning the dataset, on BigQuery, using SQL: 

1. Identifying the null values and deleting them if needed
2. Identifying the primary keys for each tables
3. Renaming the columns for easier joins later
4. Casting the columns to a better-suited type (date, integer)
5. Additional transformation to ease the grouping. For example, assigning a number to the rarity of the achievement

Specifically on the games table, the genre column had to be cleaned: 
It contained all the genre in a single JSON array, that I had to extract 
Not all the genres were similar, so we decided on 10 main groups and created a “category” column to ease the analysis. 

After this first cleaning, we did an exploratory analysis to understand our dataset, and see patterns. 
This is where we realised the trends mentioned above.  
We divided our analysis in two parts: 

* Player Behaviour 
* Sales Analysis 

1. **Player Behaviour**

On BigQuery, we applied transformations on the history, achievements and games tables to extract all the trophies obtained by a player on PS4 and PS5, with the date of acquisition. 
From there, we extracted the month of acquisition, and grouped by month, platform and category, while counting distinct the number of player id to have the number of active players for each genre category. 
We finally filtered by platform (PS5) and date acquired (November 12th, 2020) to only keep the active players on PS5. 

The main output is that the main genre is the Action and Combat is predominant in the active player base, while Casual and Party games are declining, especially since the end of Covid. 

<img width="557" alt="Image" src="https://github.com/user-attachments/assets/d442249e-a368-453c-b5ad-41929d013b30" />

We then used Python to create a correlation matrix between the number of achievements acquired and the number of games bought, to see if players who were active tend to buy more games. 

We can see the correlation in the graph below: 

<img width="551" alt="Image" src="https://github.com/user-attachments/assets/d967829b-30ca-4e98-a54f-da9483da9ddf" />

Once this correlation was clear, and the most liked genre was defined, we wanted to see if the sales were in correlation with the active players. 

2. **Sales Analysis**

We had the localisation of our players, so we wanted to know where our top players and spenders were. 

With two window functions, we joined the prices, purchased_games and games table to link all the games purchased by one player and its price. 
We then summed up the amount spent by the player, by grouping on a player level. We finally joined the players table to add the country of origin. 

As we can see on the graph, our top players are in North America, Europe and Brazil. 

<img width="547" alt="Image" src="https://github.com/user-attachments/assets/86780e29-ba80-4a39-b096-8a6aec2feb61" />

From this overview, we decided to categorize our players based on this spending. 
Through 5 window functions, we extracted: 
1. The sum spend per player 
2. Categorisation of players based on their spend (since November 15th, 2013): Whales, spending above 5000 euros, High Spenders, above 3000 euros, Mid Spenders, above 1000, and Low Spenders. 
3. Count the total achievements per players
4. Count the number of platinums per players
5. Count the number of unique games purchased per players

The final table was grouped by spending category, and gave us insights on the distribution of our dataset. The majority are the whales, followed by the mid-spenders. 

<img width="336" alt="Image" src="https://github.com/user-attachments/assets/0d463072-cf10-4082-be51-f85b82edb5c4" />

We then wanted to know what these players were playing. 
With 4 window functions, we: 
1. Created the same customer segments as mentioned above, adding the Zero spender for players who played only free games. 
2. Joined the players table and achievements table to know what they are playing 
3. Join the games table to add the genre category, to be able to then group by 
4. Grouped by genre category and spender segments, and counting the number of games players

We added in the final table a percentage of the weight of each genre category, within each customer segment.

The insight is that whales are attracted to Action and Combat games, and in general games that are more expensive and time-consuming.

<img width="554" alt="Image" src="https://github.com/user-attachments/assets/03e9a30c-f540-4882-9f2f-985ec2f6bf07" />

To validate that insight, we calculated the average price per genre, as well as the number of games sold. 

We executed this in two steps: 
1. First transformed table 

We counted the number of games bought from the purchased_games table, and grouped by game_id. 
We also extracted the maximum price for each game, while also grouping by game_id. 

We joined these two CTEs to have the number of games sold for each genre, and the maximum price available. 

2. Final table

Based on the transformed table, we summed the number of games sold, as well as the prices, and grouped by categories. 
We also divided the turnover by the number of sales to have the average price per genre. 

We were able to see that the Action and Combat game, while being one of the most expensive genres, is also the most sold. 
We could investigate further why RPGs players are willing to spend the highest for that type of experience.

<img width="684" alt="Image" src="https://github.com/user-attachments/assets/abd52e9c-a2eb-466e-8729-639bc1213b13" />

We thought the amount of games sold was due to the predominance of well-known developers, so we investigated further: 

With 3 window functions, we: 
1. Extracted the developers’ name, game_id, platform and category from the games table 
2. Joined the price table to know the price for each game sold
3. Grouped by game_id the purchased_games table, and counting the number of rows to know how many games were sold 
The final table gave us insight on the number of games sold per developers, and their revenue overall.

With little surprise, the main developers were the most known. Capcom is the developer of the Resident Evil saga, and Ubisoft created Assassin’s Creed, two of the most iconics franchises in gaming history. 

<img width="689" alt="Image" src="https://github.com/user-attachments/assets/b4d69423-65e0-4aac-9453-914871b7a07d" />

The last step was to create a prediction model, to try to predict the number of games sold. 
After several tests, the team settled on the Extra Trees Regressor Model, who had the best metrics: 

* An R2 of 56%
* A MAPE of 2%

We used as features the genre, date of release, price of the game, previous number of games sold by the developer, and the previous turnover for this developer. 
This model can be further improved as the dataset is deeper investigated.

## Key Insights and Recommendations:

To optimize the launch of a video game, our insights are as follows: 
1. The Action and Combat game genre drives substantial sales volumes while maintaining a high average sale price
2. October and November are ideal months for game launches
3. Choosing the right developer is essential to achieving high sales volumes, as their expertise and reputation significantly impact the success of a game
4. Implementing a well-crafted pricing strategy is crucial for maximizing sales


