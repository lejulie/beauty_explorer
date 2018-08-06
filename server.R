server <- function(input, output, session) {
  
  # Test text
  output$testText = renderPrint(
    dim(sub_prods())[1]
    )
  
  # Observe changes in top level category lists
  sub_prods = reactive({
  if(length(input$bad_ingredients) == 0){
      NULL
    }
  else{
     if(input$top_cat == "All"){
       filter(products, str_detect(ingredients, 
                           bad[bad$family %in% input$bad_ingredients, 2]))
     }
    else{
      filter(products, top_level_category == input$top_cat) %>%
        # filter(., secondary_category == input$sec_cat) %>%
        filter(., str_detect(ingredients, 
                       paste(bad[bad$family %in% input$bad_ingredients, 2],
                             collapse = '|')))
    }}
  })
  
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
  output$raw_table = DT::renderDataTable(sub_prods())

}