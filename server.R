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
      marker = list(color = c_bars)) %>%   #rgb(255,184,209)'
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
    options = list(searching = TRUE),
    escape = FALSE
    )
  
  ##### All Data Table #####
  output$raw_table = DT::renderDataTable(
    {dplyr::select(products,top_level_category, secondary_category, 
                   brand_name, product_name, review_count, review_avg_rating,
                   ingredients, url_links)},
    colnames = c("Category", "Subcategory", "Brand", "Product","Review Count",
                 "Average Review (1-5)","Ingredients","URL"),
    options = list(searching = TRUE),
    escape = FALSE
  )
}