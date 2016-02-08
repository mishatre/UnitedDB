﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	МассивСтруктурСертификатов = Параметры.МассивСтруктурСертификатов;
	
	ОбъектСсылка = Неопределено;
	Если Параметры.Свойство("ОбъектСсылка") Тогда
		ОбъектСсылка = Параметры.ОбъектСсылка;
	КонецЕсли;
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Подписать ""%1""'"), Строка(ОбъектСсылка));
	
	Для Каждого СтруктураСертификата Из МассивСтруктурСертификатов Цикл
		НоваяСтрока = СертификатыЭЦП.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураСертификата, "КомуВыдан, КемВыдан, ДействителенДо, Отпечаток");
		ЭлектроннаяЦифроваяПодпись.ЗаполнитьНазначениеСертификата(СтруктураСертификата.Назначение, НоваяСтрока.Назначение);
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ СертификатыЭЦП

&НаКлиенте
Процедура СертификатыЭЦПВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОбработкаВыбора();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Выбрать(Команда)
	ОбработкаВыбора();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСертификат(Команда)
	
	СтрокаСертификата = Элементы.СертификатыЭЦП.ТекущиеДанные;
	Если СтрокаСертификата = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ВыбранныйСертификат = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьСертификатПоОтпечатку(СтрокаСертификата.Отпечаток);
	
	СтруктураСертификата = ЭлектроннаяЦифроваяПодписьКлиентСервер.ЗаполнитьСтруктуруСертификата(ВыбранныйСертификат);
	Если СтруктураСертификата <> Неопределено Тогда
		ПараметрыФормы = Новый Структура("СтруктураСертификата, Отпечаток", СтруктураСертификата, СтрокаСертификата.Отпечаток);
		ОткрытьФорму("ОбщаяФорма.СертификатЭЦП", ПараметрыФормы, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ОбработкаВыбора()
	
	СтрокаСертификата = Элементы.СертификатыЭЦП.ТекущиеДанные;
	Если СтрокаСертификата = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ВыбранныйПароль = ?(ЗначениеЗаполнено(Пароль), Пароль, Элементы.Пароль.ТекстРедактирования);
	
	ВыбранныйСертификат = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьСертификатПоОтпечатку(СтрокаСертификата.Отпечаток);
	
	РезультатВыбора = Новый Структура;
	РезультатВыбора.Вставить("Сертификат",  ВыбранныйСертификат);
	РезультатВыбора.Вставить("Комментарий", Комментарий);
	РезультатВыбора.Вставить("Пароль",      ВыбранныйПароль);
	
	Закрыть(РезультатВыбора);
	
КонецПроцедуры

