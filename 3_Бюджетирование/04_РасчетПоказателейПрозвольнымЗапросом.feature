﻿#language: ru
@tree

@UH32_Budget
@ERPUH32_Budget
@Perform_Budget

Функционал: 04. Проверка произвольных запросов расчета показателей

	Как Администратор я хочу
	Проверить что произвольные запросы работают для расчета показателей
	чтобы показатели рассчитывались без ошибок

Контекст: 

	И я закрыл все окна клиентского приложения

Сценарий: 04.00 Определение типа приложения

	И я закрываю TestClient "CPM - Budget"
	И я подключаю TestClient "CPM - Budget" логин "Administrator" пароль ''
	Пусть Инициализация переменных

Сценарий: 04.01 Создание вида отчета "VA - Arbitrary request"

	И Я создаю вид отчета с именем "VA - Arbitrary request" и родителем "VA - Report group"
	
	* Редактируем структуру отчета
		И Я открываю контруктор отчета с именем "VA - Arbitrary request"
		И Я в конструкторе отчета добавляю строку с именем "Product range"
		И Я в конструкторе отчета добавляю колонку с именем "Price"
		И Я в конструкторе отчета добавляю аналитику с кодом "VA0Product" в ячейку 'R2C2' 

	И Я Для вида отчета "VA - Arbitrary request" создаю бланк по умолчанию
	И Я Для вида отчета "VA - Arbitrary request" в бланке для группы раскрытия с адресом 'R8C1' задаю сортировку "Product range" "Product ID"

