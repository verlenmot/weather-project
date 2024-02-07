package forecast.ingestion

object ExceptionHandler {

  def handleExceptions(statusCode: Int): Unit = {
    val nextStep: String = statusCheck(statusCode)
    flow(nextStep)
  }

  private def statusCheck(statusCode: Int): String = {
    val nextStep: String = statusCode match {
      case 200 => "continue"
      case 429 => "retry"
      case 500 => "retry"
      case _ => "stop"
    }
    nextStep
  }

  private def flow(nextStep: String): Unit = {
    nextStep match {
      case "retry" => throw new RuntimeException("Rate limitation: retry in one hour")
      case "stop" => throw new RuntimeException("Program failure: adjust code")
      case _ =>
    }
  }
}
