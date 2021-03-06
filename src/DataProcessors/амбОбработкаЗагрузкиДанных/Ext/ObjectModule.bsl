﻿	Процедура ВыгрузитьДанныеПоДокументу(Ссылка)  Экспорт
		
		Если ТипЗнч(Ссылка) =  Тип("ДокументСсылка.РеализацияТоваровУслуг") тогда
			Режим = РежимДиалогаВыбораФайла.Сохранение;
			ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
			ДиалогОткрытияФайла.ПолноеИмяФайла = "";
			Фильтр = "Текст(*.txt)|*.txt";
			ДиалогОткрытияФайла.Фильтр = Фильтр;
			ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
			ДиалогОткрытияФайла.Заголовок = "Выберите имя файла";
			Если ДиалогОткрытияФайла.Выбрать() Тогда
				ИмяФ = ДиалогОткрытияФайла.ВыбранныеФайлы[0];
				   
				
				ДФайл = Новый ЗаписьТекста(ИмяФ,КодировкаТекста.ANSI); 
				ДФайл.ЗаписатьСтроку("РЕАЛИЗАЦИЯ");// Заголовок
				ДФайл.ЗаписатьСтроку(Строка(ОбщегоНазначения.ПолучитьНомерНаПечать(Ссылка)));              //НомерДокумента
				ДФайл.ЗаписатьСтроку(Строка(Формат(Ссылка.Дата,"ДФ=yyyyMMdd")));              //ДатаДокумента
				ДФайл.ЗаписатьСтроку(Строка(Ссылка.Организация.ИНН));              //ИННПоставщика
				//Для каждого СтрокаТЧ из Ссылка.Товары цикл
				Запрос = Новый Запрос;
				Запрос.Текст = "ВЫБРАТЬ
				|	РеализацияТоваровУслугамбСрокиИСерии.Количество,
				|	РеализацияТоваровУслугамбСрокиИСерии.Номенклатура,
				|	РеализацияТоваровУслугамбСрокиИСерии.СерияНоменклатуры,
				|	РеализацияТоваровУслугамбСрокиИСерии.СрокГодности
				|ИЗ
				|	Документ.РеализацияТоваровУслуг.амбСрокиИСерии КАК РеализацияТоваровУслугамбСрокиИСерии
				|ГДЕ
				|	РеализацияТоваровУслугамбСрокиИСерии.Ссылка = &Ссылка";
				
				Запрос.УстановитьПараметр("Ссылка", Ссылка);
				
				Результат = Запрос.Выполнить();
				ТаблицаСоСрокамиИСериями = Результат.Выгрузить();
				//Наченем перебирать тч Товары
				СчетчикСтрок = 0;
				
				Для каждого СтрокаТЧТовары из Ссылка.Товары цикл
					
					Номенклатура		 = СтрокаТЧТовары.Номенклатура;
					НомНаименованиеПолн	 = СтрокаТЧТовары.Номенклатура.НаименованиеПолное;
					КоличествоВНакладной = СтрокаТЧТовары.Количество;
					ЕдИзмерения			 = СтрокаТЧТовары.ЕдиницаИзмерения;
					СтоимостьВНакладной  = СтрокаТЧТовары.Сумма;
					СтавкаНдс 			 = СтрокаТЧТовары.СтавкаНДС;
					ГТД					 = СтрокаТЧТовары.СерияНоменклатуры;   					
					Списываем 		= КоличествоВНакладной;
					ОсталосьСписать = Списываем;
					СписываемСТоимость = СтоимостьВНакладной;                                            
					
					//Узнаем, нужно ли разбивать эту позицию?
					НайденнаяСтрока = ТаблицаСоСрокамиИСериями.Найти(Номенклатура, "Номенклатура");
					Если НайденнаяСтрока = Неопределено Тогда
						ПодбираемСерии = Ложь;
					Иначе
						ПодбираемСерии = Истина;
					КонецЕсли;	                                             
					
					
					//Выводим в зависимости от того нужно подбирать серии или нет .
					Если ПодбираемСерии Тогда 
						//Переберем все серии
						
						Отбор = Новый Структура();
						Отбор.Вставить("Номенклатура",Номенклатура);
						Строки = ТаблицаСоСрокамиИСериями.НайтиСтроки(Отбор);				
						//Спишем по срокам из найденых строк	
						
						
						
						Для каждого СтрокаСроков из Строки цикл
							КоличествоВСерии = СтрокаСроков.Количество;
							СерияВСерии = СтрокаСроков.СерияНоменклатуры;
							СрокГодностиВСерии = СтрокаСроков.СрокГодности;
							
							Если КоличествоВСерии > ОсталосьСписать  и КоличествоВСерии>0 тогда
								
								СчетчикСтрок = СчетчикСтрок+1;	
								Списываем 					= ОсталосьСписать;
								ОсталосьСписать 			= 0;
								СписываемСТоимость 		= СтоимостьВНакладной*(Списываем/КоличествоВНакладной);
								СтрокаСроков.Количество 	= КоличествоВСерии - Списываем;
								
							ИначеЕсли КоличествоВСерии = ОсталосьСписать и КоличествоВСерии>0 тогда
								СчетчикСтрок = СчетчикСтрок+1;	
								Списываем 					= ОсталосьСписать;
								ОсталосьСписать 			= 0;
								СписываемСТоимость 		= СтоимостьВНакладной*(Списываем/КоличествоВНакладной);
								СтрокаСроков.Количество 	= КоличествоВСерии - Списываем;
								
								
							ИначеЕсли КоличествоВСерии < ОсталосьСписать и КоличествоВСерии>0 тогда
								СчетчикСтрок = СчетчикСтрок+1;	
								Списываем 					= КоличествоВСерии;
								ОсталосьСписать 			= ОсталосьСписать-Списываем;
								СписываемСТоимость 		= СтоимостьВНакладной*(Списываем/КоличествоВНакладной);
								СтрокаСроков.Количество 	= КоличествоВСерии - Списываем;
								
								
							КонецЕсли;
							Если Списываем>0 и КоличествоВСерии>0 тогда
								
								Дфайл.ЗаписатьСтроку("СТРОКАТЧТОВАРЫ");//НАчальный тег товара    
								ДФайл.ЗаписатьСтроку(Номенклатура.Артикул);//артикул номенклатуры
								Дфайл.ЗаписатьСтроку(Лев(Номенклатура.Наименование,11));//11 цифр наименования, если нет артикула
								Дфайл.ЗаписатьСтроку(Строка(Номенклатура.НаименованиеПолное));//Полное наименование номенклатуры
								Дфайл.ЗаписатьСтроку(СтавкаНДС);//Ставка НДС
								ДФайл.ЗаписатьСтроку(Строка(ЕдИзмерения));//ЕдИзм.
								Дфайл.ЗаписатьСтроку(Строка(Формат(Списываем,"ЧГ=0")));//Количество
								Дфайл.ЗаписатьСтроку(Строка(Формат(СписываемСТоимость,"ЧГ=0")));   //Сумма
								Дфайл.ЗаписатьСтроку(СокрЛП(ГТД.НомерГТД));//ГТД
								ДФайл.ЗаписатьСтроку(ГТД.СтранаПроисхождения);//Страна происхождения
								Дфайл.ЗаписатьСтроку(СерияВСерии);//Серия                                        
								Дфайл.ЗаписатьСтроку(Строка(Формат(СрокГодностиВСерии,"ДФ=yyyyMMdd")));//СрокГодности
								Дфайл.ЗаписатьСтроку("/СТРОКАТЧТОВАРЫ");//конечный тег товара
								         
							КонецЕсли;
							
						КонецЦикла;	
						
					Иначе
						//Не перебираем серии, просто выводим строку
						СчетчикСтрок = СчетчикСтрок+1;
						
						
						Дфайл.ЗаписатьСтроку("СТРОКАТЧТОВАРЫ");//НАчальный тег товара    
						ДФайл.ЗаписатьСтроку(Номенклатура.Артикул);//артикул номенклатуры
						Дфайл.ЗаписатьСтроку(Лев(Номенклатура.Наименование,11));//11 цифр наименования, если нет артикула
						Дфайл.ЗаписатьСтроку(Строка(Номенклатура.НаименованиеПолное));//Полное наименование номенклатуры
						Дфайл.ЗаписатьСтроку(СтавкаНДС);//Ставка НДС
						ДФайл.ЗаписатьСтроку(Строка(ЕдИзмерения));//ЕдИзм.
						Дфайл.ЗаписатьСтроку(Строка(Формат(Списываем,"ЧГ=0")));//Количество
						Дфайл.ЗаписатьСтроку(Строка(Формат(СписываемСТоимость,"ЧГ=0")));   //Сумма
						Дфайл.ЗаписатьСтроку(СокрЛП(ГТД.НомерГТД));//ГТД
						ДФайл.ЗаписатьСтроку(Гтд.СтранаПроисхождения);//Страна происхождения
						Дфайл.ЗаписатьСтроку("");//Серия
						Дфайл.ЗаписатьСтроку("");//СрокГодности
						Дфайл.ЗаписатьСтроку("/СТРОКАТЧТОВАРЫ");//конечный тег товара
						
					КонецЕсли;	
					
					
					
				КонецЦикла;
				
				
				Дфайл.ЗаписатьСтроку("/КОНЕЦ");//конечный тег
				ДФайл.Закрыть();

				Сообщить("Данные выгружены в файл: "+ИмяФ);
			КонецЕсли;
		////////////////////////////////////////////////////////////
		////Обработка выгрузки заказа покупателя
		////////////////////////////////////////////////////////////
		ИначеЕсли ТипЗнч(Ссылка) =  Тип("ДокументСсылка.ЗаказПокупателя") тогда
			
			Режим = РежимДиалогаВыбораФайла.Сохранение;
			ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
			ДиалогОткрытияФайла.ПолноеИмяФайла = "";
			Фильтр = "Текст(*.txt)|*.txt";
			ДиалогОткрытияФайла.Фильтр = Фильтр;
			ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
			ДиалогОткрытияФайла.Заголовок = "Выберите имя файла";
			Если ДиалогОткрытияФайла.Выбрать() Тогда
				ИмяФ = ДиалогОткрытияФайла.ВыбранныеФайлы[0];
				   
				
				ДФайл = Новый ЗаписьТекста(ИмяФ,КодировкаТекста.ANSI); 
				ДФайл.ЗаписатьСтроку("ЗАКАЗ");// Заголовок
				ДФайл.ЗаписатьСтроку(Строка(ОбщегоНазначения.ПолучитьНомерНаПечать(Ссылка)));              //НомерДокумента
				ДФайл.ЗаписатьСтроку(Строка(Формат(Ссылка.Дата,"ДФ=yyyyMMdd")));              //ДатаДокумента
				ДФайл.ЗаписатьСтроку(Строка(Ссылка.Контрагент.ИНН));              //ИННПоставщика
				
				Для каждого СтрокаТЧ из Ссылка.Товары цикл
					
						Дфайл.ЗаписатьСтроку("СТРОКАТЧТОВАРЫ");//НАчальный тег товара  
						
						ДФайл.ЗаписатьСтроку(СтрокаТЧ.Номенклатура.Артикул);//артикул номенклатуры
						Дфайл.ЗаписатьСтроку(Лев(СтрокаТЧ.Номенклатура.Наименование,11));//11 цифр наименования, если нет артикула
						Дфайл.ЗаписатьСтроку(Строка(СтрокаТЧ.Номенклатура.НаименованиеПолное));//Полное наименование номенклатуры
						Дфайл.ЗаписатьСтроку(СтрокаТЧ.СтавкаНДС);//Ставка НДС
						ДФайл.ЗаписатьСтроку(Строка(СтрокаТЧ.ЕдиницаИзмерения));//ЕдИзм.
						Дфайл.ЗаписатьСтроку(Строка(Формат(СтрокаТЧ.количество,"ЧГ=0")));//Количество
						Дфайл.ЗаписатьСтроку(Строка(Формат(СтрокаТЧ.Сумма,"ЧГ=0")));   //Сумма

						Дфайл.ЗаписатьСтроку("/СТРОКАТЧТОВАРЫ");//конечный тег товара
	
				КонецЦикла;
				Дфайл.ЗаписатьСтроку("/КОНЕЦ");//конечный тег
                Сообщить("Данные выгружены в файл: "+ИмяФ);

			КонецЕсли;	
		КонецЕсли;	
	КонецПроцедуры
	
	
	Процедура ЗагрузитьДанныеПоДокументу (Ссылка, Форма) Экспорт
		
		Если ТипЗнч(Ссылка) =  Тип("ДокументСсылка.ПоступлениеТоваровУслуг") тогда
			
			Режим = РежимДиалогаВыбораФайла.Открытие;
			ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
			ДиалогОткрытияФайла.ПолноеИмяФайла = "";
			Фильтр = "Текст(*.txt)|*.txt";
			ДиалогОткрытияФайла.Фильтр = Фильтр;
			ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
			ДиалогОткрытияФайла.Заголовок = "Выберите имя файла";
			Если ДиалогОткрытияФайла.Выбрать() Тогда
				ИмяФ = ДиалогОткрытияФайла.ВыбранныеФайлы[0];			
				ДФайл = Новый ЧтениеТекста(ИмяФ,КодировкаТекста.ANSI); 
				Идентификатор = ДФайл.ПрочитатьСтроку();
				Если Идентификатор = "РЕАЛИЗАЦИЯ" тогда
					НомерРеализации = ДФайл.ПрочитатьСтроку();
					ДатаРеализации = Дата(ДФайл.ПрочитатьСтроку());
					ИНН = СокрЛП(ДФайл.ПрочитатьСтроку());
					ТаблицаТоваров = Новый ТаблицаЗначений;
					ТаблицаТоваров.Колонки.Добавить("Артикул");
					ТаблицаТоваров.Колонки.Добавить("Имя12");
					ТаблицаТоваров.Колонки.Добавить("ПолнНаименование");
					ТаблицаТоваров.Колонки.Добавить("СтавкаНДС");
					ТаблицаТоваров.Колонки.Добавить("ЕдИзмерения");
					ТаблицаТоваров.Колонки.Добавить("Колич");
					ТаблицаТоваров.Колонки.Добавить("Сумма");
					ТаблицаТоваров.Колонки.Добавить("ГТД");
					ТаблицаТоваров.Колонки.Добавить("Страна");
					ТаблицаТоваров.Колонки.Добавить("Серия");
					ТаблицаТоваров.Колонки.Добавить("Срок");
					
					СчитаннаяСтрока="";
					Пока не СчитаннаяСтрока = "/КОНЕЦ" цикл
						СчитаннаяСтрока = ДФайл.ПрочитатьСтроку();
						Если СчитаннаяСтрока = "СТРОКАТЧТОВАРЫ" тогда
							СтрокаТЗТоваров = ТаблицаТоваров.Добавить();
							СтрокаТЗТОваров.Артикул    =       ДФайл.ПрочитатьСтроку();      
							СтрокаТЗТОваров.Имя12      =       ДФайл.ПрочитатьСтроку();
							СтрокаТЗТОваров.ПолнНаименование = ДФайл.ПрочитатьСтроку();
							СтрокаТЗТОваров.СтавкаНДС   =      ДФайл.ПрочитатьСтроку();
							СтрокаТЗТОваров.ЕдИзмерения =      ДФайл.ПрочитатьСтроку();
							СтрокаТЗТОваров.Колич       =      Число(ДФайл.ПрочитатьСтроку());
							СтрокаТЗТОваров.Сумма       =      Число(ДФайл.ПрочитатьСтроку());
							СтрокаТЗТОваров.ГТД         =      ДФайл.ПрочитатьСтроку();
							СтрокаТЗТОваров.Страна      =      ДФайл.ПрочитатьСтроку();
							СтрокаТЗТОваров.Серия       =      ДФайл.ПрочитатьСтроку();
							СрокГодности                =      ДФайл.ПрочитатьСтроку();
							СтрокаТЗТОваров.Срок        =      ?(ЗначениеЗаполнено(СрокГодности),Дата(СрокГодности),'00010101');
						КонецЕсли;	
					КонецЦикла;	
					
				КонецЕсли;				
				ДФайл.Закрыть();
				//Обработаем считанные данные 
				//Проверим, заполнено ли поле контрагент?
				Если не ЗначениеЗаполнено(Форма.Контрагент) тогда
					//Пробуем найти по ИНН     					
					Контрагенты = Справочники.Контрагенты;
					НайденнаяСсылка = Контрагенты.НайтиПоРеквизиту("ИНН",ИНН);
					Если не НайденнаяСсылка = Контрагенты.ПустаяСсылка() Тогда
						Форма.Контрагент = НайденнаяСсылка.Ссылка; 		   
					КонецЕсли;
				КонецЕсли;	
					//Добавим в комсментарий, что  данные были загружены из файла обмена с вектором
					Форма.Комментарий = Форма.Комментарий + " НАКЛАДНАЯ: №"+ НомерРеализации +" от "+Формат(ДатаРеализации,"ДФ=dd.MM.yyyy");
					ФормаРеализации = ЭтотОбъект.ПолучитьФорму(,Форма);
					Для каждого СтрокаЗагружаемая из ТаблицаТоваров цикл
						
						СтрокаТОваров 							= ФормаРеализации.Товары.добавить();
						СтрокаТоваров.Артикул 					= СтрокаЗагружаемая.Артикул;
						СтрокаТоваров.Имя12 					= СтрокаЗагружаемая.Имя12;
						СтрокаТоваров.Наименование 				= СтрокаЗагружаемая.ПолнНаименование; 					
						СтрокаТоваров.НайденнаяНоменклатура 	= ПодобратьНоменклатуру(СтрокаЗагружаемая.Артикул, СтрокаЗагружаемая.Имя12);
						СтрокаТоваров.СтавкаНДСЗагруженная 		= СтрокаЗагружаемая.СтавкаНДС;
						СтрокаТоваров.СтавкаНДСТекущая 			= Строка(СтрокаТоваров.НайденнаяНоменклатура.СтавкаНДС);
						СтрокаТоваров.ЕдИзмеренияЗагруженная 	= СтрокаТЗТОваров.ЕдИзмерения;
						СтрокаТоваров.ЕдИзмеренияТекущая 		= Строка(СтрокаТоваров.НайденнаяНоменклатура.БазоваяЕдиницаИзмерения);
						СтрокаТоваров.Количество                = СтрокаЗагружаемая.Колич;
						СтрокаТоваров.Сумма 					= СтрокаЗагружаемая.Сумма;
						СтрокаТоваров.ГТДЗагруженный			= СтрокаЗагружаемая.ГТД;
						СтрокаТоваров.ГТДНайденный				= НайтиСериюНоменклатуры(СтрокаЗагружаемая.ГТД, СтрокаТоваров.НайденнаяНоменклатура);
						СтрокаТоваров.Страна					= НайтиСтрану(СтрокаЗагружаемая.Страна);
						СтрокаТоваров.СрокГодности				= СтрокаЗагружаемая.Срок;
						СтрокаТоваров.Серия 					= СтрокаЗагружаемая.Серия;
						//Пробуем найти загружаемый товар в документе, возможно он уже был загружен...
							ТаблицаУжеЗагруженныхТоваров = Форма.Товары.Выгрузить();
							Отбор = Новый Структура();
							Отбор.Вставить("Номенклатура",СтрокаТоваров.НайденнаяНоменклатура);
							Отбор.Вставить("СерияНоменклатуры",СтрокаТоваров.ГТДНайденный);
							Отбор.Вставить("Количество",СтрокаТоваров.Количество);
							Отбор.Вставить("СрокГодности",СтрокаТоваров.СрокГодности);

							Строки = ТаблицаУжеЗагруженныхТоваров.НайтиСтроки(Отбор);
							Если Строки.Количество() > 0 Тогда
							СтрокаТоваров.НеЗагружать	 = Истина;
							КонецЕсли;

					КонецЦикла;
					ФормаРеализации.Открыть();
			
				
                 					
				КонецЕсли;
				
		////////////////////////////////////////////////
		///ЗагрузкаДанных в заказ покупателя.
		////////////////////////////////////////////////
		 ИначеЕсли ТипЗнч(Ссылка) =  Тип("ДокументСсылка.ЗаказПокупателя") тогда
			 
			Режим = РежимДиалогаВыбораФайла.Открытие;
			ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
			ДиалогОткрытияФайла.ПолноеИмяФайла = "";
			Фильтр = "Текст(*.txt)|*.txt";
			ДиалогОткрытияФайла.Фильтр = Фильтр;
			ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
			ДиалогОткрытияФайла.Заголовок = "Выберите имя файла";
			Если ДиалогОткрытияФайла.Выбрать() Тогда
				ИмяФ = ДиалогОткрытияФайла.ВыбранныеФайлы[0];			
				ДФайл = Новый ЧтениеТекста(ИмяФ,КодировкаТекста.ANSI); 
				Идентификатор = ДФайл.ПрочитатьСтроку();
				Если Идентификатор = "ЗАКАЗ" тогда
					НомерЗаказа = ДФайл.ПрочитатьСтроку();
					ДатаЗаказа = Дата(ДФайл.ПрочитатьСтроку());
					ИНН = СокрЛП(ДФайл.ПрочитатьСтроку());
					ТаблицаТоваров = Новый ТаблицаЗначений;
					ТаблицаТоваров.Колонки.Добавить("Артикул");
					ТаблицаТоваров.Колонки.Добавить("Имя12");
					ТаблицаТоваров.Колонки.Добавить("ПолнНаименование");
					ТаблицаТоваров.Колонки.Добавить("СтавкаНДС");
					ТаблицаТоваров.Колонки.Добавить("ЕдИзмерения");
					ТаблицаТоваров.Колонки.Добавить("Колич");
					ТаблицаТоваров.Колонки.Добавить("Сумма");
					
					СчитаннаяСтрока="";
					Пока не СчитаннаяСтрока = "/КОНЕЦ" цикл
						СчитаннаяСтрока = ДФайл.ПрочитатьСтроку();
						Если СчитаннаяСтрока = "СТРОКАТЧТОВАРЫ" тогда
							СтрокаТЗТоваров = ТаблицаТоваров.Добавить();
							СтрокаТЗТОваров.Артикул    =       ДФайл.ПрочитатьСтроку();      
							СтрокаТЗТОваров.Имя12      =       ДФайл.ПрочитатьСтроку();
							СтрокаТЗТОваров.ПолнНаименование = ДФайл.ПрочитатьСтроку();
							СтрокаТЗТОваров.СтавкаНДС   =      ДФайл.ПрочитатьСтроку();
							СтрокаТЗТОваров.ЕдИзмерения =      ДФайл.ПрочитатьСтроку();
							СтрокаТЗТОваров.Колич       =      Число(ДФайл.ПрочитатьСтроку());
							СтрокаТЗТОваров.Сумма       =      Число(ДФайл.ПрочитатьСтроку());
						КонецЕсли;	
					КонецЦикла;	
					
				КонецЕсли;				
				ДФайл.Закрыть();
				//Обработаем считанные данные 
				//Проверим, заполнено ли поле контрагент?
				Если не ЗначениеЗаполнено(Форма.Контрагент) тогда
					//Пробуем найти по ИНН     					
					Контрагенты = Справочники.Контрагенты;
					НайденнаяСсылка = Контрагенты.НайтиПоРеквизиту("ИНН",ИНН);
					Если не НайденнаяСсылка = Контрагенты.ПустаяСсылка() Тогда
						Форма.Контрагент = НайденнаяСсылка.Ссылка; 		   
					КонецЕсли;
				КонецЕсли;	
					//Добавим в комсментарий, что  данные были загружены из файла обмена с вектором
					Форма.Комментарий = Форма.Комментарий + " ПРЕГРУЖЕНО ИЗ ЗАКАЗА: №"+ НомерЗаказа +" от "+Формат(ДатаЗаказа, "ДФ=dd.MM.yyyy");
					ФормаЗаказа = ЭтотОбъект.ПолучитьФорму("ФормаЗаказ",Форма);
					Для каждого СтрокаЗагружаемая из ТаблицаТоваров цикл
						
						СтрокаТОваров 							= ФормаЗаказа.Товары.добавить();
						СтрокаТоваров.Артикул 					= СтрокаЗагружаемая.Артикул;
						СтрокаТоваров.Имя12 					= СтрокаЗагружаемая.Имя12;
						СтрокаТоваров.Наименование 				= СтрокаЗагружаемая.ПолнНаименование; 					
						СтрокаТоваров.НайденнаяНоменклатура 	= ПодобратьНоменклатуру(СтрокаЗагружаемая.Артикул, СтрокаЗагружаемая.Имя12);
						СтрокаТоваров.СтавкаНДСЗагруженная 		= СтрокаЗагружаемая.СтавкаНДС;
						СтрокаТоваров.СтавкаНДСТекущая 			= Строка(СтрокаТоваров.НайденнаяНоменклатура.СтавкаНДС);
						СтрокаТоваров.ЕдИзмеренияЗагруженная 	= СтрокаТЗТОваров.ЕдИзмерения;
						СтрокаТоваров.ЕдИзмеренияТекущая 		= Строка(СтрокаТоваров.НайденнаяНоменклатура.БазоваяЕдиницаИзмерения);
						СтрокаТоваров.Количество                = СтрокаЗагружаемая.Колич;
						СтрокаТоваров.Сумма 					= СтрокаЗагружаемая.Сумма;
					КонецЦикла;
					ФормаЗаказа.Открыть();
			
				
                 					
				КонецЕсли;

		
		КонецЕсли;
	КОнецПроцедуры	

	
