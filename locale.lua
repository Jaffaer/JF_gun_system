Locales = {}

local function Translate(key, ...)
	local localeName = Config.Locale
	local currentLocale = Locales[localeName]

	if currentLocale then
		local text = currentLocale[key]
		if text then
			local arg1, arg2, arg3 = ...
			return string.format(text, arg1, arg2, arg3)
		else
			return "Translation [" .. localeName .. "][" .. key .. "] does not exist"
		end
	else
		return "Locale [" .. localeName .. "] does not exist"
	end
end

_ = Translate