Сценарий: 04.02 Проверка поведения формы настройки показателей

	И Я открываю контруктор отчета с именем "VA - Arbitrary request"
				
	* Вводим формулу расчета	
		Тогда открылось окно "Report wizard"
		И из выпадающего списка с именем 'WorkMode' я выбираю точное значение "Indicators calculation formulas"
		И в табличном документе 'SpreadsheetFieldTemlate' я перехожу к ячейке 'R2C2'
		И в табличном документе 'SpreadsheetFieldTemlate' я делаю двойной клик на текущей ячейке
		И в поле с именем 'TextDocumentFieldProcedure' я ввожу текст ' '
		И я нажимаю на кнопку с именем 'AddOperand1'

	* Проверяем поведение формы при расширенном движке расчета показателей
		Тогда открылось окно "Data sources"
		И я нажимаю на кнопку с именем 'FormCreate'			
		Когда открылось окно "Data source (create)"
		И из выпадающего списка с именем 'MethodOfObtaining' я выбираю точное значение "Current infobase report item indicator"
		И элемент формы с именем 'UseMultiperiodContext' отсутствует на форме
		И элемент формы с именем 'Help' отсутствует на форме
		И из выпадающего списка с именем 'MethodOfObtaining' я выбираю точное значение "Current infobase accumulation register"
		И элемент формы с именем 'UseMultiperiodContext' отсутствует на форме
		И элемент формы с именем 'Help' отсутствует на форме
		И из выпадающего списка с именем 'MethodOfObtaining' я выбираю точное значение "Current infobase accounting register"
		И элемент формы с именем 'UseMultiperiodContext' отсутствует на форме
		И элемент формы с именем 'Help' отсутствует на форме
		И из выпадающего списка с именем 'MethodOfObtaining' я выбираю точное значение "Current infobase information register"
		И элемент формы с именем 'UseMultiperiodContext' отсутствует на форме
		И элемент формы с именем 'Help' отсутствует на форме
		И из выпадающего списка с именем 'MethodOfObtaining' я выбираю точное значение "Current infobase catalog"
		И элемент формы с именем 'UseMultiperiodContext' отсутствует на форме
		И элемент формы с именем 'Help' отсутствует на форме
		И из выпадающего списка с именем 'MethodOfObtaining' я выбираю точное значение "Arbitrary query to current infobase"
		И элемент формы с именем 'UseMultiperiodContext' присутствует на форме
		И элемент формы с именем 'Help' присутствует на форме			
		И я нажимаю на кнопку с именем 'Help'
		Тогда открылось окно "Help"
		И Я закрываю окно "Help"

	* Устанавливаем текст запроса
		Когда открылось окно "Data source (create) *"
		Если '$$IsCPM$$' Тогда 
			И в поле с именем 'QueryTextForm' я ввожу текст 
				|'SELECT'|
				|'	ItemsPrices.Period AS Date,'|
				|'	ItemsPrices.Products AS Products,'|
				|'	MAX(ItemsPrices.Price) AS Price'|
				|'INTO втCalculated'|
				|'FROM'|
				|'	InformationRegister.ItemsPrices AS ItemsPrices'|
				|'WHERE'|
				|'	ItemsPrices.Period >= &StartDateParameter'|
				|'	AND ItemsPrices.Period <= &EndDateParameter'|
				|'	AND ItemsPrices.PriceType_ = &ParameterPriceType_'|
				|''|
				|'GROUP BY'|
				|'	ItemsPrices.Period,'|
				|'	ItemsPrices.Products'|
				|';'|
				|''|
				|'////////////////////////////////////////////////////////////////////////////////'|
				|'SELECT'|
				|'	втCalculated.Date AS Date,'|
				|'	втCalculated.Products AS Products,'|
				|'	втCalculated.Price AS Price'|
				|'FROM'|
				|'	втCalculated AS втCalculated'|
		Если '$$IsERPCPM$$' Тогда
			И в поле с именем 'QueryTextForm' я ввожу текст 
				|'SELECT'|
				|'	ItemsPrices.Period AS Date,'|
				|'	ItemsPrices.Products AS Products,'|
				|'	MAX(ItemsPrices.Price) AS Price'|
				|'INTO втCalculated'|
				|'FROM'|
				|'	InformationRegister.ItemsPrices25 AS ItemsPrices'|
				|'WHERE'|
				|'	ItemsPrices.Period >= &StartDateParameter'|
				|'	AND ItemsPrices.Period <= &EndDateParameter'|
				|'	AND ItemsPrices.KindЦены = &ParameterPriceType_'|
				|''|
				|'GROUP BY'|
				|'	ItemsPrices.Period,'|
				|'	ItemsPrices.Products'|
				|';'|
				|''|
				|'////////////////////////////////////////////////////////////////////////////////'|
				|'SELECT'|
				|'	втCalculated.Date AS Date,'|
				|'	втCalculated.Products AS Products,'|
				|'	втCalculated.Price AS Price'|
				|'FROM'|
				|'	втCalculated AS втCalculated'|
		И я нажимаю на кнопку с именем 'QueryWizard'
		Тогда открылось окно "Query wizard"
		И Я закрываю окно "Query wizard"
		Если открылось окно '1C:Enterprise' Тогда
			И я нажимаю на кнопку с именем 'Button0'
		Тогда открылось окно "Data source (create) *"
		И я нажимаю на кнопку с именем 'EditQueryText'
		И я перехожу к закладке с именем 'ComplianceAnalyst'
		
	* Проверяем заполнение таблиц
		Когда открылось окно "Data source (create) *"
		И в таблице 'FieldsTreeDB' я разворачиваю строку:
			| "Field"                 |
			| "Query parameters(3)" |
		И в таблице 'FieldsTreeDB' я разворачиваю строку
			| "Field"                 |
			| "Data source fields(3)" |
		Тогда Таблица 'FieldsTreeDB' содержит '8' строк из списка:			
			| "Field"                     |
			| "Query parameters(3)"     |
			| 'StartDateParameter'       |
			| 'EndDateParameter'    |
			| 'ParameterPriceType_'           |
			| "Data source fields(3)" |
			| 'Date'                     |
			| 'Products'             |
			| 'Price'                     |
		Тогда Таблица 'ComplianceTable' содержит '3' строк из списка:
			| "Destination dimension"       | "Filling method" | "Column name"    | "Dimension kind" |
			| "Dimension 1: Product range" | "Source field"    | '[Products]' | "Product range"  |
			| "Value"                  | "Source field"    | '[Price]'         | ''              |
			| "Period"                    | "Source field"    | '[Date]'         | ''              |
		И я перехожу к закладке с именем 'FiltersPage'
		Когда открылось окно "Data source (create) *"
		Тогда Таблица 'TreeOfFilterParametersDB' содержит '3' строк из списка:
			| "Field"                    | "Filter" | "Filter clarification" | "Value to check" |
			| '[StartDateParameter]'    | ''      | ''                 | ''                      |
			| '[EndDateParameter]' | ''      | ''                 | ''                      |
			| '[ParameterPriceType_]'        | ''      | ''                 | ''                      |

	* Заполняем параметры		
		Когда открылось окно "Data source (create) *"	
		И в таблице 'TreeOfFilterParametersDB' я перехожу к строке:
			| "Field"                 |
			| '[StartDateParameter]' |
		И в таблице 'TreeOfFilterParametersDB' из выпадающего списка с именем 'ParameterCalculationMethod' я выбираю точное значение "Report period start date"
		И в таблице 'TreeOfFilterParametersDB' я завершаю редактирование строки
		И в таблице 'TreeOfFilterParametersDB' я перехожу к строке:
			| "Field"                    |
			| '[EndDateParameter]' |
		И в таблице 'TreeOfFilterParametersDB' я выбираю текущую строку
		И в таблице 'TreeOfFilterParametersDB' из выпадающего списка с именем 'ParameterCalculationMethod' я выбираю точное значение "Report period end date"
		И в таблице 'TreeOfFilterParametersDB' я завершаю редактирование строки
		И в таблице 'TreeOfFilterParametersDB' я перехожу к строке:
			| "Field"             |
			| '[ParameterPriceType_]' |
		И в таблице 'TreeOfFilterParametersDB' я выбираю текущую строку
		И в таблице 'TreeOfFilterParametersDB' из выпадающего списка с именем 'ParameterCalculationMethod' я выбираю точное значение "Fixed value"
		И в таблице 'TreeOfFilterParametersDB' я активизирую поле с именем 'DefiningMethodClarification'
		И в таблице 'TreeOfFilterParametersDB' из выпадающего списка с именем 'DefiningMethodClarification' я выбираю по строке "VA - Products"
		И в таблице 'TreeOfFilterParametersDB' я завершаю редактирование строки
		Тогда Таблица 'TreeOfFilterParametersDB' содержит '3' строк из списка:
			| "Field"                    | "Filter"                      | "Filter clarification"  | "Value to check" |
			| '[StartDateParameter]'    | "Report period start date" | ''                  | ''                      |
			| '[EndDateParameter]' | "Report period end date"  | ''                  | ''                      |
			| '[ParameterPriceType_]'        | "Fixed value"     | "VA - Products" | ''                      |

	* Записываем элемент
		Когда открылось окно "Data source (create) *"
		И я нажимаю на кнопку с именем 'FormWriteAndClose'
		И я жду закрытия окна "Data source (create) *" в течение 20 секунд
		Тогда открылось окно "Data sources"
		И в таблице 'List' я выбираю текущую строку
		Тогда открылось окно "Report wizard *"
		И я нажимаю на кнопку с именем 'WriteAndCollapse'

