package forecast.ingestion

object ErrorHandler {

  def flow(statusCode: Int): Unit = {
    val nextStep: String = statusCheck(statusCode)
    exceptionHandler(nextStep)
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
  private def exceptionHandler(nextStep: String): Unit = {
    nextStep match {
      case "retry" => throw new Exception("Retry in one hour")
      case "stop" => throw new Exception("Program failure - adjust code")
      case _ =>
    }
  }
}
