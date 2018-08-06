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
  output$bad_brand_chart = renderPlotly({
    x = factor(bad_brands()$brand_name, levels = bad_brands()[["brand_name"]])
    plot_ly(
      data = bad_brands(),
      x = ~x,#~as.character(brand_name),
      y = ~count,
      name = "test",
      type = "bar") %>%
      layout(
        xaxis = list(title = "Brand Name", tickangle = -45),
        yaxis = list(title = "Count"),
        margin = list(b = 150, l=80),
        barmode = 'group')}
  )
  
  # Data table
  output$raw_table = DT::renderDataTable(
    {dplyr::select(sub_prods(),top_level_category, secondary_category, 
                   brand_name, product_name, ingredients)},
    colnames = c("Top Level Category", "Subcategory", "Brand Name", 
                 "Product Name","Ingredients")
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
  
}