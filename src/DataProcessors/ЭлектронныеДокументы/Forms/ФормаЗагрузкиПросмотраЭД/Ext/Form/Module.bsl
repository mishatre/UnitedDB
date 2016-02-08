﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервереБезКонтекста
Функция СоздатьОбъектыИБ(АдресВременногоХранилища, ОшибкаЗаписи)
	
	Перем ДеревоРазбора;
	
	СтруктураРазбора = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	
	Если СтруктураРазбора <> Неопределено И СтруктураРазбора.Свойство("ДеревоРазбора", ДеревоРазбора) Тогда
		// Заполним ссылки на объекты из дерева соответствий, если ссылок нет,
		// тогда будем создавать объекты
		ЭлектронныеДокументыВнутренний.ЗаполнитьСсылкиНаОбъектыВДереве(ДеревоРазбора, ОшибкаЗаписи);
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция СохранитьДанныеОбъектаВБД(АдресВременногоХранилища)
	
	СтруктураРазбора = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	
	Если СтруктураРазбора <> Неопределено И СтруктураРазбора.Свойство("ДеревоРазбора") Тогда
		ЭлектронныеДокументыПереопределяемый.СохранитьДанныеОбъектаВБД(
										СтруктураРазбора.СтрокаОбъекта,
										СтруктураРазбора.ДеревоРазбора);
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция СопоставитьНоменклатуру(ДанныеФормы = Неопределено)
	
	ЗначениеВозврата = Неопределено;
	СтруктураЭД = Новый Структура;
	СтруктураЭД.Вставить("ВидЭД", ВидЭД);
	СтруктураЭД.Вставить("СпособОбменаЭД", ПредопределенноеЗначение("Перечисление.СпособыОбменаЭД.БыстрыйОбмен"));
	СтруктураЭД.Вставить("ДанныеФайлаРазбора", ДанныеФайлаРазбора);
	СтруктураЭД.Вставить("Контрагент", Контрагент);
	СтруктураЭД.Вставить("НаправлениеЭД", ПредопределенноеЗначение("Перечисление.НаправленияЭД.Входящий"));
	СтруктураЭД.Вставить("ВладелецФайла", ?( СпособЗагрузкиДокумента = 0, Неопределено,ДокументИБ));

	СтруктураПараметров = ЭлектронныеДокументыСлужебныйВызовСервера.ПолучитьПараметрыФормыСопоставленияНоменклатуры(СтруктураЭД);
	Если ЗначениеЗаполнено(СтруктураПараметров) Тогда
		ЗначениеВозврата = ОткрытьФормуМодально(СтруктураПараметров.ИмяФормы, СтруктураПараметров.ПараметрыОткрытияФормы);
	КонецЕсли;
	
	Возврат ЗначениеВозврата;
	
КонецФункции

