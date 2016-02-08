﻿
// Возвращает структуру данных со сводным описанием контрагента
//
// Параметры: 
//  СписокСведений - список значений со значенийми параметров организации
//   СписокСведений формируется функцией СведенияОЮрФизЛице
//  Список         - список запрашиваемых параметров организаиии
//  СПрефиксом     - Признак выводить или нет префикс параметра организации
//
// Возвращаемое значение:
//  Строка - описатель организации / контрагента / физ.лица.
//
Функция ОписаниеОрганизации(СписокСведений, Знач Список = "", СПрефиксом = Истина) Экспорт

	Если ПустаяСтрока(Список) Тогда
		Список = "ПолноеНаименование,ИНН,ЮридическийАдрес,Телефоны,НомерСчета,Банк,БИК,КоррСчет,Факс,ЭлПочта,ПочтовыйАдрес";
	КонецЕсли;

	Результат = "";

	СоответствиеПараметров = Новый Соответствие();
	СоответствиеПараметров.Вставить("ПолноеНаименование", " ");
	СоответствиеПараметров.Вставить("ИНН",                " ИНН ");
	СоответствиеПараметров.Вставить("КПП",                " КПП ");
	СоответствиеПараметров.Вставить("Свидетельство",			" ");
	СоответствиеПараметров.Вставить("СвидетельствоДатаВыдачи",	" от ");
	СоответствиеПараметров.Вставить("ЮридическийАдрес",   " ");
	СоответствиеПараметров.Вставить("ФактическийАдрес",   " ");
	СоответствиеПараметров.Вставить("ПочтовыйАдрес",      " ");
	СоответствиеПараметров.Вставить("Телефоны",           " тел.: ");
	СоответствиеПараметров.Вставить("НомерСчета",         " р/с ");
	СоответствиеПараметров.Вставить("Банк",               " в банке ");
	СоответствиеПараметров.Вставить("БИК",                " БИК ");
	СоответствиеПараметров.Вставить("КоррСчет",           " к/с ");
	СоответствиеПараметров.Вставить("КодПоОКПО",          " Код по ОКПО ");
	СоответствиеПараметров.Вставить("Факс",               " факс.: ");
	СоответствиеПараметров.Вставить("ЭлПочта",            " E-mail: ");

	Список          = Список + ?(Прав(Список, 1) = ",", "", ",");
	ЧислоПараметров = СтрЧислоВхождений(Список, ",");

	Для Счетчик = 1 по ЧислоПараметров Цикл

		ПозЗапятой = Найти(Список, ",");

		Если ПозЗапятой > 0  Тогда
			ИмяПараметра = Лев(Список, ПозЗапятой - 1);
			Список = Сред(Список, ПозЗапятой + 1, СтрДлина(Список));

			Попытка
				СтрокаДополнения = "";
				СписокСведений.Свойство(ИмяПараметра, СтрокаДополнения);

				Если ПустаяСтрока(СтрокаДополнения) Тогда
					Продолжить;
				КонецЕсли;

				Префикс = СоответствиеПараметров[ИмяПараметра];
				Если Не ПустаяСтрока(Результат)  Тогда
					Результат = Результат + ",";
				КонецЕсли; 

				Результат = Результат + ?(СПрефиксом = Истина, Префикс, "") + СтрокаДополнения;
			Исключение
				#Если Клиент Тогда
					Сообщить("Не удалось определить значение параметра организации: " + ИмяПараметра, СтатусСообщения.Внимание);
				#КонецЕсли
			КонецПопытки;

		КонецЕсли;

	КонецЦикла;

	Возврат СокрЛП(Результат);

КонецФункции // ОписаниеОрганизации()

