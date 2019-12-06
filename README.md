# METHODOLOGY: Determining the 2010s NBA All-Decade team with machine learning

[Link to blog post.](https://dribbleanalytics.blog/2019/12/all-decade-teams)

## Data collection

All data was collected from [Basketball-Reference](http://basketball-reference.com/). We collected all data for all player seasons starting from the 1979-1980 season (introduction of the 3-point line). To stay consistent, we only included players who entered the league on or after the 1979-1980 season, such that all players played their entire career with the 3-point line.

From this large data set, we used the following 7 features to create our models.

|Play time|Counting stats|Advanced stats|
:--|:--|:--|
|G|PPG|VORP|
|MP|TRB|WS|
||AST||

## Model creation & premise

In total, we created four models:

1. Support vector classifier (SVC)
2. Random forest classifier (RF)
3. K-nearest neighbors classifier (KNN)
4. Gradient boosting classifier (GBC)

The models were trained on 75% of our data from the 1979-1980 season until the 2008-2009 season. We determined hyperparameters using grid search. Then, they predicted All-NBA probabilities for every individual player season from the 2009-2010 season until the 2018-2019 season.

We created the All-Decade teams by sorting players by their total All-NBA shares, or their cumulative All-NBA probability throughout the decade. This allows us to objectively combine longevity vs. peak performance and compare players who only played part of the decade.

So, the player with the highest cumulative All-NBA probability went into the highest available slot for his position. Each team has 2 guards, 2 forwards, and a center. We determined positional classes based off what position the player was listed as when they made an All-NBA team. So, Kevin Love, Blake Griffin, and LaMarcus Aldridge are all forwards.

The table below shows the average results of the four models, along with the five closest players to making a team, regardless of position (the last row):

|Average|Guard|Guard|Forward|Forward|Center|
:--|:--|:--|:--|:--|:--|
|1st team|James Harden (6.665)|Russell Westbrook (6.328)|LeBron James (8.998)|Kevin Durant (7.862)|Anthony Davis (4.056)|
|2nd team|Stephen Curry (5.889)|Chris Paul (5.443)|Kevin Love (3.257)|Giannis Antetokounmpo (2.882)|DeMarcus Cousins (2.855)|
|3rd team|Damian Lillard (3.740)|Dwyane Wade (2.644)|Blake Griffin (2.819)|LaMarcus Aldridge (2.382)|Karl-Anthony Towns (2.559)|
|Just missed|Kyrie Irving (2.346)|Kawhi Leonard (2.217)|Carmelo Anthony (2.196)|Dirk Nowitzki (1.967)|Paul George (1.948)|

## R Shiny app

To help visualize each player's All-NBA probability throughout the decade, we created an R Shiny app. The app can be accessed [here](https://dribbleanalytics.shinyapps.io/all-decade-teams/).

The app allows a viewer to interactively compare any two players by their cumulative or annual All-NBA shares over any time frame.

The R code for the Shiny app is in the folder called "r-shiny-app." The code is contained in the "app" file. The .csv files provide the data uased in the app. The "publish" file simply publishes the app to shinyapps.io and tests that it runs.
