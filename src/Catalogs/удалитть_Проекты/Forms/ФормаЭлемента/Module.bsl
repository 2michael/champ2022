
&НаКлиенте
Процедура ЗаполнитьПоТипу(Команда)
	
	ЗаполнитьПоТипуНаСервере();
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоТипуНаСервере()

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТипыПроектовСоставТипа.ЭтапПроекта КАК ЭтапПроекта,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДоговорыУслугиДоговора.Ссылка) КАК КоличествоДоговоров,
		|	ВЫБОР
		|		КОГДА КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДоговорыУслугиДоговора.Ссылка) = 1
		|			ТОГДА ДоговорыУслугиДоговора1.Ссылка
		|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Договоры.ПустаяСсылка)
		|	КОНЕЦ КАК Договор,
		|	ВЫБОР
		|		КОГДА КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДоговорыУслугиДоговора.Ссылка) = 1
		|			ТОГДА ДоговорыУслугиДоговора1.Ссылка.Владелец
		|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
		|	КОНЕЦ КАК Контрагент,
		|	ТипыПроектовСоставТипа.ПлановаяДлительность КАК ПлановаяДлительность,
		|	ТипыПроектовСоставТипа.ИзмерениеДлительности КАК ИзмерениеДлительности,
		|	ТипыПроектовСоставТипа.РольОтветственного КАК РольОтветственного,
		|	ТипыПроектовСоставТипа.НомерСтроки КАК НомерСтроки
		|ПОМЕСТИТЬ ВременнаяТаблица
		|ИЗ
		|	Справочник.ТипыПроектов.СоставТипа КАК ТипыПроектовСоставТипа
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Договоры.УслугиДоговора КАК ДоговорыУслугиДоговора
		|		ПО ТипыПроектовСоставТипа.ЭтапПроекта = ДоговорыУслугиДоговора.Услуга
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Договоры.УслугиДоговора КАК ДоговорыУслугиДоговора1
		|		ПО ТипыПроектовСоставТипа.ЭтапПроекта = ДоговорыУслугиДоговора1.Услуга
		|ГДЕ
		|	ТипыПроектовСоставТипа.Ссылка = &ТипПроекта
		|
		|СГРУППИРОВАТЬ ПО
		|	ТипыПроектовСоставТипа.ЭтапПроекта,
		|	ДоговорыУслугиДоговора1.Ссылка,
		|	ТипыПроектовСоставТипа.ПлановаяДлительность,
		|	ТипыПроектовСоставТипа.ИзмерениеДлительности,
		|	ТипыПроектовСоставТипа.РольОтветственного,
		|	ТипыПроектовСоставТипа.НомерСтроки,
		|	ДоговорыУслугиДоговора1.Ссылка.Владелец
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблица.ЭтапПроекта КАК ЭтапПроекта,
		|	ВременнаяТаблица.Договор КАК Договор,
		|	ВременнаяТаблица.Контрагент КАК Контрагент,
		|	ВременнаяТаблица.ПлановаяДлительность КАК ПлановаяДлительность,
		|	ВременнаяТаблица.ИзмерениеДлительности КАК ИзмерениеДлительности,
		|	&ДатаДокумента КАК ДатаНачалаПлановая,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблица.ИзмерениеДлительности = ЗНАЧЕНИЕ(Справочник.ЕдиницыИзмерения.ДЕНЬ)
		|			ТОГДА ДОБАВИТЬКДАТЕ(&ДатаДокумента, ДЕНЬ, ВременнаяТаблица.ПлановаяДлительность)
		|		КОГДА ВременнаяТаблица.ИзмерениеДлительности = ЗНАЧЕНИЕ(Справочник.ЕдиницыИзмерения.Час)
		|			ТОГДА ДОБАВИТЬКДАТЕ(&ДатаДокумента, ЧАС, ВременнаяТаблица.ПлановаяДлительность)
		|		КОГДА ВременнаяТаблица.ИзмерениеДлительности = ЗНАЧЕНИЕ(Справочник.ЕдиницыИзмерения.Месяц)
		|			ТОГДА ДОБАВИТЬКДАТЕ(&ДатаДокумента, МЕСЯЦ, ВременнаяТаблица.ПлановаяДлительность)
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ КАК ДатаОкончанияПлановая,
		|	ОтветственныеКонтрагентовСрезПоследних.ОтветственныйИсполнитель КАК ОтветственныйИсполнитель,
		|	ВременнаяТаблица.НомерСтроки КАК НомерСтроки
		|ИЗ
		|	ВременнаяТаблица КАК ВременнаяТаблица
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОтветственныеСотрудникиКонтрагентов.СрезПоследних(&ДатаДокумента, ) КАК ОтветственныеКонтрагентовСрезПоследних
		|		ПО ВременнаяТаблица.Контрагент = ОтветственныеКонтрагентовСрезПоследних.Контрагент
		|			И ВременнаяТаблица.РольОтветственного = ОтветственныеКонтрагентовСрезПоследних.Роль
		|			И ВременнаяТаблица.ЭтапПроекта = ОтветственныеКонтрагентовСрезПоследних.ЭтапПроекта
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблица.ЭтапПроекта,
		|	ВременнаяТаблица.Договор,
		|	ВременнаяТаблица.Контрагент,
		|	ВременнаяТаблица.ПлановаяДлительность,
		|	ВременнаяТаблица.ИзмерениеДлительности,
		|	ОтветственныеКонтрагентовСрезПоследних.ОтветственныйИсполнитель,
		|	ВременнаяТаблица.НомерСтроки
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВременнаяТаблица.НомерСтроки";
	
	Запрос.УстановитьПараметр("ТипПроекта",    Объект.ТипПроекта);
	Запрос.УстановитьПараметр("ДатаДокумента", Объект.Дата);
	
	Объект.СоставПроекта.Загрузить(Запрос.Выполнить().Выгрузить());
	Объект.ЗависимостиЭтапов.Загрузить(Объект.ТипПроекта.ЗависимостиЭтапов.Выгрузить());
	ПроставитьЗависимостиЭтапов();
	РассчитатьСрокиЭтапов();
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьСрокиЭтапов()
	
	Для Каждого СтрокаСоставаПроекта Из Объект.СоставПроекта Цикл
		РассчитатьСрокиЭтаповПоСтроке(СтрокаСоставаПроекта);	
	КонецЦикла;
	