// Функция собирает фамилию, имя и отчество физ. лица на указанную дату
//
// Параметры: 
//  ФизЛицо.    - физ. лицо, для которго необходимо получить данные
//  ДатаПериода - дата получения сведений
//
// Возвращаемое значение:
//  Структура с данными.
//
Функция ФамилияИмяОтчество(ФизЛицо, ДатаПериода) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПарФизЛицо",     ФизЛицо);
	Запрос.УстановитьПараметр("ПарДатаПериода", ДатаПериода);

	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Фамилия,
	|	Имя,
	|	Отчество
	|ИЗ
	|	РегистрСведений.ФИОФизЛиц.СрезПоследних(&ПарДатаПериода, ФизЛицо = &ПарФизЛицо)
	|";

	Шапка = Запрос.Выполнить().Выбрать();
	Шапка.Следующий();

	Результат = Новый Структура("Фамилия, Имя, Отчество");

	Результат.Фамилия  = ?(НЕ ЗначениеЗаполнено(Шапка.Фамилия),  "", Шапка.Фамилия);
	Результат.Имя      = ?(НЕ ЗначениеЗаполнено(Шапка.Имя),      "", Шапка.Имя);
	Результат.Отчество = ?(НЕ ЗначениеЗаполнено(Шапка.Отчество), "", Шапка.Отчество);

	Возврат Результат;

КонецФункции // ФамилияИмяОтчество()

// Формирует описание серий и характеристик ТМЦ для печати
//
// Параметры
//  Выборка  – <ВыборкаИзРезультатаЗапроса > – Исходные данные
//
// Возвращаемое значение:
//   Строка - Описание серий и характеристик ТМЦ
//
Функция ПредставлениеСерий(Выборка) Экспорт

	Результат = "(";

	Если ЗначениеЗаполнено(Выборка.Характеристика) Тогда
		Результат = Результат + Выборка.Характеристика;
	КонецЕсли;

	Если ЗначениеЗаполнено(Выборка.Серия) Тогда
		Результат = ?(Результат = "(", Результат, Результат + "; ");
		Результат = Результат + Выборка.Серия;
	КонецЕсли;

	Результат = Результат + ")";

	Возврат ?(Результат = "()", "", " " + Результат)

КонецФункции // ПредставлениеСерий()

// Стандартная для данной конфигурации функция форматирования прописи количества
//
// Параметры: 
//  Количество - число, которое мы хотим форматировать
//
// Возвращаемое значение:
//  Отформатированная должным образом строковое представление количества.
//
Функция КоличествоПрописью(Количество) Экспорт

	ЦелаяЧасть   = Цел(Количество);
	ДробнаяЧасть = Окр(Количество - ЦелаяЧасть, 3);

	Если ДробнаяЧасть = Окр(ДробнаяЧасть,0) Тогда
		ПараметрыПрописи = ", , , , , , , , 0";
	ИначеЕсли ДробнаяЧасть = Окр(ДробнаяЧасть, 1) Тогда
		ПараметрыПрописи = "целая, целых, целых, ж, десятая, десятых, десятых, м, 1";
	ИначеЕсли ДробнаяЧасть = Окр(ДробнаяЧасть, 2) Тогда
		ПараметрыПрописи = "целая, целых, целых, ж, сотая, сотых, сотых, м, 2";
	Иначе
		ПараметрыПрописи = "целая, целых, целых, ж, тысячная, тысячных, тысячных, м, 3";
	КонецЕсли;

	Возврат ЧислоПрописью(Количество, ,ПараметрыПрописи);

КонецФункции // КоличествоПрописью()

// Функция собирает подразделение и должность физ. лица на указанную дату
//
// Параметры: 
//  ФизЛицо.    - физ. лицо, для которго необходимо получить данные
//  ДатаПериода - дата получения сведений
//  Организация - организация, для которой необходимо получить данные
//
// Возвращаемое значение:
//  Структура с данными.
//
Функция ДолжностьОтветственногоЛицаОрганизации(ФизЛицо, ДатаПериода, Организация) Экспорт

	Результат = Новый Структура("Должность");

	Если ЗначениеЗаполнено(Организация) Тогда
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ФизЛицо"    , ФизЛицо);
		Запрос.УстановитьПараметр("ДатаПериода", ДатаПериода);
		Запрос.УстановитьПараметр("Организация", Организация);

		Запрос.Текст = "
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	Должность.Представление КАК Должность
		|ИЗ
		|	РегистрСведений.ОтветственныеЛицаОрганизации.СрезПоследних(&ДатаПериода, СтруктурнаяЕдиница = &Организация)
		|ГДЕ
		|	ФизическоеЛицо = &ФизЛицо
		|";

		Шапка = Запрос.Выполнить().Выбрать();
		Если Шапка.Следующий() Тогда
			Результат.Должность = Шапка.Должность;
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;

