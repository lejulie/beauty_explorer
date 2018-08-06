server <- function(input, output, session) {
  
  # Products selected by category and checkboxes
  sub_prods = reactive({
    if(length(input$bad_ingredients) == 0){
      NULL}
    else{
      if(input$top_cat == "All"){
        filter(products, grepl(paste(bad[bad$family %in% input$bad_ingredients, 
                                         2], collapse = '|'),
                               ingredients))}
      else{
        filter(products, top_level_category == input$top_cat) %>%
          # filter(., secondary_category == input$sec_cat) %>%
          filter(., grepl(paste(bad[bad$family %in% input$bad_ingredients, 
                                    2], collapse = '|'),
                          ingredients))}}
  })
  
  # Data for bad brand plot
  bad_brands = reactive({
    sub = sub_prods() %>% 
      group_by(brand_name) %>% 
      summarise(count = n()) %>% 
      arrange(desc(count))
    if(length(sub$brand_name) > n_bars){sub = sub[1:30,]}
    sub
  })
  
  # Bad brand histogram
  output$bad_brand_histogram = renderPlot(
    ggplot(bad_brands(), aes(x = reorder(brand_name,-count), y = count)) +
      geom_bar(stat = "identity") +
      xlab("Brand") + 
      ylab("Count of Products") + 
      theme(axis.text.x = element_text(angle = 90, hjust = 1))
  )
  
  # # Update sub category list
  # observeEvent(input$top_cat, {
  #   new_list = cat_map %>%
  #     filter(top_level_category == input$top_cat)
  #   new_list = sort(unique(new_list$secondary_category))
  #   updateSelectInput(
  #     session,
  #     "sec_cat",
  #     choices = new_list,
  #     label = "Category",
  #     if(input$sec_cat %in% new_list){selected = input$sec_cat}
  #     else{selected = new_list[1]}
  #     )
  # })
  
  # Data table
  output$raw_table = DT::renderDataTable(
    dplyr::select(sub_prods(),top_level_category, secondary_category, brand_name,
           product_name, ingredients)
    )

}