ui <- dashboardPage(
  skin = "green",
  dashboardHeader(title = "Beauty Explorer",
                  titleWidth = 200),
  ## Sidebar content
  dashboardSidebar(
    width = 200,
    sidebarMenu(
      menuItem("Welcome", tabName = "welcome", icon = icon("home")),
      menuItem("Explore", tabName = "explore", icon = icon("compass"))
    )
  ),
  dashboardBody(
    tabItems(
      # Welcome
      tabItem(tabName = "welcome",
              h2("What's beauty made of?"),
              br(),
              div(class = "my-class", p("Introductory text will go here..."))
      ), #end welcome
      
      # Explorer
      tabItem(tabName = "explore",
              h2("Beauty Product Explorer"),
              fluidRow(
                column(width = 4,
                  selectInput("top_cat", label = "Top Level Category", 
                      choices = top_cats, 
                      selected = top_cats[1]),
                  
                  # selectInput("sec_cat", label = "Category",
                  #     choices = secondary_cats,
                  #     selected = secondary_cats[1]),
                  
                  checkboxGroupInput("bad_ingredients", label = "Ingredients", 
                      choices = bad[,1],
                      selected = bad[1,1])
                ),
                
                column(width = 8,
                       h3("Count of Products with Undesierable Ingredients"),
                       plotlyOutput("bad_brand_chart")
                )
              ),
              br(),
              fluidRow(
                column(width=12,DT::dataTableOutput("raw_table"))
              )
      ) #end explorer
    ) #end tab items
  ) #end dashboard body
)