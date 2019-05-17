tabDashboard = tabItem(tabName = "dashboard",
  fluidRow(
    box(
      width = 12,
      title = "Talks, Presentations & Events", background = "yellow", solidHeader = TRUE,
      valueBox("Test1", "Test1", color = "yellow", icon = icon("chalkboard-teacher")),
      valueBox("Test2", "Test2", color = "yellow", icon = icon("users")),
      valueBox("Test3", "Test3", color = "yellow", icon = icon("clipboard-check"))
    )
  )
)
