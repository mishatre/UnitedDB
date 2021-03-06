﻿
Функция ЗагрузитьЭлементХМЛ(ОбъектXML, ИмяУзла, Параметры) Экспорт
	Перем СтрокаТовара, ТипНалога, ВалютаСтрок;
	
	Параметры.Свойство("СтрокаТовара", СтрокаТовара);
	Параметры.Свойство("ТипНалога", ТипНалога);
	
	Если ИмяУзла = "ЭлектроннаяНакладная" Тогда
		
	ИначеЕсли ИмяУзла = "ДлительностьОжиданияОтвета" Тогда
		ДлительностьОжиданияОтвета = ЭлектронныеДокументы.ПолучитьДлительностьЭлемента(ОбъектXML);
		
	ИначеЕсли ИмяУзла = "ИдСклада" Тогда
		Если ОбъектXML.КоличествоАтрибутов() и ОбъектXML.ПрочитатьАтрибут() Тогда
			Склад = ОбъектXML.Значение;
		КонецЕсли;
	ИначеЕсли ИмяУзла = "НомерТоварнойНакладной" Тогда
		НомерТоварнойНакладной = ЭлектронныеДокументы.ПолучитьТекстЭлементаХМЛ(ОбъектXML);
		
	ИначеЕсли ИмяУзла = "ДатаТоварнойНакладной" Тогда
		ДатаТоварнойНакладной = ЭлектронныеДокументы.ПолучитьДатуЭлемента(ОбъектXML);
		
	ИначеЕсли ИмяУзла = "Товар" Тогда
		СтрокаТовара = Товары.Добавить();
		Параметры.Вставить("СтрокаТовара",СтрокаТовара);
			
	ИначеЕсли   ИмяУзла = "ИдТовара" Тогда
		ЭлектронныеДокументы.ЗаполнитьНоменклатуруИХарактеристикуПоИдентификатору(СтрокаТовара, ЭлектронныеДокументы.ПолучитьТекстЭлементаХМЛ(ОбъектXML), Параметры);
	
	ИначеЕсли   ИмяУзла = "НомерАкцептованногоЗаказа" Тогда
		
		ИсходныйДокумент = ЭлектронныеДокументы.ПолучитьСсылкуНаДокументПоДаннымИзXML(ОбъектXML, Неопределено, Параметры);	
	
	ИначеЕсли   ИмяУзла = "ЕдиницаИзмерения" Тогда
		//СтрокаТовара.ЕдиницаИзмерения = Справочники.КлассификаторЕдиницИзмерения.НайтиПоКоду(ПолучитьТекстЭлементаХМЛ(ОбъектXML));
	
	ИначеЕсли ИмяУзла = "Количество" Тогда
		СтрокаТовара.Количество = ЭлектронныеДокументы.ПолучитьЧислоЭлемента(ОбъектXML);
		
	ИначеЕсли ИмяУзла = "ИдТоварногоСертификата" Тогда
		СтрокаТовара.ИдТоварногоСертификата = ЭлектронныеДокументы.ПолучитьТекстЭлементаХМЛ(ОбъектXML);
		
	ИначеЕсли ИмяУзла = "СуммаПоСтроке" Тогда
		
	ИначеЕсли ИмяУзла = "Сумма" и ТипНалога = Неопределено Тогда
		
		ЭлектронныеДокументы.ПрочитатьВалютуДокумента(ЭтотОбъект, ОбъектXML, Параметры);
		
		СтрокаТовара.Сумма = ЭлектронныеДокументы.ПолучитьЧислоЭлемента(ОбъектXML);
	
	ИначеЕсли ИмяУзла = "Налог" Тогда
		
	ИначеЕсли ИмяУзла = "ТипНалога" Тогда
		
		Параметры.Вставить("ТипНалога", вРег(ЭлектронныеДокументы.ПолучитьТекстЭлементаХМЛ(ОбъектXML)));
		
	ИначеЕсли ИмяУзла = "ВеличинаСтавкиНалога" Тогда
		
		Если ТипНалога = "НДС" Тогда
			СтрокаТовара.СтавкаНДС = Перечисления.СтавкиНДС["НДС" + ЭлектронныеДокументы.ПолучитьТекстЭлементаХМЛ(ОбъектXML)];
		КонецЕсли;
		
	ИначеЕсли ИмяУзла = "Сумма" и Не ТипНалога = Неопределено Тогда
		
		ЭлектронныеДокументы.ПрочитатьВалютуДокумента(ЭтотОбъект, ОбъектXML, Параметры);
		
		Значение = ЭлектронныеДокументы.ПолучитьЧислоЭлемента(ОбъектXML);
		Если ТипНалога = "НДС" Тогда
			СтрокаТовара.СуммаНДС = Значение;
		Иначе
			СтрокаТовара.СуммаИныхНалогов = СтрокаТовара.СуммаИныхНалогов + Значение;
		КонецЕсли;
		
	ИначеЕсли ИмяУзла = "ВключеноВСтоимость" Тогда
		
		Если ТипНалога = "НДС" Тогда
			
			ВключеноВСтоимостьСтроки = ЭлектронныеДокументы.ПолучитьБулевоЭлемента(ОбъектXML);
			ВключеноВСтоимостьСтрок  = Неопределено;
			
			Если Параметры.Свойство("ВключеноВСтоимостьСтрок", ВключеноВСтоимостьСтрок) Тогда
				
				Если Не ВключеноВСтоимостьСтрок = ВключеноВСтоимостьСтроки Тогда
					ЭлектронныеДокументы.ДополинтьИнформациюДляСообщения(Параметры.ТекстОшибки, "Торговая система не поддерживает документы с различным способом включения НДС в цену товара в одном документе!"); 
				КонецЕсли;
			Иначе
				СуммаВключаетНДС = ВключеноВСтоимостьСтроки;
				Параметры.Вставить("ВключеноВСтоимостьСтрок", ВключеноВСтоимостьСтроки);
				
			КонецЕсли;
			
		КонецЕсли;
		
		Параметры.Удалить("ТипНалога")
		
	ИначеЕсли ИмяУзла = "Примечание" Тогда
		
		СтрокаТовара.Примечание = ЭлектронныеДокументы.ПолучитьТекстЭлементаХМЛ(ОбъектXML);
		
	ИначеЕсли ИмяУзла = "НомерГТД" Тогда
		
		СтрокаТовара.НомерГТД = ЭлектронныеДокументы.ПолучитьТекстЭлементаХМЛ(ОбъектXML);
		
	ИначеЕсли ИмяУзла = "СрокРеализации" или ИмяУзла = "НомерГТД"  Тогда
		
	ИначеЕсли ИмяУзла = "СерийныйНомер" Тогда
		
		СтрокаТовара.СерийныйНомер = ЭлектронныеДокументы.ПолучитьТекстЭлементаХМЛ(ОбъектXML);
		
	ИначеЕсли ИмяУзла = "Сертификат" Тогда
		
		СтрокаТовара.Сертификат = ЭлектронныеДокументы.ПолучитьТекстЭлементаХМЛ(ОбъектXML);
		
	ИначеЕсли ИмяУзла = "СтранаПроисхождения" Тогда
		
		СтрокаТовара.СтранаПроисхождения = ЭлектронныеДокументы.ПолучитьТекстЭлементаХМЛ(ОбъектXML);
		
	ИначеЕсли ИмяУзла = "СрокГодности" Тогда
		
		СтрокаТовара.СрокГодности = ЭлектронныеДокументы.ПолучитьДатуЭлемента(ОбъектXML);
		
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция СуществуетИсходящийДокумент(СсылкаНаОтветныйДокумент = Неопределено) Экспорт
	
	СсылкаНаОтветныйДокумент = ЭлектронныеДокументы.НайтиПервыйОтветныйДокумент(Ссылка, "ИсходящийРеджектАкцептНакладной");
	
	Возврат ЗначениеЗаполнено(СсылкаНаОтветныйДокумент);
	
КонецФункции // ()
 
