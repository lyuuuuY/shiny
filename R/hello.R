library("Rapi")
library("stopwords")
#ui
ui <- function(){
  fluidPage(
    titlePanel("TOP 10 Nouns in selected Speeches "),
    sidebarLayout(  #侧边栏输入内容
      sidebarPanel(
        textInput("start_date","Enter the start of date(yyyy-mm-dd,Optional):" ),
        textInput("end_date","Enter the end of date(yyyy-mm-dd,Optional)"),
        selectInput("type_speech","Enter tpye of speech(Optional):",choices = c("nej","")),
        selectInput("party","Select the party(Optional):",choices = c("c","l","kd","mp","m","s",
                                                           "sd","v","-","nyd")),
        textInput("member","Enter Member ID:"),

        selectInput("size","Select the size of feedback",choices = c(
          "10","50","200","1000","2000","5000","10000")),
        actionButton("submit", "Submit")
        ),
      mainPanel = ("nounTable") #输出表格



      )
    )

}

#serve

server <- function(input,output,session){
  observeEvent(input$submit, { #用户点击“Submit”时触发事件
    start_date <- input$start_date
    end_date <- input$end_date
    type_speech <- input$type_speech
    party<- input$party
    member <- input$member
    size <- as.numeric(input$size)
    #调用R包函数获取输出结果
    results <- get_top_10_nouns(start_date,end_date,type_speech,party,member,size)
    #处理输出结果统计发言总数部分提取数字
    speech_count <- as.numeric(sub("the number of speeches：","",results$number_of_speeches))
    top_nouns <- results$top_10_nouns #提取名词
    #转换为数据框
    noun_data <- data.frame(
      Noun=names(top_nouns),
      Frenquency=as.numeric(top_nouns),
      SpeechCount=speech_count,
      stringsAsFactors = FALSE
    )
    output$nounTable <- renderTable({
      noun_data
    })
  })
}
shinyApp(ui = ui, server =server)
