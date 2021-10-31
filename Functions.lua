function notify(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(true, false)
end
function text(content,x,y) 
    SetTextFont(6)
    SetTextProportional(0)
    SetTextScale(0.4,0.4)
    SetTextEntry("STRING")
    AddTextComponentString(content)
    DrawText(x,y)
end
function FormatNumber(Number)
	if Number == nil then
		return "unknown"
	end

	return tonumber(string.format("%.2f", Number))
end