Функция ПреобразоватьСтавкуНДС (СтавкаНДС) Экспорт
	
	Если СтавкаНДС = "18%" тогда
		 Возврат Перечисления.СтавкиНДС.НДС18;
	ИначеЕсли СтавкаНДС = "18% / 118%" тогда
		 Возврат Перечисления.СтавкиНДС.НДС18_118;
	ИначеЕсли СтавкаНДС = "20%" тогда
		 Возврат Перечисления.СтавкиНДС.НДС20;		 		 
	ИначеЕсли СтавкаНДС = "20% / 120%" тогда
		 Возврат Перечисления.СтавкиНДС.НДС20_120;
	ИначеЕсли СтавкаНДС = "10%" тогда
		 Возврат Перечисления.СтавкиНДС.НДС10;		 
	ИначеЕсли СтавкаНДС = "10% / 110%" тогда
		 Возврат Перечисления.СтавкиНДС.НДС10_110;
	ИначеЕсли СтавкаНДС = "0%" тогда
		 Возврат Перечисления.СтавкиНДС.НДС0;		 
	КонецЕсли;	
	                                        
КонецФункции	

Функция НайтиСтрану (СтрокаПоиска)Экспорт
	
Страны = Справочники.КлассификаторСтранМира;
НайденнаяСсылка = Страны.НайтиПоНаименованию(СтрокаПоиска);
Возврат НайденнаяСсылка;	
	
