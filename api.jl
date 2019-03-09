using HTTP
import JSON

url = "http://weather.livedoor.com/forecast/webservice/json/v1?city=130010"

#=
Dict{String,Any} with 8 entries:
  "location" => Dict{String,Any}("city"=>"東京","area"=>"関東","prefecture"=>"東京都")
    "forecasts" => Any[Dict{String,Any}("telop"=>"晴れ","image"=>Dict{String,Any}("height"=>31,"title"=>"晴れ","width"=>50,"url"=>"http://weather.livedoor.com/img/icon/1.gif"),"date"=>"2019-03-08","temperature"=>Dict{String,Any}("max"=>nothing,"min"=>nothing),"dateLabel"=>"今日"), Dict{String,Any}("telop"=>"晴れ","image"=>Dict{String,Any}("height"=>31,"title"=>"晴れ","width"=>50,"url"=>"http://weather.livedoor.com/img/icon/1.gif"),"date"=>"2019-03-09","temperature"=>Dict{String,Any}("max"=>Dict{String,Any}("fahrenheit"=>"60.8","celsius"=>"16"),"min"=>Dict{String,Any}("fahrenheit"=>"35.6","celsius"=>"2")),"dateLabel"=>"明日"), Dict{String,Any}("telop"=>"曇のち雨","image"=>Dict{String,Any}("height"=>31,"title"=>"曇のち雨","width"=>50,"url"=>"http://weather.livedoor.com/img/icon/13.gif"),"date"=>"2019-03-10","temperature"=>Dict{String,Any}("max"=>nothing,"min"=>nothing),"dateLabel"=>"明後日")]
      "title" => "東京都 東京 の天気"
        "link" => "http://weather.livedoor.com/area/forecast/130010"
          "copyright" => Dict{String,Any}("provider"=>Any[Dict{String,Any}("name"=>"日本気象協会","link"=>"http://tenki.jp/")],"image"=>Dict{String,Any}("height"=>26,"title"=>"livedoor 天気情報","width"=>118,"link"=>"http://weather.livedoor.com/","url"=>"http://weather.livedoor.com/img/cmn/livedoor.gif"),"title"=>"(C) LINE Corporation","link"=>"http://weather.livedoor.com/")
            "description" => Dict{String,Any}("text"=>" 本州付近は広く高気圧に覆われています。\n\n 東京地方は、晴れています。\n\n 8日は、高気圧に覆われて、晴れるでしょう。伊豆諸島では、気圧の谷の\n影響により、雨や雷雨となる所があるでしょう。\n\n 9日も、高気圧に覆われて、おおむね晴れる見込みです。伊豆諸島では、\n気圧の谷の影響により、明け方までは雨や雷雨となる所があるでしょう。\n\n【関東甲信地方】\n 関東甲信地方は、おおむね晴れています。\n\n 8日は、高気圧に覆われて、おおむね晴れるでしょう。伊豆諸島では、気\n圧の谷の影響により、雨や雷雨となる所があるでしょう。\n\n 9日も、高気圧に覆われて、おおむね晴れる見込みです。伊豆諸島では、\n気圧の谷の影響により、明け方までは雨や雷雨となる所があるでしょう。\n\n 関東地方と伊豆諸島の海上では、9日にかけてうねりを伴って波が高いで\nしょう。船舶は高波に注意してください。","publicTime"=>"2019-03-08T21:26:00+0900")
              "pinpointLocations" => Any[Dict{String,Any}("name"=>"府中市","link"=>"http://weather.livedoor.com/area/forecast/1320600"), Dict{String,Any}...]
=#

dictaccess(
function weather_display(data)
  println(join((data["location"]["prefecture"], data["location"]["city"], data["publicTime"]), ", "))
  println(data["description"]["text"])
  for forecast = data["forecasts"]
    println(forecast)
    # ["temperature"]["max"] とか ["min"] が nothing のときがある
    max, min = (temp -> (temp["max"] != null ? temp["max"]["celsius"] : NaN, temp["min"] != null ? temp["min"]["celsius"] : NaN))(forecast["temperature"])
    println("$(forecast["dateLabel"])($(forecast["date"])) : $(forecast["telop"]) $(max)℃ ($(min)℃ )")
  end
end

response = HTTP.get(url)
if response.status == 200
  JSON.parse(String(response.body)) |> weather_display
end