Сценарий: 04.03 Создание экземпляра отчета - "VA - Arbitrary request" с использованием многопериодного контекста

	И Я создаю экземпляр отчета для вида отчета "VA - Arbitrary request" сценарий "VA - Main scenario" период '1/1/2024' '3/31/2024' периодичность "Month" организация "Mercury LLC" проект '' аналитики '' '' '' '' '' ''

	* Документ должен быть пустой
		Тогда табличный документ 'SpreadsheetFieldTemlate' равен:
			| "VA - Arbitrary request" | ''               | ''                | ''             | ''      |
			| ''                         | ''               | ''                | ''             | ''      |
			| ''                         | "January 2024" | "February 2024" | "March 2024" | "TOTAL" |
			| ''                         | "Price"           | "Price"            | "Price"         | "Price"  |
			| "Product range"             | '0'              | '0'               | '0'            | '0'     |

	* Рассчитываем значения показателей	
		Когда открылось окно '$WindowTitle$'
		И я нажимаю на кнопку с именем 'FormFillByDefault'
		Тогда табличный документ 'SpreadsheetFieldTemlate' равен:
			| "VA - Arbitrary request"                                        | ''               | ''                | ''             | ''           |
			| ''                                                                | ''               | ''                | ''             | ''           |
			| ''                                                                | "January 2024" | "February 2024" | "March 2024" | "TOTAL"      |
			| ''                                                                | "Price"           | "Price"            | "Price"         | "Price"       |
			| "Product range"                                                    | '6,030,000'      | '6,633,000'       | '7,495,400'    | '20,158,400' |
			| "5C:Corporate performance management "                                      | '1,250,000'      | '1,375,000'       | '1,553,800'    | '4,178,800'  |
			| "2C:Corporation "                                                  | '2,050,000'      | '2,255,000'       | '2,548,200'    | '6,853,200'  |
			| "4C:Enterprise 8.3 CORP. Server License (x86-64) "           | '180,000'        | '198,000'         | '223,700'      | '601,700'    |
			| "1C:ERP. Corporate performance management "                                   | '1,950,000'      | '2,145,000'       | '2,423,900'    | '6,518,900'  |
			| "3C:Enterprise 8 CORP. Client license for 100 users " | '600,000'        | '660,000'         | '745,800'      | '2,005,800'  |
	
	* Записываем документ
		Когда открылось окно '$WindowTitle$'
		И я нажимаю на кнопку с именем 'WriteAndClose'
		И я жду закрытия окна '$WindowTitle$' в течение 20 секунд

