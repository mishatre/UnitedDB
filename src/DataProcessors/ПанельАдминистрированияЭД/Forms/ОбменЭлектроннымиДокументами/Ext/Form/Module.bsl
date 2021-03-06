﻿&НаКлиенте
Перем ОбновитьИнтерфейс;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Значения реквизитов формы
	СоставНабораКонстантФормы    = ПолучитьСтруктуруНабораКонстантЭД(НаборКонстант);
	ВнешниеРодительскиеКонстанты = ПолучитьСтруктуруРодительскихКонстантЭД(СоставНабораКонстантФормы);
	РежимРаботы                  = ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы();
	
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьЭлектронныеЦифровыеПодписи");
	
	РежимРаботы.Вставить("СоставНабораКонстантФормы",    Новый ФиксированнаяСтруктура(СоставНабораКонстантФормы));
	РежимРаботы.Вставить("ВнешниеРодительскиеКонстанты", Новый ФиксированнаяСтруктура(ВнешниеРодительскиеКонстанты));
	РежимРаботы.Вставить("БазоваяВерсия"               , 
						ЭлектронныеДокументыСлужебныйВызовСервера.ПолучитьЗначениеФункциональнойОпции("БазоваяВерсия"));
	
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	// Настройки видимости при запуске
	Элементы.ГруппаИспользоватьЭлектронныеЦифровыеПодписи.Видимость        = НЕ РежимРаботы.БазоваяВерсия;
	Элементы.ГруппаОткрытьНастройкиОбменаЭлектроннымиДокументами.Видимость = НЕ РежимРаботы.БазоваяВерсия;
	Элементы.ГруппаИспользоватьОбменЭДМеждуБанками.Видимость               = НЕ РежимРаботы.БазоваяВерсия;
	Элементы.ГруппаИспользоватьОбменЭДМеждуОрганизациями.Видимость         = НЕ РежимРаботы.БазоваяВерсия;
	
	// Обновление состояния элементов
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	ОбновитьИнтерфейсПрограммы();
	
КонецПроцедуры

