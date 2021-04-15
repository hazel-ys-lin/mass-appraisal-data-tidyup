#（資料合併）-----
#library(readxl)
#sheet1 <- read_excel("/Users/hazel_lin/Documents/Lin Yi-Sin/地政所/1092/四234_電腦輔助大量估價專題研究/data/桃園.xlsx", sheet = "不動產買賣_381214")
#sheet2 <- read_excel("/Users/hazel_lin/Documents/Lin Yi-Sin/地政所/1092/四234_電腦輔助大量估價專題研究/data/桃園.xlsx", sheet = "不動產買賣_350000")
#sheet3 <- read_excel("/Users/hazel_lin/Documents/Lin Yi-Sin/地政所/1092/四234_電腦輔助大量估價專題研究/data/桃園.xlsx", sheet = "不動產買賣_300000")
#sheet4 <- read_excel("/Users/hazel_lin/Documents/Lin Yi-Sin/地政所/1092/四234_電腦輔助大量估價專題研究/data/桃園.xlsx", sheet = "不動產買賣_250000")
#sheet5 <- read_excel("/Users/hazel_lin/Documents/Lin Yi-Sin/地政所/1092/四234_電腦輔助大量估價專題研究/data/桃園.xlsx", sheet = "不動產買賣_200000")
#sheet6 <- read_excel("/Users/hazel_lin/Documents/Lin Yi-Sin/地政所/1092/四234_電腦輔助大量估價專題研究/data/桃園.xlsx", sheet = "不動產買賣_150000")
#sheet7 <- read_excel("/Users/hazel_lin/Documents/Lin Yi-Sin/地政所/1092/四234_電腦輔助大量估價專題研究/data/桃園.xlsx", sheet = "不動產買賣_100000")
#sheet8 <- read_excel("/Users/hazel_lin/Documents/Lin Yi-Sin/地政所/1092/四234_電腦輔助大量估價專題研究/data/桃園.xlsx", sheet = "不動產買賣_50000")
#df <- data.frame()
#df <- rbind(sheet1, sheet2, sheet3, sheet4, sheet5, sheet6, sheet7, sheet8)
#write.csv(df, file = "combine.csv")

#（匯入模組、資料、計算原始筆數）-----
library(dplyr)
library(pastecs)
#library(lubridate)
df <- read.csv("/Users/hazel_lin/Documents/Lin Yi-Sin/地政所/1092/四234_電腦輔助大量估價專題研究/data/combine.csv")
#summary(df)
#frequency(df$鄉鎮市區)
#count <- data.frame(table(df$鄉鎮市區))
#land <- data.frame(table(df$交易標的))
#type <- data.frame(table(df$主要用途))
#non.city<- data.frame(table(df$非都市土地使用分區))
原始數據筆數<- nrow(df)

#1.刪除無行政區交易（沒有標示鄉鎮市區的）-----
無鄉鎮市區筆數 <- nrow(df[is.na(df$鄉鎮市區),])
df <- df[!is.na(df$鄉鎮市區),]

#2.刪除僅土地和車位之交易-----
土地車位筆數<- nrow(df[(df$交易標的=="土地" | df$交易標的=="車位"),])
df <- df[!(df$交易標的=="土地" | df$交易標的=="車位"),]
#land.new <-data.frame(table(df$交易標的))
#print(is.numeric(df$建物現況格局.衛))
#去掉土地車位後筆數 <- nrow(df)
#（前置作業：算屋齡）-----
df <- df %>%
  mutate(trade.date = df$交易年月日+19110000)
df <- df %>%
  mutate(build.date = df$建築完成年月+19110000)
df <- df %>%
  mutate( trade.year = substr(x = df$trade.date, start = 1, stop = 4))
df <- df %>%
  mutate(build.year = substr(x = df$build.date, start = 1, stop = 4))

df$house.age <- as.numeric(df$trade.year) - as.numeric(df$build.year)

#匯出去掉土地與車位後的屋齡數據
#write.csv(df, file = "/Users/hazel_lin/Documents/Lin Yi-Sin/地政所/1092/四234_電腦輔助大量估價專題研究/data/before_modified.csv", row.names = F)

#3.篩選交易年月（保留2012~2020年間交易，刪除2011（含）年前和2021（含）以後）-----
#house_age <- data.frame(table(df$house.age))
#trade_year <- data.frame(table(df$trade.year))
#build_year <- data.frame(table(df$build.year))
民國101年前和109年後交易筆數<- nrow(df[(df$trade.year > 2020 | df$trade.year < 2012 ),])
df <- df[!(df$trade.year > 2020 | df$trade.year < 2012 ),]
交易年為空白筆數<- nrow(df[is.na(df$trade.year),])
df <- df[!is.na(df$trade.year),]
#篩選交易年月後筆數<- nrow(df)

