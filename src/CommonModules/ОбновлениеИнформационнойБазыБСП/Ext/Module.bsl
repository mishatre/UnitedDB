﻿////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы библиотеки СтандартныеПодсистемы (БСП).
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// Сведения о библиотеке (или конфигурации).

// Заполняет основные сведения о библиотеке или основной конфигурации.
// Библиотека, имя которой имя совпадает с именем конфигурации в метаданных, определяется как основная конфигурация.
// 
// Параметры:
//  Описание - Структура - сведения о библиотеке:
//
//   Имя                 - Строка - имя библиотеки, например, "СтандартныеПодсистемы".
//   Версия              - Строка - версия в формате из 4-х цифр, например, "2.1.3.1".
//
//   ТребуемыеПодсистемы - Массив - имена других библиотек (Строка), от которых зависит данная библиотека.
//                                  Обработчики обновления таких библиотек должны быть вызваны ранее
//                                  обработчиков обновления данной библиотеки.
//                                  При циклических зависимостях или, напротив, отсутствии каких-либо зависимостей,
//                                  порядок вызова обработчиков обновления определяется порядком добавления модулей
//                                  в процедуре ПриДобавленииПодсистем общего модуля ПодсистемыКонфигурацииПереопределяемый.
//
Процедура ПриДобавленииПодсистемы(Описание) Экспорт
	
	Описание.Имя    = "СтандартныеПодсистемы";
	Описание.Версия = "2.1.3.50";
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики обновления информационной базы.

// Добавляет в список процедуры-обработчики обновления данных ИБ
// для всех поддерживаемых версий библиотеки или конфигурации.
// Вызывается перед началом обновления данных ИБ для построения плана обновления.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - описание полей 
//                                  см. в процедуре ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления
//
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.Версия              = "1.0.0.0";
//  Обработчик.Процедура           = "ОбновлениеИБ.ПерейтиНаВерсию_1_0_0_0";
//  Обработчик.МонопольныйРежим    = Ложь;
//  Обработчик.Опциональный        = Истина;
// 
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	// Обработчики этого события для подсистем БСП добавляются через подписку на служебное событие:
	// "СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПриДобавленииОбработчиковОбновления".
	//
	// Процедуры обработки этого события всех подсистем БСП имеют то же имя, что и эта процедура,
	// но размещены в своих подсистемах.
	// Чтобы найти процедуры можно выполнить глобальный поиск по имени процедуры.
	// Чтобы найти модули в которых размещены процедуры, можно выполнить поиск по имени события.
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПриДобавленииОбработчиковОбновления");
	
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Если Обработчик.Подсистема <> "СтандартныеПодсистемы" Тогда
			Продолжить;
		КонецЕсли;
		Обработчик.Модуль.ПриДобавленииОбработчиковОбновления(Обработчики);
	КонецЦикла;
	
КонецПроцедуры

// Вызывается перед процедурами-обработчиками обновления данных ИБ.
//
Процедура ПередОбновлениемИнформационнойБазы() Экспорт
	
	// Обработчики этого события для подсистем БСП добавляются через подписку на служебное событие:
	// "СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПередОбновлениемИнформационнойБазы".
	//
	// Процедуры обработки этого события всех подсистем БСП имеют то же имя, что и эта процедура,
	// но размещены в своих подсистемах.
	// Чтобы найти процедуры можно выполнить глобальный поиск по имени процедуры.
	// Чтобы найти модули в которых размещены процедуры, можно выполнить поиск по имени события.
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПередОбновлениемИнформационнойБазы");
	
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Если Обработчик.Подсистема <> "СтандартныеПодсистемы" Тогда
			Продолжить;
		КонецЕсли;
		Обработчик.Модуль.ПередОбновлениемИнформационнойБазы();
	КонецЦикла;
	
КонецПроцедуры

