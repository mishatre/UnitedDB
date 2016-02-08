﻿// Получает контекст платежного документа, не зависящий от прикладного решения 
//
// Параметры:
//  СвойстваКонтекста - Структура - содержит сведения, необходимые для получения контекста.
//               Состав потребных сведений (ключей, значений) определяется конфигурацией-потребителем 
//               и описан в НовыйИсточникДанныхКонтекстаПлатежногоДокумента().
//               Для БП3 - "Период", "Организация", "СчетПолучателя"
//
// Возвращаемое значение:
//  Структура - содержит ключи, описанные в ПлатежиВБюджетКлиентСервер.ПоляКонтекста()
//
Функция КонтекстПлатежногоДокумента(ИсточникДанных) Экспорт
	
	Контекст = ПлатежиВБюджетКлиентСервер.НовыйКонтекст();
	
	Контекст.Период = ИсточникДанных.Период;
	Если Не ЗначениеЗаполнено(Контекст.Период) Тогда
		Контекст.Период = НачалоДня(ОбщегоНазначения.ПолучитьРабочуюДату());
	КонецЕсли;
	
	Контекст.КодТерриторииПоУмолчанию = Справочники.Организации.КодТерритории(ИсточникДанных.Организация, Контекст.Период);
	Контекст.ФизическоеЛицо           = ИсточникДанных.Организация.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо;
	Контекст.НомерСчетаПолучателя     = ИсточникДанных.СчетПолучателя.НомерСчета;
	
	Возврат Контекст;
	
КонецФункции

Функция НовыйИсточникДанныхКонтекстаПлатежногоДокумента() Экспорт
	
	ИсточникДанных = Новый Структура;
	ИсточникДанных.Вставить("Период",         '0001-01-01');
	ИсточникДанных.Вставить("Организация",    Справочники.Организации.ПустаяСсылка());
	ИсточникДанных.Вставить("СчетПолучателя", Справочники.БанковскиеСчета.ПустаяСсылка());
	
	Возврат ИсточникДанных;
	
КонецФункции
