using HTTP
import JSON

url = "http://weather.livedoor.com/forecast/webservice/json/v1?city=130010"

function weather_display(data)
  println(join((data["location"]["prefecture"], data["location"]["city"], data["publicTime"]), ", "))
  println(data["description"]["text"])
  for forecast = data["forecasts"]
    println(forecast)
    # ["temperature"]["max"] とか ["min"] が nothing のときがある
    max, min = (temp -> (temp["max"] != nothing ? temp["max"]["celsius"] : NaN, temp["min"] != nothing ? temp["min"]["celsius"] : NaN))(forecast["temperature"])
    println("$(forecast["dateLabel"])($(forecast["date"])) : $(forecast["telop"]) $(max)℃ ($(min)℃ )")
  end
end

response = HTTP.get(url)
if response.status == 200
  JSON.parse(String(response.body)) |> weather_display
end


