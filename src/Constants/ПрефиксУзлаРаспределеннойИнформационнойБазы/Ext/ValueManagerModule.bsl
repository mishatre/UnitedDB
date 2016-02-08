﻿
Процедура ПриЗаписи(Отказ)
	
	Если ПустаяСтрока(Значение) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ Первые 1 1
	               |	
	               |ИЗ
	               |	РегистрСведений.ПрефиксыИнформационныхБаз КАК ПрефиксыИнформационныхБаз
				   |ГДЕ
				   |	ПрефиксыИнформационныхБаз.Префикс = &Префикс";
				   
	Запрос.УстановитьПараметр("Префикс", Значение);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписейРегистра = РегистрыСведений.ПрефиксыИнформационныхБаз.СоздатьНаборЗаписей();
	
	НаборЗаписейРегистра.Отбор.Префикс.Установить(Значение);
	
	СтрокаРегистра = НаборЗаписейРегистра.Добавить();
	
	СтрокаРегистра.Префикс = Значение;
		
	НаборЗаписейРегистра.Записать();	
		
КонецПроцедуры
