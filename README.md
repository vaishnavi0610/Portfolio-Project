# Portfolio-Project
This will contain all my initial projects
# FOR DESCRIPTIVE STATISTICS AND DATA VISUALIZATION.


#*PROBLEM STATEMENT:
#*You are provided with a dataset of a departmental store. 
#*It contains details of products from May, 2020, a period marked by covid-19.
#*Your objective is to analyse the patterns and trends of the products, and gather insights for 
#*strategic decision making.

##The package needed is dplyr :
###TO INSTALL THE PACKAGE, RUN THE FOLLOWING:-

install.packages("dplyr")

####LOAD THE DPLYR PACKAGE
require(dplyr)

##LET'S LOAD THE DATASET
store = read.csv(file.choose(), header = T)
View(store)

#GLIMPSE THE DATASET
glimpse(store)

#1.filter()

#GET THE INFORMATION OF THE PRODUCT WHERE TO PRODUCT_TYPE IS 'beauty products'
store1 = filter(store, PRODUCT_TYPE == "beauty products")
View(store1)

#GET THE INFORMATION OF THE PRODUCT WHERE IT BELONGS TO COMPANY S&M

store2 = filter(store, COMPANY == c("S", "M") )
View(store2)
unique(store2$PRODUCT_TYPE)

#2. slice() 


#GET THE DETAILS OF FIRST 10 ROWS

store3 = slice(store,1:10)
View(store3)

# DETAILS OF FIRST 6 ROWS
store2<-store %>% slice_head(n = 6)
View(store2)

#3.arrange()
#ARRANGE THE DATASET IN ASCENDING ORDER OF QUANTITTY DEMANDED

store_ordered = arrange(store, QUANTITY_DEMANDED)
View(store_ordered)

#ARRANGE THE DATASET IN DESCENDING ORDER OF SELLING PRICE

store3 <- arrange(store, desc(SELLING_PRICE) )
View(store3)

#4. select() 

#GET THE INFORMATION OF COLUMNS SELLING_PRICE,COMPANY

store_sp = select(store, SELLING_PRICE, COMPANY)
View(arrange (store_sp, SELLING_PRICE))

#GET THE INFORMATION OF COLUMNS 2 & 5

store4 = select(store,c(2,5))
View(store4)

#GET THE INFORMATION OF COLUMNS 2 TO 5

store5 = select(store,2:5 )
View(store5)

#GET THE INFORMATION OF COLUMNS STARTING WITH P

store6 = select(store, starts_with("P"))
View(store6)

#GET THE INFORMATION OF COLUMNS ENDING WITH E
store7<- select(store, ends_with("E"))
View(store7)

###5.mutate()
#ADD A COLUMN TO SHOW THE PROFIT

store8 = mutate(store, PROFIT = SELLING_PRICE - COST_PRICE)
View(arrange(store8, PROFIT))

#ADD A COLUMN TO SHOW THE PROFIT PERCENT

store_profit = mutate(store8, PROFIT_PERCENT= PROFIT/COST_PRICE*100)
View(store_profit)

#ADD A COLUMN TO SHOW THE NET PROFIT

store_netp = mutate(store8, NET_PROFIT=PROFIT*QUANTITY_DEMANDED, PROFIT_PERCENT= PROFIT/COST_PRICE*100)
View(store_netp)

# SAVING THE UPDATED FILE

write.table(store_netp, file = "FINAL DEPARTMENTAL STORE.csv", sep=",")

store <- read.csv("FINAL DEPARTMENTAL STORE.csv")
View(store)

#summarize()
#Find the following descriptive statistics for the net profit.

summarize(store, AVERAGE = mean(NET_PROFIT))
summarize(store, MEDIAN = median(NET_PROFIT))
summarize(store, VARIANCE = var(NET_PROFIT))
summarize(store, STD_DEV = sd(NET_PROFIT))
summarize(store, MINIMUM = min(NET_PROFIT))
summarize(store, MAXIMUN = max(NET_PROFI))

#Find the quantile 
summarise(store, QUANTILE=quantile(NET_PROFIT))


#Find the range
summarise(store, RANGE=range(NET_PROFIT))


#group_by().
#### It is used to group data
### Sort the data grouped by PRODUCT_TYPE

store_grouped = group_by(store, PRODUCT_TYPE)

##7.1.Find the AVERAGE/mean 

summarise(store_grouped, MEAN = mean(NET_PROFIT), MEDIAN = median(NET_PROFIT), VARIANCE = var(NET_PROFIT), SD = sd(NET_PROFIT), MINIMUM = min(NET_PROFIT), MAXIMUM = max(NET_PROFIT), SUM = sum(NET_PROFIT))

#*GET THE INFORMATION OF THE COLUMNS 4-10, WHERE PRODUCT_CATEGORY IS
#* 'babycare'ARRANGED IN ASCENDING ORDER OF QUANTITY_DEMANDED
store_i = arrange(filter(select(store,4:10),PRODUCT_CATEGORY == "babycare"), QUANTITY_DEMANDED)
View(store_i)