&НаКлиенте
// Обработчик оповещения формы.
//
// Параметры:
//	ИмяСобытия - Строка - обрабатывается только событие Запись_НаборКонстант, генерируемое панелями администрирования.
//	Параметр   - Структура - содержит имена констант, подчиненных измененной константе, "вызвавшей" оповещение.
//	Источник   - Строка - имя измененной константы, "вызвавшей" оповещение.
//
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия <> "Запись_НаборКонстант" Тогда
		Возврат; // такие событие не обрабатываются
	КонецЕсли;
	
	// Если это изменена константа, расположенная в другой форме и влияющая на значения констант этой формы,
	// то прочитаем значения констант и обновим элементы этой формы.
	Если РежимРаботы.ВнешниеРодительскиеКонстанты.Свойство(Источник)
		ИЛИ (ТипЗнч(Параметр) = Тип("Структура")
			И ПолучитьОбщиеКлючиСтруктурЭД(Параметр, РежимРаботы.ВнешниеРодительскиеКонстанты).Количество() > 0) Тогда
		
		ЭтаФорма.Прочитать();
		УстановитьДоступность();
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ИспользоватьОбменЭДПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЭлектронныеЦифровыеПодписиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОбменЭДМеждуОрганизациямиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОбменЭДСБанкамиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьНемедленнуюОтправкуЭДПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОткрытьНастройкиПрофилейЭДО(Команда)
	ОткрытьФорму("Справочник.ПрофилиНастроекЭДО.Форма.ФормаСписка", , ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСоглашенияОбИспользованииЭД(Команда)
	ОткрытьФорму("Справочник.СоглашенияОбИспользованииЭД.Форма.ФормаСписка", , ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкиОбменаЭлектроннымиДокументами(Команда)
	ОткрытьФорму("ОбщаяФорма.НастройкаКриптографии", , ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПомощникПодключенияКСервису1СТакском(Команда)
	ЭлектронныеДокументыКлиент.ПомощникПодключенияКСервису1СТакском();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПомощникПодключенияКПорталу1СЭДО(Команда)
	ЭлектронныеДокументыКлиент.ПомощникПодключенияКСервису1СЭДО();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПомощникПодключенияКПрямомуОбмену(Команда)
	ЭлектронныеДокументыКлиент.ПомощникПодключенияКПрямомуОбмену();
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	Результат = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если ОбновлятьИнтерфейс Тогда
		#Если НЕ ВебКлиент Тогда
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 1, Истина);
		ОбновитьИнтерфейс = Истина;
		#КонецЕсли
	КонецЕсли;
	
	Если Результат.Свойство("ОповещениеФорм") Тогда
		Оповестить(Результат.ОповещениеФорм.ИмяСобытия, Результат.ОповещениеФорм.Параметр, Результат.ОповещениеФорм.Источник);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	#Если НЕ ВебКлиент Тогда
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбновитьИнтерфейс();
	КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

// Константы

&НаКлиенте
// Возвращает структуру, содержащую ключи, имеющиеся в обеих исходных структурах.
//
Функция ПолучитьОбщиеКлючиСтруктурЭД(Структура1, Структура2)
	
	Результат = Новый Структура;
	
	Для Каждого КлючИЗначение Из Структура1 Цикл
		Если Структура2.Свойство(КлючИЗначение.Ключ) Тогда
			Результат.Вставить(КлючИЗначение.Ключ);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	Результат = Новый Структура;
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Процедура СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат;
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		Если ЕстьПодчиненныеКонстантыЭД(КонстантаИмя, КонстантаЗначение) Тогда
			УстановитьЗначенияЗависимыхКонстант(КонстантаИмя);
			ЭтаФорма.Прочитать();
		КонецЕсли;
		
		ОповещениеФорм = Новый Структура(
			"ИмяСобытия, Параметр, Источник",
			"Запись_НаборКонстант", ПолучитьСтруктуруПодчиненныхКонстантЭД(КонстантаИмя), КонстантаИмя);
		Результат.Вставить("ОповещениеФорм", ОповещениеФорм);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	ЭтоПолноправныйПользователь = Пользователи.ЭтоПолноправныйПользователь();
	
	УстановитьПривилегированныйРежим(Истина);
	ИспользоватьЭлектронныеЦифровыеПодписи = Константы.ИспользоватьЭлектронныеЦифровыеПодписи.Получить();
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьЭлектронныеЦифровыеПодписи" ИЛИ РеквизитПутьКДанным = "" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаКомментарийОткрытьНастройкиОбменаЭлектроннымиДокументами", "Видимость",
			НЕ РежимРаботы.БазоваяВерсия И НЕ ИспользоватьЭлектронныеЦифровыеПодписи);
		
	КонецЕсли;
		
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьОбменЭД"
		ИЛИ РеквизитПутьКДанным = "НаборКонстант.ИспользоватьЭлектронныеЦифровыеПодписи" ИЛИ РеквизитПутьКДанным = "" Тогда
		
		ЗначениеКонстанты = НаборКонстант.ИспользоватьОбменЭД;
		ВключеныЭДиЭЦП    = ЗначениеКонстанты И ИспользоватьЭлектронныеЦифровыеПодписи;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОткрытьТиповыеСоглашенияОбИспользованииЭД",           "Доступность", ЗначениеКонстанты);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОткрытьСоглашенияОбИспользованииЭД", 				  "Доступность", ЗначениеКонстанты);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ИспользоватьОтложеннуюОтправкуЭлектронныхДокументов", "Доступность", ЗначениеКонстанты);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОткрытьПомощникПодключенияКПрямомуОбмену",			  "Доступность", ЗначениеКонстанты);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ИспользоватьОбменЭДСБанками",                         "Доступность", ЗначениеКонстанты);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОткрытьНастройкиОбменаЭлектроннымиДокументами", 	  "Доступность", ВключеныЭДиЭЦП);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ИспользоватьОбменЭДМеждуОрганизациями", 			  "Доступность", ВключеныЭДиЭЦП);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОткрытьПомощникПодключенияКСервису1СТакском",		  "Доступность", ВключеныЭДиЭЦП);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОткрытьПомощникПодключенияКСервису1СЭДО",			  "Доступность", ВключеныЭДиЭЦП);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ИспользоватьЭлектронныеЦифровыеПодписи", 			  "Доступность", ЭтоПолноправныйПользователь);
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

// Константы

