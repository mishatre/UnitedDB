﻿Перем мПериод			Экспорт; // Период движений
Перем мТаблицаДвижений	Экспорт; // Таблица движений

Процедура ДобавитьДвижение() Экспорт
	
	Если мПериод <> Неопределено Тогда
		
		мТаблицаДвижений.ЗаполнитьЗначения(мПериод, "Период");
		
	КонецЕсли;
	
	мТаблицаДвижений.ЗаполнитьЗначения(Истина, "Активность");
	ОбщегоНазначения.ВыполнитьДвижениеПоРегистру(ЭтотОбъект,,, Ложь);
	
КонецПроцедуры // ДобавитьДвижение()

