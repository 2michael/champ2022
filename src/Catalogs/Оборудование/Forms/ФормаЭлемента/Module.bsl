
&НаКлиенте
Процедура ПоказатьНаКарте(Команда)
	МассивОбъектов = Новый Массив;
	МассивОбъектов.Добавить(Объект);
	ПараметрыОткрытия = Новый Структура("ОбъектыОтображения",МассивОбъектов);
	ОткрытьФорму("Обработка.МониторингОбъектов.Форма.Форма",ПараметрыОткрытия,ЭтотОбъект); 
КонецПроцедуры
