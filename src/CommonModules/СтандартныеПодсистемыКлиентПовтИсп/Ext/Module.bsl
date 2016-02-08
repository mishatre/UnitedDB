﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает структуру параметров, необходимых для работы
// конфигурации на клиенте при запуске, т.е. в обработчиках событий
// - ПередНачаломРаботыСистемы,
// - ПриНачалеРаботыСистемы
//
// Важно: при запуске недопустимо использовать команды сброса кэша
// повторно используемых модулей, иначе запуск может привести
// к непредсказуемым ошибкам и лишним серверным вызовам
// 
// Возвращаемое значение:
//   ФиксированнаяСтруктура - структура параметров работы клиента при запуске.
//
Функция ПараметрыРаботыКлиентаПриЗапуске() Экспорт
	
	ПервыйЗапросПараметров = Ложь;
	Если ТипЗнч(ПараметрыРаботыКлиентаПриОбновлении) <> Тип("Структура") Тогда
		ПараметрыРаботыКлиентаПриОбновлении = Новый Структура;
	КонецЕсли;
	Если ПараметрыРаботыКлиентаПриОбновлении.Свойство("ПервыйЗапросПараметров") Тогда
		ПервыйЗапросПараметров = Истина;
		ПараметрыРаботыКлиентаПриОбновлении.Удалить("ПервыйЗапросПараметров");
	КонецЕсли;
	
#Если ВебКлиент Тогда
	ЭтоВебКлиент = Истина;
#Иначе
	ЭтоВебКлиент = Ложь;
#КонецЕсли
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ЭтоLinuxКлиент = СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Linux_x86
	              ИЛИ СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Linux_x86_64;

	Параметры = Новый Структура;
	Параметры.Вставить("ПервыйЗапросПараметров", ПервыйЗапросПараметров);
	Параметры.Вставить("ПараметрЗапуска", ПараметрЗапуска);
	Параметры.Вставить("СтрокаСоединенияИнформационнойБазы", СтрокаСоединенияИнформационнойБазы());
	Параметры.Вставить("ЭтоВебКлиент",    ЭтоВебКлиент);
	Параметры.Вставить("ЭтоLinuxКлиент", ЭтоLinuxКлиент);
	
	Возврат СтандартныеПодсистемыВызовСервера.ПараметрыРаботыКлиентаПриЗапуске(Параметры);
	
КонецФункции

// Возвращает структуру параметров, необходимых для работы
// конфигурации на клиенте.
// 
// Возвращаемое значение:
//   ФиксированнаяСтруктура - структура параметров работы клиента при запуске.
//
Функция ПараметрыРаботыКлиента() Экспорт
	
	#Если ТонкийКлиент Тогда 
		ИмяИсполняемогоФайлаКлиента = "1cv8c.exe";
	#Иначе
		ИмяИсполняемогоФайлаКлиента = "1cv8.exe";
	#КонецЕсли
	
	ТекущаяДата = ТекущаяДата(); // текущая дата клиентского компьютера
	
	ПараметрыРаботыКлиента = Новый Структура;
	ПараметрыРаботы = СтандартныеПодсистемыВызовСервера.ПараметрыРаботыКлиента();
	Для Каждого Параметр Из ПараметрыРаботы Цикл
		ПараметрыРаботыКлиента.Вставить(Параметр.Ключ, Параметр.Значение);
	КонецЦикла;
	ПараметрыРаботыКлиента.ПоправкаКВремениСеанса = ПараметрыРаботыКлиента.ПоправкаКВремениСеанса - ТекущаяДата;
	ПараметрыРаботыКлиента.Вставить("ИмяИсполняемогоФайлаКлиента", ИмяИсполняемогоФайлаКлиента);
	
	Возврат Новый ФиксированнаяСтруктура(ПараметрыРаботыКлиента);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Возвращает массив описаний обработчиков клиентского события.
Функция ОбработчикиКлиентскогоСобытия(Событие, Служебное = Ложь) Экспорт
	
	ПодготовленныеОбработчики = ПодготовленныеОбработчикиКлиентскогоСобытия(Событие, Служебное);
	
	Если ПодготовленныеОбработчики = Неопределено Тогда
		// Автообновление кэша. Обновление повторно используемых значений требуется.
		СтандартныеПодсистемыВызовСервера.ПриОшибкеПолученияОбработчиковКлиентскогоСобытия();
		ОбновитьПовторноИспользуемыеЗначения();
		// Повторная попытка получить обработчики события.
		ПодготовленныеОбработчики = ПодготовленныеОбработчикиКлиентскогоСобытия(Событие, Служебное, Ложь);
	КонецЕсли;
	
	Возврат ПодготовленныеОбработчики;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПодготовленныеОбработчикиКлиентскогоСобытия(Событие, Служебное = Ложь, ПерваяПопытка = Истина)
	
	Параметры = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске(
		).ОбработчикиКлиентскихСобытий;
	
	Если Служебное Тогда
		Обработчики = Параметры.ОбработчикиСлужебныхСобытий.Получить(Событие);
	Иначе
		Обработчики = Параметры.ОбработчикиСобытий.Получить(Событие);
	КонецЕсли;
	
	Если ПерваяПопытка И Обработчики = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Обработчики = Неопределено Тогда
		Если Служебное Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не найдено клиентское служебное событие ""%1"".'"), Событие);
		Иначе
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не найдено клиентское событие ""%1"".'"), Событие);
		КонецЕсли;
	КонецЕсли;
	
	Массив = Новый Массив;
	
	Для каждого Обработчик Из Обработчики Цикл
		Элемент = Новый Структура;
		Модуль = Неопределено;
		Если ПерваяПопытка Тогда
			Попытка
				Модуль = ОбщегоНазначенияКлиентСервер.ОбщийМодуль(Обработчик.Модуль);
			Исключение
				Возврат Неопределено;
			КонецПопытки;
		Иначе
			Модуль = ОбщегоНазначенияКлиентСервер.ОбщийМодуль(Обработчик.Модуль);
		КонецЕсли;
		Элемент.Вставить("Модуль",     Обработчик.Модуль);
		Элемент.Вставить("Версия",     Обработчик.Версия);
		Элемент.Вставить("Подсистема", Обработчик.Подсистема);
		Массив.Добавить(Новый ФиксированнаяСтруктура(Элемент));
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(Массив);
	
КонецФункции

// Возвращает соответствие имен и клиентских модулей.
Функция ИменаКлиентскихМодулей() Экспорт
	
	МассивИмен = СтандартныеПодсистемыВызовСервера.МассивИменКлиентскихМодулей();
	
	КлиентскиеМодули = Новый Соответствие;
	
	Для каждого Имя Из МассивИмен Цикл
		КлиентскиеМодули.Вставить(Вычислить(Имя), Имя);
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(КлиентскиеМодули);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Возвращает клиентский общий модуль по имени.
Функция КлиентскийОбщийМодуль(Имя) Экспорт
	
	Модуль = Вычислить(Имя);
	
#Если НЕ ВебКлиент Тогда
	Если ТипЗнч(Модуль) <> Тип("ОбщийМодуль") Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Общий модуль ""%1"" не найден.'"), Имя);
	КонецЕсли;
#КонецЕсли
	
	Возврат Модуль;
	
КонецФункции
