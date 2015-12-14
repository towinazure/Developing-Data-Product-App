data(iris)
library(randomForest)
library(prcomp)
library(ggplot2)
set.seed(1234)
iris.rf <- randomForest(Species ~ ., 
                        data=iris, 
                        importance=TRUE,
                        proximity=TRUE,
                        ntree = 1)

iris <- data.frame(iris)
log.ir <- log(iris[, 1:4])
ir.species <- iris[, 5]
iris.pca <- prcomp(log.ir, center = TRUE, scale = TRUE)
iris.pca.dat <- data.frame(PC1 = iris.pca$x[, 1], 
                           PC2 = iris.pca$x[, 2], 
                           Class = as.character(ir.species))
  
str(iris.pca.dat)

iris.pca.rf <- randomForest(Class ~ PC1 + PC2,
                            data=iris.pca.dat, 
                            importance = FALSE,
                            proximity = FALSE,
                            ntree = 50)

iris.pca.dat$Pred.Class <- iris.pca.rf$predicted
iris.pca.dat$Pred.Class <- as.character(iris.pca.dat$Pred.Class)
iris.pca.dat$Pred.Class[is.na(iris.pca.dat$Pred.Class)] <- 'unknown'
iris.pca.dat$Pred.Class  <- as.factor(iris.pca.dat$Pred.Class)
iris.pca.dat$Pred.Class <- factor(iris.pca.dat$Pred.Class,  levels = c('setosa', 'versicolor', 'virginica', 'unknown'))
iris.pca.dat$Correctness <- 'Correct'
levels(iris.pca.dat$Class) <- c('setosa', 'versicolor', 'virginica', 'unknown')
iris.pca.dat$Correctness[iris.pca.dat$Class != iris.pca.dat$Pred.Class] <- 'Incorrect' 


ggplot(data = iris.pca.dat, mapping = aes(x = PC1, y = PC2, group = Correctness)) + 
  geom_point(aes(colour = Pred.Class), size = 4.5) +
  geom_point(data = iris.pca.dat,
             aes(colour = Class, shape = Correctness), size = 7) +
  scale_shape_manual(values = c('Correct' = 1, 'Incorrect' = 4))

# palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#585858",
#           "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
# plot(x = iris.pca.dat$PC1, 
#      y = iris.pca.dat$PC2, 
#      col = iris.pca.dat$Pred.Class, 
#      pch = 20, cex = 3, 
#      xlab = 'PC1', ylab = 'PC2') 
# incorrect.dat <- subset(iris.pca.dat, Correctness == 'Incorrect')
#   points(x = incorrect.dat$PC1, y = incorrect.dat$PC2, pch = 4, col = incorrect.dat$Class, cex = 3) 
#   par(xpd=T, mar = c(10,10,10,10))
#   legend(3.2, -4, legend = c('setosa', 'versicolor', 'virginica', 'unknown', 'Correct', 'Incorrect'), 
#     pch = c(20, 20, 20, 20, 20, 4),
#     col = c("#E41A1C", "#377EB8", "#4DAF4A", "#585858", "black", "black"))