КонецПроцедуры	

&НаСервере
Процедура РассчитатьСрокиЭтаповПоСтроке(СтрокаСоставаПроекта)
	
	Длительность_Час  = 60*60;
	Длительность_День = Длительность_Час * 24;
	
	Если СтрокаСоставаПроекта.ЭтапыПредшественники.Количество() Тогда
		
		КрайняяДатаЭтапа = Дата('00010101000000');
		 
		Для Каждого ЭтапПредшественник Из СтрокаСоставаПроекта.ЭтапыПредшественники Цикл 
			МассивНайденныхСтрок = Объект.СоставПроекта.НайтиСтроки(Новый Структура("ЭтапПроекта",ЭтапПредшественник.Значение));
			Для Каждого НайденнаяСтрокаМассива Из МассивНайденныхСтрок Цикл 
				Если НайденнаяСтрокаМассива.ЭтапыПредшественники.Количество() Тогда 
					РассчитатьСрокиЭтаповПоСтроке(НайденнаяСтрокаМассива);
				КонецЕсли;	
				КрайняяДатаЭтапа = Макс(КрайняяДатаЭтапа,НайденнаяСтрокаМассива.ДатаОкончанияПлановая);
			КонецЦикла;	
		КонецЦикла;
		
		СтрокаСоставаПроекта.ДатаНачалаПлановая = КрайняяДатаЭтапа + 1;
		
		Если СтрокаСоставаПроекта.ИзмерениеДлительности = Справочники.ЕдиницыИзмерения.День Тогда 				
			СтрокаСоставаПроекта.ДатаОкончанияПлановая = КрайняяДатаЭтапа + Длительность_День * СтрокаСоставаПроекта.ПлановаяДлительность;
		ИначеЕсли СтрокаСоставаПроекта.ИзмерениеДлительности = Справочники.ЕдиницыИзмерения.Месяц Тогда 				
			СтрокаСоставаПроекта.ДатаОкончанияПлановая = КрайняяДатаЭтапа + ДобавитьМесяц(КрайняяДатаЭтапа,СтрокаСоставаПроекта.ПлановаяДлительность);	
		ИначеЕсли СтрокаСоставаПроекта.ИзмерениеДлительности = Справочники.ЕдиницыИзмерения.Час Тогда 				
			СтрокаСоставаПроекта.ДатаОкончанияПлановая = КрайняяДатаЭтапа + Длительность_Час * СтрокаСоставаПроекта.ПлановаяДлительность;	
		КонецЕсли;
		
	Иначе //Если НЕ ЗначениеЗаполнено(СтрокаСоставаПроекта.ДатаОкончанияПлановая) Тогда
		
		СтрокаСоставаПроекта.ДатаНачалаПлановая = Объект.Дата;
		
		Если СтрокаСоставаПроекта.ИзмерениеДлительности = Справочники.ЕдиницыИзмерения.День Тогда 				
			СтрокаСоставаПроекта.ДатаОкончанияПлановая = Объект.Дата + Длительность_День * СтрокаСоставаПроекта.ПлановаяДлительность;
		ИначеЕсли СтрокаСоставаПроекта.ИзмерениеДлительности = Справочники.ЕдиницыИзмерения.Месяц Тогда 				
			СтрокаСоставаПроекта.ДатаОкончанияПлановая = Объект.Дата + ДобавитьМесяц(КрайняяДатаЭтапа,СтрокаСоставаПроекта.ПлановаяДлительность);	
		ИначеЕсли СтрокаСоставаПроекта.ИзмерениеДлительности = Справочники.ЕдиницыИзмерения.Час Тогда 				
			СтрокаСоставаПроекта.ДатаОкончанияПлановая = Объект.Дата + Длительность_Час * СтрокаСоставаПроекта.ПлановаяДлительность;	
		КонецЕсли;
		
	КонецЕсли;
	
	Если СтрокаСоставаПроекта.ИзмерениеДлительности = Справочники.ЕдиницыИзмерения.День ИЛИ
		 СтрокаСоставаПроекта.ИзмерениеДлительности = Справочники.ЕдиницыИзмерения.Месяц Тогда
		 
		СтрокаСоставаПроекта.ДатаНачалаПлановая    = НачалоДня(СтрокаСоставаПроекта.ДатаНачалаПлановая);
		
		Если СтрокаСоставаПроекта.ДатаОкончанияПлановая = НачалоДня(СтрокаСоставаПроекта.ДатаОкончанияПлановая) Тогда
			СтрокаСоставаПроекта.ДатаОкончанияПлановая = СтрокаСоставаПроекта.ДатаОкончанияПлановая - 1;
		КонецЕсли;
		
		СтрокаСоставаПроекта.ДатаОкончанияПлановая = КонецДня(СтрокаСоставаПроекта.ДатаОкончанияПлановая);
		
	КонецЕсли;	
	
