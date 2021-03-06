﻿
// Функция формирует значение нового ключа связи.
//
// Параметры функции
// ПараметрыСвязиСтрокТЧ – соответствие, в котором сохраняется текущее «свободное» значение ключа
// ДокументОбъект – документ, 
// ИмяТЧ – имя «основной» табличной части объекта,
// ПроверятьМаксЗначение – флаг необходимости проверки начальной инициализации ключа
//
Функция ПолучитьНовыйКлючСвязи(ПараметрыСвязиСтрокТЧ, ДокументОбъект, ИмяТЧ, ПроверятьМаксЗначение = Ложь) Экспорт
	
	Если ПроверятьМаксЗначение Тогда
		ПроверитьМаксЗначениеКлюча(ПараметрыСвязиСтрокТЧ, ДокументОбъект, ИмяТЧ);
	КонецЕсли;
	
	МаксКлюч = ПараметрыСвязиСтрокТЧ[ИмяТЧ].СвободныйКлюч; // берется текущее «свободное» значение ключа

	ПараметрыСвязиСтрокТЧ[ИмяТЧ].СвободныйКлюч = МаксКлюч + 1; // после чего «свободное» значение увеличивается на единицу

	ПараметрыСвязиСтрокТЧ[ИмяТЧ].ФлагМодификации = Истина; // устанавливаем признак  модифицированности
	
	Возврат МаксКлюч;
	
КонецФункции // ПолучитьНовыйКлючСвязи()

// Процедура проверяет максимальное значение ключа связи. 
//
Процедура ПроверитьМаксЗначениеКлюча(ПараметрыСвязиСтрокТЧ, ДокументОбъект, ИмяТЧ) Экспорт
	
	Если ПараметрыСвязиСтрокТЧ[ИмяТЧ].СвободныйКлюч <> Неопределено Тогда
		Возврат; // «не занятый» ключ уже был определен ранее.
	КонецЕсли;
	
	// При первом обращении «свободный» ключ необходимо рассчитать.
	Если ДокументОбъект[ИмяТЧ].Количество() = 0 Тогда
		ПараметрыСвязиСтрокТЧ[ИмяТЧ].СвободныйКлюч = 1; // отсчет начинается с нуля
	Иначе
		
		// Если в табл. части уже присутствуют строки, то новое «свободное» значение ключа
		// рассчитывается от максимального существующего значения.
		СписокКлючей = Новый СписокЗначений;				
		СписокКлючей.ЗагрузитьЗначения(ДокументОбъект[ИмяТЧ].ВыгрузитьКолонку("КлючСвязи"));
		СписокКлючей.СортироватьПоЗначению(НаправлениеСортировки.Убыв);
		ПараметрыСвязиСтрокТЧ[ИмяТЧ].СвободныйКлюч = СписокКлючей[0].Значение + 1;
		
	КонецЕсли;
	
КонецПроцедуры // ПроверитьМаксЗначениеКлюча()

// Процедура удаляет строки подчиненной табличной части для которых нет
// соответствующей строки табличной части номенклатуры.
//
Процедура УдалитьНеиспользуемыеСтрокиПодчиненнойТЧ(ДокументОбъект, ПараметрыСвязиСтрокТЧ, ИмяТЧ, ИмяПодчиненнойТЧ = "СерийныеНомера") Экспорт
	
	Если ПараметрыСвязиСтрокТЧ[ИмяТЧ].ФлагМодификации Тогда
		
		КолвоСтрокДопТЧ = ДокументОбъект[ИмяПодчиненнойТЧ].Количество(); 
		Для ОбратныйИндекс = 1 По КолвоСтрокДопТЧ Цикл 
			СтрокаДопТЧ = ДокументОбъект[ИмяПодчиненнойТЧ][КолвоСтрокДопТЧ - ОбратныйИндекс]; 
			
			Если ДокументОбъект[ИмяТЧ].Найти(СтрокаДопТЧ.КлючСвязи, "КлючСвязи") = Неопределено 
			 ИЛИ СтрокаДопТЧ.КлючСвязи = 0 Тогда 
				ДокументОбъект[ИмяПодчиненнойТЧ].Удалить(СтрокаДопТЧ); 
			КонецЕсли; 			
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры // УдалитьНеиспользуемыеСтрокиПодчиненнойТЧ()