// Вызывается после завершения обновления данных ИБ.
// 
// Параметры:
//   ПредыдущаяВерсия       - Строка - версия до обновления. "0.0.0.0" для "пустой" ИБ.
//   ТекущаяВерсия          - Строка - версия после обновления.
//   ВыполненныеОбработчики - ДеревоЗначений - список выполненных процедур-обработчиков обновления,
//                                             сгруппированных по номеру версии.
//   ВыводитьОписаниеОбновлений - Булево - (возвращаемое значение) если установить Истина,
//                                то будет выведена форма с описанием обновлений. По умолчанию, Истина.
//   МонопольныйРежим           - Булево - Истина, если обновление выполнялось в монопольном режиме.
//
// Пример обхода выполненных обработчиков обновления:
//
//	Для Каждого Версия Из ВыполненныеОбработчики.Строки Цикл
//		
//		Если Версия.Версия = "*" Тогда
//			// Обработчик, который может выполнятся при каждой смене версии.
//		Иначе
//			// Обработчик, который выполняется для определенной версии.
//		КонецЕсли;
//		
//		Для Каждого Обработчик Из Версия.Строки Цикл
//			...
//		КонецЦикла;
//		
//	КонецЦикла;
//
Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсия, Знач ТекущаяВерсия,
		Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт
	
	// Вызываем процедуры-обработчики служебного события "ПослеОбновленияИнформационнойБазы".
	// (Для быстрого перехода к процедурам-обработчикам выполнить глобальный поиск по имени события.)
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПослеОбновленияИнформационнойБазы");
	
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Если Обработчик.Подсистема <> "СтандартныеПодсистемы" Тогда
			Продолжить;
		КонецЕсли;
		Обработчик.Модуль.ПослеОбновленияИнформационнойБазы(ПредыдущаяВерсия, ТекущаяВерсия,
			ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим);
	КонецЦикла;
	
КонецПроцедуры

// Вызывается при подготовке табличного документа с описанием изменений в программе.
//
// Параметры:
//   Макет - ТабличныйДокумент - описание обновления всех библиотек и конфигурации.
//           Макет можно дополнить или заменить.
//           См. также общий макет ОписаниеИзмененийСистемы.
//
Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// Работа с событиями служебного программного интерфейса.
// Использование только в пределах библиотеки и отдельно от других библиотек.

