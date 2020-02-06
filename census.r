variable_list <- c(
  "C24050_002",
  "C24050_003",
  "C24050_004",
  "C24050_005",
  "C24050_006",
  "C24050_007",
  "C24050_008",
  "C24050_010",
  "C24050_011",
  "C24050_012",
  "C24050_013",
  "C24050_014",
  "B01003_001"
  )
#state_list = ["39", "29", "26", "24", "42"]
state_list <- c("39", "29", "26", "24", "42")


df <- data_frame() 
  for (j in 1:length(state_list)) {
    print(state_list[j]) 
    
    
  for (i in 2010:2018){
    acs <- get_acs('tract', variables = variable_list, year = i, survey='acs5', state=state_list[j]) %>% 
      mutate(year = i,
             variable = paste0(variable, "_ ", year)) %>% 
      select(-(moe), -(year))
    df <- rbind(df, acs)
  } 
  }

df <- df %>% 
  spread(key=variable, value=estimate)
  
var2 <- c(
  "B15003_016",
  "B15003_017",
  "B15003_018",
  "B15003_019",
  "B15003_020",
  "B15003_021",
  "B15003_022",
  "B15003_023",
  "B15003_024",
  "B15003_025",
  "B25077_001",
  "B25031_001",
  "B25104_001",
  "B06012_002",
  "B06012_004"
)

df2 <- data_frame() 
for (j in 1:length(state_list)) {
  print(state_list[j]) 
  
  
  for (i in 2010:2018){
    tryCatch({
    acs <- get_acs('tract', variables = var2, year = i, survey='acs5', state=state_list[j]) %>% 
      mutate(year = i,
             variable = paste0(variable, "_ ", year)) %>% 
      select(-(moe), -(year))
    df2 <- rbind(df2, acs)
    },
    error = function(e) {
      str(e)
    })
  } 
}

df2 <- df2 %>% 
  spread(key=variable, value=estimate) %>% 
  select(-(NAME))

df_out <- merge(df, df2, by="GEOID", sort = TRUE) 

write.csv(df_out, 'V:\\CLE-VAL-CLIENTS\\Dave Grubman\\For Annette Stevenson\\census_data.csv', row.names = FALSE) 
  