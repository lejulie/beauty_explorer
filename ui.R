ui <- dashboardPage(
  skin = "yellow",
  dashboardHeader(title = "What's beauty made of?",
                  titleWidth = 250),
  ## Sidebar content
  dashboardSidebar(
    width = 250,
    sidebarMenu(
      menuItem("Welcome", tabName = "welcome", icon = icon("home")),
      menuItem("Explore", tabName = "explore", icon = icon("compass"))
    )
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "welcome",
              h2("Welcome")
      ),
      
      # Second tab content
      tabItem(tabName = "explore",
              h2("Beauty Product Explorer")
      )
    )
  )
)