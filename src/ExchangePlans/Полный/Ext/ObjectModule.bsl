﻿
Перем мЭтоНовыйЭлемент;
Перем мМонопольныйРежимПередЗаписью;

Функция СообщитьИнформациюПользователюПослеСозданияНовогоУзла() Экспорт
	
	НужноПерезапуститьВсеПодключенияКИБ = Ложь;
	
	Если мЭтоНовыйЭлемент 
		И НЕ ПараметрыСеанса.ИспользованиеРИБ
		И НЕ мМонопольныйРежимПередЗаписью Тогда
		
		НужноПерезапуститьВсеПодключенияКИБ = Истина;
		
	КонецЕсли;	
	
	Если НужноПерезапуститьВсеПодключенияКИБ Тогда
		
		Если мМонопольныйРежимПередЗаписью Тогда
			
			ПолныеПрава.ОпределитьПараметрыСеансаДляОбменаДанными();
			Возврат "";
			
		Иначе	
			
			Возврат "Для корректной работы механизма обмена данными необходимо завершить работу всех пользователей и перезапустить текущий сеанс работы 1С:Предприятия.";	
			
		КонецЕсли;
		
	Иначе
		
		Если мЭтоНовыйЭлемент Тогда
			
			ПолныеПрава.ОпределитьПараметрыСеансаДляОбменаДанными();	
			
		КонецЕсли;
		
		Возврат "";
		
	КонецЕсли;
	
КонецФункции

Процедура ПередЗаписью(Отказ)
	
	мЭтоНовыйЭлемент = ЭтоНовый();
	мМонопольныйРежимПередЗаписью = ОбщегоНазначения.ОпределитьТекущийРежимРаботыМонопольный();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	СтрокаСообщенияПользователю = СообщитьИнформациюПользователюПослеСозданияНовогоУзла();
	
	#Если Клиент Тогда
	Сообщить(СтрокаСообщенияПользователю);
	#КонецЕсли		
		
КонецПроцедуры

Процедура ОпределитьТипОтправкиДанных(ЭлементДанных, ОтправкаЭлемента) Экспорт
КонецПроцедуры

Процедура ПриПолученииДанныхОтГлавного(ЭлементДанных, ПолучениеЭлемента, ОтправкаНазад)
	Если ТипЗнч(ЭлементДанных) = Тип("СправочникОбъект.Пользователи") И Не ЭлементДанных.ЭтоГруппа Тогда
		ИдентификаторСсылки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭлементДанных.Ссылка, "ИдентификаторПользователяИБ");
		Если ЭлементДанных.ИдентификаторПользователяИБ <> ИдентификаторСсылки Тогда
			ЭлементДанных.ИдентификаторПользователяИБ = ИдентификаторСсылки;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ПриПолученииДанныхОтПодчиненного(ЭлементДанных, ПолучениеЭлемента, ОтправкаНазад)
	Если ТипЗнч(ЭлементДанных) = Тип("СправочникОбъект.Пользователи") И Не ЭлементДанных.ЭтоГруппа Тогда
		ИдентификаторСсылки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭлементДанных.Ссылка, "ИдентификаторПользователяИБ");
		Если ЭлементДанных.ИдентификаторПользователяИБ <> ИдентификаторСсылки Тогда
			ЭлементДанных.ИдентификаторПользователяИБ = ИдентификаторСсылки;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
