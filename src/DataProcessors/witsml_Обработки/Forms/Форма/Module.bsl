
&НаКлиенте
Процедура ЗаполнитьСправочникwitsml_RealtimeData(Команда)
	ЗаполнитьСправочникwitsml_RealtimeDataНаСервере();
КонецПроцедуры  // ЗаполнитьСправочникwitsml_RealtimeData(Команда)

&НаСервере
Процедура ЗаполнитьСправочникwitsml_RealtimeDataНаСервере()
	
	ТЗ = Новый ТаблицаЗначений;    

	Макет = Справочники.witsml_RealtimeData.ПолучитьМакет("Data");
	
	ОбластьДанных = Макет.Область(1, 1, Макет.ВысотаТаблицы, Макет.ШиринаТаблицы); 
	
	ИсточникДанных = Новый ОписаниеИсточникаДанных(ОбластьДанных);  
	ПостроительОтчета = Новый ПостроительОтчета; 
	ПостроительОтчета.ИсточникДанных = ИсточникДанных;
	ПостроительОтчета.Выполнить();

	Выборка = ПостроительОтчета.Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		s_Name         = СокрЛП(Выборка.Name); 
		s_Descriptions = СокрЛП(Выборка.Description); 
		s_Status       = СокрЛП(Выборка.Status);
		
		СпрСсылка = Справочники.witsml_RealtimeData.НайтиПоНаименованию(s_Name, Истина);
		Если Не ЗначениеЗаполнено(СпрСсылка) Тогда
			СпрОбъект = Справочники.witsml_RealtimeData.СоздатьЭлемент();
			СпрОбъект.Наименование = s_Name;
		Иначе
			СпрОбъект = СпрСсылка.ПолучитьОбъект();
		КонецЕсли;
		
		СпрОбъект.Descriptions = s_Descriptions;
		СпрОбъект.Status       = Перечисления.witsml_Statuses[s_Status];
		
		СпрОбъект.Записать();
		
	КонецЦикла;  // Пока Выборка.Следующий() Цикл
	
КонецПроцедуры  // ЗаполнитьСправочникwitsml_RealtimeDataНаСервере()

&НаСервере
Процедура ЗаполнитьСправочникwitsml_UnitsНаСервере()
	
	ТЗ = Новый ТаблицаЗначений;    

	Макет = Справочники.witsml_Units.ПолучитьМакет("Data");
	
	ОбластьДанных = Макет.Область(1, 1, Макет.ВысотаТаблицы, Макет.ШиринаТаблицы); 
	
	ИсточникДанных = Новый ОписаниеИсточникаДанных(ОбластьДанных);  
	ПостроительОтчета = Новый ПостроительОтчета; 
	ПостроительОтчета.ИсточникДанных = ИсточникДанных;
	ПостроительОтчета.Выполнить();

	Выборка = ПостроительОтчета.Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		//Type					-> UnitType				(ПеречислениеСсылка.witsml_UnitType)
		//Name					-> Наименование			(Строка)
		//Annotation			-> Код					(Строка)
		//Base unit				-> BaseUnit				(СправочникСсылка.witsml_Units) 
		//UnitConversionType	-> UnitConversionType	(ПеречислениеСсылка.witsml_UnitConversionType)	
		//Conversion			-> Conversion			(Строка)
		//Description			-> Descriptions			(Строка)
		//Origin				-> Origin				(Строка)
		
		s_Type               = СокрЛП(Выборка.Type); 
		s_Name               = СокрЛП(Выборка.Name); 
		s_Annotation         = СокрЛП(Выборка.Annotation); 
		s_BaseUnit           = СокрЛП(Выборка.BaseUnit); 
		s_UnitConversionType = СокрЛП(Выборка.UnitConversionType); 
		s_Conversion         = СокрЛП(Выборка.Conversion); 
		s_Description        = СокрЛП(Выборка.Description); 
		s_Origin             = СокрЛП(Выборка.Origin); 
		
		СпрСсылка = Справочники.witsml_Units.GetByAnnotation(s_Annotation);
		
		Если Не ЗначениеЗаполнено(СпрСсылка) Тогда
			СпрОбъект = Справочники.witsml_Units.СоздатьЭлемент();
			СпрОбъект.Код = s_Annotation;
		Иначе
			СпрОбъект = СпрСсылка.ПолучитьОбъект();
		КонецЕсли;
		
		UnitConversionType = Перечисления.witsml_UnitConversionType.ПустаяСсылка();
		Если      s_UnitConversionType = "Conversion (fraction)" Тогда
			UnitConversionType = Перечисления.witsml_UnitConversionType.fraction;
		ИначеЕсли s_UnitConversionType = "Conversion (factor)" Тогда
			UnitConversionType = Перечисления.witsml_UnitConversionType.factor;
		ИначеЕсли s_UnitConversionType = "Conversion (formula)" Тогда
			UnitConversionType = Перечисления.witsml_UnitConversionType.formula;
		КонецЕсли;
		
		СпрОбъект.UnitType           = ?(s_Type = "Base Units", Перечисления.witsml_UnitType.BaseUnits, Перечисления.witsml_UnitType.DerivedUnits);
		СпрОбъект.Наименование       = s_Name;
		СпрОбъект.BaseUnit           = Справочники.witsml_Units.GetByAnnotation(s_BaseUnit);
		СпрОбъект.UnitConversionType = UnitConversionType;
		СпрОбъект.Conversion         = s_Conversion;
		СпрОбъект.Descriptions       = s_Description;
		СпрОбъект.Origin             = s_Origin;
		
		СпрОбъект.Записать();
		
	КонецЦикла;  // Пока Выборка.Следующий() Цикл
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСправочникwitsml_Units(Команда)
	ЗаполнитьСправочникwitsml_UnitsНаСервере();
КонецПроцедуры
