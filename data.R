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

 

#（匯出篩選後資料、筆數紀錄表）-----
篩選後筆數<-nrow(df)
刪除筆數紀錄表 <- data.frame(rbind(原始數據筆數,無鄉鎮市區筆數,土地車位筆數,民國101年前和109年後交易筆數,
                                  交易年為空白筆數,無建築完成年月筆數,屋齡為NA筆數,屋齡為負和61年以上筆數,
                                  主建物面積為零筆數,主要用途非住筆數,倉庫筆數,工廠筆數,廠辦筆數,農舍筆數,
                                  房廳衛為零筆數,總價與單價皆為零筆數,備註刪除筆數,篩選後筆數))
#匯出刪除筆數紀錄表
write.csv(刪除筆數紀錄表, file = "/Users/hazel_lin/Documents/Lin Yi-Sin/地政所/1092/四234_電腦輔助大量估價專題研究/data/刪除筆數紀錄表.csv", row.names = T, fileEncoding = "UTF-8")

#匯出篩選後資料
write.csv(df, file = "/Users/hazel_lin/Documents/Lin Yi-Sin/地政所/1092/四234_電腦輔助大量估價專題研究/data/篩選後資料.csv", row.names = F, fileEncoding = "UTF-8")

#匯出備註異常值分類統計
write.csv(備註異常值分類統計, file = "/Users/hazel_lin/Documents/Lin Yi-Sin/地政所/1092/四234_電腦輔助大量估價專題研究/data/備註異常值分類統計.csv", row.names = T, fileEncoding = "UTF-8")


#（待處理：車位拆分）-----
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