Сценарий: 04.04 Проверка поведениея формы настройки показателей без использования многопериодного контекста

	И Я открываю контруктор отчета с именем "VA - Arbitrary request"

	* Снимаем флаг многопериодного контекста у источника данных	
		Тогда открылось окно "Report wizard"
		И из выпадающего списка с именем 'WorkMode' я выбираю точное значение "Indicators calculation formulas"
		И в табличном документе 'SpreadsheetFieldTemlate' я перехожу к ячейке 'R2C2'
		И в табличном документе 'SpreadsheetFieldTemlate' я делаю двойной клик на текущей ячейке
		И я нажимаю на кнопку с именем 'AddOperand1'
		Когда открылось окно "Data sources"
		И я выбираю пункт контекстного меню с именем 'ListContextMenuChange' на элементе формы с именем 'List'
		Если '$$ЭтоPerform$$' Тогда
			Тогда открылось окно 'Arbitrary query to current infobase (Data source)'
		Иначе					
			Тогда открылось окно "Arbitrary query to current infobase (Data source)"
		И я запоминаю текущее окно как 'WindowTitle'
		И я нажимаю на кнопку с именем 'FormWriteAndClose'
		И я жду закрытия окна '$WindowTitle$' в течение 20 секунд

	* Проверяем поведение формы при расширенном движке расчета показателей		
		Тогда открылось окно "Data sources"
		И я выбираю пункт контекстного меню с именем 'ListContextMenuChange' на элементе формы с именем 'List'
		Тогда открылось окно '$WindowTitle$'
		И элемент формы с именем 'UseMultiperiodContext' присутствует на форме
		И элемент формы с именем 'Help' присутствует на форме
		И я снимаю флаг с именем 'UseMultiperiodContext'
		И я перехожу к закладке с именем 'ComplianceAnalyst'
		И я перехожу к закладке с именем 'FiltersPage'
		Тогда Таблица 'TreeOfFilterParametersDB' содержит '3' строк из списка:
			| "Field"                    | "Filter"                      | "Filter clarification"  | "Value to check" |
			| '[StartDateParameter]'    | "Report period start date" | ''                  | ''                      |
			| '[EndDateParameter]' | "Report period end date"  | ''                  | ''                      |
			| '[ParameterPriceType_]'        | "Fixed value"     | "VA - Products" | ''                      |
		И я нажимаю на кнопку с именем 'FormWrite'
		И флаг с именем 'UseMultiperiodContext' равен 'False'												
								
	* Проверяем заполнение таблиц
		Когда открылось окно '$WindowTitle$'
		И я нажимаю на кнопку с именем 'EditQueryText'
		И я нажимаю на кнопку с именем 'EditQueryText'				
		И в таблице 'FieldsTreeDB' я разворачиваю строку:
			| "Field"                 |
			| "Query parameters(3)" |
		И в таблице 'FieldsTreeDB' я разворачиваю строку
			| "Field"                     |
			| "Data source fields(3)" |
		Тогда Таблица 'FieldsTreeDB' содержит '8' строк из списка:				
			| "Field"                     |
			| "Query parameters(3)"     |
			| 'StartDateParameter'       |
			| 'EndDateParameter'    |
			| 'ParameterPriceType_'           |
			| "Data source fields(3)" |
			| 'Date'                     |
			| 'Products'             |
			| 'Price'                     |
		Тогда Таблица 'ComplianceTable' содержит '2' строк из списка:	
			| "Destination dimension"       | "Filling method" | "Column name"    | "Dimension kind" |
			| "Dimension 1: Product range" | "Source field"    | '[Products]' | "Product range"  |
			| "Value"                  | "Source field"    | '[Price]'         | ''              |
		И я перехожу к закладке с именем 'FiltersPage'
		Когда открылось окно '$WindowTitle$'
		Тогда Таблица 'TreeOfFilterParametersDB' содержит '3' строк из списка:
			| "Field"                    | "Filter"                      | "Filter clarification"  | "Value to check" |
			| '[StartDateParameter]'    | "Report period start date" | ''                  | ''                      |
			| '[EndDateParameter]' | "Report period end date"  | ''                  | ''                      |
			| '[ParameterPriceType_]'        | "Fixed value"     | "VA - Products" | ''                      |
	 			
	* Закрываем источник данных
		Когда открылось окно '$WindowTitle$'
		И Я закрываю окно '$WindowTitle$'
		Тогда открылось окно "Data sources"
		И Я закрываю окно "Data sources"
		Тогда открылось окно "Report wizard"
		И я нажимаю на кнопку с именем 'UndoFormulaEdit'

