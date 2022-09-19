Процедура Обработать_obj_logs(XDTO_obj_logs, obj_logs_GUID) Экспорт
	
	fileCreationDate = XDTO_obj_logs.documentInfo.fileCreationInformation.fileCreationDate; 
	
	XDTO_obj_log = XDTO_obj_logs.Log;
	
	Если ТипЗнч(XDTO_obj_log) = Тип("СписокXDTO") Тогда
		Для Каждого ЭлементXDTO ИЗ XDTO_obj_log Цикл
			Обработать_obj_log(ЭлементXDTO)
		КонецЦикла;
	Иначе
		Обработать_obj_log(ЭлементXDTO)
	КонецЕсли;
		
	//Установка отметки об обработке пакета xml
	НаборЗаписей = РегистрыСведений.witsml_obj_logs_xml.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.GUID.Установить(obj_logs_GUID);
	НаборЗаписей.Прочитать();
	
	Для Каждого ЗаписьНабора Из НаборЗаписей Цикл
		ЗаписьНабора.Обработан        = Истина;
		ЗаписьНабора.fileCreationDate = fileCreationDate;
	КонецЦикла;  // Для Каждого ЗаписьНабора Из НаборЗаписей Цикл
	
	Если НаборЗаписей.Модифицированность() Тогда
		НаборЗаписей.Записать();
	КонецЕсли;
	
КонецПроцедуры  // Обработать_obj_logs(XDTO_obj_logs, obj_logs_GUID) Экспорт

Процедура Обработать_obj_log(XDTO_obj_log)

	s_Well        = СокрЛП(XDTO_obj_log.nameWell);
	s_Wellbore    = СокрЛП(XDTO_obj_log.nameWellbore);
	s_indexType   = СтрЗаменить(XDTO_obj_log.indexType, " ", "");
	n_indexColumn = Число(XDTO_obj_log.indexCurve.columnIndex);
	s_LogName     = СокрЛП(XDTO_obj_log.name);
	
	Well     = Справочники.witsml_Wells.НайтиПоНаименованию(s_Well);
	Если НЕ ЗначениеЗаполнено(Well) Тогда
		Сообщить("Не найдено значение справочника witsml_Wells: "+s_Well);
	КонецЕсли;
	
	Wellbore = Справочники.witsml_Wellbores.НайтиПоНаименованию(s_Wellbore);
	Если НЕ ЗначениеЗаполнено(Wellbore) Тогда
		Сообщить("Не найдено значение справочника witsml_Wellbores: "+s_Wellbore);
	КонецЕсли;
	
	IndexType = Перечисления.witsml_LogIndexType[s_indexType];
	Если НЕ ЗначениеЗаполнено(IndexType) Тогда
		Сообщить("Не найдено значение Перечисления witsml_LogIndexType: "+s_indexType);
	КонецЕсли;

	IndexClass = Справочники.witsml_RealtimeData.ПустаяСсылка();
	
	Набор_RealtimeData = Новый Соответствие;
	
	Для Каждого Элемент_logCurveInfo Из XDTO_obj_log.logCurveInfo Цикл
		
		s_classWitsml = СокрЛП(Элемент_logCurveInfo.classWitsml);
		RealtimeData  = Справочники.witsml_RealtimeData.НайтиПоНаименованию(s_classWitsml);
		Если НЕ ЗначениеЗаполнено(RealtimeData) Тогда
			Сообщить("Не найдено значение справочника witsml_RealtimeData: "+s_classWitsml);
		КонецЕсли;
		
		columnIndex   = Элемент_logCurveInfo.columnIndex;
		
		Набор_RealtimeData.Вставить(RealtimeData, columnIndex);
		
		Если n_indexColumn = columnIndex Тогда
			IndexClass = RealtimeData;
		КонецЕсли;		
		
	КонецЦикла;  // Для Каждого Элемент_logCurveInfo Из XDTO_obj_log.logCurveInfo Цикл
	
	Для Каждого Элемент_logData Из XDTO_obj_log.logData.Data Цикл
		
		Массив_logData = СтрРазделить(Элемент_logData, ",");
		
		Index = Массив_logData[n_indexColumn - 1];
		
		Для Каждого Элемент_RealtimeData Из Набор_RealtimeData Цикл
			
			ЗаписьНабора = РегистрыСведений.witsml_obj_log_logData.СоздатьМенеджерЗаписи();
			ЗаписьНабора.Well         = Well; 
			ЗаписьНабора.Wellbore     = Wellbore; 
			ЗаписьНабора.IndexClass   = IndexClass; 
			ЗаписьНабора.Index        = Index; 
			ЗаписьНабора.RealtimeData = Элемент_RealtimeData.Ключ;
			ЗаписьНабора.Value        = Массив_logData[Элемент_RealtimeData.Значение-1];
			ЗаписьНабора.LogName      = s_LogName;
			ЗаписьНабора.IndexType    = IndexType;
			ЗаписьНабора.Записать();
			
		КонецЦикла;  // Для Каждого Элемент_RealtimeData Из Набор_RealtimeData Цикл
		
	КонецЦикла;  // Для Каждого Элемент_logData Из XDTO_obj_log.logData.Data Цикл
	
КонецПроцедуры  // Обработать_obj_log(XDTO_obj_log)