КонецПроцедуры  // РассчитатьСрокиЭтаповПоСтроке(СтрокаСоставаПроекта)	

&НаСервере
Процедура ПроставитьЗависимостиЭтапов()
	
	Для каждого СтрокаСоставаТипов Из Объект.СоставПроекта Цикл
	   СтрокаСоставаТипов.ЭтапыПредшественники.Очистить();	
	КонецЦикла;
	
	Для каждого СтрокаЗависимостейЭтапов Из Объект.ЗависимостиЭтапов Цикл
		
		СтрокиЗависимыхЭтаповВСоставе = Объект.СоставПроекта.НайтиСтроки(Новый Структура("ЭтапПроекта",СтрокаЗависимостейЭтапов.ЗависимыйЭтап));
		
		Для каждого НайденнаяСтрокаСостава Из СтрокиЗависимыхЭтаповВСоставе Цикл

			НайденнаяСтрокаСостава.ЭтапыПредшественники.Добавить(СтрокаЗависимостейЭтапов.Этап);
		
		КонецЦикла;
	
	КонецЦикла;

КонецПроцедуры	

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда 
		Объект.Дата = ТекущаяДатаСеанса();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ТипПроектаПриИзмененииНаСервере()
	
	Если Не ЗначениеЗаполнено(Объект.Наименование) Тогда 
		Объект.Наименование = Объект.ТипПроекта.Наименование+" от "+Объект.Дата;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипПроектаПриИзменении(Элемент)
	ТипПроектаПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура СоставПроектаКонтрагентПриИзмененииНаСервере()
	
	ТекущаяСтрокаСоставПроекта = Элементы.СоставПроекта.ТекущаяСтрока;
	ЗначениеТекущихДанных = Объект.СоставПроекта.НайтиПоИдентификатору(ТекущаяСтрокаСоставПроекта);
	
	Если Не ЗначениеТекущихДанных = Неопределено Тогда 
		СрезОтветственных = РегистрыСведений.ОтветственныеПоКонтрагентам.ПолучитьПоследнее(Объект.Дата,Новый Структура("Контрагент",ЗначениеТекущихДанных.Контрагент));
		ЗначениеТекущихДанных.ОтветственныйИсполнитель = СрезОтветственных.ОтветственныйСотрудник;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоставПроектаКонтрагентПриИзменении(Элемент)
	
	СоставПроектаКонтрагентПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПроставитьЗависимостиЭтапов();
	
КонецПроцедуры