КонецФункции	

Функция ПодобратьНоменклатуру(Артикул, Имя12)
	  //Пробуем найти по артикулу
	  Запрос = Новый Запрос;
	  Запрос.Текст = "ВЫБРАТЬ
	  |	Номенклатура.Ссылка
	  |ИЗ
	  |	Справочник.Номенклатура КАК Номенклатура
	  |ГДЕ
	  |	Номенклатура.ПометкаУдаления = ЛОЖЬ
	  |	И Номенклатура.Артикул ПОДОБНО &Артикул";
	  
	  Запрос.УстановитьПараметр("Артикул", СокрЛП(Артикул)+"%" );
	  
	  Результат = Запрос.Выполнить();
	  Выборка = Результат.Выбрать();
	  
	  Если Выборка.Следующий() и ЗначениеЗаполнено(Артикул) Тогда
	  
	  	  Возврат Выборка.Ссылка;
		  
	  Иначе	  
		  Запрос = Новый Запрос;
	  Запрос.Текст = "ВЫБРАТЬ
	                 |	Номенклатура.Ссылка
	                 |ИЗ
	                 |	Справочник.Номенклатура КАК Номенклатура
	                 |ГДЕ
	                 |	Номенклатура.ПометкаУдаления = ЛОЖЬ
	                 |	И Номенклатура.Наименование ПОДОБНО &Наименование";
	  
	  Запрос.УстановитьПараметр("Наименование", СокрЛП(Имя12)+"%" );
	  
	  Результат = Запрос.Выполнить();
	  Выборка = Результат.Выбрать();
	  
	  Если Выборка.Следующий() и ЗначениеЗаполнено(Имя12) Тогда
	  
	  	  Возврат Выборка.Ссылка;
		  
	  Иначе	  
		  Возврат Справочники.Номенклатура.ПустаяСсылка();
	  КонецЕсли;

	  КонецЕсли;
	  
	  
  КонецФункции	
  
Функция НайтиСериюНоменклатуры (ГТД, НоменклатураВладелец) экспорт
	Запрос = Новый Запрос;
	  Запрос.Текст = "ВЫБРАТЬ
	                 |	СерииНоменклатуры.Ссылка
	                 |ИЗ
	                 |	Справочник.СерииНоменклатуры КАК СерииНоменклатуры
	                 |ГДЕ
	                 |	СерииНоменклатуры.ПометкаУдаления = ЛОЖЬ
	                 |	И СерииНоменклатуры.Наименование ПОДОБНО &Наименование
	                 |	И СерииНоменклатуры.Владелец = &Владелец";
	  
	  Запрос.УстановитьПараметр("Наименование", СокрЛП(ГТД)+"%" );
	  Запрос.УстановитьПараметр("Владелец", НоменклатураВладелец);
	  
	  Результат = Запрос.Выполнить();
	  Выборка = Результат.Выбрать();
	  
	  Если Выборка.Следующий() и ЗначениеЗаполнено(ГТД) Тогда
	  
	  	  Возврат Выборка.Ссылка;
		  
	  Иначе	  
		  Возврат Справочники.СерииНоменклатуры.ПустаяСсылка();
	  КонецЕсли;
  
  КонецФункции	  
  