КонецФункции // ДолжностьОтветственногоЛицаОрганизации()

// Функция расчитывает ширину области в табличном докумете
//
// Параметры:
//  ИмяОбласти    - Строка, имя области для которой необходимо получить ширину
//  Макет - Табличный документ
//
// Возвращаемое значение:
//  число
//
Функция РасчетШириныОбластиМакета(ИмяОбласти, Макет) Экспорт
	
	ШиринаКолонки = 0;

	НизМест = Макет.Область(ИмяОбласти).Низ;

	Для Сч = Макет.Область(ИмяОбласти).Лево По Макет.Область(ИмяОбласти).Право Цикл
		ШиринаКолонки = ШиринаКолонки + Макет.Область(, Сч, НизМест).ШиринаКолонки;
	КонецЦикла;
	возврат ШиринаКолонки;

КонецФункции

// Формируется текст плательщика или получателя для печатной формы платежного документа
//
// Параметры
//  ТекстНаименования  	– <строка> – значение реквизита документа, если реквизит заполнен, он и выводится на печать
//  ВладелецСчета  		– <СправочникСсылка.Организации>/<СправочникСсылка.Контрагенты> – владелец банковского счета
//  БанковскийСчет		– <СправочникСсылка.БанковскиеСчета> – банковский счет плательщика или получателя
//  ВБюджет				– <Булево> – признак перечисления денежных средств в бюджет
//
// Возвращаемое значение:
//   <Строка>			– наименование плательщика или получателя, которое будет выводиться в печатной форме платежного документа
//
Функция СформироватьТекстНаименованияПлательшикаПолучателя(ТекстНаименования, ВладелецСчета, БанковскийСчет, ВБюджет = Ложь) Экспорт
	
	ТекстРезультат = ТекстНаименования;
	Если ПустаяСтрока(ТекстРезультат) Тогда
		
		Если ТипЗнч(ВладелецСчета) = Тип("СправочникСсылка.Организации") 
		  И ВБюджет 
		  И НЕ ПустаяСтрока(ВладелецСчета.НаименованиеПлательщикаПриПеречисленииНалогов) Тогда
		  
			ТекстРезультат = ВладелецСчета.НаименованиеПлательщикаПриПеречисленииНалогов;
			
		ИначеЕсли ПустаяСтрока(БанковскийСчет.ТекстКорреспондента) Тогда
			
			ТекстРезультат = ?(ПустаяСтрока(ВладелецСчета.НаименованиеПолное), 
			                   ВладелецСчета.Наименование, ВладелецСчета.НаименованиеПолное);
			Если ЗначениеЗаполнено(БанковскийСчет.БанкДляРасчетов) Тогда
				ТекстРезультат = ТекстРезультат + " р/с " + БанковскийСчет.НомерСчета
				+ " в " + БанковскийСчет.Банк + " " + БанковскийСчет.Банк.Город;
			КонецЕсли;	
			
		Иначе
			
			ТекстРезультат = БанковскийСчет.ТекстКорреспондента;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ТекстРезультат;
	
КонецФункции // СформироватьТекстНаименованияПлательшикаПолучателя()