&НаКлиенте
Процедура ИзменитьВидимостьДоступность()
	
	Если Врег(ВидЭД) = ВРег("РеквизитыОрганизации") Тогда
		
		Элементы.ЭлементСправочникаИБ.Доступность = (СпособЗагрузкиДокумента = 1);
		
	Иначе	
		Если ЗагрузкаЭД Тогда
			Элементы.ДокументИБ.Доступность = (СпособЗагрузкиДокумента = 1);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьВидимостьДоступностьПриСозданииНаСервере()
	
	Элементы.ГруппаСодержимоеДокумента.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	
	Если ЗагрузкаЭД Тогда
		
		Элементы.ГруппаКнопок.Видимость = Истина;
		Элементы.ГруппаГиперссылка.Видимость = Ложь;

		Если ВРег(ВидЭД) = ВРег("РеквизитыОрганизации") Тогда
			
			Заголовок = Нстр("ru = 'Загрузка данных из файла'");
			
			Элементы.ГруппаНастроекСправочники.Видимость = Истина;
			Элементы.ГруппаНастроекДокументы.Видимость = Ложь;
		Иначе
			
			Заголовок = Нстр("ru = 'Загрузка документа из файла'");
			
			Элементы.ГруппаНастроекСправочники.Видимость = Ложь;
			Элементы.ГруппаНастроекДокументы.Видимость = Истина;
		КонецЕсли;
		
	Иначе
		Текст = Нстр("ru = 'Электронный документ'");
		Заголовок = Текст;
		Элементы.ГруппаНастроекСправочники.Видимость = Ложь;
		Элементы.ГруппаНастроекДокументы.Видимость = Ложь;
		Элементы.ГруппаКнопок.Видимость = Ложь;
		Элементы.ГруппаГиперссылка.Видимость = Истина;
	КонецЕсли;
	
	Если ВидЭД = Перечисления.ВидыЭД.КаталогТоваров Тогда
		Элементы.Загрузка.Видимость = Ложь;
		Элементы.ТипОбъекта.Заголовок = Нстр("ru = 'Загрузить'");
		ТипОбъекта = "Каталог товаров";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьПросмотрЭДСервер(СтруктураЭД, Отказ)
	
	Перем ПерезаполняемыйДокумент, ДеревоРазбора, СтрокаОбъекта;
	
	ФайлПросмотра = Неопределено;
	ИмяФайлаКартинок = Неопределено;
	ФайлДопДанных = Неопределено;
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(СтруктураЭД.АдресХранилища);
	
	Если СтруктураЭД.ФайлАрхива Тогда
		
		ПапкаДляРаспаковки = ЭлектронныеДокументыСлужебный.РабочийКаталог("ext", СтруктураЭД.УникальныйИдентификатор);
		ИмяФайлаАрхива = ЭлектронныеДокументыСлужебный.ТекущееИмяВременногоФайла("zip");
		ДвоичныеДанные.Записать(ИмяФайлаАрхива);
		
		УдалитьФайлы(ПапкаДляРаспаковки, "*");
		
		ЧтениеЗИП = Новый ЧтениеZIPФайла(ИмяФайлаАрхива);
		Попытка
			ЧтениеЗИП.ИзвлечьВсе(ПапкаДляРаспаковки);
		Исключение
			ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			Если НЕ ЭлектронныеДокументыСлужебный.ВозможноИзвлечьФайлы(ЧтениеЗИП, ПапкаДляРаспаковки) Тогда
				ТекстСообщения = ЭлектронныеДокументыПовтИсп.ПолучитьСообщениеОбОшибке("006");
			КонецЕсли;
			ЭлектронныеДокументыСлужебныйВызовСервера.ОбработатьИсключениеПоЭДНаСервере(НСтр("ru = 'Распаковка архива ЭД'"),
			ТекстОшибки, ТекстСообщения);
			
			УдалитьФайлы(ИмяФайлаАрхива);
			УдалитьФайлы(ПапкаДляРаспаковки);
			Возврат;
		КонецПопытки;
		
		УдалитьФайлы(ИмяФайлаАрхива);
		// скопируем файл просмотра
		МассивФайловПросмотра = НайтиФайлы(ПапкаДляРаспаковки, "*.pdf", Истина);
		Если МассивФайловПросмотра.Количество() > 0 Тогда
			ФайлПросмотра = МассивФайловПросмотра[0];
		КонецЕсли;
		
		// Расшифровать файл с данными
		МассивФайлИнформации = НайтиФайлы(ПапкаДляРаспаковки, "meta*.xml", Истина);
		Если МассивФайлИнформации.Количество() > 0 Тогда
			ФайлИнформации = МассивФайлИнформации[0];
		КонецЕсли;
		
		МассивФайлКарточки = НайтиФайлы(ПапкаДляРаспаковки, "card*.xml", Истина);
		Если МассивФайлКарточки.Количество() > 0 Тогда
			ФайлКарточки = МассивФайлКарточки[0];
		КонецЕсли;
		
		// скопируем файл просмотра
		МассивФайловКартинок = НайтиФайлы(ПапкаДляРаспаковки, "*.zip", Истина);
		Если МассивФайловКартинок.Количество() > 0 Тогда
			ФайлКартинок = МассивФайловКартинок[0];
			ИмяФайлаКартинок = ФайлКартинок.ПолноеИмя;
		КонецЕсли;
		
		Если ФайлКарточки = Неопределено Или ФайлИнформации = Неопределено Тогда
			
			ШаблонСообщения = НСтр("ru = 'Возникла ошибка при чтении данных из файла ""%1№"" (подробности см. в Журнале регистрации).'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, СтруктураЭД.ИмяФайла);
			
			ШаблонСообщения = НСтр("ru = 'Файл ""%1"" не содержит электронных документов.'");
			ПредставлениеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, СтруктураЭД.ИмяФайла);
			ЭлектронныеДокументыСлужебныйВызовСервера.ОбработатьИсключениеПоЭДНаСервере(НСтр("ru = 'Чтение ЭД.'"),
			ПредставлениеОшибки,
			ТекстСообщения);
			УдалитьФайлы(ПапкаДляРаспаковки);
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		СоответствиеФайлПараметры = ЭлектронныеДокументыВнутренний.ПолучитьСоответствиеФайлПараметры(ФайлИнформации, ФайлКарточки);
		
		Для Каждого ЭлементСоответствия Из СоответствиеФайлПараметры Цикл
			
			МассивФайловИсточник = НайтиФайлы(ПапкаДляРаспаковки, ЭлементСоответствия.Ключ, Истина);
			Если МассивФайловИсточник.Количество() > 0 Тогда
				
				ИмяФайла = ЭлектронныеДокументыСлужебный.ТекущееИмяВременногоФайла("xml");
				КопироватьФайл(МассивФайловИсточник[0].ПолноеИмя, ИмяФайла);
				
			КонецЕсли;
			
			ДопДанные = Неопределено;
			Если ЭлементСоответствия.Значение.Свойство("ДопДанные", ДопДанные) И ТипЗнч(ДопДанные) = Тип("Структура") Тогда
				
				ИмяФайлаДопДанных = Неопределено;
				Если ДопДанные.Свойство("ФайлДопДанных",ИмяФайлаДопДанных) И ЗначениеЗаполнено(ИмяФайлаДопДанных) Тогда
					
					МассивФайловДопДанных = НайтиФайлы(ПапкаДляРаспаковки, ИмяФайлаДопДанных, Истина);
					Если МассивФайловДопДанных.Количество() > 0 Тогда
						
						ФайлДопДанных = ЭлектронныеДокументыСлужебный.ТекущееИмяВременногоФайла("xml");
						КопироватьФайл(МассивФайловДопДанных[0].ПолноеИмя, ФайлДопДанных);
						
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе
		ИмяФайла = ЭлектронныеДокументыСлужебный.ТекущееИмяВременногоФайла("xml");
		ДвоичныеДанные.Записать(ИмяФайла);
	КонецЕсли;
	
	СтруктураЭД.Свойство("СсылкаНаДокумент", ПерезаполняемыйДокумент);
	
	СтруктураРазбора = ЭлектронныеДокументыВнутренний.СформироватьДеревоРазбора(ИмяФайла,
																				Перечисления.НаправленияЭД.Входящий,
																				ФайлДопДанных,
																				ИмяФайлаКартинок);
	ДвоичныеДанныеФайлаРазбора = Новый ДвоичныеДанные(ИмяФайла);
	ДанныеФайлаРазбора = ПоместитьВоВременноеХранилище(ДвоичныеДанныеФайлаРазбора, УникальныйИдентификатор);
	
	ДанныеЭД = Неопределено;
	
	Если ТипЗнч(СтруктураРазбора) = Тип("Структура") Тогда
		
		АдресСтруктурыРазбораЭД = ПоместитьВоВременноеХранилище(СтруктураРазбора, УникальныйИдентификатор);
		ДанныеЭД = ЭлектронныеДокументыВнутренний.ПечатнаяФормаЭД(
			СтруктураРазбора, СтруктураЭД.НаправлениеЭД, СтруктураЭД.УникальныйИдентификатор, , ВидЭД);
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЭД) = Тип("ТабличныйДокумент") Тогда
		
		Если ЗагрузкаЭД Тогда
			Если (НЕ ЗначениеЗаполнено(ДокументИБ) ИЛИ СпособЗагрузкиДокумента = 0) И СтруктураРазбора <> Неопределено
					И СтруктураРазбора.Свойство("ДеревоРазбора", ДеревоРазбора)
					И СтруктураРазбора.Свойство("СтрокаОбъекта", СтрокаОбъекта) Тогда
				ОшибкаЗаписи = Ложь;
				СтрокаДерева = НайтиСтрокуВДереве(ДеревоРазбора, СтрокаОбъекта, "Контрагент");
				Если СтрокаДерева <> Неопределено Тогда
					Контрагент = СтрокаДерева.СсылкаНаОбъект;
				КонецЕсли;
			КонецЕсли;
			ЭлектронныеДокументыПереопределяемый.СписокТиповДокументовПоВидуЭД(ВидЭД, СписокТипов);
			Для Каждого ТекЗначение Из СписокТипов Цикл
				ТекЭлемент = Элементы.ТипОбъекта.СписокВыбора.Добавить();
				ТекЭлемент.Значение = ТекЗначение.Представление;
				
				// Если реквизит ДокументИБ еще не заполнен и зачитано первое по списку значение, то заполним имеющимися данными:
				Если НЕ ЗначениеЗаполнено(ДокументИБ) И СписокТипов.Индекс(ТекЗначение) = 0 Тогда
					ТипОбъекта = ТекЗначение.Представление;
					ДокументИБ = ТекЗначение.Значение;
					ИмяОбъектаМетаданных = ТекЗначение.Значение.Метаданные().ПолноеИмя();
				КонецЕсли;
				
				Если ВРег(ВидЭД) = ВРег("РеквизитыОрганизации") Тогда
					Если ЗначениеЗаполнено(Контрагент) Тогда
						ДокументИБ = Контрагент;
						СпособЗагрузкиДокумента = 1;
					КонецЕсли;
				КонецЕсли;
				
				// Если в структуре параметров есть ссылка на (перезаполняемый) документ ИБ и его тип совпал с типом одного из значений
				// списка типов, то заполним этими данными соответствующие реквизиты формы.
				// Данное условие необходимо для корректной обработки ситуации, когда в качестве перезаполняемого документа, выбран
				// документ с типом не совпадающим ни с одним из доступных в списке или не совпадает с типом первого элемента списка.
				Если ЗначениеЗаполнено(ПерезаполняемыйДокумент) И ТипЗнч(ПерезаполняемыйДокумент) = ТипЗнч(ТекЗначение.Значение) Тогда
					ТипОбъекта = ТекЗначение.Представление;
					ДокументИБ = ПерезаполняемыйДокумент;
					ИмяОбъектаМетаданных = ТекЗначение.Значение.Метаданные().ПолноеИмя();
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Контрагент) И ЗначениеЗаполнено(ПерезаполняемыйДокумент) Тогда
			
			ИмяСправочникаКонтрагенты = ИмяСправочника("Контрагенты");
			
			Если Не ЗначениеЗаполнено(ИмяСправочникаКонтрагенты) Тогда
				ИмяСправочникаКонтрагенты = "Контрагенты";
			КонецЕсли;
			
			Если ТипЗнч(ПерезаполняемыйДокумент) = Тип("СправочникСсылка."+ ИмяСправочникаКонтрагенты) Тогда
				Контрагент = ПерезаполняемыйДокумент;
			Иначе
				Если ПерезаполняемыйДокумент.Метаданные().Реквизиты.Найти("Контрагент") = Истина Тогда
					Контрагент = ПерезаполняемыйДокумент.Контрагент;
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
		ТабличныйДокументФормы = ДанныеЭД;
		Элементы.ГруппаСодержимоеДокумента.ТекущаяСтраница = Элементы.СтраницаТабличныйДокумент;
		
	Иначе
		
		Если Не ФайлПросмотра = Неопределено Тогда
			
			
			ПутьКФайлу = ФайлПросмотра.ПолноеИмя;
			РасширениеФайла = СтрЗаменить(ФайлПросмотра.Расширение, ".", "");
			
			ДДФайла = Новый ДвоичныеДанные(ПутьКФайлу);
			
			// Передадим на клиента двоичные данные файла для просмотра:
			АдресСтруктурыРазбораЭД = ПоместитьВоВременноеХранилище(ДДФайла, УникальныйИдентификатор);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПапкаДляРаспаковки) Тогда
		УдалитьФайлы(ПапкаДляРаспаковки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ИмяСправочника(ИмяСправочника)
	
	ИмяСправочника = ЭлектронныеДокументыПовтИсп.ПолучитьИмяПрикладногоСправочника(ИмяСправочника);
	
	Возврат ИмяСправочника;
	
КонецФункции

&НаСервере
Функция НайтиСтрокуВДереве(ДеревоРазбора, СтрокаОбъекта, ИмяОбъектаПоиска)
	
	ВозвращаемоеЗначение = Неопределено;
	
	СтруктураПоиска = Новый Структура("Реквизит", ИмяОбъектаПоиска);
	МассивСтрок = СтрокаОбъекта.Строки.НайтиСтроки(СтруктураПоиска);
	Если МассивСтрок.Количество() > 0 Тогда
		ИндексСтрокиКонтрагента = МассивСтрок[0].ЗначениеРеквизита;
		СтруктураПоиска = Новый Структура("ИндексСтроки", ИндексСтрокиКонтрагента);
		МассивСтрок = ДеревоРазбора.Строки.НайтиСтроки(СтруктураПоиска, Истина);
		Если МассивСтрок.Количество() > 0 Тогда
			СтрокаДерева = МассивСтрок[0];
			ВозвращаемоеЗначение = СтрокаДерева;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

&НаСервере
Функция СформироватьДокументИБ(ДанныеФормы, ТекстСообщения, Записывать = Ложь, ОбновитьСтруктуруРазбора = Ложь)
	
	Перем СтрокаОбъекта, ДеревоРазбора;
	
	ДокументИБСформирован = Ложь;
	
	Если Не ОбновитьСтруктуруРазбора
		И ЗначениеЗаполнено(АдресСтруктурыРазбораЭД)
		И ЭтоАдресВременногоХранилища(АдресСтруктурыРазбораЭД) Тогда
		
		СтруктураРазбора = ПолучитьИзВременногоХранилища(АдресСтруктурыРазбораЭД);
		
	Иначе
		
		ИмяФайла = ПолучитьИмяВременногоФайла("xml");
		ДвоичныеДанныеФайла = ПолучитьИзВременногоХранилища(ДанныеФайлаРазбора);
		ДвоичныеДанныеФайла.Записать(ИмяФайла);
		
		СтруктураРазбора = ЭлектронныеДокументыВнутренний.СформироватьДеревоРазбора(ИмяФайла,
																					Перечисления.НаправленияЭД.Входящий);
		УдалитьФайлы(ИмяФайла);

	КонецЕсли;
	
	Если СтруктураРазбора <> Неопределено И СтруктураРазбора.Свойство("ДеревоРазбора", ДеревоРазбора)
		И СтруктураРазбора.Свойство("СтрокаОбъекта", СтрокаОбъекта) Тогда
		// Если на форме указан контрагент, не совпадающий с контрагентом в дереве разбора (найденный по реквизитам из ЭД),
		// то заменим контрагента в дереве на контрагента с формы.
		СтрокаДерева = НайтиСтрокуВДереве(ДеревоРазбора, СтрокаОбъекта, "Контрагент");
		Если СтрокаДерева.СсылкаНаОбъект <> Контрагент Тогда
			СтрокаДерева.СсылкаНаОбъект = Контрагент;
			// Замена партнера
			Если ЭлектронныеДокументыПовтИсп.ИспользуетсяДополнительнаяАналитикаКонтрагентовСправочникПартнеры() Тогда
				СтрокаДереваПартнер = НайтиСтрокуВДереве(ДеревоРазбора, СтрокаОбъекта, "Партнер");
				Если СтрокаДереваПартнер <> Неопределено Тогда
					РеквизитыПартнера = Новый Структура();
					РеквизитыПартнера.Вставить("Контрагент", Контрагент);
					ИмяПрикладногоСправочника = ЭлектронныеДокументыСлужебныйВызовСервера.ПолучитьИмяПрикладногоСправочника("Партнеры");
					СтрокаДереваПартнер.СсылкаНаОбъект = ЭлектронныеДокументыПереопределяемый.НайтиСсылкуНаОбъект(ИмяПрикладногоСправочника, , РеквизитыПартнера);
				КонецЕсли; 
			КонецЕсли;
		КонецЕсли;
		ДокументСсылка = ?(СпособЗагрузкиДокумента = 1, ДокументИБ, Неопределено);
		
		Попытка
			ЭлементСсылка = ЭлектронныеДокументыПереопределяемый.СохранитьДанныеОбъектаВБД(СтрокаОбъекта,
																							ДеревоРазбора,
																							ДокументСсылка,
																							Записывать);
			
			Если Записывать Тогда
				ЭлементОбъект = ЭлементСсылка.ПолучитьОбъект();
			Иначе
				ЭлементОбъект = ЭлементСсылка;
			КонецЕсли;
			
			Если ДанныеФормы <> Неопределено Тогда
							
				ЗначениеВДанныеФормы(ЭлементОбъект, ДанныеФормы);
			Иначе
				
				Если ВРег(ВидЭД) = ВРег("РеквизитыОрганизации") Тогда
					
					ДанныеФормы = ЭлементСсылка;
					
				Иначе
					
					ДанныеФормы = ЭлементОбъект;
					
				КонецЕсли;
			КонецЕсли;
			
			ДокументИБСформирован = Истина;
			
		Исключение
			
			ШаблонСообщения = НСтр("ru = '%1.
									|%2 '");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения,
				ИнформацияОбОшибке().Описание,
				КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));

		КонецПопытки;
	КонецЕсли;

	Возврат ДокументИБСформирован;
	