store_ii = group_by(store, PRODUCT_CATEGORY)
View(store_ii)
summarise(store_ii, MEAN = mean(QUANTITY_DEMANDED), MEDIAN = median(QUANTITY_DEMANDED),VARIANCE = var(QUANTITY_DEMANDED), SD = sd(QUANTITY_DEMANDED), MINIMUM = min(QUANTITY_DEMANDED), MAXIMUM = max(QUANTITY_DEMANDED),SUM = sum(QUANTITY_DEMANDED))

#*DATA VISUALIZATION

#COLUMN PLOT
#The package needed is dplyr and ggplot2
install.packages("ggplot2")
require(ggplot2)

#PLOT FOR AVERAGE_QUANTITY & PRODUCT_TYPE
store%>%group_by(PRODUCT_TYPE)%>%
  summarise(Average_Quantity = mean(QUANTITY_DEMANDED))%>%
  ggplot(aes(x= PRODUCT_TYPE, y = Average_Quantity)) + 
  geom_col(width = 0.8, fill = "magenta")+ 
  theme(text = element_text(size = 10, color = "blue"))


#8.2.PLOT FOR AVERAGE_NET_PROFIT & PRODUCT_TYPE
 store%>% group_by(PRODUCT_TYPE)%>%
   summarise(Average_Net_Profit = mean(NET_PROFIT))%>%
  ggplot(aes(x= PRODUCT_TYPE, y = Average_Net_Profit))+
   geom_col(width = 0.5, fill = "light green")+
   theme(text = element_text(size = 10, color = "orange"))


#SCATTER PLOT
#PLOT FOR NET_PROFIT & COMPANY 

store%>%
  ggplot(aes(x = COMPANY, y = NET_PROFIT, color = PRODUCT_TYPE))+geom_point()

#*PLOT FOR PROFIT  & QUANTITY_DEMANDED WHERE
#* PRODUCT_TYPE == "beauty products"
 store %>% filter(PRODUCT_TYPE == "beauty products" ) %>%
   ggplot(aes(x = QUANTITY_DEMANDED, y = PROFIT, 
              color = PRODUCT_CATEGORY))+ geom_point()
 
#% SCATTER PLOT FOR SELLING PRICE AND QUANTITY DEMANDED
 store%>% 
   ggplot(aes(x=QUANTITY_DEMANDED, y = SELLING_PRICE, 
              color = PRODUCT_TYPE ))+geom_point()
 
#SCATTER PLOT FOR SELLING PRICE AND QUANTITY DEMANDED OF BEAUTY PRODUCTS AND HYGIENE
 
 store%>% filter(PRODUCT_TYPE == c("beauty products", "hygiene"))%>%
   ggplot(aes(x=QUANTITY_DEMANDED, y = SELLING_PRICE, color = PRODUCT_TYPE ))+geom_point()
 
#LINE PLOT
 
#PLOT FOR  PRICE-DEMAND RELATIONSHIP BETWEEN FOOD ITEMS
 
store%>% filter(PRODUCT_TYPE == c("foodgrains&spices", "Organic food", "Packed Food"))%>%
  ggplot(aes(x= QUANTITY_DEMANDED, y = SELLING_PRICE, color = PRODUCT_TYPE))+geom_line()
  
  # LINE PLOT FOR AVERAGE PROFIT AND COMPANY
store%>%group_by(COMPANY)%>%
  summarise(Avg_Profit = mean(PROFIT))%>%
  ggplot(aes(x = Avg_Profit, y = COMPANY, group = 1))+ geom_line(color = "yellow")
  
 
#HISTOGRAM 
 
#HISTOGRAM FOR PROFIT_PERCENT OF PRODUCT_CATEGORY

store%>%
  ggplot(aes(x= PROFIT_PERCENT, fill = PRODUCT_CATEGORY))+geom_histogram(binwidth = 30)
#HISTOGRAM FOR QUANTITY_DEMANDED OF PRODUCT_CATEGORY WHERE PRODUCT_TYPE IS "snacks"
 store %>%
   filter(PRODUCT_TYPE == "snacks") %>%
   ggplot(aes(x=QUANTITY_DEMANDED, fill=PRODUCT_CATEGORY))+geom_histogram(binwidth = 30)
 

#correlation 
 require(ggcorrplot)
 require(ggplot2)

View(store)
store_num = dplyr::select_if(store, is.numeric)
View(store_num)
cor_matrix = round(cor(store_num),1)
cor_matrix

# p-value matrix
cor_p = round(cor_pmat(store_num),1)
cor_p

#plotting the correlation map


ggcorrplot(cor_matrix,hc.order = T, type = "lower", lab = T, lab_col = "white", lab_size = 2,
           outline.color = "green", p.mat = cor_p, insig = "blank")


#CHART FOR EACH TYPE'S QUANTITY DEMANDED WHERE THE PRODUCT_TYPE IS "ORGANIC FOOD"

store%>%filter(PRODUCT_TYPE == "Organic food")%>%
  group_by(PRODUCT_CATEGORY)%>%
  summarise(Total_demand = sum(QUANTITY_DEMANDED))%>%
  ggplot(aes(x= PRODUCT_CATEGORY, y = Total_demand))+ geom_col(color = "blue", fill = "green", width = 0.5) 