#4.刪除無建築完成年月、預售屋/老屋交易（屋齡為負或61年（含）以上）-----
無建築完成年月筆數<- nrow(df[is.na(df$建築完成年月),])
df <- df[!is.na(df$建築完成年月),]
屋齡為NA筆數 <- nrow(df[is.na(df$house.age),])
df <- df[!is.na(df$house.age),]
屋齡為負和61年以上筆數<- nrow(df[(df$house.age<0 | df$house.age>=61),])
df <- df[!(df$house.age<0 | df$house.age>=61),]

#5.刪除無建物移轉面積（=0）者-----
主建物面積為零筆數 <- nrow(df[(df$主建物面積==0),])
df <- df[!(df$主建物面積==0),]

#6.篩選主要用途（刪除非住用類-----
主要用途非住筆數<- nrow(df[(df$主要用途=="停車空間"|df$主要用途=="商業用"|
                      df$主要用途=="工商用"|df$主要用途=="工業用"|df$主要用途=="市場攤位"|
                      df$主要用途=="農業用"|df$主要用途=="農舍"),])
df <- df[!(df$主要用途=="停車空間"|df$主要用途=="商業用"|df$主要用途=="工商用"|
             df$主要用途=="工業用"|df$主要用途=="市場攤位"|df$主要用途=="農業用"|df$主要用途=="農舍"),]
住類建物型態 <- data.frame(table(df$建物型態))

#7.篩選建物型態（刪除倉庫、工廠、廠辦、農舍）-----
倉庫筆數<-nrow(df[(df$建物型態=="倉庫"),])
工廠筆數<-nrow(df[(df$建物型態=="工廠"),])
廠辦筆數<-nrow(df[(df$建物型態=="廠辦"),])
農舍筆數<-nrow(df[(df$建物型態=="農舍"),])
df <- df[!(df$建物型態=="倉庫"|df$建物型態=="工廠"|df$建物型態=="廠辦"|df$建物型態=="農舍"),]

#8.刪除異常格局（0房0廳0衛）-----
房廳衛為零筆數<- nrow(df[(df$建物現況格局.房==0 & df$建物現況格局.廳==0 & df$建物現況格局.衛==0),])
df <- df[!(df$建物現況格局.房==0 & df$建物現況格局.廳==0 & df$建物現況格局.衛==0),]

#（未處理：交易筆棟數欄位）-----
#df$交易筆棟數 <- NULL #刪除交易筆棟數欄位

#9.刪除無法推算總價或單價之交易（總價且單價為零）-----
總價與單價皆為零筆數<- nrow(df[(df$總價.元.==0 & df$單價.元.平方公尺.==0),])
df <- df[!(df$總價.元.==0 & df$單價.元.平方公尺.==0),]

