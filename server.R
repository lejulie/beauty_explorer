server <- function(input, output, session) {
  
  # Observe changes in top level category lists
  sub_prods = reactive({
    filter(products, 
           top_level_category == input$top_cat)
  })
  
  # Update sub category list 
  observeEvent(input$top_cat, {
    new_list = sort(unique(sub_prods()$secondary_category))
    updateSelectInput(
      session, 
      "sec_cat",
      choices = new_list,
      label = "Category",
      if(input$sec_cat %in% new_list){selected = input$sec_cat}
      else{selected = new_list[1]}
      )
  })
  
}