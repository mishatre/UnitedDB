﻿
/////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБСЛУЖИВАЮЩИЕ НАСЛЕДСТВЕННОСТЬ ПРАВ ДОСТУПА ИЕРАРХИЧЕСКИХ СПРАВОЧНИКОВ

Функция ПолучитьМассивДочернихЭлементов(Родитель) Экспорт
	
	МетаданныеРодителя = Родитель.Метаданные();
	Если ЗначениеЗаполнено(Родитель) и (Не МетаданныеРодителя.Иерархический или МетаданныеРодителя.ВидИерархии = Метаданные.СвойстваОбъектов.ВидИерархии.ИерархияГруппИЭлементов и Не Родитель.ЭтоГруппа) Тогда
		Возврат Новый Массив;
	КонецЕсли; 
	
	Если Метаданные.Перечисления.Содержит(МетаданныеРодителя) Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	_Таблица.Ссылка КАК Ссылка
		|ИЗ
		|	Перечисление." + МетаданныеРодителя.Имя + " КАК _Таблица";
	Иначе
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	_Таблица.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник." + МетаданныеРодителя.Имя + " КАК _Таблица";
		
		Если МетаданныеРодителя.Иерархический Тогда
			Запрос.Текст = Запрос.Текст + "
			|ГДЕ
			|	_Таблица.Ссылка В ИЕРАРХИИ(&Родитель)
			|	И _Таблица.Ссылка <> &Родитель";
			Запрос.УстановитьПараметр("Родитель", Родитель);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции // () 

