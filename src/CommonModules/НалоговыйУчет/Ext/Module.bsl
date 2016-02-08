﻿// Проверяет облагается услуга ЕНВД, если организация является плательщиком ЕНВД.
//
// Параметры:
//  Номенклатура                         - ссылка на справочник номенклатуры, определяет услугу;
//  Организация                          - ссылка на справочник организаций, определяет организацию;
//  Дата                                 - дата проверки;
//  мОрганизацияЯвляетсяПлательщикомЕНВД - булево, признак что организация является плательщиком ЕНВД;
//
// Возвращаемое значение:
//  Истина, если услуга облагается ЕНВД, инчае - Ложь.
//
Функция ПроверитьУслугаОблагаетсяЕНВД(Номенклатура, Организация, Дата, ОрганизацияЯвляетсяПлательщикомЕНВД) Экспорт

	// Если учетная политика неопределена
	Если ОрганизацияЯвляетсяПлательщикомЕНВД = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;

	// Организация не является плательщиком ЕНВД
	Если НЕ ОрганизацияЯвляетсяПлательщикомЕНВД Тогда
		Возврат Ложь;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Номенклатура) ИЛИ НЕ ЗначениеЗаполнено(Организация)Тогда
		Возврат Ложь;
	КонецЕсли;

	Флаг = Ложь;

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Дата",         Дата);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("Организация",  Организация);

	Запрос.Текст = "
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	Услуги.ОблагаетсяЕНВД КАК УслугаОблагаетсяЕНВД
	|ИЗ
	|	РегистрСведений.УслугиЕНВД.СрезПоследних(&Дата, Организация = &Организация И Номенклатура = &Номенклатура) КАК Услуги
	|";

	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Флаг = Выборка.УслугаОблагаетсяЕНВД
	КонецЕсли;

	Возврат Флаг;

КонецФункции // ПроверитьУслугаОблагаетсяЕНВД()

// Возвращает дату начала применения кодов ОКТМО в платежных поручениях на перечисление налогов
//
// Параметры:
//  ВВидеСтроки - если Ложь, возвращаемое значение имеет тип "Дата", в противном случае - "Строка".
//
Функция ДатаНачалаПримененияОКТМО(ВВидеСтроки = Ложь) Экспорт
	ДатаНачалаПрименения = Дата(2014,1,1);
	Если ВВидеСтроки Тогда
		Возврат Формат(ДатаНачалаПрименения, "ДЛФ=DD");
	Иначе
		Возврат ДатаНачалаПрименения;
	КонецЕсли;
КонецФункции