﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ)
	
	// Вызывается непосредственно до записи объекта в базу данных
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если СтатусЭД <> Ссылка.СтатусЭД Тогда
		Если ВидЭД = Перечисления.ВидыЭД.ПредложениеОбАннулировании И СтатусЭД <> Ссылка.СтатусЭД Тогда
			ПараметрыВладельцаЭД = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЭлектронныйДокументВладелец,
				"СтатусЭД, НаправлениеЭД");
			Если ПараметрыВладельцаЭД.СтатусЭД = Перечисления.СтатусыЭД.ПолученоПредложениеОбАннулировании
				ИЛИ ПараметрыВладельцаЭД.СтатусЭД = Перечисления.СтатусыЭД.СформированоПредложениеОбАннулировании Тогда
				Если (СтатусЭД = Перечисления.СтатусыЭД.ОтправленоПодтверждение
						ИЛИ СтатусЭД = Перечисления.СтатусыЭД.ПолученоПодтверждение) Тогда
					ЭлектронныеДокументыСлужебныйВызовСервера.УстановитьСтатусЭД(ЭлектронныйДокументВладелец,
						Перечисления.СтатусыЭД.Аннулирован);
				ИначеЕсли (СтатусЭД = Перечисления.СтатусыЭД.ОтклоненПолучателем
						ИЛИ СтатусЭД = Перечисления.СтатусыЭД.Отклонен) Тогда
					НастройкиОбмена = ЭлектронныеДокументыСлужебный.НастройкиОбменаЭД(ЭлектронныйДокументВладелец);
					МассивСтатусов = ЭлектронныеДокументыСлужебный.ВернутьМассивСтатусовЭД(НастройкиОбмена);
					НовыйСтатусЭД = МассивСтатусов[МассивСтатусов.ВГраница()];
					СтруктураПараметров = Новый Структура("СтатусЭД, ПричинаОтклонения", НовыйСтатусЭД, "");
					ЭлектронныеДокументыСлужебный.ИзменитьПоСсылкеПрисоединенныйФайл(ЭлектронныйДокументВладелец,
						СтруктураПараметров, Ложь);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// Пометка на удаление ЭД разрешена только для неподписанных ЭД.
	ПометкаУдаленияСсылка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ПометкаУдаления");
	Если ПометкаУдаления = Истина И ПометкаУдаленияСсылка = Ложь Тогда
		Если ЗначениеЗаполнено(ЭлектронныйДокументВладелец) Тогда
			ПодписанЭПЭлектронныйДокументВладелец = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭлектронныйДокументВладелец, "ПодписанЭЦП");
		Иначе
			ПодписанЭПЭлектронныйДокументВладелец = Неопределено;
		КонецЕсли;
		Если ПодписанЭЦП ИЛИ (ЗначениеЗаполнено(ПодписанЭПЭлектронныйДокументВладелец) И ПодписанЭПЭлектронныйДокументВладелец) Тогда
			ПометкаУдаления = Ложь;
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

#КонецЕсли