Процедура ЗаписатьПраваДоступаПользователейКОбъекту(ПраваДоступаПользователей, Ссылка, Отказ, ПрошлыйИзмененныйРодительОбъектаДоступа = Неопределено, Интерактивно = Ложь) Экспорт
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ОтборПоПользователю = ТипЗнч(Ссылка) = Тип("СправочникСсылка.ГруппыПользователей");
		
	Если ОтборПоПользователю Тогда
		ПраваДоступаПользователей.Отбор.Пользователь.Установить(Ссылка);
	Иначе
		ПраваДоступаПользователей.Отбор.ОбъектДоступа.Установить(Ссылка);
	КонецЕсли;
	
	ТаблицаПравДоступа = ПолучитьТаблицуПравДоступаБезУнаследуемыхЗаписей(ПраваДоступаПользователей);
	
	Для каждого СтрокаТаблицы Из ТаблицаПравДоступа Цикл
		Если ОтборПоПользователю Тогда
			СтрокаТаблицы.Пользователь  = Ссылка;
		Иначе
			СтрокаТаблицы.ОбъектДоступа = Ссылка;
		КонецЕсли;
		СтрокаТаблицы.ВладелецПравДоступа = СтрокаТаблицы.ОбъектДоступа;
	КонецЦикла;
	
	СтруктураОтбора = ПолучитьСтруктуруОтборовНабораЗаписей(ПраваДоступаПользователей);
	
	ОткликИнтерактивнойЗаписи = "";
	ПолныеПрава.ЗаписатьПраваДоступаПользователей(ТаблицаПравДоступа,СтруктураОтбора, Отказ, "Не записаны права доступа к объекту """+ Ссылка + """!", Интерактивно, ОткликИнтерактивнойЗаписи);
	
	# Если Клиент Тогда
	Если НЕ ПустаяСтрока(ОткликИнтерактивнойЗаписи) Тогда
		Сообщить(ОткликИнтерактивнойЗаписи);
		Предупреждение("Обнаружено несоответствие настроек!");
	КонецЕсли; 
	# КонецЕсли
	
	Если НЕ Отказ Тогда
		ПрочитатьПраваДоступаКОбъекту(ПраваДоступаПользователей, Ссылка);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПрочитатьПраваДоступаКОбъекту(ПраваДоступаПользователей, Ссылка) Экспорт

	// Снимем все отборы
	Для каждого Отбор Из ПраваДоступаПользователей.Отбор Цикл
		Отбор.Использование = Ложь;
	КонецЦикла;
	
	Если ТипЗнч(Ссылка) = Тип("СправочникСсылка.Пользователи") ИЛИ ТипЗнч(Ссылка) = Тип("СправочникСсылка.ГруппыПользователей") Тогда
		ПраваДоступаПользователей.Отбор.Пользователь.Значение = Ссылка;
		ПраваДоступаПользователей.Отбор.Пользователь.Использование = Истина;
	Иначе
		ПраваДоступаПользователей.Отбор.ОбъектДоступа.Значение = Ссылка;
		ПраваДоступаПользователей.Отбор.ОбъектДоступа.Использование = Истина;
	КонецЕсли;
	
	ПраваДоступаПользователей.Прочитать();
	
КонецПроцедуры

Функция ПолучитьСписокВидовНаследованияПравДоступа(ОбъектДоступа) Экспорт
	
	СписокПеречисления = Новый СписокЗначений;
	
	Если НЕ ЗначениеЗаполнено(ОбъектДоступа) Тогда
		СписокПеречисления.Добавить(Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.РаспространитьНаПодчиненных);
		СписокПеречисления.Добавить(Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.ТолькоДляТекущегоПрава);
	Иначе
		Если Справочники.ТипВсеСсылки().СодержитТип(ТипЗнч(ОбъектДоступа)) Тогда
			МетаданныеОбъекта = ОбъектДоступа.Метаданные();
			Если МетаданныеОбъекта.Иерархический Тогда
				Если МетаданныеОбъекта.ВидИерархии = Метаданные.СвойстваОбъектов.ВидИерархии.ИерархияГруппИЭлементов Тогда
					Если ОбъектДоступа.ЭтоГруппа Тогда
						СписокПеречисления.Добавить(Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.РаспространитьНаПодчиненных);
					Иначе
						СписокПеречисления.Добавить(Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.ТолькоДляТекущегоПрава);
					КонецЕсли;
				Иначе
					СписокПеречисления.Добавить(Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.ТолькоДляТекущегоПрава);
					СписокПеречисления.Добавить(Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.РаспространитьНаПодчиненных);
				КонецЕсли;
			Иначе
				СписокПеречисления.Добавить(Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.ТолькоДляТекущегоПрава);
			КонецЕсли;
		Иначе
			СписокПеречисления.Добавить(Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.ТолькоДляТекущегоПрава);
		КонецЕсли;
	КонецЕсли;
	
	Возврат СписокПеречисления;
	
КонецФункции

Функция ПолучитьТаблицуПравДоступаБезУнаследуемыхЗаписей(ПраваДоступаПользователей) Экспорт
	
	ТаблицаПравДоступа = РегистрыСведений.НастройкиПравДоступаПользователей.СоздатьНаборЗаписей().Выгрузить();
	
	Для каждого СтрокаТаблицыНабора Из ПраваДоступаПользователей Цикл
		
		Если СтрокаТаблицыНабора.ВидНаследованияПравДоступаИерархическихСправочников = Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.ТолькоДляТекущегоПрава или СтрокаТаблицыНабора.ВидНаследованияПравДоступаИерархическихСправочников = Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.РаспространитьНаПодчиненных Тогда
			ЗаполнитьЗначенияСвойств(ТаблицаПравДоступа.Добавить(), СтрокаТаблицыНабора);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ТаблицаПравДоступа;
	
КонецФункции

Процедура ДополнитьНаборПравДоступаНаследуемымиЗаписями(НаборПрав) Экспорт
	
	ИсходнаяТаблица = ПолучитьТаблицуПравДоступаБезУнаследуемыхЗаписей(НаборПрав);
	
	СоответствиеМассивовДочернихЭлементов     = Новый Соответствие;
	СоответствиеМассивовРодительскихЭлементов = Новый Соответствие;
	
	Для каждого СтрокаНабора Из ИсходнаяТаблица Цикл
		
		Если СтрокаНабора.ВидНаследованияПравДоступаИерархическихСправочников = Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.РаспространитьНаПодчиненных Тогда
			
			//Дополним набор записями для дочерних элементов
			МассивЭлементов = СоответствиеМассивовДочернихЭлементов[СтрокаНабора.ОбъектДоступа];
			Если МассивЭлементов = Неопределено Тогда
				МассивЭлементов = ПолучитьМассивДочернихЭлементов(СтрокаНабора.ОбъектДоступа);
				СоответствиеМассивовДочернихЭлементов.Вставить(СтрокаНабора.ОбъектДоступа,МассивЭлементов);
			КонецЕсли;
			
			Для каждого Ссылка Из МассивЭлементов Цикл
				Запись = НаборПрав.Добавить();
				ЗаполнитьЗначенияСвойств(Запись, СтрокаНабора,,"ОбъектДоступа,ВидНаследованияПравДоступаИерархическихСправочников");
				Запись.ОбъектДоступа = Ссылка;
				Запись.ВидНаследованияПравДоступаИерархическихСправочников = Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.НаследуетсяОтРодителя;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // () 

Процедура ДополнитьНаборПравДоступаУнаследованнымиЗаписями(ПраваДоступаПользователей, ОбъектДоступа, Родитель) Экспорт
	
	ОбъектДоступаМетаданные = ОбъектДоступа.Метаданные();
	
	// Добавим записи, унаследованные от родителей
	Родители = Новый Массив;
	ТекущийРодитель = Родитель;
	Пока ЗначениеЗаполнено(ТекущийРодитель) Цикл
		Родители.Добавить(ТекущийРодитель);
		ТекущийРодитель = ТекущийРодитель.Родитель;
	КонецЦикла;
	Родители.Добавить(ТекущийРодитель);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	*
	|ИЗ
	|	РегистрСведений.НастройкиПравДоступаПользователей КАК ПраваДоступаПользователей
	|ГДЕ
	|	ПраваДоступаПользователей.ОбъектДоступа В(&Родители)
	|	И ПраваДоступаПользователей.ВидНаследованияПравДоступаИерархическихСправочников = &РаспространитьНаПодчиненных";
		
	Если ПраваДоступаПользователей.Отбор.ОбластьДанных.Использование Тогда
		Запрос.Текст = Запрос.Текст + "
		|	И ПраваДоступаПользователей.ОбластьДанных = &ОбластьДанных";
		Запрос.УстановитьПараметр("ОбластьДанных", ПраваДоступаПользователей.Отбор.ОбластьДанных.Значение);
	КонецЕсли;

	Если ПраваДоступаПользователей.Отбор.Пользователь.Использование Тогда
		Запрос.Текст = Запрос.Текст + "
		|	И ПраваДоступаПользователей.Пользователь = &Пользователь";
		Запрос.УстановитьПараметр("Пользователь", ПраваДоступаПользователей.Отбор.Пользователь.Значение);
	КонецЕсли;
		
	Запрос.УстановитьПараметр("Родители", Родители);
	Запрос.УстановитьПараметр("РаспространитьНаПодчиненных", Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.РаспространитьНаПодчиненных);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		Запись = ПраваДоступаПользователей.Добавить();
		ЗаполнитьЗначенияСвойств(Запись, Выборка,,"ОбъектДоступа, ВидНаследованияПравДоступаИерархическихСправочников");
		Запись.ОбъектДоступа = ОбъектДоступа;
		Запись.ВидНаследованияПравДоступаИерархическихСправочников = Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.НаследуетсяОтРодителя;
	КонецЦикла;
	
КонецПроцедуры // () 

Процедура ПередЗаписьюНовогоОбъектаСПравамиДоступаПользователей(ЭтотОбъект, Отказ, Родитель, СсылкаНового = Неопределено) Экспорт

	Если ЭтотОбъект.ЭтоНовый() Тогда
		
		СсылкаНового = ЭтотОбъект.ПолучитьСсылкуНового();
		Если НЕ ЗначениеЗаполнено(СсылкаНового) Тогда
			СсылкаНового = Справочники[ЭтотОбъект.Метаданные().Имя].ПолучитьСсылку();
		КонецЕсли;
		
		ПолныеПрава.ЗарегистрироватьПраваДоступаПользователяКОбъекту(СсылкаНового, Родитель, Отказ);
		
		Если НЕ Отказ И НЕ ЗначениеЗаполнено(ЭтотОбъект.ПолучитьСсылкуНового()) Тогда
			ЭтотОбъект.УстановитьСсылкуНового(СсылкаНового);
		КонецЕсли; 	
		
	КонецЕсли;

КонецПроцедуры

Функция СравнитьТаблицыНаборовЗаписей(ТаблицаЗначений1, ТаблицаЗначений2) Экспорт

	Если ТипЗнч(ТаблицаЗначений1) <> Тип("ТаблицаЗначений") ИЛИ ТипЗнч(ТаблицаЗначений2) <> Тип("ТаблицаЗначений") Тогда
		Возврат Ложь;
	КонецЕсли; 
	
	Если ТаблицаЗначений1.Количество() <> ТаблицаЗначений2.Количество() Тогда
		Возврат Ложь;
	КонецЕсли; 

	Если ТаблицаЗначений1.Колонки.Количество() <> ТаблицаЗначений2.Колонки.Количество() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Проверим поля
	Для каждого Колонка Из ТаблицаЗначений1.Колонки Цикл
		Если ТаблицаЗначений2.Колонки.Найти(Колонка.Имя) = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла; 
	Для каждого Колонка Из ТаблицаЗначений2.Колонки Цикл
		Если ТаблицаЗначений1.Колонки.Найти(Колонка.Имя) = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла; 
	
	// создадим индексы таблицы для поиска
	СтрокаИндекса = "";
	Для каждого Колонка Из ТаблицаЗначений1.Колонки Цикл
		Если СтрокаИндекса = "" Тогда
			СтрокаИндекса = Колонка.Имя;
		Иначе
			СтрокаИндекса = СтрокаИндекса + "," + Колонка.Имя;
		КонецЕсли;
	КонецЦикла;
	Если СтрокаИндекса<>"" Тогда
		ТаблицаЗначений2.Индексы.Добавить(СтрокаИндекса);
	КонецЕсли;
	
	// Проверим записи
	Для каждого СтрокаТаблицы Из ТаблицаЗначений1 Цикл
		СтруктураПоиска = Новый Структура;
		Для каждого Колонка Из ТаблицаЗначений1.Колонки Цикл
			СтруктураПоиска.Вставить(Колонка.Имя, СтрокаТаблицы[Колонка.Имя]);
		КонецЦикла;
		СтрокиТаблицы2 = ТаблицаЗначений2.НайтиСтроки(СтруктураПоиска);
		Если СтрокиТаблицы2.Количество() <> 1 Тогда
			Возврат Ложь;
		КонецЕсли; 
	КонецЦикла;
	
	// создадим индексы таблицы для поиска
	СтрокаИндекса = "";
	Для каждого Колонка Из ТаблицаЗначений2.Колонки Цикл
		Если СтрокаИндекса = "" Тогда
			СтрокаИндекса = Колонка.Имя;
		Иначе
			СтрокаИндекса = СтрокаИндекса + "," + Колонка.Имя;
		КонецЕсли;
	КонецЦикла;
	Если СтрокаИндекса<>"" Тогда
		ТаблицаЗначений1.Индексы.Добавить(СтрокаИндекса);
	КонецЕсли;
	
	Для каждого СтрокаТаблицы Из ТаблицаЗначений2 Цикл
		СтруктураПоиска = Новый Структура;
		Для каждого Колонка Из ТаблицаЗначений2.Колонки Цикл
			СтруктураПоиска.Вставить(Колонка.Имя, СтрокаТаблицы[Колонка.Имя]);
		КонецЦикла;
		СтрокиТаблицы1 = ТаблицаЗначений1.НайтиСтроки(СтруктураПоиска);
		Если СтрокиТаблицы1.Количество() <> 1 Тогда
			Возврат Ложь;
		КонецЕсли; 
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции // СравнитьТаблицыЗначений()

/////////////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ ПРОЦЕДУРЫ И ФУНКЦИИ ОБСЛУЖИВАНИЯ МЕХАНИЗМА НАСТРОЙКИ ПРАВ ДОСТУПА

Процедура УстановитьЗначенияДляНовойСтрокиПравДоступа(Элемент, НоваяСтрока, ЭтоГруппа = Ложь) Экспорт

	Если НоваяСтрока И Элемент.ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(Элемент.ОтборСтрок.ОбластьДанных.Значение) Тогда
		Элемент.ТекущиеДанные.ОбластьДанных = Элемент.ОтборСтрок.ОбластьДанных.Значение;
		Если ЭтоГруппа Тогда
			Элемент.ТекущиеДанные.ВидНаследованияПравДоступаИерархическихСправочников = Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.РаспространитьНаПодчиненных;
		Иначе
			Элемент.ТекущиеДанные.ВидНаследованияПравДоступаИерархическихСправочников = Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.ТолькоДляТекущегоПрава;
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

/////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБСЛУЖИВАЮЩИЕ СОБЫТИЯ ЭЛЕМЕНТОВ УПРАВЛЕНИЯ ФОРМ

#Если Клиент Тогда

Процедура ПриВыводеСтрокиПраваДоступа(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт

	ОформлениеСтроки.Ячейки.Чтение.УстановитьФлажок(Истина);
	ОформлениеСтроки.Ячейки.Запись.ОтображатьТекст = Ложь;

КонецПроцедуры

#КонецЕсли

Функция ПолучитьСписокДоступныхДляРедактированияВидовНаследованияПравДоступа() Экспорт

	СписокПеречисления = Новый СписокЗначений;
	СписокПеречисления.Добавить(Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.ТолькоДляТекущегоПрава);
	СписокПеречисления.Добавить(Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.РаспространитьНаПодчиненных);
	Возврат СписокПеречисления;

КонецФункции

Функция ПолучитьСписокДоступныхДляРедактированияВидовНаследованияПравДоступаЭлемента() Экспорт

	СписокПеречисления = Новый СписокЗначений;
	СписокПеречисления.Добавить(Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.ТолькоДляТекущегоПрава);
	Возврат СписокПеречисления;

КонецФункции

Функция ПолучитьСписокДоступныхДляРедактированияВидовНаследованияПравДоступаГруппы() Экспорт

	СписокПеречисления = Новый СписокЗначений;
	СписокПеречисления.Добавить(Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.РаспространитьНаПодчиненных);
	Возврат СписокПеречисления;

КонецФункции

Функция ПолучитьСписокДоступныхДляРедактированияВидовНаследованияПравДоступаВФормеПользователя(ОбъектДоступа) Экспорт

	СписокПеречисления = Новый СписокЗначений;
	Если Справочники.ТипВсеСсылки().СодержитТип(ТипЗнч(ОбъектДоступа)) Тогда
		Если НЕ ЗначениеЗаполнено(ОбъектДоступа) Тогда
			СписокПеречисления.Добавить(Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.ТолькоДляТекущегоПрава);
		Иначе
			Если ОбъектДоступа.Метаданные().Иерархический Тогда
				Если ОбъектДоступа.Метаданные().ВидИерархии = Метаданные.СвойстваОбъектов.ВидИерархии.ИерархияГруппИЭлементов Тогда
					Если ОбъектДоступа.ЭтоГруппа Тогда
						СписокПеречисления.Добавить(Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.РаспространитьНаПодчиненных);
					Иначе
						СписокПеречисления.Добавить(Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.ТолькоДляТекущегоПрава);
					КонецЕсли; 
				Иначе
					СписокПеречисления.Добавить(Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.ТолькоДляТекущегоПрава);
					СписокПеречисления.Добавить(Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.РаспространитьНаПодчиненных);
				КонецЕсли; 
			Иначе
				СписокПеречисления.Добавить(Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.ТолькоДляТекущегоПрава);
			КонецЕсли; 
		КонецЕсли; 
	Иначе
		СписокПеречисления.Добавить(Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.ТолькоДляТекущегоПрава);
	КонецЕсли; 
	Возврат СписокПеречисления;

КонецФункции

Функция ПолучитьИмяРеквизитаРодителяОбъектаДоступа(Ссылка) Экспорт

	Возврат "Родитель";

КонецФункции // () 

Функция ПолучитьМассивРодительскихЭлементов(Ссылка, МассивРодительскихЭлементов = Неопределено) Экспорт
	
	ИмяРеквизитаРодителя = ПолучитьИмяРеквизитаРодителяОбъектаДоступа(Ссылка);
	Если МассивРодительскихЭлементов = Неопределено Тогда
		МассивРодительскихЭлементов = Новый Массив;
	КонецЕсли;
	
	Если Не ИмяРеквизитаРодителя = "Родитель" или Ссылка.Метаданные().Иерархический Тогда
		ТекущийРодитель = Ссылка[ИмяРеквизитаРодителя];
		Пока ЗначениеЗаполнено(ТекущийРодитель) Цикл
			МассивРодительскихЭлементов.Добавить(ТекущийРодитель);
			ТекущийРодитель = ТекущийРодитель[ИмяРеквизитаРодителя];
		КонецЦикла; 
	КонецЕсли;
	
	Возврат МассивРодительскихЭлементов;
	
КонецФункции

/////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБСЛУЖИВАЮЩИЕ СОБЫТИЯ ЭЛЕМЕНТОВ УПРАВЛЕНИЯ ФОРМ

#Если Клиент Тогда

Процедура РедактироватьПраваДоступа(Ссылка) Экспорт

	Обработки.НастройкаПравДоступа.ПолучитьФорму("НастройкаПравДоступа",,Ссылка).Открыть();

КонецПроцедуры

#КонецЕсли

Функция ПолучитьСтруктуруОтборовНабораЗаписей(ПраваДоступаПользователей) Экспорт
	
	СтруктураОтбора = Новый Структура;
	
	Для каждого ЭлементОтбора Из ПраваДоступаПользователей.Отбор Цикл
		Если ЭлементОтбора.Использование Тогда
			СтруктураОтбора.Вставить(ЭлементОтбора.Имя, ЭлементОтбора.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтруктураОтбора;
	
КонецФункции

Функция ПолучитьВидОбъектаДоступа(ОбъектДоступа) Экспорт

	Если ТипЗнч(ОбъектДоступа) = Тип("СправочникСсылка.Организации") Тогда
		Возврат Перечисления.ВидыОбъектовДоступа.Организации;
	ИначеЕсли ТипЗнч(ОбъектДоступа) = Тип("СправочникСсылка.ГруппыДоступаККонтрагентам") Тогда
		Возврат Перечисления.ВидыОбъектовДоступа.Контрагенты;
	Иначе
		Возврат Перечисления.ВидыОбъектовДоступа.ПустаяСсылка();
	КонецЕсли;

КонецФункции

/////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ  - ОБРАБОТЧИКИ ПОДПИСОК НА СОБЫТИЯ МЕХАНИЗМА ДАТЫ ЗАПРЕТА РЕДАКТИРОВАНИЯ

// Проверка возможности записи данных документа с учетом даты запрета изменения данных (даты запрета редактирования)
//
Процедура ПередЗаписьюДокументаПроверкаДоступностиПериода(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПроверкаПериодаДокумента(Источник, Отказ, РежимЗаписи);
	#Если Клиент Тогда
		Если Отказ Тогда
			Сообщить("Редактирование данных этого периода запрещено. Изменения не могут быть записаны...", СтатусСообщения.Важное);
		КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры // ПередЗаписьюДокументаПроверкаДоступностиПериода()

// Проверка возможности записи (изменения) содержимого регистров с учетом даты запрета изменения данных (даты запрета редактирования)
//
Процедура ПередЗаписьюРегистраДатаЗапретаРедактированияПередЗаписью(Источник, Отказ, Замещение) Экспорт
	
	ПроверкаПериодаЗаписейРегистров(Источник, Отказ);
	Если Отказ Тогда
		#Если Клиент Тогда
			Сообщить("Редактирование данных этого периода запрещено. Изменения не могут быть записаны...", СтатусСообщения.Важное);
		#КонецЕсли
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписьюРегистраДатаЗапретаРедактированияПередЗаписью()

// Процедура проверки возможности записи (изменения) данных документа с учетом даты запрета изменения данных (даты запрета редактирования)
//
Процедура ПроверкаПериодаДокумента(ДокументОбъект, Отказ, РежимЗаписи = Неопределено)
	
	СоответствиеГраницЗапрета = ПараметрыСеанса.ГраницыЗапретаИзмененияДанных.Получить();
	
	// Для пользователя с полными правами проверок выполнять не нужно
	Если СоответствиеГраницЗапрета = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроверкиДокумента = ПолучитьПараметрыПроверкиДокумента(ДокументОбъект);
	
	Если Не ДокументОбъект.ЭтоНовый() Тогда
		СтараяВерсияДокумента = ПолучитьВерсиюДокументаПередИзменением(ДокументОбъект, ПараметрыПроверкиДокумента);
    	ПроверитьВерсиюДокумента(СтараяВерсияДокумента, ПараметрыПроверкиДокумента, СоответствиеГраницЗапрета, Отказ);
	КонецЕсли;
			
	Если Не Отказ Тогда
		ПроверитьВерсиюДокумента(ДокументОбъект, ПараметрыПроверкиДокумента, СоответствиеГраницЗапрета, Отказ, РежимЗаписи);
	КонецЕсли;
	
КонецПроцедуры // ПроверкаПериодаДокумента

// Функция возвращает из БД версию документа до его изменения
//
Функция ПолучитьВерсиюДокументаПередИзменением(ДокументОбъект, ПараметрыПроверкиДокумента)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ 
	|Дата" 
	+ ?(ПараметрыПроверкиДокумента.ЕстьОрганизация, "," + Символы.ПС + "Организация КАК Организация", "")
	+ ?(ПараметрыПроверкиДокумента.ЕстьУправленческийУчет, "," + Символы.ПС + "ОтражатьВУправленческомУчете КАК ОтражатьВУправленческомУчете", "")
	+ ?(ПараметрыПроверкиДокумента.ЕстьБухгалтерскийУчет, "," + Символы.ПС + "ОтражатьВБухгалтерскомУчете КАК ОтражатьВБухгалтерскомУчете", "")
	+ ?(ПараметрыПроверкиДокумента.ПроверятьПроведениеДокумента, "," + Символы.ПС + "Проведен КАК Проведен", "") + "	
	|ИЗ Документ." + ПараметрыПроверкиДокумента.МетаданныеДокумента.Имя + "
	|ГДЕ Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", ДокументОбъект.Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Возврат Выборка;
	
КонецФункции // ПолучитьВерсиюДокументаПередИзменением()

// Процедура проверки версии документа на нарушение даты запрета
//
Процедура ПроверитьВерсиюДокумента(ДокументОбъект, ПараметрыПроверкиДокумента, СоответствиеГраницЗапрета, Отказ, РежимЗаписи = Неопределено)
		
	Если ПараметрыПроверкиДокумента.ПроверятьПроведениеДокумента Тогда		
		ДокументПроведен = ДокументОбъект.Проведен ИЛИ ?(РежимЗаписи = Неопределено, ЛОЖЬ, РежимЗаписи = РежимЗаписиДокумента.Проведение);
		Если Не ДокументПроведен Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	// Не выполняется проверка дат запрета редактирования
	Если НЕ ПараметрыПроверкиДокумента.ПроверятьУправленческуюДатуЗапрета и
		НЕ ПараметрыПроверкиДокумента.ПроверятьРегламентированнуюДатуЗапрета Тогда
		
		Возврат;
	КонецЕсли;	
	
	// Проверка регламентированной даты запрета
	Если ПараметрыПроверкиДокумента.ПроверятьРегламентированнуюДатуЗапрета Тогда	
		ГраницаПоОрганизации = СоответствиеГраницЗапрета[ДокументОбъект.Организация];
		
		// Если регламентированная дата запрета для регламентного документа не определена
		// то используется общая дата запрета изменения данных
		Если ГраницаПоОрганизации = Неопределено Тогда
			ГраницаПоОрганизации = СоответствиеГраницЗапрета["ОбщаяДатаЗапретаРедактирования"];    
		КонецЕсли;
		
		Если НЕ ГраницаПоОрганизации = Неопределено 
			И ДокументОбъект.Дата <= ГраницаПоОрганизации	Тогда
			
			Отказ = Истина;			
		КонецЕсли;		
	КонецЕсли;		    
	
	// Проверка управленческой даты запрета
	Если ПараметрыПроверкиДокумента.ПроверятьУправленческуюДатуЗапрета Тогда        
		ГраницаПериода = СоответствиеГраницЗапрета[Справочники.Организации.ПустаяСсылка()];       
		// Если управленческая дата запрета для управленческого документа не определена
		// то используется общая дата запрета изменения данных
		Если ГраницаПоОрганизации = Неопределено Тогда
			ГраницаПоОрганизации = СоответствиеГраницЗапрета[Справочники.Организации.ПустаяСсылка()];    
		КонецЕсли;
		
		Если ГраницаПериода <> Неопределено Тогда
			
			Если ДокументОбъект.Дата <= ГраницаПериода Тогда
				Отказ = Истина;				
			КонецЕсли;         			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ПроверитьВерсиюДокумента()

// Функция возвращает структуру с параметрами проверки документа по умолчанию
//
Функция ПолучитьПараметрыПроверкиДокумента(ДокументОбъект)
	
	ПараметрыПроверкиДокумента = Новый Структура;
	МетаданныеДокумента = ДокументОбъект.Метаданные();
	
	ПараметрыПроверкиДокумента.Вставить("МетаданныеДокумента", МетаданныеДокумента);
	
	// если  в документе есть реквизит организация, дата запрета оперделяется с учетом организации
	ПараметрыПроверкиДокумента.Вставить("ЕстьОрганизация", 			(МетаданныеДокумента.Реквизиты.Найти("Организация") <> Неопределено));
	ПараметрыПроверкиДокумента.Вставить("ЕстьУправленческийУчет",	(МетаданныеДокумента.Реквизиты.Найти("ОтражатьВУправленческомУчете") <> Неопределено));
	ПараметрыПроверкиДокумента.Вставить("ЕстьБухгалтерскийУчет", 	(МетаданныеДокумента.Реквизиты.Найти("ОтражатьВБухгалтерскомУчете") <> Неопределено));
	
	// Если для документа проведение запрещено, проверка на дату запрета редактирования
	//проверяется без учета проведенности
	ПараметрыПроверкиДокумента.Вставить("ПроверятьПроведениеДокумента", (МетаданныеДокумента.Проведение = Метаданные.СвойстваОбъектов.Проведение.Разрешить));
		
	Если ЗаполнитьПараметрыПроверкиПоВидуДокумента(ДокументОбъект, ПараметрыПроверкиДокумента) Тогда
		Возврат ПараметрыПроверкиДокумента;
	КонецЕсли;
			
	ПараметрыПроверкиДокумента.Вставить("ПроверятьУправленческуюДатуЗапрета", 		(НЕ ПараметрыПроверкиДокумента.ЕстьОрганизация) или (ПараметрыПроверкиДокумента.ЕстьУправленческийУчет и ДокументОбъект["ОтражатьВУправленческомУчете"]));
	ПараметрыПроверкиДокумента.Вставить("ПроверятьРегламентированнуюДатуЗапрета", 	ПараметрыПроверкиДокумента.ЕстьОрганизация и (НЕ ПараметрыПроверкиДокумента.ЕстьБухгалтерскийУчет или ДокументОбъект["ОтражатьВБухгалтерскомУчете"]));	
	
	Возврат ПараметрыПроверкиДокумента;
	
КонецФункции // ПолучитьПараметрыПроверкиДокумента()

//Функция возвращает структуру параметров проверки документа для нетиповых случаев
//
Функция ЗаполнитьПараметрыПроверкиПоВидуДокумента(ДокументОбъект, ПараметрыПроверкиДокумента)
		
	Если ПараметрыПроверкиДокумента.МетаданныеДокумента.Имя = "ЗаказПокупателя" Тогда		
		ЗаполнитьПараметрыПроверкиДокументаЗаказПокупателя(ДокументОбъект, ПараметрыПроверкиДокумента);
	Иначе
		Возврат Ложь;
	КонецЕсли;	
	
	Возврат Истина;
	
КонецФункции // ЗаполнитьПараметрыПроверкиПоВидуДокумента()

// Процедура заполнения структуры параметров проверки для документа ЗаказПокупателя
//
Процедура ЗаполнитьПараметрыПроверкиДокументаЗаказПокупателя(ДокументОбъект, ПараметрыПроверкиДокумента)
	
	ПараметрыПроверкиДокумента.Вставить("ПроверятьУправленческуюДатуЗапрета", Истина);
	ПараметрыПроверкиДокумента.Вставить("ПроверятьРегламентированнуюДатуЗапрета", Ложь);
	
КонецПроцедуры // ЗаполнитьПараметрыПроверкиДокументаЗаказПокупателя()

// Процедура выполняет проверку возможности записи регистров сведений и регистров накопления
// с учетом даты запрета изменения данных (даты запрета редактирования)
//
Процедура ПроверкаПериодаЗаписейРегистров(НаборЗаписей, Отказ)
	
	СоответствиеГраницЗапрета = ПараметрыСеанса.ГраницыЗапретаИзмененияДанных.Получить();
	
	// Для пользователя с полными правами проверок выполнять не нужно
	Если СоответствиеГраницЗапрета = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МетаданныеНабора = НаборЗаписей.Метаданные();		
	ЕстьОрганизация = (МетаданныеНабора.Измерения.Найти("Организация")<>Неопределено);
	
	
	// Проверку сущестствующих записей выполняем только для регистров сведений, подчиненных регистратору,
	// регистрам накопления и регистрам бухгалтерии.
	// Проверка необходима, так как удаление записей прошлого периода (в результате перезаписи набора)
	// тоже допускать нельзя.
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("СоответствиеГраницЗапрета", 	СоответствиеГраницЗапрета);
	СтруктураПараметров.Вставить("МетаданныеНабора", 			МетаданныеНабора);
	СтруктураПараметров.Вставить("ЕстьОрганизация", 			ЕстьОрганизация);
	
	Если Метаданные.РегистрыСведений.Содержит(МетаданныеНабора) И НЕ МетаданныеНабора.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.ПодчинениеРегистратору Тогда
		ПроверкаСуществующихЗаписейРегистраСОтборомПоИзмерениям(НаборЗаписей, СтруктураПараметров, Отказ);
	Иначе
		ПроверкаСуществующихЗаписейРегистра(НаборЗаписей, СтруктураПараметров, Отказ);
	КонецЕсли;
                  		
	Если НаборЗаписей.Количество() > 0 И НЕ Отказ Тогда				
		Отказ = Ложь;
		Если ЕстьОрганизация Тогда
			Для Каждого Запись ИЗ НаборЗаписей Цикл
				ГраницаПоОрганизации = СоответствиеГраницЗапрета[Запись.Организация];
				ЕСли ГраницаПоОрганизации <> Неопределено 
					 И Запись.Период <= ГраницаПоОрганизации Тогда
					Отказ = Истина;
					Возврат;
				КонецЕсли;
			КонецЦикла;
		Иначе
			ГраницаПериода = СоответствиеГраницЗапрета[Справочники.Организации.ПустаяСсылка()];
			Если ГраницаПериода <> Неопределено Тогда
				Для Каждого Запись ИЗ НаборЗаписей Цикл
					ЕСли Запись.Период <= ГраницаПериода Тогда
						Отказ = Истина;
						Возврат;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;		
	КонецЕсли;
КонецПроцедуры // ПроверкаПериодаЗаписейРегистров

Процедура ПроверкаСуществующихЗаписейРегистра(НаборЗаписей, СтруктураПараметров, Отказ)
	
	ИмяРегистра = СтруктураПараметров.МетаданныеНабора.ПолноеИмя();
	
	Запрос = Новый Запрос;
	ВложенныйЗапрос = "";
	ЕСли СтруктураПараметров.ЕстьОрганизация Тогда
		индекс = 1;
		ИмяПоляОрганизации = "Организация";
		Для Каждого КлючИЗначение ИЗ СтруктураПараметров.СоответствиеГраницЗапрета Цикл
			ВложенныйЗапрос = ВложенныйЗапрос + ?(ВложенныйЗапрос = "", "", "
			|ОБЪЕДИНИТЬ ВСЕ") +"
			|ВЫБРАТЬ &Организация"+индекс+" КАК Организация, &ДатаЗапрета" + Формат(индекс, "ЧГ=0") + " КАК ДатаЗапрета";
			Запрос.УстановитьПараметр("Организация" + Индекс, КлючИЗначение.Ключ);
			ГраницаПериода = КлючИЗначение.Значение;
			Запрос.УстановитьПараметр("ДатаЗапрета" + Индекс, ?(ГраницаПериода = Неопределено, NULL, ГраницаПериода));
			Индекс = Индекс + 1;
		КонецЦикла;
	Иначе
		ПустаяОрганизация = Справочники.Организации.ПустаяСсылка();
		ИмяПоляОрганизации = "&ПустаяОрганизация";
		ВложенныйЗапрос = "ВЫБРАТЬ &ПустаяОрганизация КАК Организация, &ДатаЗапрета КАК ДатаЗапрета";
		Запрос.УстановитьПараметр("ПустаяОрганизация", ПустаяОрганизация);
		ГраницаПериода = СтруктураПараметров.СоответствиеГраницЗапрета[ПустаяОрганизация];
		Запрос.УстановитьПараметр("ДатаЗапрета", ?(ГраницаПериода = Неопределено, NULL, ГраницаПериода));			
	КонецЕсли;			
	
	Запрос.Текст = "
	|ВЫБРАТЬ ПЕРВЫЕ 1 1
	|ИЗ
	|(
	|ВЫБРАТЬ " + ИмяПоляОрганизации + " КАК Организация, МИНИМУМ(Период) КАК Период  ИЗ " + ИмяРегистра + " КАК Набор
	|ГДЕ Регистратор = &Регистратор
	|СГРУППИРОВАТЬ ПО " + ИмяПоляОрганизации + "
	|) КАК НаборЗаписей
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|(" + ВложенныйЗапрос + "		
	|) КАК ДатыЗапрета
	|ПО НаборЗаписей.Организация = ДатыЗапрета.Организация
	|ГДЕ НаборЗаписей.Период <= ДатыЗапрета.ДатаЗапрета ИЛИ ДатыЗапрета.ДатаЗапрета ЕСТЬ NULL";
	Запрос.УстановитьПараметр("Регистратор", НаборЗаписей.Отбор.Регистратор.Значение);				

	Если НЕ Запрос.Выполнить().Пустой() Тогда
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры // ПроверкаСуществующихЗаписейРегистра()

Процедура ПроверкаСуществующихЗаписейРегистраСОтборомПоИзмерениям(НаборЗаписей, СтруктураПараметров, Отказ)
	
    ИмяРегистра = СтруктураПараметров.МетаданныеНабора.ПолноеИмя();
    
    // Формируем текст условия блока ГДЕ основного запроса,
    // в соответствии с установленным отбором для набора записей
    
    Запрос = Новый Запрос;
       
    СписокПолейУсловияОтбораТекст = "";
    Итерация = 0;
    Для каждого ЭлементОтбора Из НаборЗаписей.Отбор Цикл                
        Если не ЭлементОтбора.Использование Тогда
            Продолжить;
        КонецЕсли;                
        
        Если НЕ Итерация = 0  Тогда            
            СписокПолейУсловияОтбораТекст = СписокПолейУсловияОтбораТекст  + " И ";
        КонецЕсли;        
        
        СписокПолейУсловияОтбораТекст = СписокПолейУсловияОтбораТекст +" Набор." + ЭлементОтбора.Имя + " = &" + ЭлементОтбора.Имя;                       
        Запрос.УстановитьПараметр(ЭлементОтбора.Имя, ЭлементОтбора.Значение);        
        
        Итерация = 1;
    КонецЦикла; 
    
    Если Итерация = 1 Тогда
        СписокПолейУсловияОтбораТекст = " ГДЕ " + СписокПолейУсловияОтбораТекст;    	            
    КонецЕсли;                   
    
    ВложенныйЗапрос = "";
    Если СтруктураПараметров.ЕстьОрганизация Тогда
    	Индекс = 1;
    	ИмяПоляОрганизации = "Организация";
    	Для Каждого КлючИЗначение ИЗ СтруктураПараметров.СоответствиеГраницЗапрета Цикл
    		ВложенныйЗапрос = ВложенныйЗапрос + ?(ВложенныйЗапрос = "", "", "
    		|ОБЪЕДИНИТЬ ВСЕ") +"
    		|ВЫБРАТЬ &Организация" + Индекс + " КАК Организация, &ДатаЗапрета" + Формат(Индекс, "ЧГ=0") + " КАК ДатаЗапрета";
    		Запрос.УстановитьПараметр("Организация" + Индекс, КлючИЗначение.Ключ);
    		ГраницаПериода = КлючИЗначение.Значение;
    		Запрос.УстановитьПараметр("ДатаЗапрета" + Индекс, ?(ГраницаПериода = Неопределено, NULL, ГраницаПериода));
    		Индекс = Индекс + 1;
    	КонецЦикла;
    Иначе
    	ПустаяОрганизация = Справочники.Организации.ПустаяСсылка();
    	ИмяПоляОрганизации = "&ПустаяОрганизация";
    	ВложенныйЗапрос = "ВЫБРАТЬ &ПустаяОрганизация КАК Организация, &ДатаЗапрета КАК ДатаЗапрета";
    	Запрос.УстановитьПараметр("ПустаяОрганизация", ПустаяОрганизация);
    	ГраницаПериода = СтруктураПараметров.СоответствиеГраницЗапрета[ПустаяОрганизация];
    	Запрос.УстановитьПараметр("ДатаЗапрета", ?(ГраницаПериода = Неопределено, NULL, ГраницаПериода));			
    КонецЕсли;			    
    
    
    Запрос.Текст = "
    |ВЫБРАТЬ ПЕРВЫЕ 1 1
    |ИЗ
    |(
    |ВЫБРАТЬ " + ИмяПоляОрганизации + " КАК Организация, МИНИМУМ(Период) КАК Период  ИЗ " + ИмяРегистра + " КАК Набор
    | "+ СписокПолейУсловияОтбораТекст + "
    |СГРУППИРОВАТЬ ПО " + ИмяПоляОрганизации + "
    |) КАК НаборЗаписей
    |ЛЕВОЕ СОЕДИНЕНИЕ
    |(" + ВложенныйЗапрос + "		
    |) КАК ДатыЗапрета
    |ПО НаборЗаписей.Организация = ДатыЗапрета.Организация
    |ГДЕ НаборЗаписей.Период <= ДатыЗапрета.ДатаЗапрета ИЛИ ДатыЗапрета.ДатаЗапрета ЕСТЬ NULL";      

	Если НЕ Запрос.Выполнить().Пустой() Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры // ПроверкаСуществующихЗаписейРегистраСОтборомПоИзмерениям()

Процедура  ОпределитьДоступностьВозможностьИзмененияДокументаПоДатеЗапрета(ДокументОбъект, ФормаДокумента) Экспорт
	
	СоответствиеГраницЗапрета = ПараметрыСеанса.ГраницыЗапретаИзмененияДанных.Получить();
	
	// Для пользователя с полными правами проверок выполнять не нужно
	Если СоответствиеГраницЗапрета = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроверкиДокумента = ПолучитьПараметрыПроверкиДокумента(ДокументОбъект);

	ПроверитьВерсиюДокумента(ДокументОбъект, ПараметрыПроверкиДокумента, СоответствиеГраницЗапрета, ФормаДокумента.ТолькоПросмотр);
	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ  - ОБРАБОТЧИКИ ПОДПИСОК НА СОБЫТИЯ МЕХАНИЗМА РЕГИСТРАЦИИ ОБЪЕКТОВ ПРАВ ДОСТУПА ДОКУМЕНТОВ

Процедура ПриЗаписиДокументаРегистрацияОбъектовПравДоступа(Источник, Отказ) Экспорт

	// Соберем данные для регистрации.
	ТаблицаСвойств = ПолучитьТаблицуСвойствДляРегистрацииОбъектовДоступаДокумента(Источник.Метаданные());

	Если ТаблицаСвойств.Количество() <> 0 Тогда

		// Теперь зарегистрируем данные объекта.
		ОбъектыДоступа = Новый Массив;
		Для каждого СтрокаТЗ Из ТаблицаСвойств Цикл
			ОбъектыДоступа.Добавить(?(ПустаяСтрока(СтрокаТЗ.ИмяТЧ), Источник[СтрокаТЗ.ИмяСвойства], Источник[СтрокаТЗ.ИмяТЧ].ВыгрузитьКолонку(СтрокаТЗ.ИмяСвойства)));
		КонецЦикла;
		
		Если Источник.ДополнительныеСвойства.Свойство("ПараметрыЗаписиОбъектовДоступа") Тогда
			Замещать = Источник.ДополнительныеСвойства.ПараметрыЗаписиОбъектовДоступа.Замещать;
		Иначе
			Замещать = Истина;
		КонецЕсли;

		ПолныеПрава.РегистрацияОбъектовДоступаДокумента(Источник.Ссылка, ОбъектыДоступа);
	КонецЕсли;

КонецПроцедуры // ПриЗаписиДокументаРегистрацияОбъектовПравДоступа()

// Функция формирует таблицу значений, содержащую имена реквизитов, через которые
// ограничивается доступ с документу.
//
// Параметры:
//  МетаданныеДокумента - метаданные документа.
//
// Возвращаемое значение:
//  ТаблицаЗначений - сформированная таблица значений.
//
Функция ПолучитьТаблицуСвойствДляРегистрацииОбъектовДоступаДокумента(МетаданныеДокумента) Экспорт

	СоответствиеДанных = ПараметрыСеанса.МетаданныеДокументовРегистрацииОбъектовДоступа.Получить();
	ИскомыйКлюч = Тип("ДокументСсылка." + МетаданныеДокумента.Имя);

	ИскомоеЗначение = СоответствиеДанных[ИскомыйКлюч];
	Если ИскомоеЗначение = Неопределено Тогда // данных по этому документу нет
		МассивИскомыхТипов = СоответствиеДанных["ТипыОбъектовДоступа"];

		ТаблицаСвойств = Новый ТаблицаЗначений;
		ТаблицаСвойств.Колонки.Добавить("ИмяТЧ");
		ТаблицаСвойств.Колонки.Добавить("ИмяСвойства");

		// Обработаем реквизиты шапки.
		РеквизитыДокумента = МетаданныеДокумента.Реквизиты;
		Для каждого Реквизит Из РеквизитыДокумента Цикл
			ОписаниеТиповРеквизита = Реквизит.Тип;
			Для каждого ИскомыйТип Из МассивИскомыхТипов Цикл
				Если ОписаниеТиповРеквизита.СодержитТип(ИскомыйТип) Тогда
					НоваяСтрока = ТаблицаСвойств.Добавить();
					НоваяСтрока.ИмяТЧ = "";
					НоваяСтрока.ИмяСвойства = Реквизит.Имя;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;

		// Обработаем табличные части.
		ТабличныеЧастиДокумента = МетаданныеДокумента.ТабличныеЧасти;
		Для каждого ТЧ Из ТабличныеЧастиДокумента Цикл
			РеквизитыТЧДокумента = ТЧ.Реквизиты;
			Для каждого Реквизит Из РеквизитыТЧДокумента Цикл
				ОписаниеТиповРеквизита = Реквизит.Тип;
				Для каждого ИскомыйТип Из МассивИскомыхТипов Цикл
					Если ОписаниеТиповРеквизита.СодержитТип(ИскомыйТип) Тогда
						НоваяСтрока = ТаблицаСвойств.Добавить();
						НоваяСтрока.ИмяТЧ = ТЧ.Имя;
						НоваяСтрока.ИмяСвойства = Реквизит.Имя;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;

		СоответствиеДанных.Вставить(ИскомыйКлюч, ТаблицаСвойств);

		ПараметрыСеанса.МетаданныеДокументовРегистрацииОбъектовДоступа = Новый ХранилищеЗначения(СоответствиеДанных);
	Иначе
		ТаблицаСвойств = ИскомоеЗначение;
	КонецЕсли;

	Возврат ТаблицаСвойств;

КонецФункции // ПолучитьТаблицуСвойствДляРегистрацииОбъектовДоступаДокумента()

Процедура ПередЗаписьюДокументаРегистрацияОбъектовПравДоступа(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	ДополнительныеСвойства = Источник.ДополнительныеСвойства;
	ДополнительныеСвойства.Вставить("ПараметрыЗаписиОбъектовДоступа", Новый Структура("Замещать"));
	ДополнительныеСвойства.ПараметрыЗаписиОбъектовДоступа.Замещать = НЕ Источник.ЭтоНовый();
КонецПроцедуры

#Если Клиент Тогда

Процедура РедактироватьДополнительныеПраваПользователей() Экспорт

	РегистрыСведений.ЗначенияДополнительныхПравПользователя.ПолучитьФорму("ФормаРедактирования").Открыть();

КонецПроцедуры

#КонецЕсли
