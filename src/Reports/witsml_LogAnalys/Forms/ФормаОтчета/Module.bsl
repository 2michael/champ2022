
&НаСервере
Процедура ПриОткрытииНаСервере()
	 ЭтотОтчет = РеквизитФормыВЗначение("Отчет");
    ЭтотОтчет.СкомпоноватьРезультат(Результат);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)	  
	Если ЗначениеЗаполнено(Этаформа.Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы[0].ПравоеЗначение) Тогда 
		ПриОткрытииНаСервере(); 
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	АвтоОтображениеСостояния = РежимАвтоОтображенияСостояния.НеОтображать;
КонецПроцедуры