// Доопределяет события, к которым можно будет добавить обработчики
// через процедуру ПриДобавленииОбработчиковСлужебныхСобытий.
//
// Параметры:
//  КлиентскиеСобытия – Массив, где значения типа Строка - полное имя события.
//  СерверныеСобытия  – Массив, где значения типа Строка - полное имя события.
//
// Для упрощения поддержки, рекомендуется делать вызов такой же
// процедуры в общем модуле библиотеки.
//
// Пример использования в общем модуле библиотеки:
//
//	// Переопределяет стандартное предупреждение открытием произвольной формы активных пользователей.
//	//
//	// Параметры:
//	//  ИмяФормы - Строка (возвращаемое значение).
//	//
//	// Синтаксис:
//	// Процедура ПриОткрытииФормыАктивныхПользователей(ИмяФормы) Экспорт
//	//
//	СерверныеСобытия.Добавить(
//		"СтандартныеПодсистемы.БазоваяФункциональность\ПриОпределенииФормыАктивныхПользователей");
//
// Комментарий можно копировать при создании нового обработчика.
// Раздел "Синтаксис:" используется для создания новой процедуры обработчика.
//
Процедура ПриДобавленииСлужебныхСобытий(КлиентскиеСобытия, СерверныеСобытия) Экспорт
	
	// СЕРВЕРНЫЕ СОБЫТИЯ.
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	СтандартныеПодсистемыСервер.ДобавитьСлужебныеСобытия(КлиентскиеСобытия, СерверныеСобытия);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	// СтандартныеПодсистемы.БизнесПроцессыИЗадачи
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.БизнесПроцессыИЗадачи") Тогда
		Модуль = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("БизнесПроцессыИЗадачиСервер");
		Модуль.ПриДобавленииСлужебныхСобытий(КлиентскиеСобытия, СерверныеСобытия);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.БизнесПроцессыИЗадачи
	
	// СтандартныеПодсистемы.КалендарныеГрафики
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.КалендарныеГрафики") Тогда
		Модуль = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("КалендарныеГрафики");
		Модуль.ПриДобавленииСлужебныхСобытий(КлиентскиеСобытия, СерверныеСобытия);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.КалендарныеГрафики
	
	// СтандартныеПодсистемы.НапоминанияПользователя
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.НапоминанияПользователя") Тогда
		Модуль = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("НапоминанияПользователяСлужебный");
		Модуль.ПриДобавленииСлужебныхСобытий(КлиентскиеСобытия, СерверныеСобытия);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.НапоминанияПользователя
	
	// СтандартныеПодсистемы.ОбновлениеВерсииИБ
	ОбновлениеИнформационнойБазы.ПриДобавленииСлужебныхСобытий(КлиентскиеСобытия, СерверныеСобытия);
	// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ
	
	// СтандартныеПодсистемы.Пользователи
	ПользователиСлужебный.ПриДобавленииСлужебныхСобытий(КлиентскиеСобытия, СерверныеСобытия);
	// Конец СтандартныеПодсистемы.Пользователи
	
	// СтандартныеПодсистемы.ПрисоединенныеФайлы
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.ПрисоединенныеФайлы") Тогда
		Модуль = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ПрисоединенныеФайлыСлужебный");
		Модуль.ПриДобавленииСлужебныхСобытий(КлиентскиеСобытия, СерверныеСобытия);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПрисоединенныеФайлы
	
	// СтандартныеПодсистемы.ФайловыеФункции
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.ФайловыеФункции") Тогда
		Модуль = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ФайловыеФункцииСлужебный");
		Модуль.ПриДобавленииСлужебныхСобытий(КлиентскиеСобытия, СерверныеСобытия);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ФайловыеФункции
	
КонецПроцедуры

// Доопределяет обработчики служебных событий, объявленных
// через процедуру ПриДобавлениСлужебныхСобытий.
//
// Параметры:
//  КлиентскиеОбработчики – Соответствие, где
//                            Ключ     – Строка - полное имя события,
//                            Значение – Массив - массив имен клиентских общих модулей обработчиков.
//
//  СерверныеОбработчики  – Соответствие, где
//                            Ключ     – Строка - полное имя события,
//                            Значение – Массив - массив имен серверных общих модулей обработчиков.
//
// Для упрощения поддержки, рекомендуется делать вызов такой же
// процедуры в общем модуле библиотеки.
//
// Пример использования в общем модуле библиотеки:
//
//	СерверныеОбработчики[
//		"СтандартныеПодсистемы.БазоваяФункциональность\ПриОпределенииФормыАктивныхПользователей"
//			].Добавить(СоединенияИБ);
//
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	СтандартныеПодсистемыСервер.ДобавитьОбработчикиСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	// СтандартныеПодсистемы.ОбновлениеВерсииИБ
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.ОбновлениеВерсииИБ") Тогда
		Модуль = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ОбновлениеИнформационнойБазы");
		Модуль.ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ
	
	// СтандартныеПодсистемы.Пользователи
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.Пользователи") Тогда
		Модуль = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ПользователиСлужебный");
		Модуль.ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Пользователи
	
	// СтандартныеПодсистемы.ПрисоединенныеФайлы
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.ПрисоединенныеФайлы") Тогда
		Модуль = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ПрисоединенныеФайлыСлужебный");
		Модуль.ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПрисоединенныеФайлы
	
	// СтандартныеПодсистемы.ФайловыеФункции
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.ФайловыеФункции") Тогда
		Модуль = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ФайловыеФункцииСлужебный");
		Модуль.ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ФайловыеФункции
	
	// СтандартныеПодсистемы.ЭлектроннаяПодпись
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.ЭлектроннаяПодпись") Тогда
		Модуль = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ЭлектроннаяЦифроваяПодпись");
		Модуль.ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ЭлектроннаяПодпись
	
КонецПроцедуры