// Процедура проверяет соответствие номенклатуры и серийных номеров по ключу связи.
//
Процедура ПроверитьСерийныеНомера(СтрокаТабличнойЧасти, ДокументОбъект) Экспорт
	
	Если СтрокаТабличнойЧасти.КлючСвязи > 0 Тогда
		
		Строка = ДокументОбъект.СерийныеНомера.Найти(СтрокаТабличнойЧасти.КлючСвязи, "КлючСвязи");
		Если Строка <> Неопределено И Строка.СерийныйНомер.Владелец <> СтрокаТабличнойЧасти.Номенклатура Тогда
			СтрокаТабличнойЧасти.КлючСвязи = 0;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ПроверитьСерийныеНомера()

// Процедура проверяет соответстви количества серийных номеров количеству товаров.
//
Процедура ПроверитьКоличествоСерийныхНомеровВДокументе(ДокументОбъект, ИмяТЧ) Экспорт
	
	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("Номенклатура",			"Номенклатура");
	СтруктураПолей.Вставить("Количество", 			"Количество * Коэффициент /Номенклатура.ЕдиницаХраненияОстатков.Коэффициент");
	СтруктураПолей.Вставить("ВестиСерийныеНомера",	"Номенклатура.ВестиСерийныеНомера");
	СтруктураПолей.Вставить("КлючСвязи",			"КлючСвязи");
	
	ТаблицаНоменклатуры = ОбщегоНазначения.СформироватьЗапросПоТабличнойЧасти(ДокументОбъект, ИмяТЧ, СтруктураПолей).Выгрузить();
	
	Для Каждого СтрокаТабличнойЧасти Из ТаблицаНоменклатуры Цикл
		
		Если СтрокаТабличнойЧасти.ВестиСерийныеНомера <> Истина Тогда
			Продолжить;
		КонецЕсли;
		
		Отбор = Новый Структура("КлючСвязи", СтрокаТабличнойЧасти.КлючСвязи);
		МассивСтрок = ДокументОбъект.СерийныеНомера.НайтиСтроки(Отбор);
		КоличествоСерийныхНомеров = МассивСтрок.Количество();
		
		Если СтрокаТабличнойЧасти.Количество <> КоличествоСерийныхНомеров Тогда
			#Если Клиент Тогда
			Сообщить("Количество серийных номеров не соответствует количеству номенклатуры (строка № " + СтрокаТабличнойЧасти.НомерСтроки + " таб. часть """ + ИмяТЧ + """)");
			#КонецЕсли
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // ПроверитьКоличествоСерийныхНомеровВДокументе()

// Процедура осуществляет обработку заполнения данных о серийном номере при
// подборе. Вызывается из обработки подбора в тех документах, в которых
// предусмотрена работа с серийными номерами.
//
// Параметры
//  ЗначениеВыбора        - <Структура>
//                        - Структура параметров, передаваемая
//                          процедуре-обработчику подбора.
//
//  СерийныеНомера        - <ДокументТабличнаяЧасть.*.СерийныеНомера>
//                        - Табличная часть документа, содержащая серийные
//                          номера.
//
//  ТабличнаяЧасть        - <ДокументТабличнаяЧасть.*.*>
//                        - Табличная часть документа, в которую осуществляется
//                          подбор.
//
//  СтрокаТабличнойЧасти  - <ДокументТабличнаяЧастьСтрока.*.*>
//                        - Строка табличной части документа, в которую был
//                          осуществлён подбор.
//
//  ПараметрыСвязиСтрокТЧ - <Соответствие>
//                        - Параметр связи строк табличных частей.
//
//  ТабличнаяЧастьИмя     - <Строка>
//                        - Имя табличной части документа, в которую
//                          осуществляется подбор.
//
//  ДокументОбъект        - <ДокументОбъект.*>
//                        - Документ, в который осуществляется подбор.
//
Процедура ОбработкаПодбораНоменклатурыПоСерийномуНомеру(ЗначениеВыбора, СерийныеНомера,
                                                        ТабличнаяЧасть, СтрокаТабличнойЧасти,
                                                        ПараметрыСвязиСтрокТЧ,
                                                        ТабличнаяЧастьИмя,
                                                        ДокументОбъект) Экспорт

	СерийныйНомер = Неопределено;
	Количество    = Неопределено;
	ЗначениеВыбора.Свойство("Количество",    Количество);
	ЗначениеВыбора.Свойство("СерийныйНомер", СерийныйНомер);
	Если СерийныйНомер <> Неопределено Тогда
		Если СерийныеНомера.Найти(СерийныйНомер, "СерийныйНомер") <> Неопределено Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Серийный номер """ + СокрЛП(СерийныйНомер.Код) + """ уже присутствует в списке серийных номеров.");
			СтрокаТабличнойЧасти.Количество = СтрокаТабличнойЧасти.Количество - Количество;
			Если СтрокаТабличнойЧасти.Количество = 0 Тогда
				ТабличнаяЧасть.Удалить(СтрокаТабличнойЧасти);
			Иначе
				ОбработкаТабличныхЧастей.РассчитатьКоличествоМестТабЧасти(СтрокаТабличнойЧасти, ДокументОбъект);
				ОбработкаТабличныхЧастей.РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти,          ДокументОбъект);
				ОбработкаТабличныхЧастей.РассчитатьСуммуНДСТабЧасти(СтрокаТабличнойЧасти,       ДокументОбъект);
			КонецЕсли;
			Возврат;
		КонецЕсли;

		Если СтрокаТабличнойЧасти.КлючСвязи = 0 Тогда
			СтрокаТабличнойЧасти.КлючСвязи = ПолучитьНовыйКлючСвязи(ПараметрыСвязиСтрокТЧ, ДокументОбъект, ТабличнаяЧастьИмя, Истина);
		КонецЕсли;
		СтрокаСН                       = СерийныеНомера.Добавить();
		СтрокаСН.КлючСвязи             = СтрокаТабличнойЧасти.КлючСвязи;
		СтрокаСН.СерийныйНомер         = СерийныйНомер;
	КонецЕсли;

КонецПроцедуры // ОбработкаПодбораНоменклатурыПоСерийномуНомеру()

// Функция формирует данные об исходной таблицы с серийными номерами, до "расщепления" исходной таблица.
// "Расщепление" возможно например при нажатии на кнопку "Заполнить и провести" в некоторых документах
//
Функция СформироватьИсходнуюТаблицуСерийныйНомеров(ТабЧасть, ТабСерийныеНомера) Экспорт
	
	СтруктДанныеСерНомера = Новый Структура;
	
	ТабИсходная = Новый ТаблицаЗначений;
	ТабИсходная.Колонки.Добавить("Количество", ОбщегоНазначения.ПолучитьОписаниеТиповЧисла(15, 3));
	ТабИсходная.Колонки.Добавить("КлючСвязи",  ОбщегоНазначения.ПолучитьОписаниеТиповЧисла( 5, 0));
	ТабИсходная.Колонки.Добавить("СерНомера"); // Массив
	
	МаксКлюч = 0;
	Для Каждого СтрокаТабЧасти Из ТабЧасть Цикл
	
		НоваяСтрока = ТабИсходная.Добавить();
		НоваяСтрока.Количество = СтрокаТабЧасти.Количество;
		НоваяСтрока.КлючСвязи  = СтрокаТабЧасти.КлючСвязи;
		МаксКлюч = Макс(МаксКлюч, СтрокаТабЧасти.КлючСвязи);
		
	КонецЦикла;
	
	СтруктПоиска = Новый Структура;
	Для Каждого СтрокаТабЧасти Из ТабИсходная Цикл
		Если СтрокаТабЧасти.КлючСвязи > 0 Тогда
			СтруктПоиска.Вставить("КлючСвязи", СтрокаТабЧасти.КлючСвязи);
			СтрокаТабЧасти.СерНомера = ТабСерийныеНомера.НайтиСтроки(СтруктПоиска);
		КонецЕсли;
	КонецЦикла;
	
	СтруктДанныеСерНомера.Вставить("ТабДанные", ТабИсходная);
	СтруктДанныеСерНомера.Вставить("МаксКлюч",  МаксКлюч);
	
	Возврат СтруктДанныеСерНомера;

КонецФункции // СформироватьИсходнуюТаблицуСерийныйНомеров()

// Процедура корректируют поля "КлючСвязи" для таб. части "СерийныеНомера", в случае когда строки основной таблицы (Товары) разделяются.
// Например при нажатии на кнопку "Заполнить и провести" в некоторых документах.
//
Процедура КорректироватьТабЧастьСерийныеНомера(СтруктДанныеСерНомера, ИндексИсхСтроки, ИсхКоличество, НоваяСтрока, ВыделеноКоличество) Экспорт
	
	Если СтруктДанныеСерНомера = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТабДанные = СтруктДанныеСерНомера.ТабДанные;
	
	// Определим избыток серийных номеров, "висящих" на исходной строке
	Если ТабДанные[ИндексИсхСтроки].СерНомера = Неопределено Тогда // Не было серийных номеров связанных с исходной строкой
		Возврат;
	КонецЕсли;
	
	Превышение = ТабДанные[ИндексИсхСтроки].СерНомера.Количество() - Цел(ИсхКоличество);
	Если Превышение > 0 Тогда // Избыток серийных номеров, которые надо "перекинуть" на новую строку
	
		МожноПереместить = Мин(Превышение, ВыделеноКоличество);
		Если МожноПереместить <= 0 Тогда
			Возврат;
		КонецЕсли;
		
		Если НоваяСтрока.КлючСвязи <> 0 Тогда
			Возврат; // Были изменения ключей связи/серийных номеров вне данного механизма.
					 // Либо повторный вызов данной процедуры для одной строки. Такая ситуация не обрабатывается.
		КонецЕсли;
		
		// Вычислим новое значение ключа связи
		МаксКлюч = СтруктДанныеСерНомера.МаксКлюч;
		МаксКлюч = МаксКлюч + 1;
		СтруктДанныеСерНомера.Вставить("МаксКлюч", МаксКлюч);
			
		// Установим новый ключ связи в новой строке документа
		НоваяСтрока.КлючСвязи = МаксКлюч;
		
		// Запоминаем сколько всего серийных номеров, перемещать будем последние (т.е. с конца)
		// первые остаются на первоначальной строке
		ВсегоСерНомеров = ТабДанные[ИндексИсхСтроки].СерНомера.Количество() - 1;
		Пока МожноПереместить > 0 Цикл
		
			ТабДанные[ИндексИсхСтроки].СерНомера[ВсегоСерНомеров].КлючСвязи = МаксКлюч; // Установлен новый ключ связи в ТАБ.ЧАСТИ документа
			ТабДанные[ИндексИсхСтроки].СерНомера.Удалить(ВсегоСерНомеров);              // Удаляем элемент массива, строка в документе остается!!!
			ВсегоСерНомеров  = ВсегоСерНомеров  - 1; // Уменьшаем индекс последнего элемента массива
			МожноПереместить = МожноПереместить - 1; // Уменьшаем количество доступных перемещений.
			
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры // КорректироватьТабЧастьСерийныеНомера()

#Если Клиент Тогда
	
// Функция формирует печатную форму со списом серийных номеров
// Параметры:
//		ТекДок - документ, данные которого надо распечатать
//		ИмяТабЧасти - имя табличной части по которой надо строить отчет
// Возврат:
//		Табличный документ
//
Функция ПечатьСерийныхНомеров(ТекДок, ИмяТабЧасти) Экспорт
	
	ВидДокумента = ТекДок.Метаданные().Имя;
	
	ТекстЗапроса =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДокТабЧасть.ЕдиницаИзмерения                КАК ЕдиницаИзмерения,
		|	ДокТабЧасть.Номенклатура                    КАК Номенклатура,
		|	ДокТабЧасть.ХарактеристикаНоменклатуры      КАК Характеристика,
		|	ДокТабЧасть.СерияНоменклатуры               КАК Серия,
		|	ПРЕДСТАВЛЕНИЕ(ДокТабЧасть.ЕдиницаИзмерения) КАК ПечЕдиницаИзмерения,
		|	ПРЕДСТАВЛЕНИЕ(ДокТабЧасть.Номенклатура)     КАК ПечНоменклатура,
		|	ДокСерийныеНомера.СерийныйНомер             КАК СерийныйНомер,
		|	ДокТабЧасть.Количество                      КАК Количество,
		|	ДокТабЧасть.НомерСтроки                     КАК НомерСтроки
		|ИЗ
		|	Документ." + ВидДокумента + "." + ИмяТабЧасти + " КАК ДокТабЧасть
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ." + ВидДокумента + ".СерийныеНомера КАК ДокСерийныеНомера
		|		ПО ДокТабЧасть.КлючСвязи = ДокСерийныеНомера.КлючСвязи
		|ГДЕ
		|	ДокТабЧасть.Ссылка = &ТекДок
		|	И ДокСерийныеНомера.Ссылка = &ТекДок
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки,
		|	ДокСерийныеНомера.НомерСтроки";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("ТекДок", ТекДок);
	
	ТабДокумент = Новый ТабличныйДокумент;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Макет = ПолучитьОбщийМакет("СписокСерийныхНомеров");
	Область = Макет.ПолучитьОбласть("Заголовок");
	Область.Параметры.ТекстЗаголовок = ОбщегоНазначения.СформироватьЗаголовокДокумента( ТекДок);
	ТабДокумент.Вывести(Область);
	
	Область = Макет.ПолучитьОбласть("ТабШапка");
	ТабДокумент.Вывести(Область);
	
	ОбластьНоменклатура   = Макет.ПолучитьОбласть("ТабНоменклатура");
	ОбластьСерийныйНомер  = Макет.ПолучитьОбласть("ТабСерийныйНомер");
	
	Индекс = 0;
	ТекНоменклатура   = Неопределено;
	ТекХарактеристика = Неопределено;
	ТекСерия          = Неопределено;
	Обход = РезультатЗапроса.Выбрать();
	Пока Обход.Следующий() Цикл
	
		Если ТекНоменклатура   <> Обход.Номенклатура
		 ИЛИ ТекХарактеристика <> Обход.Характеристика
		 ИЛИ ТекСерия          <> Обход.Серия Тогда
		
			Индекс = Индекс + 1;
			
			ТекНоменклатура   = Обход.Номенклатура;
			ТекХарактеристика = Обход.Характеристика;
			ТекСерия          = Обход.Серия;
			
			ОбластьНоменклатура.Параметры.НомСтр          = Индекс;
			ОбластьНоменклатура.Параметры.ПечНоменклатура = Обход.ПечНоменклатура + ФормированиеПечатныхФорм.ПредставлениеСерий(Обход);
			ОбластьНоменклатура.Параметры.Номенклатура    = Обход.Номенклатура;
			ОбластьНоменклатура.Параметры.ЕдИзм           = Обход.ЕдиницаИзмерения;
			ОбластьНоменклатура.Параметры.ПечЕдИзм        = Обход.ПечЕдиницаИзмерения;
			ОбластьНоменклатура.Параметры.Количество      = Обход.Количество;
			
			ТабДокумент.Вывести(ОбластьНоменклатура);
			
		КонецЕсли;
			
		ОбластьСерийныйНомер.Параметры.ПечСерийныйНомер = Обход.СерийныйНомер;
		ОбластьСерийныйНомер.Параметры.СерийныйНомер    = Обход.СерийныйНомер;
							
		ТабДокумент.Вывести(ОбластьСерийныйНомер);
		
	КонецЦикла;
	
	Область = Макет.ПолучитьОбласть("ТабПодвал");
	ТабДокумент.Вывести(Область);
	
	Возврат ТабДокумент;

КонецФункции // ПечатьСерийныхНомеров()

#КонецЕсли