&НаСервере
Процедура УстановитьЗначенияЗависимыхКонстант(ИмяРодительскойКонстанты)
	
	СтруктуруПодчиненныхКонстант = ПолучитьСтруктуруПодчиненныхКонстантЭД(ИмяРодительскойКонстанты);
	Для Каждого ИмяКонстанты Из СтруктуруПодчиненныхКонстант Цикл
		Константы[ИмяКонстанты.Ключ].Установить(НаборКонстант[ИмяРодительскойКонстанты]);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
// Возвращает состав набор констант.
//
// Параметры:
//	Набор - КонстантыНабор
//
// Возвращаемое значение:
//  Структура
//		Ключ - имя константы из набора
//
Функция ПолучитьСтруктуруНабораКонстантЭД(Набор)
	
	Результат = Новый Структура;
	
	Для Каждого МетаКонстанта Из Метаданные.Константы Цикл
		Если ЕстьРеквизитОбъекта(Набор, МетаКонстанта.Имя) Тогда
			Результат.Вставить(МетаКонстанта.Имя);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ЕстьРеквизитОбъекта(Объект, ИмяРеквизита)
	
	КлючУникальностиЭД   = Новый УникальныйИдентификатор;
	СтруктураРеквизита = Новый Структура(ИмяРеквизита, КлючУникальностиЭД);

	ЗаполнитьЗначенияСвойств(СтруктураРеквизита, Объект);
	
	Возврат СтруктураРеквизита[ИмяРеквизита] <> КлючУникальностиЭД;
	
КонецФункции

