using HTTP
import JSON

url = "http://weather.livedoor.com/forecast/webservice/json/v1?city=130010"

function dig(d::Nothing, args...)
    nothing
end

function dig(dict::Dict, key, remains...)
    haskey(dict, key) || return nothing

    current = dict[key]
    length(remains) > 0 || return current

    dig(current, remains...)
end

function weather_display(data)
    d = (args...) -> dig(data, args...)

    pref        = d("location", "prefecture")
    city        = d("location", "city")
    public_time = d("publicTime")

    join((pref, city, public_time), ", ") |> println

    d("description", "text") |> println

    for forecast in data["forecasts"]
        temp = c -> dig(forecast, "temperature", c, "celsius") |>
               v -> v == nothing ? NaN : v

        println("$(forecast["dateLabel"])($(forecast["date"])) : $(forecast["telop"]) $(temp("max"))℃ ($(temp("min"))℃ )")
    end
end

response = HTTP.get(url)
if response.status == 200
    JSON.parse(String(response.body)) |> weather_display
end

