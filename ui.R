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
      menuItem("By Brand", tabName = "by_brand", icon = icon("shopping-bag")),
      menuItem("Ingredients", tabName = "questionable", 
               icon = icon("exclamation-triangle")),
      menuItem("All Products", tabName = "all_products", icon = icon("table")),
      menuItem("About", tabName = "about", icon = icon("certificate")))
  ),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),
    tabItems(
      ##### Welcome #####
      tabItem(tabName = "welcome",
            h2("What's Beauty Made Of?"),
            br(),
            fluidRow(
            column(width = 8,
              div(class = "my-class", 
              p("Whatever your daily grooming regimen entails, it surely involves off 
                the shelf cosmetic products: cleanser, shampoo, fragrance, makeup, 
                moisturizer, sunscreen, the list goes on.  But what are these products 
                made of?  How much do they differ by brand?"),
              p("This web app explores ingredients in over 11,000 products listed on ",
                tags$a(target="_blank",href="https://www.ulta.com","www.ulta.com"),
                " and allows you to filter by commonly scrutinized ingredients such as  
                particular dyes, preservatives, and detergents."))))
      ), #end welcome
      
      ##### Explorer #####
      tabItem(tabName = "explore",
            h2("Beauty Product Explorer"),
            fluidRow(
              column(width = 12,
                div(class = 'my-class',
                p("Select ingredients below to see which brands’ products 
                  contain them. Check out the full list of products with each 
                  ingredient in the data table below. To learn more about why 
                  these ingredients have come under fire, check out the 
                  Ingredients page.")))
            ),
            br(),
            fluidRow(
              column(width = 3,
                     wellPanel(
                selectInput("top_cat", label = h4("Top Level Category"), 
                    choices = top_cats, 
                    selected = top_cats[1]),
                
                checkboxGroupInput("bad_ingredients", label = h4("Ingredients"), 
                    choices = bad[,1],
                    selected = bad[1,1]))),
              
              column(width = 9,
                     h3("Count of Products for Top 30 Brands"),
                     plotlyOutput("bad_brand_chart"))),
            
            fluidRow(
              column(width=12,
                     h3("Product List"),
                     DT::dataTableOutput("bad_sub_table")))
      ), #end explorer
      
      ##### By Brand #####
      tabItem(tabName = "by_brand",
              h2("Explore by Brand"),
              fluidRow(
                column(width = 12,
                       div(class = 'my-class',
                           p("Select a band below to see the count of products
                             which contain commonly scrutinized ingredients.  
                             See the full list of products by the selected
                             brand in the table below.")))
                           ),
              br(),
              fluidRow(
                column(width = 3,
                       wellPanel(
                         selectInput("brand_select", label = h4("Brand"), 
                                     choices = brands, 
                                     selected = brands[1]))),
                
                column(width = 9,
                       h3("Count of Products by Family of Ingredients"),
                       plotlyOutput("ingredients_by_brand_chart"))),
              
              fluidRow(
                column(width=12,
                       h3("Complete Product List"),
                       DT::dataTableOutput("ingredients_by_brand_table")))
                           ), #end by brand
      
      ###### Commonly Scrutinized Ingredients #####
      tabItem(tabName = "questionable",
            h2("Commonly Scrutinized Ingredients"),
            br(),
            fluidRow(
              column(width = 8, 
                div(class = "my-class", 
                p("This app makes it easy to find products with several classes 
                  of ingredients that are commonly scrutinized.  Below, see
                  the prevalence of these ingredients and learn more 
                  more about the claims around them and how they are identified
                  by the app.")))
              ),
            fluidRow(
              column(width = 8,
                     div(class = "my-class",
                     img(src = "count_prods_in_family_by_category.png", 
                         width = "100%")))
            ),
            fluidRow(
              column(width = 8, 
                  div(class = "my-class", 
                  h4("Coal Tar Dyes"),
                  p(tags$b("What they are:"),"Coal Tar Dyes are synthetic 
                   dyes produced from ",tags$a(
                     target="_blank", href='https://en.wikipedia.org/wiki/Coal_tar',
                     'coal tar.'),"They are common in cosmetics, food
                   products, textiles, and other household products."
                   ),
                  p(tags$b("Ingredients identified by the app:"),"Ingredients
                   starting with “CI”, “FD&C”, or “D&C” and followed by a color
                   number of name, P-Phenylenediamine"),
                   h4("Formaldehyde"),
                  p(tags$b("What it is:"),tags$a(
                   target="_blank", href='https://en.wikipedia.org/wiki/Formaldehyde',
                   'Formaldehyde')," is an organic compound that can be harmful 
                   after prolonged exposure."),
                  p(tags$b("Ingredients identified by the app:"),"Formaldehyde"),
                  h4("Fragrance"),
                  p(tags$b("What it is:"),"In the US, flavor and fragrance 
                   ingredients ",tags$a(target="_blank", href=
'https://www.fda.gov/cosmetics/productsingredients/ingredients/ucm388821.htm#labeling',
'may not have to be explicitly listed'),'and may instead be represented simply as 
"fragrance" to protect trade secrets.  
However, some people may exhibit sensitivity to some of these unlisted ingredients.'),
                  p(tags$b("Ingredients identified by the app:"),"Fragrance, Parfum"),
                  h4("Palm Oil"),
                  p(tags$b("What it is:"),"Palm oil is an oil used in food products 
                    and cosmetics which is associated with ",tags$a(
target="_blank", href='http://wwf.panda.org/our_work/food/agriculture/about_palm_oil/environmental_impacts/',
                      'environmental issues such as deforestation.')),
                  p(tags$b("Ingredients identified by the app:"),"Palm Oil, Palm
                    Kernel Oil"),
                  h4("Parabens"),
                  p(tags$b("What it is:"),"Parabens are ",tags$a(
target="_blank", href='https://www.fda.gov/cosmetics/productsingredients/ingredients/ucm128042.htm',
                      'commonly used preservatives'),"in cosmetics.  There may be ",
tags$a(target="_blank", href='https://www.scientificamerican.com/article/should-people-be-concerned-about-parabens-in-beauty-products/',
       'concerns'),' that prolonged exposure to high concentrations of parabens 
                      could have an impact on human health.'),
                  p(tags$b("Ingredients identified by the app:"),"Paraben, Alkyl 
                    Parahydroxy Benzoates, Methylparaben, Ethylparaben, 
                    Propylparaben, Butylparaben and Isobutylparaben"),
                  h4("Siloxanes"),
                  p(tags$b("What they are:"),"Siloxanes are commonly used in 
                    cosmetics for conditioning and increasing softness.  However, 
                    they may pose some ",tags$a(
target="_blank", href='https://en.wikipedia.org/wiki/Siloxane#Safety_and_environmental_considerations',
                      'environmental concerns.')),
                  p(tags$b("Ingredients identified by the app:"),"Cyclotetrasiloxane, 
                    Octamethylcyclotetrasiloxane, Cylcopentasiloxane, 
                    Polydimethylsiloxan"),
                  h4("Sulfates"),
                  p(tags$b("What they are:"),"Sulfates such as sodium lauryl sulfate 
                    (SLS) are common lathering agents in cleansers and toothpastes, 
                    which ",tags$a(
                      target="_blank", href='https://www.allure.com/story/best-sulfate-free-shampoos',
                      'may be harsh on skin or hair.')),
                  p(tags$b("Ingredients identified by the app:"),"Sodium Lauryl 
                    Sulfate, Sls, Sodium Laureth Sulfate, Sles, Sodium Lauryl 
                    Sulfoacetate, Sodium Lauroyl Isoethionate, Sodium Lauroyl Taurate, 
                    Sodium Cocoyl Isoethionate, Sodium Lauroyl Methyl Isoethionate, 
                    Sodium Lauroyl Sarcosinate, Disodium Laureth Sulfosuccinate"),
                  h4("Sunscreen Chemicals"),
                  p(tags$b("What they are:"),"Some ingredients common in sunscreen, 
                    such as oxybenzone and octinoxate, ",tags$a(
target="_blank", href='https://www.huffingtonpost.com/entry/oxybenzone-chemical-sunscreen_us_5aeb38b0e4b0c4f1931ffce0',
                  'may pose an environmental hazard'),"to coral reefs."),
                  p(tags$b("Ingredients identified by the app:"),"Benzophenone, 
                  Paba, Avobenzone, Homosalate, Ethoxycinnmate, Oxybenzone"))))
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
      fluidRow(
      column(width = 8,
        div(class = "my-class", 
          p('My name is Julie Levine.  I’m a graduate from the School of 
            Engineering and Applied Science at the University of 
            Pennsylvania.  In a past life, I was a marketer and product 
            manager for tech startups ',
            tags$a(target="_blank", href='https://www.factual.com/','Fatual'),' and ',
            tags$a(target="_blank", href='https://www.datadoghq.com/','Datadog.'),
            'Presently, I’m a Data Science Fellow at ', 
            tags$a(target="_blank", href='https://nycdatascience.com/','NYC Data 
            Science Academy.'),'Check out more of my projects on the ',
            tags$a(target="_blank", href=
'https://nycdatascience.com/blog/author/lejulie/','NYC Data Science Academy
            blog'),' and on ',
            tags$a(target="_blank", href="https://github.com/lejulie?tab=repositories",
            "github."),"  Learn more about me on ",tags$a(target="_blank", href=
            "https://www.linkedin.com/in/lejulieb/","LinkedIn."))))))
    ) #end tab items
  ) #end dashboard body
)