КонецФункции

&НаСервереБезКонтекста
Функция МожноЗагрузитьЭДВида(Знач ВидЭД)
	
	МожноЗагрузить = Истина;
	МассивАктуальныхВидовЭД = ЭлектронныеДокументыПовтИсп.ПолучитьАктуальныеВидыЭД();
	Если МассивАктуальныхВидовЭД.Найти(ВидЭД) = Неопределено Тогда
		МожноЗагрузить = Ложь;
	КонецЕсли;
	
	Возврат МожноЗагрузить;
	
КонецФункции


&НаСервере
Функция ФайлДанныхЭД(СсылкаНаЭД, Знач ИмяФайлаПодчиненногоЭД = Неопределено)
	
	ДопИнформацияПоЭД = ЭлектронныеДокументыСлужебный.ПолучитьДанныеФайла(СсылкаНаЭД,
	                                                                      СсылкаНаЭД.УникальныйИдентификатор(),
	                                                                      Истина);
	
	Если ДопИнформацияПоЭД.Свойство("СсылкаНаДвоичныеДанныеФайла")
		И ЗначениеЗаполнено(ДопИнформацияПоЭД.СсылкаНаДвоичныеДанныеФайла) Тогда
		
		ДанныеЭД = ПолучитьИзВременногоХранилища(ДопИнформацияПоЭД.СсылкаНаДвоичныеДанныеФайла);
		
		Если ЗначениеЗаполнено(ДопИнформацияПоЭД.Расширение) Тогда
			ИмяФайла = ЭлектронныеДокументыСлужебный.ТекущееИмяВременногоФайла(ДопИнформацияПоЭД.Расширение);
		Иначе
			ИмяФайла = ЭлектронныеДокументыСлужебный.ТекущееИмяВременногоФайла("xml");
		КонецЕсли;
		
		Если ИмяФайла = Неопределено Тогда
			ТекстОшибки = НСтр("ru = 'Не удалось просмотреть электронный документ. Проверьте настройку рабочего каталога'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
			Возврат Неопределено;
		КонецЕсли;
		
		ДанныеЭД.Записать(ИмяФайла);
		
		Если СсылкаНаЭД.ВидЭД = Перечисления.ВидыЭД.ТОРГ12Покупатель
			ИЛИ СсылкаНаЭД.ВидЭД = Перечисления.ВидыЭД.АктЗаказчик
			ИЛИ СсылкаНаЭД.ВидЭД = Перечисления.ВидыЭД.СоглашениеОбИзмененииСтоимостиПолучатель Тогда
			
			ТабличныйДокумент = ФайлДанныхЭД(СсылкаНаЭД.ЭлектронныйДокументВладелец, ИмяФайла);
			Возврат ТабличныйДокумент;
		ИначеЕсли Найти(ДопИнформацияПоЭД.Расширение, "zip") > 0 Тогда
			
			ЗИПЧтение = Новый ЧтениеZipФайла(ИмяФайла);
			ПапкаДляРаспаковки = ЭлектронныеДокументыСлужебный.РабочийКаталог(,СсылкаНаЭД.УникальныйИдентификатор());
			
			Если ПапкаДляРаспаковки = Неопределено Тогда
				ТекстОшибки = НСтр("ru = 'Не удалось просмотреть электронный документ. Проверьте настройку рабочего каталога'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
				Возврат Неопределено;
			КонецЕсли;
			
			Попытка
				ЗипЧтение.ИзвлечьВсе(ПапкаДляРаспаковки);
			Исключение
				ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
				Если НЕ ЭлектронныеДокументыСлужебный.ВозможноИзвлечьФайлы(ЗипЧтение, ПапкаДляРаспаковки) Тогда
					ТекстСообщения = ЭлектронныеДокументыПовтИсп.ПолучитьСообщениеОбОшибке("006");
				КонецЕсли;
				ЭлектронныеДокументыСлужебныйВызовСервера.ОбработатьИсключениеПоЭДНаСервере(НСтр("ru = 'Распаковка пакета ЭД'"),
					ТекстОшибки, ТекстСообщения);
				ЗипЧтение.Закрыть();
				УдалитьФайлы(ПапкаДляРаспаковки);
				Возврат Неопределено;
			КонецПопытки;
			
			ФлагПросмотра = Ложь;
									
			ФайлыАрхиваXML = НайтиФайлы(ПапкаДляРаспаковки, "*.xml");
			
			Для Каждого РаспакованныйФайл Из ФайлыАрхиваXML Цикл
				
				ТабличныйДокумент = ЭлектронныеДокументыВнутренний.СформироватьПечатнуюФормуЭД(
					РаспакованныйФайл.ПолноеИмя, СсылкаНаЭД.НаправлениеЭД, СсылкаНаЭД.УникальныйИдентификатор());
					
				Если ТипЗнч(ТабличныйДокумент) = Тип("ТабличныйДокумент") Тогда
					Возврат ТабличныйДокумент;
				КонецЕсли;
				
			КонецЦикла;
			
			ФайлыАрхиваMXL = НайтиФайлы(ПапкаДляРаспаковки, "*.mxl");
			Для Каждого РаспакованныйФайл Из ФайлыАрхиваMXL Цикл
				ИмяФайлаДанных = РаспакованныйФайл.ПолноеИмя;
				ТабличныйДокумент = Новый ТабличныйДокумент;
				ТабличныйДокумент.Прочитать(ИмяФайлаДанных);
				УдалитьФайлы(ПапкаДляРаспаковки);
				Возврат ТабличныйДокумент;
			КонецЦикла;
			
			УдалитьФайлы(ПапкаДляРаспаковки);
		ИначеЕсли Найти(ДопИнформацияПоЭД.Расширение, "xml") > 0 Тогда
			Если СсылкаНаЭД.ВидЭД = Перечисления.ВидыЭД.Подтверждение
				ИЛИ СсылкаНаЭД.ВидЭД = Перечисления.ВидыЭД.ИзвещениеОПолучении
				ИЛИ СсылкаНаЭД.ВидЭД = Перечисления.ВидыЭД.УведомлениеОбУточнении
				ИЛИ СсылкаНаЭД.ВидЭД = Перечисления.ВидыЭД.ПредложениеОбАннулировании
				ИЛИ СсылкаНаЭД.ВидЭД = Перечисления.ВидыЭД.ТОРГ12Продавец
				ИЛИ СсылкаНаЭД.ВидЭД = Перечисления.ВидыЭД.АктИсполнитель
				ИЛИ СсылкаНаЭД.ВидЭД = Перечисления.ВидыЭД.СоглашениеОбИзмененииСтоимостиОтправитель
				ИЛИ СсылкаНаЭД.ВидЭД = Перечисления.ВидыЭД.СчетФактура
				ИЛИ СсылкаНаЭД.ВидЭД = Перечисления.ВидыЭД.КорректировочныйСчетФактура Тогда
				
				ВыборкаЭДДопДанных = ЭлектронныеДокументыСлужебный.ВыборкаДопДанныеЭД(СсылкаНаЭД);
				Если ВыборкаЭДДопДанных.Следующий() Тогда
					ДопДанныеЭД = ЭлектронныеДокументыСлужебный.ПолучитьДанныеФайла(ВыборкаЭДДопДанных.Ссылка,
					                                                                ВыборкаЭДДопДанных.Ссылка.УникальныйИдентификатор(),
					                                                                Истина);
					СсылкаНаДДДопДанныхЭД = "";
					Если ДопДанныеЭД.Свойство("СсылкаНаДвоичныеДанныеФайла", СсылкаНаДДДопДанныхЭД)
						И ЗначениеЗаполнено(СсылкаНаДДДопДанныхЭД) Тогда
						ДанныеДопФайла = ПолучитьИзВременногоХранилища(СсылкаНаДДДопДанныхЭД);
					
						Если ЗначениеЗаполнено(ДопДанныеЭД.Расширение) Тогда
							ИмяФайлаДопДанных = ЭлектронныеДокументыСлужебный.ТекущееИмяВременногоФайла(ДопДанныеЭД.Расширение);
						Иначе
							ИмяФайлаДопДанных = ЭлектронныеДокументыСлужебный.ТекущееИмяВременногоФайла("xml");
						КонецЕсли;
					
						Если ИмяФайлаДопДанных = Неопределено Тогда
							ТекстОшибки = НСтр("ru = 'Не удалось получить доп. данные электронного документа.
													|Проверьте настройку рабочего каталога'");
							ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
							Возврат Неопределено;
						КонецЕсли;
						ДанныеДопФайла.Записать(ИмяФайлаДопДанных);
					КонецЕсли;
				КонецЕсли;
				
				ИмяФайлаДанных = ИмяФайла;
				ТабличныйДокумент = ЭлектронныеДокументыВнутренний.СформироватьПечатнуюФормуЭД(ИмяФайла, СсылкаНаЭД.НаправлениеЭД,
													СсылкаНаЭД.УникальныйИдентификатор(), ИмяФайлаПодчиненногоЭД, ИмяФайлаДопДанных);
													
				Если НЕ ИмяФайлаДопДанных = Неопределено Тогда
					УдалитьФайлы(ИмяФайлаДопДанных);
				КонецЕсли;
				Если ТипЗнч(ТабличныйДокумент) = Тип("ТабличныйДокумент") Тогда
					Возврат ТабличныйДокумент;
				КонецЕсли;
			
			ИначеЕсли СсылкаНаЭД.ВидЭД = Перечисления.ВидыЭД.ПлатежноеПоручение
				ИЛИ СсылкаНаЭД.ВидЭД = Перечисления.ВидыЭД.ЗапросВыписки
				ИЛИ СсылкаНаЭД.ВидЭД = Перечисления.ВидыЭД.ВыпискаБанка
				ИЛИ СсылкаНаЭД.ВидЭД = Перечисления.ВидыЭД.Квитанция Тогда
			
				ИмяФайлаДанных = ИмяФайла;
				ТабличныйДокумент = ЭлектронныеДокументыВнутренний.СформироватьПечатнуюФормуЭД(
					ИмяФайла, СсылкаНаЭД.НаправлениеЭД, СсылкаНаЭД.УникальныйИдентификатор(), ИмяФайлаПодчиненногоЭД);
			
				Если ТипЗнч(ТабличныйДокумент)=Тип("ТабличныйДокумент") Тогда
					Возврат ТабличныйДокумент;
				КонецЕсли;

			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции


&НаКлиенте
Процедура ОбработатьВыборТипаОбъекта()
	
	Если ЗначениеЗаполнено(ТипОбъекта) Тогда
		Для Каждого Элемент ИЗ СписокТипов Цикл
			Если Элемент.Представление = ТипОбъекта Тогда
				ВыбраннаяСсылка = Элемент.Значение;
				Если НЕ ЗначениеЗаполнено(ДокументИБ) ИЛИ ТипЗнч(ДокументИБ) <> ТипЗнч(ВыбраннаяСсылка) Тогда
					ДокументИБ = ВыбраннаяСсылка;
				КонецЕсли;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СформироватьТекстСлужебногоСообщения()
	
	Если ЗначениеЗаполнено(ИмяФайлаХМЛ) Тогда
		
		ЗаголовокЭлемента = НСтр("ru = 'Не удалось прочитать файл """+ ИмяФайлаХМЛ+".""'");
		
	Иначе
		
		ЗаголовокЭлемента = НСтр("ru = 'Не найден файл электронного документа ""* .xml.""'");
		
	КонецЕсли;
	
	Элементы.КомментарийСлужебноеСообщение.Заголовок = ЗаголовокЭлемента;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВыполнитьДействие(Команда)
	
	Если ЗагрузкаЭД И ЗначениеЗаполнено(ИмяОбъектаМетаданных) Тогда
		ОчиститьСообщения();
		
		Отказ = Ложь;
		ТекстСообщения = "";
		
		Если ВРег(ВидЭД) = ВРег("РеквизитыОрганизации") Тогда
			
			Отказ = Ложь;
			ТекстСообщения = "";
			
			Если СпособЗагрузкиДокумента = 1 И Не ЗначениеЗаполнено(ДокументИБ) Тогда
				ТекстСообщения = НСтр("ru = 'Не указан элемент справочника для перезаполнения.'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
				Отказ = Истина;
			КонецЕсли;
			
			СоздатьОбъектыИБ(АдресСтруктурыРазбораЭД, Отказ);
			
			Если Отказ Тогда
				Возврат;
			КонецЕсли;
			
			ДанныеФормы = Неопределено;
			Если Не СформироватьДокументИБ(ДанныеФормы, ТекстСообщения, Истина) Тогда
				Отказ = Истина;
			КонецЕсли;
			
			
			Если Отказ Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
				Возврат;
			КонецЕсли;
			
			Закрыть();
			
			ОткрытьЗначение(ДанныеФормы);
			
		Иначе
			
			Если НЕ МожноЗагрузитьЭДВида(ВидЭД) Тогда
				ТекстСообщения = НСтр("ru = 'Не поддерживается загрузка электронных документов вида ""%1"".'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%1", ТипОбъекта);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
				Отказ = Истина;
			КонецЕсли;
			Если НЕ ЗначениеЗаполнено(Контрагент) Тогда
				ТекстСообщения = НСтр("ru = 'Не указан контрагент.'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
				Отказ = Истина;
			КонецЕсли;
			Если СпособЗагрузкиДокумента = 1 И НЕ ЗначениеЗаполнено(ДокументИБ) Тогда
				ТекстСообщения = НСтр("ru = 'Не указан документ для перезаполнения.'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
				Отказ = Истина;
			КонецЕсли;
			
			СоздатьОбъектыИБ(АдресСтруктурыРазбораЭД, Отказ);
			
			Если Отказ Тогда
				Возврат;
			КонецЕсли;
			
			СопоставлятьНоменклатуруПередЗаполнениемДокумента = Ложь;
			ЭлектронныеДокументыКлиентПереопределяемый.СопоставлятьНоменклатуруПередЗаполнениемДокумента(СопоставлятьНоменклатуруПередЗаполнениемДокумента);
			
			Если СопоставлятьНоменклатуруПередЗаполнениемДокумента Тогда
				ОбновитьСтруктуруРазбора = СопоставитьНоменклатуру();
			КонецЕсли;

			Попытка
				Если СпособЗагрузкиДокумента = 1 И ЗначениеЗаполнено(ДокументИБ) Тогда
					ФормаДокумента = ПолучитьФорму(ИмяОбъектаМетаданных + ".ФормаОбъекта", Новый Структура("Ключ", ДокументИБ));
				Иначе
					ФормаДокумента = ПолучитьФорму(ИмяОбъектаМетаданных + ".ФормаОбъекта");
				КонецЕсли;
			Исключение
				ТекстСообщения = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);
			КонецПопытки;
			
			Если НЕ Отказ Тогда
				Если ТипЗнч(ФормаДокумента) = Тип("УправляемаяФорма") Тогда
					ДанныеФормы = ФормаДокумента.Объект;
				Иначе
					ДанныеФормы = Неопределено;
				КонецЕсли;
				
				Если ОбновитьСтруктуруРазбора = Неопределено Тогда
					ОбновитьСтруктуруРазбора = Ложь;
				КонецЕсли;
				
				Если Не СформироватьДокументИБ(ДанныеФормы, ТекстСообщения,, ОбновитьСтруктуруРазбора) Тогда
					Отказ = Истина;
				КонецЕсли;
				
				Если Отказ Тогда
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
				Иначе
					
					Если Не СопоставлятьНоменклатуруПередЗаполнениемДокумента Тогда
						ЗначениеВозврата = СопоставитьНоменклатуру(ДанныеФормы);
						Если ЗначениеЗаполнено(ЗначениеВозврата) Тогда
							ЭлектронныеДокументыСлужебныйВызовСервера.ЗаполнитьИсточник(ДанныеФормы, ЗначениеВозврата);
						КонецЕсли;
					КонецЕсли;
					Если ТипЗнч(ФормаДокумента) = Тип("УправляемаяФорма") Тогда
						КопироватьДанныеФормы(ДанныеФормы, ФормаДокумента.Объект);
					Иначе
						ФормаДокумента.ДокументОбъект = ДанныеФормы;
					КонецЕсли;
					
					МассивОповещения = Новый Массив;
					МассивОповещения.Добавить(ДокументИБ);
					Оповестить("ОбновитьДокументИБПослеЗаполненияИзФайла", МассивОповещения);
					
					ФормаДокумента.Открыть();
					ФормаДокумента.Модифицированность = Истина;
					Закрыть();
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ВидЭД = ПредопределенноеЗначение("Перечисление.ВидыЭД.КаталогТоваров") Тогда
		
		СоздатьОбъектыИБ(АдресСтруктурыРазбораЭД, Ложь);
		СопоставитьНоменклатуру();
		СохранитьДанныеОбъектаВБД(АдресСтруктурыРазбораЭД);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЕЙ ФОРМЫ

&НаКлиенте
Процедура СпособЗагрузкиДокументаПриИзменении(Элемент)
	
	ИзменитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура СпособЗагрузкиСправочникаПриИзменении(Элемент)
	
	ИзменитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипОбъектаПриИзменении(Элемент)
	
	ОбработатьВыборТипаОбъекта();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокТиповСправочниковПриИзменении(Элемент)
	
	ОбработатьВыборТипаОбъекта();
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументИБНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ДокументИБ = Неопределено Тогда
		ТекЭлемент = Неопределено;
		Если ЗначениеЗаполнено(ТипОбъекта) Тогда
			Для Каждого ЭлементСписка Из СписокТипов Цикл
				Если ТипОбъекта = ЭлементСписка.Представление Тогда
					ДокументИБ = ЭлементСписка.Значение;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураЭД = "";
	НаправлениеЭД = "";
	Если Параметры.Свойство("СтруктураЭД", СтруктураЭД) И ТипЗнч(СтруктураЭД) = Тип("Структура")
		И СтруктураЭД.Свойство("НаправлениеЭД", НаправлениеЭД) Тогда
		
		ЗагрузкаЭД = (НаправлениеЭД = Перечисления.НаправленияЭД.Входящий);
		
		СтруктураЭД.Свойство("ВладелецЭД", ДокументИБ);
		Если ЗагрузкаЭД Тогда
			
			СсылкаНаЗаполняемыйДокумент = "";
			Если СтруктураЭД.Свойство("СсылкаНаДокумент", СсылкаНаЗаполняемыйДокумент)
				И ЗначениеЗаполнено(СсылкаНаЗаполняемыйДокумент) Тогда
				
				СпособЗагрузкиДокумента = 1;
			КонецЕсли;
		КонецЕсли;
		ВыполнитьПросмотрЭДСервер(СтруктураЭД, Отказ);
	КонецЕсли;
	
	ЭлектронныйДокумент = Неопределено;
	Если Параметры.Свойство("ЭлектронныйДокумент", ЭлектронныйДокумент) Тогда
		ЗагрузкаЭД = Ложь;
		Параметры.Свойство("ВладелецЭД", ДокументИБ);
		ДанныеЭД = ФайлДанныхЭД(ЭлектронныйДокумент);
		Если ДанныеЭД = Неопределено Тогда
			Возврат;
		КонецЕсли;
		Если ТипЗнч(ДанныеЭД) = Тип("ТабличныйДокумент") Тогда
			ТабличныйДокументФормы = ДанныеЭД;
		КонецЕсли;
	КонецЕсли;
	
	ИзменитьВидимостьДоступностьПриСозданииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИзменитьВидимостьДоступность();
	
	Если ЭтоАдресВременногоХранилища(АдресСтруктурыРазбораЭД) И ЗначениеЗаполнено(РасширениеФайла) Тогда
		#Если ВебКлиент Тогда
			ПутьКФайлуПросмотра = АдресСтруктурыРазбораЭД;
		#Иначе
			ПутьКФайлуПросмотра = ПолучитьИмяВременногоФайла(РасширениеФайла);
			ДДФайла = ПолучитьИзВременногоХранилища(АдресСтруктурыРазбораЭД);
			ДДФайла.Записать(ПутьКФайлуПросмотра);
		#КонецЕсли
		Если Найти("HTML PDF DOCX XLSX", ВРег(РасширениеФайла)) > 0 Тогда
			
			СформироватьТекстСлужебногоСообщения();
			
			Элементы.Панель.ТекущаяСтраница = Элементы.ПросмотрЭД;
			
		Иначе
			#Если НЕ ВебКлиент Тогда
				ЗапуститьПриложение(ПутьКФайлуПросмотра);
			#КонецЕсли
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	
КонецПроцедуры

