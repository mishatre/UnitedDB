﻿
Функция ПолучитьНаименованиеСтрокиТовара(СтрокаТаблицыТовары)
	
	Если ЗначениеЗаполнено(СтрокаТаблицыТовары.Номенклатура.НаименованиеПолное) Тогда
		НаименованиеТовара = СтрокаТаблицыТовары.Номенклатура.НаименованиеПолное;
	Иначе
		НаименованиеТовара = СтрокаТаблицыТовары.Номенклатура.Наименование;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтрокаТаблицыТовары.ХарактеристикаНоменклатуры) Тогда
		НаименованиеТовара = НаименованиеТовара + " (" + Строка(СтрокаТаблицыТовары.ХарактеристикаНоменклатуры)	+ ")";
	КонецЕсли;
	
	Возврат НаименованиеТовара;	
	
КонецФункции

Процедура ДобавитьСтрокиКаталогаТоваровВДеревоТэгов(СтрокиДерева, Отказ, Сообщение);
	
 	Для каждого СтрокаТаблицыТовары Из Товары Цикл
		
		СообщениеСтроки = "";
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	СвойстваНоменклатурыЭлектронногоОбмена.Код КАК ИмяСвойства,
		|	ЗначенияСвойствОбъектов.Значение КАК ЗначениеСвойства
		|ИЗ
		|	РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СвойстваНоменклатурыЭлектронногоОбмена КАК СвойстваНоменклатурыЭлектронногоОбмена
		|		ПО СвойстваНоменклатурыЭлектронногоОбмена.СвойствоНоменклатуры = ЗначенияСвойствОбъектов.Свойство
		|ГДЕ
		|	ЗначенияСвойствОбъектов.Объект = &Номенклатура";
		
		СвойстваТовара = Новый Структура;
		
		Запрос.УстановитьПараметр("Номенклатура", СтрокаТаблицыТовары.Номенклатура);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			СвойстваТовара.Вставить(СокрЛП(Выборка.ИмяСвойства), Выборка.ЗначениеСвойства);
		КонецЦикла;
		
		СтрокиТовара = ЭлектронныеДокументы.ДобавитьСтрокуВДеревоТэгов(СтрокиДерева, "Товар").Строки;
		
		Значение = ЭлектронныеДокументы.СоздатьИдентификаторыЭлОбмена(?(НЕ ЗначениеЗаполнено(СтрокаТаблицыТовары.ХарактеристикаНоменклатуры), СтрокаТаблицыТовары.Номенклатура, СтрокаТаблицыТовары.ХарактеристикаНоменклатуры));
		ЭлектронныеДокументы.ДобавитьСтрокуВДеревоТэгов(СтрокиТовара, "ИдТовараПоставщика", Значение , "ТоварИД");
		
		МенеджерЗаписи = РегистрыСведений.НоменклатураКонтрагентов.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Контрагент                 = Контрагент;
		МенеджерЗаписи.Номенклатура               = СтрокаТаблицыТовары.Номенклатура;
		МенеджерЗаписи.ХарактеристикаНоменклатуры = СтрокаТаблицыТовары.ХарактеристикаНоменклатуры;
		МенеджерЗаписи.Прочитать();
		Если МенеджерЗаписи.Выбран() Тогда
			ЭлектронныеДокументы.ДобавитьСтрокуВДеревоТэгов(СтрокиТовара, "ИдТовараКлиента", МенеджерЗаписи.КодНоменклатурыКонтрагента, "ТоварИД")
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Штрихкоды.Штрихкод
		|ИЗ
		|	РегистрСведений.Штрихкоды КАК Штрихкоды
		|ГДЕ
		|	Штрихкоды.Владелец = &Владелец
		|	И Штрихкоды.ХарактеристикаНоменклатуры = &ХарактеристикаНоменклатуры";
		
		Запрос.УстановитьПараметр("Владелец", СтрокаТаблицыТовары.Номенклатура);
		Запрос.УстановитьПараметр("ХарактеристикаНоменклатуры", СтрокаТаблицыТовары.ХарактеристикаНоменклатуры);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			ЭлектронныеДокументы.ДобавитьСтрокуВДеревоТэгов(СтрокиТовара, "ШтриховойКод", "0" + Выборка.Штрихкод, "GTIN")
		КонецЦикла;
		
		ЭлектронныеДокументы.ДобавитьСтрокуВДеревоТэгов(СтрокиТовара, "ОКЕИ", СтрокаТаблицыТовары.Номенклатура.БазоваяЕдиницаИзмерения.Код, "ОКЕИ");
		
		ЗначениеСвойства = Неопределено;
		Если СвойстваТовара.Свойство("ОКП", ЗначениеСвойства) и ЗначениеЗаполнено(ЗначениеСвойства) Тогда
			ЭлектронныеДокументы.ДобавитьСтрокуВДеревоТэгов(СтрокиТовара, "ОКП", ЗначениеСвойства, "ОКП")
		Иначе
			СообщениеСтроки = СообщениеСтроки + Символы.ПС + " - не заполнено ОКП";
		КонецЕсли;
		
		СтранаПроисхождения = СтрокаТаблицыТовары.Номенклатура.СтранаПроисхождения;
		Если НЕ ЗначениеЗаполнено(СтранаПроисхождения) Тогда
			СтранаПроисхождения = Справочники.КлассификаторСтранМира.Россия;	
		КонецЕсли;
		ЭлектронныеДокументы.ДобавитьСтрокуВДеревоТэгов(СтрокиТовара, "ИСО3166", СтранаПроисхождения.Код, "ИСО3166");
		
		ЗначениеСвойства = Неопределено;
		Если СвойстваТовара.Свойство("ОКВЭД", ЗначениеСвойства) и ЗначениеЗаполнено(ЗначениеСвойства) Тогда
			ЭлектронныеДокументы.ДобавитьСтрокуВДеревоТэгов(СтрокиТовара, "ОКВЭД", ЗначениеСвойства, "ОКВЭД")
		КонецЕсли;
		
		ЗначениеСвойства = ПолучитьНаименованиеСтрокиТовара(СтрокаТаблицыТовары);
 		Если ЗначениеЗаполнено(ЗначениеСвойства) Тогда
			ЭлектронныеДокументы.ДобавитьСтрокуВДеревоТэгов(СтрокиТовара, "Наименование", ЗначениеСвойства);
		Иначе
			СообщениеСтроки = СообщениеСтроки + Символы.ПС + " - не заполнено наименование";
		КонецЕсли;
		
		ЗначениеСвойства = Неопределено;
		Если СвойстваТовара.Свойство("ТорговаяМарка", ЗначениеСвойства) и ЗначениеЗаполнено(ЗначениеСвойства) Тогда
			ЭлектронныеДокументы.ДобавитьСтрокуВДеревоТэгов(СтрокиТовара, "ТорговаяМарка", ЗначениеСвойства)
		Иначе
			СообщениеСтроки = СообщениеСтроки + Символы.ПС + " - не заполнена торговая марка";
		КонецЕсли;
		
		ЗначениеСвойства = Неопределено;
		Если СвойстваТовара.Свойство("Производитель", ЗначениеСвойства) и ЗначениеЗаполнено(ЗначениеСвойства) Тогда
			ЭлектронныеДокументы.ДобавитьСтрокуВДеревоТэгов(СтрокиТовара, "Производитель", ЗначениеСвойства)
		Иначе
			СообщениеСтроки = СообщениеСтроки + Символы.ПС + " - не заполнен производитель";
		КонецЕсли;
		
		ЗначениеСвойства = СтрокаТаблицыТовары.Номенклатура.ДополнительноеОписаниеНоменклатуры;
		Если ЗначениеЗаполнено(ЗначениеСвойства) Тогда
			ЭлектронныеДокументы.ДобавитьСтрокуВДеревоТэгов(СтрокиТовара, "Описание", ЗначениеСвойства)
		КонецЕсли;
		
		ЗначениеСвойства = Неопределено;
		Если СвойстваТовара.Свойство("ВесНетто", ЗначениеСвойства) и ЗначениеЗаполнено(ЗначениеСвойства) Тогда
			ЭлектронныеДокументы.ДобавитьСтрокуВДеревоТэгов(СтрокиТовара, "ВесНетто", ЗначениеСвойства, "ВесТип")
		КонецЕсли;
		
		ЗначениеСвойства = Неопределено;
		Если СвойстваТовара.Свойство("ВесБрутто", ЗначениеСвойства) и ЗначениеЗаполнено(ЗначениеСвойства) Тогда
			ЭлектронныеДокументы.ДобавитьСтрокуВДеревоТэгов(СтрокиТовара, "ВесБрутто", ЗначениеСвойства, "ВесТип")
		КонецЕсли;
		
		ЗначениеСвойства = Неопределено;
		Если СвойстваТовара.Свойство("ВысотаСлояТовара", ЗначениеСвойства) и ЗначениеЗаполнено(ЗначениеСвойства) Тогда
			ЭлектронныеДокументы.ДобавитьСтрокуВДеревоТэгов(СтрокиТовара, "ВысотаСлояТовара", ЗначениеСвойства, "Габариты")
		КонецЕсли;
		
		ЗначениеСвойства = Неопределено;
		Если СвойстваТовара.Свойство("ВысотаТовара", ЗначениеСвойства) и ЗначениеЗаполнено(ЗначениеСвойства) Тогда
			ЭлектронныеДокументы.ДобавитьСтрокуВДеревоТэгов(СтрокиТовара, "ВысотаТовара", ЗначениеСвойства, "Габариты")
		КонецЕсли;
		
		ЗначениеСвойства = Неопределено;
		Если СвойстваТовара.Свойство("ШиринаТовара", ЗначениеСвойства) и ЗначениеЗаполнено(ЗначениеСвойства) Тогда
			ЭлектронныеДокументы.ДобавитьСтрокуВДеревоТэгов(СтрокиТовара, "ШиринаТовара", ЗначениеСвойства, "Габариты")
		КонецЕсли;
		
		ЗначениеСвойства = Неопределено;
		Если СвойстваТовара.Свойство("ГлубинаТовара", ЗначениеСвойства) и ЗначениеЗаполнено(ЗначениеСвойства) Тогда
			ЭлектронныеДокументы.ДобавитьСтрокуВДеревоТэгов(СтрокиТовара, "ГлубинаТовара", ЗначениеСвойства, "Габариты")
		КонецЕсли;
		
		ЗначениеСвойства = Неопределено;
		Если СвойстваТовара.Свойство("ОбъемТовара", ЗначениеСвойства) и ЗначениеЗаполнено(ЗначениеСвойства) Тогда
			ЭлектронныеДокументы.ДобавитьСтрокуВДеревоТэгов(СтрокиТовара, "ОбъемТовара", ЗначениеСвойства, "ОбъемТип")
		КонецЕсли;
		
		ЗначениеСвойства = Неопределено;
		Если СвойстваТовара.Свойство("МинКоличествоДляЗаказа", ЗначениеСвойства) и ЗначениеЗаполнено(ЗначениеСвойства) Тогда
			ЭлектронныеДокументы.ДобавитьСтрокуВДеревоТэгов(СтрокиТовара, "МинКоличествоДляЗаказа", ЗначениеСвойства, "КоличествоТип")
		КонецЕсли;
		
		ЗначениеСвойства = Неопределено;
		Если СвойстваТовара.Свойство("КоличествоВСлоеНаЕвропалете", ЗначениеСвойства) и ЗначениеЗаполнено(ЗначениеСвойства) Тогда
			ЭлектронныеДокументы.ДобавитьСтрокуВДеревоТэгов(СтрокиТовара, "КоличествоВСлоеНаЕвропалете", ЗначениеСвойства, "КоличествоТип")
		КонецЕсли;
		
		ЗначениеСвойства = Неопределено;
		Если СвойстваТовара.Свойство("СрокХранения", ЗначениеСвойства) и ЗначениеЗаполнено(ЗначениеСвойства) Тогда
			ЭлектронныеДокументы.ДобавитьСтрокуВДеревоТэгов(СтрокиТовара, "СрокХранения", ЭлектронныеДокументы.ХМЛДлительность(ЗначениеСвойства));
		КонецЕсли;
		
		ЗначениеСвойства = Неопределено;
		Если СвойстваТовара.Свойство("ТемператураХранения", ЗначениеСвойства) и ЗначениеЗаполнено(ЗначениеСвойства) Тогда
			ЭлектронныеДокументы.ДобавитьСтрокуВДеревоТэгов(СтрокиТовара, "ТемператураХранения", ЗначениеСвойства)
		КонецЕсли;
		
		ЗначениеСвойства = Неопределено;
		Если СвойстваТовара.Свойство("Кратность", ЗначениеСвойства) и ЗначениеЗаполнено(ЗначениеСвойства) Тогда
			ЭлектронныеДокументы.ДобавитьСтрокуВДеревоТэгов(СтрокиТовара, "Кратность", ЗначениеСвойства, "КратностьТип")
		КонецЕсли;
		
		ЗначениеСвойства = Неопределено;
		Если СвойстваТовара.Свойство("КоличествоЕдиницОбъектаВерхнегоУровня", ЗначениеСвойства) и ЗначениеЗаполнено(ЗначениеСвойства) Тогда
			ЭлектронныеДокументы.ДобавитьСтрокуВДеревоТэгов(СтрокиТовара, "КоличествоЕдиницОбъектаВерхнегоУровня", ЗначениеСвойства, "КоличествоТип")
		КонецЕсли;
		
		Если Не ПустаяСтрока(СообщениеСтроки) Тогда
			Сообщение = Сообщение + Символы.ПС + "Строка: " + СтрокаТаблицыТовары.НомерСтроки + ". Номенклатура: """ + СтрокаТаблицыТовары.Номенклатура + """ не может быть выгружена:" + СообщениеСтроки;
			Отказ = Истина;
		КонецЕсли;	
		
	КонецЦикла;
	
КонецПроцедуры

#Если Клиент Тогда
	
Процедура ВыполнитьПроверкуОбязательностиСопоставленияСвойствНоменклатуры(Отказ, Сообщение)
	
	МассивСвойствДляОбменаНоменклатурой = ЭлектронныеДокументы.ПолучитьМассивОбязательныхСвойствДляОбменаТоварами();
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	СвойстваНоменклатурыЭлектронногоОбмена.СвойствоНоменклатуры
	               |ИЗ
	               |	Справочник.СвойстваНоменклатурыЭлектронногоОбмена КАК СвойстваНоменклатурыЭлектронногоОбмена
				   |ГДЕ
				   |	СвойстваНоменклатурыЭлектронногоОбмена.Ссылка В (&МассивСвойств)
				   |	И СвойстваНоменклатурыЭлектронногоОбмена.СвойствоНоменклатуры = &ПустоеСвойство";
				   
	Запрос.УстановитьПараметр("МассивСвойств", МассивСвойствДляОбменаНоменклатурой);
	Запрос.УстановитьПараметр("ПустоеСвойство", ПланыВидовХарактеристик.СвойстваОбъектов.ПустаяСсылка());
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	ОтветПользователя = Вопрос("Не все свойства для выгрузки номенклатуры установлены. 
	|Определить соответствие свойств?", РежимДиалогаВопрос.ДаНет, ,  КодВозвратаДиалога.Да);
	
	Если ОтветПользователя <> КодВозвратаДиалога.Да	Тогда
		Возврат;
	КонецЕсли;
	
	ФормаСпискаСвойств = Справочники.СвойстваНоменклатурыЭлектронногоОбмена.ПолучитьФормуСписка();
	ФормаСпискаСвойств.Открыть();	
	
КонецПроцедуры

#КонецЕсли

Процедура ЗаполнитьXML(ОбъектXML, Отказ, Сообщение, ДобавлятьАтрибутПроверки = Ложь, ДополнятьИсходящееСообщениеПриложеннымиФайлами = Ложь) Экспорт
	
	#Если Клиент Тогда
		
		ВыполнитьПроверкуОбязательностиСопоставленияСвойствНоменклатуры(Отказ, Сообщение);
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
	#КонецЕсли
	
	ПрефиксИмен = "";
	ПространствоИменСОДИ    = "urn:moo-sodi.ru:commerceml_sodi";
	
	ОбъектXML.ЗаписатьНачалоЭлемента("КаталогТоваров", ПространствоИменСОДИ);
	ОбъектXML.ЗаписатьСоответствиеПространстваИмен(ПрефиксИмен, ПространствоИменСОДИ);
	ОбъектXML.ЗаписатьСоответствиеПространстваИмен("xsi", "http://www.w3.org/2001/XMLSchema-instance");
	
	Если ДобавлятьАтрибутПроверки Тогда
		ОбъектXML.ЗаписатьАтрибут("xsi:schemaLocation","urn:moo-sodi.ru:commerceml_sodi cml-catalogs-3.0sodi.xsd");
	КонецЕсли;
	
	ДеревоТэгов  = ЭлектронныеДокументы.ИнициализироватьДеревоТэгов(ЭтотОбъект, Отказ, Сообщение);
	СтрокиДерева = ДеревоТэгов.Строки;
		
	ЭлектронныеДокументы.ДобавитьСтрокуВДеревоТэгов(СтрокиДерева, "НомерИсходногоДокумента", ИсходныйДокумент.НомерВходящегоДокумента, "ДокументИД");
	ЭлектронныеДокументы.ДобавитьСтрокуВДеревоТэгов(СтрокиДерева, "ДлительностьОжиданияОтвета", ЭлектронныеДокументы.ХМЛДлительность(ДлительностьОжиданияОтвета));
	ЭлектронныеДокументы.ДобавитьСтрокуВДеревоТэгов(СтрокиДерева, "ЭтоПолныйКаталог", ЭлектронныеДокументы.ХМЛБулево(ЭтоПолныйКаталог));
	ДобавитьСтрокиКаталогаТоваровВДеревоТэгов(СтрокиДерева, Отказ, Сообщение);
	ЭлектронныеДокументы.ЗаписатьТэгиВXMLДокумент(ОбъектXML, ДеревоТэгов.Строки, ПрефиксИмен);
	ОбъектXML.ЗаписатьКонецЭлемента();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ЭлектронныеДокументы.ПередЗаписьюДокументаВведенногоНаОсновании(ЭтотОбъект, Отказ);	
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(Основание)
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ВходящийЗапросКаталога") Тогда
		
		ЭлектронныеДокументы.ЗаполнитьШапкуИсходящегоДокументаПоОснованию(ЭтотОбъект, Основание);
		
	КонецЕсли;
	
КонецПроцедуры

Функция SOAPAction() Экспорт
	
	Возврат "catalog";
	
КонецФункции // () 