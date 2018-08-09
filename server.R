server <- function(input, output, session) {
  
  ##### Explorer #####
  # Products selected by category and checkboxes
  sub_prods = reactive({
    if(length(input$bad_ingredients) == 0){
      products}
    else{
      if(input$top_cat == "All"){
        filter(products, grepl(paste(bad[bad$family %in% input$bad_ingredients, 
                                         2], collapse = '|'),
                               ingredients,ignore.case = TRUE))}
      else{
        filter(products, top_level_category == input$top_cat) %>%
          # filter(., secondary_category == input$sec_cat) %>%
          filter(., grepl(paste(bad[bad$family %in% input$bad_ingredients, 
                                    2], collapse = '|',ignore.case = TRUE),
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
      x = ~x,
      y = ~count,
      #text = ~count, textposition = 'auto',
      type = "bar",
      marker = list(color = c_bars)) %>%
      layout(
        xaxis = list(title = "", tickangle = -45),
        yaxis = list(title = ""),
        margin = list(b = 150, l=80),
        barmode = 'group',
        plot_bgcolor = c_bg,
        paper_bgcolor = c_bg) %>%
      config(displayModeBar = F, showLink = F) %>%
      layout(height = 450)
  })
  
  # Data table
  output$bad_sub_table = DT::renderDataTable(
    {dplyr::select(sub_prods(),top_level_category, secondary_category, 
                   brand_name, product_name, ingredients,url_links)},
    colnames = c("Category", "Subcategory", "Brand", 
                 "Product","Ingredients","URL"),
    options = list(searching = TRUE, columnDefs =
                     list(list(className = 'dt-left', targets = 1:6))),
    escape = FALSE
    )
  
  ##### By Brand #####
  
  # Data for ingredients by brand plot
  ing_by_brand = reactive({
    by_brand[,c("rn",clean(input$brand_select))]
  })
  
  # Data for ingredients by brand table
  prods_by_brand = reactive({
    products[products$brand_name == input$brand_select,]
  })
  
  # By brand histogram
  output$ingredients_by_brand_chart = renderPlotly({
    x = factor(ing_by_brand()$rn, levels = ing_by_brand()[["rn"]])
    y = ing_by_brand()[,2]
    print("Y:")
    print(y)
    plot_ly(
      data = ing_by_brand(),
      x = ~x,
      y = ~y,
      type = "bar",
      marker = list(color = c_bars)) %>%
      layout(
        xaxis = list(title = "", tickangle = -45),
        yaxis = list(title = ""),
        margin = list(b = 150, l=80),
        barmode = 'group',
        plot_bgcolor = c_bg,
        paper_bgcolor = c_bg) %>%
      config(displayModeBar = F, showLink = F) %>%
      layout(height = 450)
  })
  
  # By brand data table
  output$ingredients_by_brand_table = DT::renderDataTable(
    {dplyr::select(prods_by_brand(),top_level_category, secondary_category, 
                  product_name, ingredients,url_links)},
    colnames = c("Category","Subcategory","Product","Ingredients","URL"),
    options = list(searching = TRUE, columnDefs =
                     list(list(className = 'dt-left', targets = 1:5))),
    escape = FALSE
  )
  
  ##### All Data Table #####
  output$raw_table = DT::renderDataTable(
    {dplyr::select(products,top_level_category, secondary_category, 
                   brand_name, product_name, review_count, review_avg_rating,
                   ingredients, url_links)},
    colnames = c("Category", "Subcategory", "Brand", "Product","Review Count",
                 "Average Review (1-5)","Ingredients","URL"),
    options = list(searching = TRUE, columnDefs =
                     list(list(className = 'dt-left', targets = 1:7))),
    escape = FALSE
  )
}