&НаКлиенте
Процедура СоставПроектаЭтапыПредшественникиПриИзменении(Элемент)
	
	ТекущаяСтрокаСостава = Элементы.СоставПроекта.ТекущиеДанные;
	МассивЗначенийКУдалению = Новый Массив;
	
	Для Каждого ЭлементСпискаЭтаповПредшественников Из ТекущаяСтрокаСостава.ЭтапыПредшественники Цикл 
		
		МассивНайденныхСтрок = Объект.ЗависимостиЭтапов.НайтиСтроки(Новый Структура("Этап,ЗависимыйЭтап",ТекущаяСтрокаСостава.ЭтапПроекта,ЭлементСпискаЭтаповПредшественников.Значение));
		
		Если МассивНайденныхСтрок.Количество() Тогда 
			МассивЗначенийКУдалению.Добавить(ЭлементСпискаЭтаповПредшественников);
			Сообщить("Зацикливание этапов! Необходимо выбрать другой этап");
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого ЭлементМассиваКУдалению Из МассивЗначенийКУдалению Цикл 
		 ТекущаяСтрокаСостава.ЭтапыПредшественники.Удалить(ЭлементМассиваКУдалению);
	КонецЦикла;	
	
	ПроставитьЗависимостиЭтаповИзСоставаПроекта();
	
	РассчитатьСрокиЭтапов();	
	
КонецПроцедуры

&НаСервере
Процедура ПроставитьЗависимостиЭтаповИзСоставаПроекта()
	
	Объект.ЗависимостиЭтапов.Очистить();
	
	Для каждого СтрокаСоставаТипов Из Объект.СоставПроекта Цикл
		Если СтрокаСоставаТипов.ЭтапыПредшественники.Количество() Тогда 	
			Для Каждого ЭтапПредшественник Из СтрокаСоставаТипов.ЭтапыПредшественники Цикл 
			    НоваяСтрокаЗависимостей = Объект.ЗависимостиЭтапов.Добавить();
			    НоваяСтрокаЗависимостей.Этап = ЭтапПредшественник.Значение;
			    НоваяСтрокаЗависимостей.ЗависимыйЭтап = СтрокаСоставаТипов.ЭтапПроекта;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры	

&НаСервере
Процедура СоздатьБизнесПроцессНаСервере()
	
	СоставнойБизнесПроцесс = БизнесПроцессы.СоставнойБизнесПроцесс.СоздатьБизнесПроцесс();
	СоставнойБизнесПроцесс.Дата                  = ТекущаяДата();
	СоставнойБизнесПроцесс.Наименование          = Объект.Наименование;
	СоставнойБизнесПроцесс.ОбъектБизнесСобытие   = Объект.Ссылка;
	СоставнойБизнесПроцесс.Автор                 = ПараметрыСеанса.ТекущийПользователь;
	СоставнойБизнесПроцесс.ДатаНачалаПлановая    = Объект.ДатаНачалаПлановая;
	СоставнойБизнесПроцесс.ДатаОкончанияПлановая = Объект.ДатаОкончанияПлановая;
	
	Для Каждого ЭтапПроекта Из Объект.СоставПроекта Цикл
		
		ОбъектБизнесПроцесс = БизнесПроцессы.БизнесПроцесс.СоздатьБизнесПроцесс();
		ОбъектБизнесПроцесс.Дата                  = ТекущаяДата();
		ОбъектБизнесПроцесс.Наименование          = ЭтапПроекта.ЭтапПроекта.Наименование;
		ОбъектБизнесПроцесс.ОбъектБизнесСобытие   = ЭтапПроекта.ЭтапПроекта;
		ОбъектБизнесПроцесс.Автор                 = ПараметрыСеанса.ТекущийПользователь;
		ОбъектБизнесПроцесс.ДатаНачалаПлановая    = ЭтапПроекта.ДатаНачалаПлановая;
		ОбъектБизнесПроцесс.ДатаОкончанияПлановая = ЭтапПроекта.ДатаОкончанияПлановая;
		ОбъектБизнесПроцесс.Записать();
		
		НоваяСтрока = СоставнойБизнесПроцесс.Этапы.Добавить();
		НоваяСтрока.БизнесПроцесс = ОбъектБизнесПроцесс.Ссылка;
		
	КонецЦикла;  // Для Каждого ЭтапПроекта Из Объект.СоставПроекта Цикл
	
	СоставнойБизнесПроцесс.Записать();
	
КонецПроцедуры  // СоздатьБизнесПроцессНаСервере()

&НаКлиенте
Процедура СоздатьБизнесПроцесс(Команда)
	СоздатьБизнесПроцессНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СоставПроектаДатаОкончанияПлановаяПриИзменении(Элемент)
	
	Длительность_Час  = 60*60;
	Длительность_День = Длительность_Час * 24;
	
	ТекущиеДанные = Элементы.СоставПроекта.ТекущиеДанные;
	
	ТекущиеДанные.ПлановаяДлительность = (ТекущиеДанные.ДатаОкончанияПлановая - ТекущиеДанные.ДатаНачалаПлановая + 1) / Длительность_День;  
	
	РассчитатьСрокиЭтапов();
	
КонецПроцедуры