// Формирует значения по умолчанию реквизитов плательщика и получателя для банковских платежных документов
//
// Параметры
//  Плательщик  		– <СправочникСсылка.Организации>/<СправочникСсылка.Контрагенты> – плательщик, владелец банковского счета
//  СчетПлательщика		– <СправочникСсылка.БанковскиеСчета> – банковский счет плательщика
//  Получатель  		– <СправочникСсылка.Организации>/<СправочникСсылка.Контрагенты> – получатель, владелец банковского счета
//  СчетПолучателя		– <СправочникСсылка.БанковскиеСчета> – банковский счет получателя
//  ВидОперации			– <Перечисление.ВидыОпераций...> – вид операции документа
//
// Возвращаемое значение:
//   <Структура>		– структура строковых реквизитов плательщика и получателя
//						  ключи структуры: 
//							ТекстПлательщика, ИННПлательщика, КПППлательщика, 
//							ТекстПолучателя, ИННПолучателя, КПППолучателя
//							НаименованиеБанкаПлательщика, НомерСчетаПлательщика, БикБанкаПлательщика, СчетБанкаПлательщика 
//							НаименованиеБанкаПолучателя, НомерСчетаПолучателя, БикБанкаПолучателя, СчетБанкаПолучателя
//
Функция СформироватьАвтоЗначенияРеквизитовПлательщикаПолучателя(Плательщик, СчетПлательщика, Получатель, СчетПолучателя, ВидОперации, ПеречислениеВБюджет = Ложь) Экспорт

	ЗначенияРеквизитов = Новый Структура;
	
	ВБюджет = (ВидОперации = Перечисления.ВидыОперацийППИсходящее.ПеречислениеНалога)
		ИЛИ ПеречислениеВБюджет;
		
	ЗначенияРеквизитов.Вставить("ТекстПлательщика", 
		СформироватьТекстНаименованияПлательшикаПолучателя(
			"", Плательщик, СчетПлательщика, ВБюджет));
	
	ЗначенияРеквизитов.Вставить("ИННПлательщика", Плательщик.ИНН);

	УказаниеКППплательщикаОбязательно = ВБюджет;
	
	ЗначенияРеквизитов.Вставить("КПППлательщика", 
		?(УказаниеКППплательщикаОбязательно, 
		?(НЕ ПустаяСтрока(Плательщик.КПП), Плательщик.КПП, "0"), 
		""));
									
	Если ВидОперации = Перечисления.ВидыОперацийППИсходящее.ПереводНаДругойСчет Тогда
		ВладелецСчетаПолучателя = Плательщик;
	Иначе
		ВладелецСчетаПолучателя = Получатель;
	КонецЕсли;
	
	ЗначенияРеквизитов.Вставить("ТекстПолучателя", 
		СформироватьТекстНаименованияПлательшикаПолучателя(
			"", ВладелецСчетаПолучателя, СчетПолучателя, ВБюджет));
	
	ЗначенияРеквизитов.Вставить("ИННПолучателя", ВладелецСчетаПолучателя.ИНН);

	УказаниеКППполучателяОбязательно = ВБюджет;
	
	ЗначенияРеквизитов.Вставить("КПППолучателя", 
		?(УказаниеКППполучателяОбязательно, 
		?(НЕ ПустаяСтрока(ВладелецСчетаПолучателя.КПП), ВладелецСчетаПолучателя.КПП, "0"), 
		""));
								
	НепрямыеРасчетыУПлательщика = ЗначениеЗаполнено(СчетПлательщика.БанкДляРасчетов);
	БанкПлательщика = 
		?(НепрямыеРасчетыУПлательщика, СчетПлательщика.БанкДляРасчетов, СчетПлательщика.Банк);
	ЗначенияРеквизитов.Вставить("НаименованиеБанкаПлательщика", 
		БанкПлательщика.Наименование + " " + БанкПлательщика.Город);
	ЗначенияРеквизитов.Вставить("НомерСчетаПлательщика", 
		?(НепрямыеРасчетыУПлательщика, СчетПлательщика.Банк.КоррСчет, СчетПлательщика.НомерСчета));
	ЗначенияРеквизитов.Вставить("БикБанкаПлательщика", БанкПлательщика.Код);
	ЗначенияРеквизитов.Вставить("СчетБанкаПлательщика", БанкПлательщика.КоррСчет);
									
	НепрямыеРасчетыУПолучателя = ЗначениеЗаполнено(СчетПолучателя.БанкДляРасчетов);
	БанкПолучателя = 
		?(НепрямыеРасчетыУПолучателя, СчетПолучателя.БанкДляРасчетов, СчетПолучателя.Банк);
	ЗначенияРеквизитов.Вставить("НаименованиеБанкаПолучателя", 
		БанкПолучателя.Наименование + " " + БанкПолучателя.Город);
	ЗначенияРеквизитов.Вставить("НомерСчетаПолучателя", 
		?(НепрямыеРасчетыУПолучателя, СчетПолучателя.Банк.КоррСчет, СчетПолучателя.НомерСчета));
	ЗначенияРеквизитов.Вставить("БикБанкаПолучателя", БанкПолучателя.Код);
	ЗначенияРеквизитов.Вставить("СчетБанкаПолучателя", БанкПолучателя.КоррСчет);
									
	Возврат ЗначенияРеквизитов;
	
