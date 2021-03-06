﻿
// ОБРАБОТЧИКИ ОБНОВЛЕНИЯ

// Обработчик обновления
//
// Устанавливает новый код вида операции для сводных счетов-фактур по комиссии
Процедура УстановитьКодВидаОперацииСводныйКомиссионный() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СчетФактураПолученный.Ссылка КАК Ссылка,
	|	""27"" КАК КодВидаОперации,
	|	ВЫБОР
	|		КОГДА СчетФактураПолученный.КодВидаОперации = ""27""
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК КодУстановлен
	|ИЗ
	|	Документ.СчетФактураПолученный КАК СчетФактураПолученный
	|ГДЕ
	|	(СчетФактураПолученный.ВидСчетаФактуры = ЗНАЧЕНИЕ(Перечисление.ВидСчетаФактурыПолученного.НаПоступление)
	|			ИЛИ СчетФактураПолученный.ВидСчетаФактуры = ЗНАЧЕНИЕ(Перечисление.ВидСчетаФактурыПолученного.Корректировочный))
	|	И СчетФактураПолученный.ПометкаУдаления = ЛОЖЬ
	|	И СчетФактураПолученный.СводныйКомиссионный = ИСТИНА
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СчетФактураПолученный.Ссылка,
	|	""28"",
	|	ВЫБОР
	|		КОГДА СчетФактураПолученный.КодВидаОперации = ""28""
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ
	|ИЗ
	|	Документ.СчетФактураПолученный КАК СчетФактураПолученный
	|ГДЕ
	|	СчетФактураПолученный.ВидСчетаФактуры = ЗНАЧЕНИЕ(Перечисление.ВидСчетаФактурыПолученного.НаАванс)
	|	И СчетФактураПолученный.ПометкаУдаления = ЛОЖЬ
	|	И СчетФактураПолученный.СводныйКомиссионный = ИСТИНА
	|ИТОГИ
	|	СУММА(КодУстановлен)
	|ПО
	|	ОБЩИЕ";
	
	ВыборкаИтоги = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Если ВыборкаИтоги.Следующий()
		И ВыборкаИтоги.КодУстановлен = 0 Тогда
		ВыборкаДокументы = ВыборкаИтоги.Выбрать();
		Пока ВыборкаДокументы.Следующий() Цикл
			СчетФактураДокумент = ВыборкаДокументы.Ссылка.ПолучитьОбъект();
			СчетФактураДокумент.КодВидаОПерации = ВыборкаДокументы.КодВидаОперации;
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(СчетФактураДокумент);
		КонецЦикла;
	Иначе
		Возврат;
	КонецЕсли;
		
КонецПроцедуры
