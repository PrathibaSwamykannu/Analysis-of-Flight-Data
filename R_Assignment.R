head(FAA1_1_,10)

install.packages("dplyr")
library(dplyr)

#to check missing values
colSums(is.na(FAA1_1_)) 

#to remove missing values
FAA1 = na.omit(FAA1_1_) 

#to remove duplicates
distinct(FAA1) 

#to remove abnormal values
nrow(FAA1)
faa1 = filter(FAA1,duration > 40)
nrow(faa1)
faa2 = filter(faa1,speed_ground > 30 & speed_ground <140)
nrow(faa2)
faa3 = filter(faa2,speed_air>30 & speed_air <140)
nrow(faa3)
faa4 = filter(faa3,height >= 6)
nrow(faa4)
faa5 = filter(faa4,distance < 6000)
nrow(faa5)

#to find negative values
sum(faa5<0) 

FAA1 = faa5

install.packages("ggplot2") 
library(ggplot2)

#plot distance against duration
ggplot(data = FAA1, mapping = aes(x = duration, y = distance)) + geom_point()


#plot distance against no_pasg
ggplot(data = FAA1, mapping = aes(x = no_pasg, y = distance)) + geom_point()


#plot distance against speed_ground
ggplot(data = FAA1, mapping = aes(x = speed_ground, y = distance)) + geom_point()


#plot distance against speed_air
ggplot(data = FAA1, mapping = aes(x = speed_air, y = distance)) + geom_point()


#plot distance against height
ggplot(data = FAA1, mapping = aes(x = height, y = distance)) + geom_point()


#plot distance against pitch
ggplot(data = FAA1, mapping = aes(x = pitch, y = distance)) + geom_point()


#plot distance against aircraft make
ggplot(data = FAA1, mapping = aes(x = aircraft, y = distance)) + geom_point()



# correlation matrix
install.packages("corrplot")
library(corrplot)
res <- cor(faa1[,2:8])
round(res, 2)


# creating a linear model
Model=lm(distance~aircraft+duration+no_pasg+speed_ground+speed_air+height+pitch,data = faa1)

# Getting model summary
summary(Model)


# Splitting the aircraft dataset into two by the aircraft make - Boeing and Airbus and building the model.
Boeingdata = filter(FAA1,aircraft== 'boeing')
nrow(Boeingdata)
Boeing_model<-lm(distance~duration+no_pasg+speed_ground+speed_air+height+pitch,data = Boeingdata)
summary(Boeing_model)

#Airbus dataset
Airbusdata = filter(FAA1,aircraft== 'airbus')
nrow(Airbusdata)
Airbus_model<-lm(distance~duration+no_pasg+speed_ground+speed_air+height+pitch,data = Airbusdata)
summary(Airbus_model)


