﻿
Процедура ПриВыполнении(Отказ)
	Если ВидЗадачи = Перечисления.амбВидыЗадач.Согласование тогда
		Если КоличествоКопийПечати = 0 тогда
			Предупреждение("Укажите количество копий печати (3 шт - регионы, 2 шт - СПБ., 2 шт-расписки)");
			Отказ = Истина;
		КонецЕсли
	КонецЕсли;	
КонецПроцедуры
