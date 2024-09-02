
library(shiny)
library(reticulate)
np <- import("numpy")

source_python("gradiante.py")

#tableOut, soluc = newtonSolverX(-5, "2x^5 - 3", 0.0001)

shinyServer(function(input, output) {
    
    #Evento y evaluación de metodo de newton para ceros
    newtonCalculate<-eventReactive(input$nwtSolver, {
        inputEcStr<-input$ecuacion[1]
        print(inputEcStr)
        initVal<-input$initVal[1]
        error<-input$Error[1]
        #outs<-add(initVal, error)
        outs<-newtonSolverX(initVal, inputEcStr, error)
        outs
    })
    
    #Evento y evaluación de diferencias finitas
    diferFinitCalculate<-eventReactive(input$diferFinEval, {
        inputEcStr<-input$difFinEcu[1]
        valX<-input$valorX[1]
        h<-input$valorH[1]
        outs<-evaluate_derivate_fx(inputEcStr, valX, h)
        as.character(outs)
    })
    
    
    #REnder metodo de Newton
    output$salidaTabla<-renderTable({
        newtonCalculate()
    })
    
    #Render Diferncias Finitas
    output$difFinitOut<-renderText({
        diferFinitCalculate()
    })
    
    # Evento y evaluación de método de Bisección
    bisectionCalculate <- eventReactive(input$bisectSolver, {
      inputEcStr <- input$ecuacionBisect[1]
      initA <- input$initA[1]
      initB <- input$initB[1]
      error <- input$ErrorBisect[1]
      k_max <- input$kMax[1]
      
      outs <- bisectionSolverX(initA, initB, inputEcStr, error, k_max)
      outs
    })
    
    # Render método de Bisección
    output$salidaBiseccion <- renderTable({
      bisectionCalculate()
    })
    
    newtonCalculate <- eventReactive(input$nwtSolver, {
      inputEcStr <- input$ecuacion[1]
      initVal <- input$initVal[1]
      error <- input$Error[1]
      k_max <- input$kMaxNewton[1]
      
      outs <- newtonSolverX(initVal, inputEcStr, error, k_max)
      outs
    })
    
    # Render método de Newton-Raphson
    output$salidaTabla <- renderTable({
      newtonCalculate()
    })
    
    
    problem1_solver <- eventReactive(input$p1Solver, {
      matrizQ_text <- input$matrizQ
      print(matrizQ_text)
      filas <- strsplit(matrizQ_text, "\n")[[1]]
      print(filas[1])

      matrizQ_list <- lapply(filas, function(fila) as.numeric(unlist(strsplit(fila, ","))))
      matrizQ <- do.call(rbind, matrizQ_list)
      

      vectorC <- as.numeric(unlist(strsplit(gsub("\\s", "", input$vectorC), ",")))
      vectorX0 <- as.numeric(unlist(strsplit(gsub("\\s", "", input$vectorX0), ",")))
      tolerancia <- as.numeric(input$tolerancia)
      iteraciones <- as.integer(input$iteraciones)
      
      alpha_strategy <- input$modoAlpha
      alpha <- as.numeric(input$valorAlpha)
      
      
      np_Q <- np$array(matrizQ)
      np_c <- np$array(vectorC)
      np_x0 <- np$array(vectorX0)
      
      outs <- py$gradient_descent(np_Q, np_c, np_x0, tolerancia, iteraciones, alpha_strategy, alpha)
      
      return(outs)
    })
    
    output$salidap1 <- renderTable({
      problem1_solver()
    })
    
    output$plotGradNorm <- renderPlot({
      results <- problem1_solver()
      
      if (!is.null(results)) {
        plot(results$Iter, results$P_grad, type = "b", col = "blue", 
             xlab = "Iteraciones", ylab = "Norma del Gradiente", 
             main = "Comportamiento del Gradiente vs k")
      }
    })
    
    problem2_solver <- eventReactive(input$p2Solver, {
      vectorx <- as.numeric(unlist(strsplit(gsub("\\s", "", input$X0), ",")))
      alpha <- as.numeric(input$valorAlpha)
      tolerancia <- as.numeric(input$tolerancia)
      iteraciones <- as.integer(input$iteraciones)
      
      outs <- gradient_descent_rosenbrock(vectorx, alpha, tolerancia, iteraciones)
      outs
    })
    
    output$salidap2 <- renderTable({
      problem2_solver()
    })
    
    output$plotGradNorm2 <- renderPlot({
      results <- problem2_solver()
      
      if (!is.null(results)) {
        plot(results$Iter, results$P_grad, type = "b", col = "blue", 
             xlab = "Iteraciones", ylab = "Norma del Gradiente", 
             main = "Comportamiento del Gradiente vs k")
      }
    })
    
    
})
