
Процедура ПроверитьПоказатели() Экспорт
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПороговыеЗначенияПоказателейWitsml.Показатель КАК Показатель,
		|	ПороговыеЗначенияПоказателейWitsml.ТипИндекса КАК ТипИндекса,
		|	ПороговыеЗначенияПоказателейWitsml.МинимальноеЗначение КАК МинимальноеЗначение,
		|	ПороговыеЗначенияПоказателейWitsml.МаксимальноеЗначение КАК МаксимальноеЗначение,
		|	ПороговыеЗначенияПоказателейWitsml.РольОтветственного КАК РольОтветственного,
		|	witsml_obj_log_logData.Value КАК Value,
		|	witsml_obj_log_logData.Well КАК Well,
		|	Объекты.Ссылка КАК Объект,
		|	witsml_obj_log_logData.Index КАК Index
		|ПОМЕСТИТЬ ВременнаяТаблицаОтклонений
		|ИЗ
		|	Справочник.Объекты КАК Объекты
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.witsml_obj_log_logData КАК witsml_obj_log_logData
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПороговыеЗначенияПоказателейWitsml КАК ПороговыеЗначенияПоказателейWitsml
		|			ПО witsml_obj_log_logData.IndexType = ПороговыеЗначенияПоказателейWitsml.ТипИндекса
		|				И witsml_obj_log_logData.RealtimeData = ПороговыеЗначенияПоказателейWitsml.Показатель
		|		ПО Объекты.ОбъектУчета = witsml_obj_log_logData.Well
		|ГДЕ
		|	(ПороговыеЗначенияПоказателейWitsml.МинимальноеЗначение > witsml_obj_log_logData.Value
		|			ИЛИ witsml_obj_log_logData.Value > ПороговыеЗначенияПоказателейWitsml.МаксимальноеЗначение)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаОтклонений.Показатель КАК Показатель,
		|	ВременнаяТаблицаОтклонений.ТипИндекса КАК ТипИндекса,
		|	ВременнаяТаблицаОтклонений.МинимальноеЗначение КАК МинимальноеЗначение,
		|	ВременнаяТаблицаОтклонений.МаксимальноеЗначение КАК МаксимальноеЗначение,
		|	ВременнаяТаблицаОтклонений.РольОтветственного КАК РольОтветственного,
		|	ВременнаяТаблицаОтклонений.Value КАК Value,
		|	ВременнаяТаблицаОтклонений.Well КАК Well,
		|	ВременнаяТаблицаОтклонений.Объект КАК Объект,
		|	ВременнаяТаблицаОтклонений.Index КАК Index,
		|	СобытияОбъектов.Значение КАК Значение
		|ПОМЕСТИТЬ ВремТаб
		|ИЗ
		|	ВременнаяТаблицаОтклонений КАК ВременнаяТаблицаОтклонений
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СобытияОбъектов КАК СобытияОбъектов
		|		ПО (СобытияОбъектов.Объект = ВременнаяТаблицаОтклонений.Объект)
		|			И (СобытияОбъектов.ТипИндекса = ВременнаяТаблицаОтклонений.ТипИндекса)
		|			И (СобытияОбъектов.ЗначениеИндекса = ВременнаяТаблицаОтклонений.Index)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВремТаб.Показатель КАК Показатель,
		|	ВремТаб.ТипИндекса КАК ТипИндекса,
		|	ВремТаб.МинимальноеЗначение КАК МинимальноеЗначение,
		|	ВремТаб.МаксимальноеЗначение КАК МаксимальноеЗначение,
		|	ВремТаб.РольОтветственного КАК РольОтветственного,
		|	ВремТаб.Value КАК Value,
		|	ВремТаб.Well КАК Well,
		|	ВремТаб.Объект КАК Объект,
		|	ВремТаб.Index КАК Index,
		|	ВремТаб.Значение КАК Значение
		|ИЗ
		|	ВремТаб КАК ВремТаб
		|ГДЕ
		|	ВремТаб.Значение ЕСТЬ NULL";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
		НастройкиКомпоновки = Отчеты.witsml_LogAnalys.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных").НастройкиПоУмолчанию;
		
		Для каждого ЭлементОтбора Из НастройкиКомпоновки.Отбор.Элементы Цикл
			Если ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Well") Тогда 
				ЭлементОтбора.ПравоеЗначение = ВыборкаДетальныеЗаписи.Well;
				ЭлементОтбора.Использование = Истина;
			КонецЕсли;	
			Если ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("RealtimeData") Тогда 
				ЭлементОтбора.ПравоеЗначение = ВыборкаДетальныеЗаписи.Показатель;
				ЭлементОтбора.Использование = Истина;
			КонецЕсли;	
			//Если ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Well") Тогда 
			//	ЭлементОтбора.ПравоеЗначение = ВыборкаДетальныеЗаписи.Well;
			//	ЭлементОтбора.Использование = Истина;
			//КонецЕсли;	
		КонецЦикла;
		
				
		
		
		СсылкаНаОтчет = ПолучитьНавигационнуюСсылку(Метаданные.Отчеты.witsml_LogAnalys,НастройкиКомпоновки,"Выявлено отклонение показателя");
		
		//ТекстОписанияСобытия = "<b>Выявлено отклонение показателя "+""""+"'<a href ="+""""+СсылкаНаОтчет+""""+">"+""""+ВыборкаДетальныеЗаписи.Показатель+""""+"</a>"+"</b>"+
		//"<br>Пороговые значения: min " + ВыборкаДетальныеЗаписи.МинимальноеЗначение + ", max " + ВыборкаДетальныеЗаписи.МаксимальноеЗначение+
		//"<br>Значение на индексе "+Формат(ВыборкаДетальныеЗаписи.Index,"ЧРД=.; ЧГ=")+": " +Формат(ВыборкаДетальныеЗаписи.Value,"ЧРД=.; ЧГ=");
		ТекстОписанияСобытия = "<a href ="+""""+СсылкаНаОтчет+""""+">"+"Выявлено отклонение показателя "+""""+ВыборкаДетальныеЗаписи.Показатель+""""+"</a>"+"</b>"+
		"<br>Пороговые значения: min " + ВыборкаДетальныеЗаписи.МинимальноеЗначение + ", max " + ВыборкаДетальныеЗаписи.МаксимальноеЗначение+
		"<br>Значение на индексе "+Формат(ВыборкаДетальныеЗаписи.Index,"ЧРД=.; ЧГ=")+": " +Формат(ВыборкаДетальныеЗаписи.Value,"ЧРД=.; ЧГ=");

		МЗ = РегистрыСведений.СобытияОбъектов.СоздатьМенеджерЗаписи();
		МЗ.Период = ТекущаяДатаСеанса();
		МЗ.Объект = ВыборкаДетальныеЗаписи.Объект;
		МЗ.ОписаниеСобытия = ТекстОписанияСобытия;
		МЗ.Показатель = ВыборкаДетальныеЗаписи.Показатель;
		МЗ.ТипИндекса = ВыборкаДетальныеЗаписи.ТипИндекса;
		МЗ.ЗначениеИндекса = ВыборкаДетальныеЗаписи.Index;
		МЗ.Значение = ВыборкаДетальныеЗаписи.Value;	
		МЗ.НавигационнаяСсылка = СсылкаНаОтчет;
		МЗ.Записать();
	КонецЦикла;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	
КонецПроцедуры