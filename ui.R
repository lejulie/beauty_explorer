ui <- dashboardPage(
  skin = "green",
  dashboardHeader(title = "Beauty Explorer",
                  titleWidth = 200),
  ## Sidebar content
  dashboardSidebar(
    width = 200,
    sidebarMenu(
      menuItem("Welcome", tabName = "welcome", icon = icon("home")),
      menuItem("Explore", tabName = "explore", icon = icon("compass")),
      menuItem("Questionable Ingredients", tabName = "questionable", 
               icon = icon("exclamation-triangle")),
      menuItem("All Products", tabName = "all_products", icon = icon("table")),
      menuItem("About", tabName = "about", icon = icon("certificate")))
  ),
  dashboardBody(
    tabItems(
      ##### Welcome #####
      tabItem(tabName = "welcome",
            h2("What's beauty made of?"),
            br(),
            div(class = "my-class", p("Introductory text will go here..."))
      ), #end welcome
      
      ##### Explorer #####
      tabItem(tabName = "explore",
            h2("Beauty Product Explorer"),
            fluidRow(
              column(width = 4,
                selectInput("top_cat", label = h4("Top Level Category"), 
                    choices = top_cats, 
                    selected = top_cats[1]),
                
                checkboxGroupInput("bad_ingredients", label = h4("Ingredients"), 
                    choices = bad[,1],
                    selected = bad[1,1])),
              
              column(width = 8,
                     h3("Count of Products with Undesierable Ingredients"),
                     plotlyOutput("bad_brand_chart"))),
            
            fluidRow(
              column(width=12,
                     h3("Products"),
                     DT::dataTableOutput("bad_sub_table")))
      ), #end explorer
      
      ###### Questionable Ingredients #####
      tabItem(tabName = "questionable",
            h2("Questionable Ingredients"),
            br(),
            div(class = "my-class", p("Copy about why we're looking at
                                      certain ingredients will go here..."))
      ),
      
      ##### All Products #####
      tabItem(tabName = "all_products",
            h2("All Products"),
            fluidRow(
              column(width=12,
                     h3("Products"),
                     DT::dataTableOutput("raw_table")))     
      ),
      
      ##### About #####
      tabItem(tabName = "about",
              h2("About"),
              br(),
              div(class = "my-class", p("About copy will go here"))
              )
    ) #end tab items
  ) #end dashboard body
)