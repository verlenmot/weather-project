package forecast.ingestion

object errorHandler {
  def statusCheck(statusCode: Int): String = {

    val nextStep: String = statusCode match {
      case 200 => "continue"
      case 429 => "retry"
      case 500 => "retry"
      case _ => "stop"
    }

    return nextStep
  }

}