Сценарий: 04.05 Создание экземпляра отчета - "VA - Arbitrary request" без использования многопериодного контекста

	И Я создаю экземпляр отчета для вида отчета "VA - Arbitrary request" сценарий "VA - Main scenario" период '1/1/2024' '3/31/2024' периодичность "Month" организация "Venus LLC" проект '' аналитики '' '' '' '' '' ''

	* Документ должен быть пустой
		Тогда табличный документ 'SpreadsheetFieldTemlate' равен:
			| "VA - Arbitrary request" | ''               | ''                | ''             | ''      |
			| ''                         | ''               | ''                | ''             | ''      |
			| ''                         | "January 2024" | "February 2024" | "March 2024" | "TOTAL" |
			| ''                         | "Price"           | "Price"            | "Price"         | "Price"  |
			| "Product range"             | '0'              | '0'               | '0'            | '0'     |

	* Рассчитываем значения показателей	
		Когда открылось окно '$WindowTitle$'
		И я нажимаю на кнопку с именем 'FormFillByDefault'
		Тогда табличный документ 'SpreadsheetFieldTemlate' равен:
			| "VA - Arbitrary request"                                        | ''               | ''                | ''             | ''           |
			| ''                                                                | ''               | ''                | ''             | ''           |
			| ''                                                                | "January 2024" | "February 2024" | "March 2024" | "TOTAL"      |
			| ''                                                                | "Price"           | "Price"            | "Price"         | "Price"       |
			| "Product range"                                                    | '6,030,000'      | '6,633,000'       | '7,495,400'    | '20,158,400' |
			| "5C:Corporate performance management "                                      | '1,250,000'      | '1,375,000'       | '1,553,800'    | '4,178,800'  |
			| "2C:Corporation "                                                  | '2,050,000'      | '2,255,000'       | '2,548,200'    | '6,853,200'  |
			| "4C:Enterprise 8.3 CORP. Server License (x86-64) "           | '180,000'        | '198,000'         | '223,700'      | '601,700'    |
			| "1C:ERP. Corporate performance management "                                   | '1,950,000'      | '2,145,000'       | '2,423,900'    | '6,518,900'  |
			| "3C:Enterprise 8 CORP. Client license for 100 users " | '600,000'        | '660,000'         | '745,800'      | '2,005,800'  |

	* Записываем документ
		Когда открылось окно '$WindowTitle$'
		И я нажимаю на кнопку с именем 'WriteAndClose'
		И я жду закрытия окна '$WindowTitle$' в течение 20 секунд
