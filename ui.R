library(shiny)
library(shinydashboard)

# Define UI for application that draws a histogram
dashboardPage(
    dashboardHeader(title = "Algoritmos en la Ciencia de Datos"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Problema 1", tabName = "problema_1"),
            menuItem("Problema 2", tabName = "problema_2")
        ) 
    ),
    dashboardBody(
        tabItems(
            tabItem("Ceros",
                    h1("Método de Newton"),
                    box(textInput("ecuacion", "Ingrese la Ecuación"),
                        textInput("initVal", "X0"),
                        textInput("Error", "Error")),
                    actionButton("nwtSolver", "Newton Solver"),
                    tableOutput("salidaTabla")),
            
            tabItem("Derivacion",
                    h1("Diferencias Finitas"),
                    box(textInput("difFinEcu", "Ingrese la Ecuación"),
                    textInput("valorX", "x"),
                    textInput("valorH", "h")),
                    actionButton("diferFinEval", "Evaluar Derivada"),
                    textOutput("difFinitOut")),
            
            tabItem("Biseccion",
                    h1("Método de Bisección"),
                    box(textInput("ecuacionBisect", "Ingrese la Ecuación"),
                        textInput("initA", "Valor de a"),
                        textInput("initB", "Valor de b"),
                        textInput("ErrorBisect", "Error"),
                        textInput("kMax", "Máximo de Iteraciones")),
                    actionButton("bisectSolver", "Resolver"),
                    tableOutput("salidaBiseccion")),

            tabItem("newton-raphson",
                    h1("Método de Newton-Raphson"),
                    box(textInput("ecuacion", "Ingrese la Ecuación"),
                        textInput("initVal", "X0"),
                        textInput("Error", "Error"),
                        textInput("kMaxNewton", "Máximo de Iteraciones")),
                    actionButton("nwtSolver", "Resolver"),
                    tableOutput("salidaTabla")),
            tabItem("problema_1",
                    h1("Funcion Cuadratica:f(x) 1/2x^TQx+c^Tx "),
                    box(
                        textAreaInput("matrizQ", label = "Ingrese la matriz Q:", rows = 3, value = "2,-1,0\n-1,2,-1\n0,-1,2"),
                        textInput("vectorC", label = "Ingrese el vector c:", value = "1,0,1"),
                        textInput("vectorX0", label = "Ingrese el vector x0:", value = "3,5,7"),
                        textInput("tolerancia", label = "Ingrese la tolerancia:", value = 0.000001),
                        textInput("iteraciones", label = "Número máximo de iteraciones:", value = 30),
                        selectInput("modoAlpha", label = "Modo de alpha:",
                                    choices = c("exacto", "constante", "variable")),
                        conditionalPanel(
                          condition = "input.modoAlpha == 'constante'",
                          numericInput("valorAlpha", label = "Valor de alpha:", value = 0.001)
                        )),
                    actionButton("p1Solver", "Resolver"),
                    tableOutput("salidap1"),
                    plotOutput("plotGradNorm")),
            tabItem("problema_2",
                    h1("Rosenbrock's Function: f(x_1,x_2) = 100(x_2 x_1^2)^2 + (1 x_1)^2 "),
                    box(
                      textInput("X0", label = "Ingrese el vector X:", value = "0,0"),
                      numericInput("valorAlpha", label = "Valor de alpha:", value = 0.05),
                      textInput("tolerancia", label = "Ingrese el Error:", value = 0.00000001),
                      textInput("iteraciones", label = "Número máximo de iteraciones:", value = 30),
                      ),
                    actionButton("p2Solver", "Resolver"),
                    tableOutput("salidap2"),
                    plotOutput("plotGradNorm2"))
        )
    )
)
