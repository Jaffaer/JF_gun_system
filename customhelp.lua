RegisterNetEvent('jf:CustomHelpMenu')
AddEventHandler('jf:CustomHelpMenu', function(animName, toogleTorch, changeAnim, isEquipped)
	print('Anim Name: ', animName)
	print('Toogle torch button: ', toogleTorch)
	print('Change anim button: ', changeAnim)
	print('Is Equipped: ', tostring(isEquipped))
	print('Locale anim:', _(animName))
	
	if isEquipped then

	else

	end
end)