КонецФункции //СформироватьАвтоЗначенияРеквизитовПлательщикаПолучателя()

// Проверяет, умещаются ли переданные табличные документы на страницу при печати.
//
// Параметры
//  ТабДокумент       – Табличный документ
//  ВыводимыеОбласти  – Массив из проверяемых таблиц или табличный документ
//  РезультатПриОшибке - Какой возвращать результат при возникновении ошибки
//
// Возвращаемое значение:
//   Булево   – умещаются или нет переданные документы
//
Функция ПроверитьВыводТабличногоДокумента(ТабДокумент, ВыводимыеОбласти, РезультатПриОшибке = Истина) Экспорт

	Попытка
		Возврат ТабДокумент.ПроверитьВывод(ВыводимыеОбласти);
	Исключение
		Возврат РезультатПриОшибке;
	КонецПопытки;

КонецФункции // ПроверитьВыводТабличногоДокумента()

#Если Клиент Тогда

// Заполняет список пунктов подменю выбора печатных форм значениями переданного соответствия.
// Всем кнопкам назначается одно переданное действие.
//
// Параметры:
//  ЭлементМеню            - кнопка командной панели формы, соответствующая подменю выбора печатных форм, 
//                           которое надо заполнить, 
//  СоответствиеМакетов    - соответствие, содержащее список макетов печатных форм 
//                           объекта для заполнения пунктов подменю, 
//  ОбъектОбработкиВыбора  - действие, которое надо выполнить при выборе любого пункта подменю.
//
Процедура УстановитьПодменюВыбораПечатнойФормы(ЭлементМеню, СписокМакетов, ОбъектОбработкиВыбора) Экспорт

	Если ТипЗнч(СписокМакетов) = Тип("Соответствие") Тогда
		Для каждого ЭлементЗаполнения Из СписокМакетов Цикл
			ЭлементМеню.Кнопки.Добавить(ЭлементЗаполнения.Значение, ТипКнопкиКоманднойПанели.Действие, 
			                            ЭлементЗаполнения.Ключ, ОбъектОбработкиВыбора);
		КонецЦикла;
	ИначеЕсли ТипЗнч(СписокМакетов) = Тип("СписокЗначений") Тогда
		Для каждого СтрокаМакетаВСписке Из СписокМакетов Цикл			
			Если СтрокаМакетаВСписке.Значение = Неопределено Тогда
				ЭлементМеню.Кнопки.Добавить(, ТипКнопкиКоманднойПанели.Разделитель);
			Иначе			
				Если ТипЗнч(СтрокаМакетаВСписке.Значение) = Тип("Строка") Тогда
					ЭлементМеню.Кнопки.Добавить(СтрокаМакетаВСписке.Значение, ТипКнопкиКоманднойПанели.Действие, 
					                            СтрокаМакетаВСписке.Представление, ОбъектОбработкиВыбора); 
				Иначе
					ЭлементМеню.Кнопки.Добавить(СтрЗаменить(СтрокаМакетаВСписке.Значение.УникальныйИдентификатор(), "-", "_"), ТипКнопкиКоманднойПанели.Действие, 
					                            СтрокаМакетаВСписке.Представление, ОбъектОбработкиВыбора); 
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
 	КонецЕсли;


КонецПроцедуры // УстановитьПодменюВыбораПечатнойФормы()

#КонецЕсли