&НаСервере
// Возвращает структуру, описывающую "подчиненные" константы для указанной "родительской" константы.
//
//	Параметры:
//		ИмяРодительскойКонстанты - Структура - имя родительской константы
//
//	Возвращаемое значение:
//		Структура
//			Ключ - имя подчиненной константы
//
Функция ПолучитьСтруктуруПодчиненныхКонстантЭД(ИмяРодительскойКонстанты)
	
	Результат       = Новый Структура;
	ТаблицаКонстант = ПолучитьТаблицуЗависимостиКонстантЭД();
	
	ПодчиненныеКонстанты = ТаблицаКонстант.НайтиСтроки(
		Новый Структура("ИмяРодительскойКонстанты", ИмяРодительскойКонстанты));
	
	Для Каждого СтрокаПодчиненного Из ПодчиненныеКонстанты Цикл
		
		Если Результат.Свойство(СтрокаПодчиненного.ИмяПодчиненнойКонстанты) Тогда
			Продолжить;
		КонецЕсли;
		
		Результат.Вставить(СтрокаПодчиненного.ИмяПодчиненнойКонстанты);
		
		ПодчиненныеПодчиненных = ПолучитьСтруктуруПодчиненныхКонстантЭД(СтрокаПодчиненного.ИмяПодчиненнойКонстанты);
		
		Для Каждого ПодчиненныйПодчиненного Из ПодчиненныеПодчиненных Цикл
			Результат.Вставить(ПодчиненныйПодчиненного.Ключ);
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
// Возвращает структуру, описывающую "родительские" константы для указанных "подчиненных" констант.
//
//	Параметры:
//		СтруктураПодчиненныхКонстант - Структура - имена подчиненных констант
//
//	Возвращаемое значение:
//		Структура
//			Ключ - имя родительской константы
//
Функция ПолучитьСтруктуруРодительскихКонстантЭД(СтруктураПодчиненныхКонстант)
	
	Результат       = Новый Структура;
	ТаблицаКонстант = ПолучитьТаблицуЗависимостиКонстантЭД();
	
	Для Каждого ИскомаяКонстанта Из СтруктураПодчиненныхКонстант Цикл
		
		РодительскиеКонстанты = ТаблицаКонстант.НайтиСтроки(
			Новый Структура("ИмяПодчиненнойКонстанты", ИскомаяКонстанта.Ключ));
		
		Для Каждого СтрокаРодителя Из РодительскиеКонстанты Цикл
			
			Если Результат.Свойство(СтрокаРодителя.ИмяРодительскойКонстанты)
			 ИЛИ СтруктураПодчиненныхКонстант.Свойство(СтрокаРодителя.ИмяРодительскойКонстанты) Тогда
				Продолжить;
			КонецЕсли;
			
			Результат.Вставить(СтрокаРодителя.ИмяРодительскойКонстанты);
			
			РодителиРодителя = ПолучитьСтруктуруРодительскихКонстантЭД(Новый Структура(СтрокаРодителя.ИмяРодительскойКонстанты));
			
			Для Каждого РодительРодителя Из РодителиРодителя Цикл
				Результат.Вставить(РодительРодителя.Ключ);
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
// Возвращает таблицу, описывающую зависимость констант в конфигурации.
// Каждая строка таблицы означает:
// для родительской константы со значением Х допустимо только значение Y для подчиненной константы.
//
// Возвращаемое значение:
//	ТаблицаЗначений с колонками
//		- ИмяРодительскойКонстанты
//		- ИмяПодчиненнойКонстанты
//		- ЗначениеРодительскойКонстанты
//		- ЗначениеПодчиненнойКонстанты
//
Функция ПолучитьТаблицуЗависимостиКонстантЭД()
	
	Результат = Новый ТаблицаЗначений;
	
	Результат.Колонки.Добавить("ИмяРодительскойКонстанты", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("ИмяПодчиненнойКонстанты",  Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("ЗначениеРодительскойКонстанты");
	Результат.Колонки.Добавить("ЗначениеПодчиненнойКонстанты");
	
	Результат.Индексы.Добавить("ИмяРодительскойКонстанты");
	Результат.Индексы.Добавить("ИмяПодчиненнойКонстанты");
	
	// ЭДО
	ДобавитьСтрокуТаблицыЗависимостиКонстантЭД(Результат,
		"ИспользоватьОбменЭД", 						Ложь, "ИспользоватьОбменЭДМеждуОрганизациями", 				 Ложь);
	ДобавитьСтрокуТаблицыЗависимостиКонстантЭД(Результат,
		"ИспользоватьОбменЭД", 						Ложь, "ИспользоватьОбменЭДСБанками", 						 Ложь);
	ДобавитьСтрокуТаблицыЗависимостиКонстантЭД(Результат,
		"ИспользоватьОбменЭД", 						Ложь, "ИспользоватьОтложеннуюОтправкуЭлектронныхДокументов", Ложь);
	
	ДобавитьСтрокуТаблицыЗависимостиКонстантЭД(Результат,
		"ИспользоватьЭлектронныеЦифровыеПодписи", 	Ложь, "ИспользоватьОбменЭДМеждуОрганизациями", 			   	 Ложь);
	ДобавитьСтрокуТаблицыЗависимостиКонстантЭД(Результат,
		"ИспользоватьЭлектронныеЦифровыеПодписи", 	Ложь, "ИспользоватьОбменЭДСБанками", 						 Ложь);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ДобавитьСтрокуТаблицыЗависимостиКонстантЭД(ТаблицаКонстант,
			ИмяРодительскойКонстанты, ЗначениеРодительскойКонстанты, ИмяПодчиненнойКонстанты, ЗначениеПодчиненнойКонстанты)
	
	НоваяСтрока = ТаблицаКонстант.Добавить();
	НоваяСтрока.ИмяРодительскойКонстанты      = ИмяРодительскойКонстанты;
	НоваяСтрока.ЗначениеРодительскойКонстанты = ЗначениеРодительскойКонстанты;
	НоваяСтрока.ИмяПодчиненнойКонстанты       = ИмяПодчиненнойКонстанты;
	НоваяСтрока.ЗначениеПодчиненнойКонстанты  = ЗначениеПодчиненнойКонстанты;
	
КонецПроцедуры

&НаСервере
// Возвращает признак наличия у константы "подчиненных" констант.
//
//	Параметры:
//		ИмяРодительскойКонстанты 	  - Строка - имя константы как оно задано в конфигураторе
//		ЗначениеРодительскойКонстанты - Произвольный - значение константы
//
//	Возвращаемое значение:
//		Булево - если Истина, то у константы есть "подчиненные" ей константы.
//
Функция ЕстьПодчиненныеКонстантыЭД(ИмяРодительскойКонстанты, ЗначениеРодительскойКонстанты)
	
	ТаблицаКонстант = ПолучитьТаблицуЗависимостиКонстантЭД();
	
	ПодчиненныеКонстанты = ТаблицаКонстант.НайтиСтроки(
		Новый Структура(
			"ИмяРодительскойКонстанты, ЗначениеРодительскойКонстанты",
			ИмяРодительскойКонстанты, ЗначениеРодительскойКонстанты));
	
	Возврат ПодчиненныеКонстанты.Количество() > 0;
	
КонецФункции