library(shiny)
library(aws.s3)

# Use the injected environment variables
Sys.setenv(
  "AWS_ACCESS_KEY_ID" = Sys.getenv("AWS_ACCESS_KEY_ID"),
  "AWS_SECRET_ACCESS_KEY" = Sys.getenv("AWS_SECRET_ACCESS_KEY"),
  "AWS_DEFAULT_REGION" = Sys.getenv("AWS_DEFAULT_REGION"),
  "AWS_SESSION_TOKEN" = Sys.getenv("AWS_SESSION_TOKEN"),
  "AWS_S3_ENDPOINT" = Sys.getenv("AWS_S3_ENDPOINT")
)

ui <- fluidPage(
  titlePanel("S3 Read/Write with aws.s3"),
  textInput("bucket", "Bucket:", "oidc-hparner"),
  textInput("key", "Object Key:", "compeat/test.txt"),
  textAreaInput("content", "Content:", ""),
  actionButton("read", "Read from S3"),
  actionButton("write", "Write to S3"),
  verbatimTextOutput("result")
)

server <- function(input, output, session) {
  observeEvent(input$read, {
    tryCatch({
      obj <- get_object(input$key, bucket = input$bucket)
      content <- rawToChar(obj)
      updateTextAreaInput(session, "content", value = content)
      output$result <- renderText("Read successful")
    }, error = function(e) {
      output$result <- renderText(paste("Error:", e$message))
    })
  })
  
  observeEvent(input$write, {
    tryCatch({
      put_object(
        file = charToRaw(input$content),
        object = input$key,
        bucket = input$bucket
      )
      output$result <- renderText("Write successful")
    }, error = function(e) {
      output$result <- renderText(paste("Error:", e$message))
    })
  })
}

shinyApp(ui, server)
