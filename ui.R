ui <- dashboardPage(
  skin = "yellow",
  dashboardHeader(title = "Beauty Explorer"),
  ## Sidebar content
  dashboardSidebar(
    sidebarMenu(
      menuItem("Welcome", tabName = "welcome", icon = icon("home")),
      menuItem("Explore", tabName = "explore", icon = icon("compass"))
    )
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "welcome",
              h2("What's beauty made of?"),
              br(),
              div(class = "my-class", p("Introductory text will go here..."))
      ),
      
      # Second tab content
      tabItem(tabName = "explore",
              h2("Beauty Product Explorer"),
              selectInput("top_cat", label = h3("Top Level Category"), 
                          choices = top_cats, 
                          selected = top_cats[1]),
              selectInput("sec_cat", label = h3("Secondary Category"), 
                          choices = secondary_cats, 
                          selected = secondary_cats[1])
      )
    )
  )
)