#10.篩選備註欄異常值-----
#1.	急買、急賣
急買急賣<- nrow(df[grepl("急買|急賣", df$備註),])
#2.	債權、債務
債權債務<- nrow(df[grepl("債權|債務", df$備註),])
#3.	親友、兄、哥、弟、姊、姐、妹、父、母、孫、女、夫、妻、配偶、關係人、
#股東、員工、共有人、親等、占用戶、親屬
關係人<-nrow(df[grepl("親友|兄|哥|弟|姊|姐|妹|父|母|孫|女|夫|妻|舅|甥|姨|姪|叔|嬸|姑|伯|
                   配偶|關係人|股東|員工|共有人|親等|占用戶|親屬|等親", df$備註),])
#4.	合併使用、併同出售
合併使用<-nrow(df[grepl("合併使用|併同出售", df$備註),])
#5.	糾紛、爭議
糾紛爭議<-nrow(df[grepl("糾紛|爭議", df$備註),])
#6.	標售、讓售
標售讓售<- nrow(df[grepl("標售|讓售", df$備註),])
#7.	預售
預售<-nrow(df[grepl("預售", df$備註),])
#8.	瑕疵、傾斜、死亡、凶宅、海砂、輻射、地下室
特殊建築<-nrow(df[grepl("瑕疵|傾斜|死亡|凶宅|海砂|輻射|地下室|自殺|他殺", df$備註),])
#9.	持分
持分<-nrow(df[grepl("持分", df$備註),])
#10.	頂樓加蓋
頂樓加蓋<-nrow(df[grepl("頂樓加蓋", df$備註),])
#11.	土地建物分別登記
土地建物分別登記<-nrow(df[grepl("土地建物分別登記", df$備註),])
#12.  畸零地
畸零地<-nrow(df[grepl("畸零地", df$備註),])
#13.  公共設施保留地
公共設施保留地<-nrow(df[grepl("公共設施保留地", df$備註),])
#14.  建商合建
建商合建<-nrow(df[grepl("建商合建|合建", df$備註),])
#15.  受民情風俗因素影響
受民情風俗因素影響<-nrow(df[grepl("民情風俗因素影響|民情|風俗", df$備註),])
#16.  團購 
團購 <-nrow(df[grepl("團購", df$備註),])
#17.	農作物、農業設施、農舍
農業設施<-nrow(df[grepl("農作物|農業設施|農舍", df$備註),])
#18.	陽台外推、增建、夾層
增建<-nrow(df[grepl("陽台外推|增建|夾層", df$備註),])
#19. 其他異常值
其他異常值<-nrow(df[grepl("托兒所|房東|房客|墳墓|靈骨塔", df$備註),])

備註刪除筆數<- 急買急賣+債權債務+關係人+合併使用+糾紛爭議+標售讓售+預售+特殊建築+
               持分+頂樓加蓋+土地建物分別登記+畸零地+公共設施保留地+建商合建+
               受民情風俗因素影響+團購+農業設施+增建+其他異常值

備註異常值分類統計 <- data.frame(rbind(急買急賣,債權債務,關係人,合併使用,糾紛爭議,標售讓售,預售,特殊建築,
                                持分,頂樓加蓋,土地建物分別登記,畸零地,公共設施保留地,建商合建,
                                受民情風俗因素影響,團購,農業設施,增建,其他異常值))
df <- df[!grepl("急買|急賣|債權|債務|
                親友|兄|哥|弟|姊|姐|妹|父|母|孫|女|夫|妻|舅|甥|姨|姪|叔|嬸|姑|伯|配偶|
                關係人|股東|員工|共有人|親等|占用戶|親屬|等親|
                合併使用|併同出售|糾紛|爭議|標售|讓售|
                預售|瑕疵|傾斜|死亡|凶宅|海砂|輻射|地下室|自殺|他殺|
                持分|頂樓加蓋|土地建物分別登記|畸零地|公共設施保留地|
                建商合建|合建|受民情風俗因素影響|民情|風俗|團購|
                農作物|農業設施|農舍|陽台外推|增建|夾層|
                托兒所|房東|房客|墳墓|靈骨塔", df$備註),]

#（匯出篩選後資料、筆數紀錄表）-----
篩選後筆數<-nrow(df)
刪除筆數紀錄表 <- data.frame(rbind(原始數據筆數,無鄉鎮市區筆數,土地車位筆數,民國101年前和109年後交易筆數,
                                  交易年為空白筆數,無建築完成年月筆數,屋齡為NA筆數,屋齡為負和61年以上筆數,
                                  主建物面積為零筆數,主要用途非住筆數,倉庫筆數,工廠筆數,廠辦筆數,農舍筆數,
                                  房廳衛為零筆數,總價與單價皆為零筆數,備註刪除筆數,篩選後筆數))
#匯出刪除筆數紀錄表
write.csv(刪除筆數紀錄表, file = "/Users/hazel_lin/Documents/Lin Yi-Sin/地政所/1092/四234_電腦輔助大量估價專題研究/data/刪除筆數紀錄表.csv", row.names = T)

#匯出篩選後資料
write.csv(df, file = "/Users/hazel_lin/Documents/Lin Yi-Sin/地政所/1092/四234_電腦輔助大量估價專題研究/data/篩選後資料.csv", row.names = F)

#匯出備註異常值分類統計
write.csv(備註異常值分類統計, file = "/Users/hazel_lin/Documents/Lin Yi-Sin/地政所/1092/四234_電腦輔助大量估價專題研究/data/備註異常值分類統計.csv", row.names = T)



#刪掉車位無法拆分
#車位無法拆分 <- nrow(df[(df$交易標的=="房地(土地+建物)+車位"& 
#                     (df$車位總價.元.==0|is.na(df$車位總價.元.))),])
#df <- df[!(df$交易標的=="房地(土地+建物)+車位"& (df$車位總價.元.==0|is.na(df$車位總價.元.))),]

#report <- data.frame(rbind(倉庫,主要用途非住,無建築完成年月,屋齡為NA,屋齡為負和61年以上,車位無法拆分))
#刪完之後的數據匯出
#write.csv(df, file = "/Users/hazel_lin/Documents/Lin Yi-Sin/地政所/1092/四234_電腦輔助大量估價專題研究/data/0324data.csv", row.names = F)
#筆數報表匯出
#write.csv(report, file = "/Users/hazel_lin/Documents/Lin Yi-Sin/地政所/1092/四234_電腦輔助大量估價專題研究/data/0324刪除筆數統計.csv", row.names = T)

#單價<-data.frame(unclass(stat.desc(df$單價.元.平方公尺.)))
#移轉總面積<-data.frame(unclass(stat.desc(df$建物移轉總面積.平方公尺.)))
#車位總價<-data.frame(unclass(stat.desc(df$車位總價.元.)))
#write.csv(單價, file = "/Users/hazel_lin/Documents/Lin Yi-Sin/地政所/1092/四234_電腦輔助大量估價專題研究/data/單價.csv", row.names = T)
#write.csv(移轉總面積, file = "/Users/hazel_lin/Documents/Lin Yi-Sin/地政所/1092/四234_電腦輔助大量估價專題研究/data/移轉總面積.csv", row.names = T)
#write.csv(車位總價, file = "/Users/hazel_lin/Documents/Lin Yi-Sin/地政所/1092/四234_電腦輔助大量估價專題研究/data/車位總價.csv", row.names = T)


