/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.
Занятие "02 - Оператор SELECT и простые фильтры, GROUP BY, HAVING".

Задания выполняются с использованием базы данных WideWorldImporters.

Бэкап БД можно скачать отсюда:
https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0
Нужен WideWorldImporters-Full.bak

Описание WideWorldImporters от Microsoft:
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-what-is
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-oltp-database-catalog
*/

-- ---------------------------------------------------------------------------
-- Задание - написать выборки для получения указанных ниже данных.
-- ---------------------------------------------------------------------------

USE WideWorldImporters

/*
1. Все товары, в названии которых есть "urgent" или название начинается с "Animal".
Вывести: ИД товара (StockItemID), наименование товара (StockItemName).
Таблицы: Warehouse.StockItems.
*/

TODO: select StockItemID, StockItemName
FROM warehouse.stockitems 
where (StockItemName like '%urgent%' 
	 or StockItemName like 'Animal%')

/*
2. Поставщиков (Suppliers), у которых не было сделано ни одного заказа (PurchaseOrders).
Сделать через JOIN, с подзапросом задание принято не будет.
Вывести: ИД поставщика (SupplierID), наименование поставщика (SupplierName).
Таблицы: Purchasing.Suppliers, Purchasing.PurchaseOrders.
По каким колонкам делать JOIN подумайте самостоятельно.
*/

TODO: 
select ps.SupplierID,
       ps.SupplierName
from Purchasing.Suppliers ps
join Purchasing.PurchaseOrders ppo on ps.SupplierID = ppo.PurchaseOrderID
where ps.DeliveryMethodID is null


/*
3. Заказы (Orders) с ценой товара (UnitPrice) более 100$ 
либо количеством единиц (Quantity) товара более 20 штук
и присутствующей датой комплектации всего заказа (PickingCompletedWhen).
Вывести:
* OrderID
* дату заказа (OrderDate) в формате ДД.ММ.ГГГГ
* название месяца, в котором был сделан заказ
* номер квартала, в котором был сделан заказ
* треть года, к которой относится дата заказа (каждая треть по 4 месяца)
* имя заказчика (Customer)
Добавьте вариант этого запроса с постраничной выборкой,
пропустив первую 1000 и отобразив следующие 100 записей.

Сортировка должна быть по номеру квартала, трети года, дате заказа (везде по возрастанию).

Таблицы: Sales.Orders, Sales.OrderLines, Sales.Customers.
*/

TODO: 
select o.OrderID,
       convert(nvarchar(16),o.OrderDate,104) as OrderDate,
	   Datename(MONTH,o.OrderDate) as "Месяц Заказа",
	   datename(q,o.orderdate) as "Квартал",
 case 
	       when DATEPART(m, o.OrderDate) IN (1, 2, 3, 4) Then 1
		   when DATEPART(m, o.OrderDate) IN (5, 6, 7, 8) Then 2
	       when DATEPART(m, o.OrderDate) IN (9, 10, 11, 12) Then 3
End as "Треть" ,
		 CustomerName
from Sales.Orders o 
    join Sales.OrderLines i on o.OrderID = i.OrderID
	join Sales.Customers c on o.CustomerID = c.CustomerID
where (UnitPrice >100 or Quantity >20) and o.PickingCompletedWhen is not null
order by Квартал ASC, Треть ASC, OrderDate ASC

----------------------

select o.OrderID,
       convert(nvarchar(16),o.OrderDate,104) as OrderDate,
	   Datename(MONTH,o.OrderDate) as "Месяц Заказа",
	   datename(q,o.orderdate) as "Квартал",
 case 
	       when DATEPART(m, o.OrderDate) IN (1, 2, 3, 4) Then 1
		   when DATEPART(m, o.OrderDate) IN (5, 6, 7, 8) Then 2
	       when DATEPART(m, o.OrderDate) IN (9, 10, 11, 12) Then 3
End as "Треть" ,
		 CustomerName
from Sales.Orders o 
    join Sales.OrderLines i on o.OrderID = i.OrderID
	join Sales.Customers c on o.CustomerID = c.CustomerID
where (UnitPrice >100 or Quantity >20) and o.PickingCompletedWhen is not null
order by Квартал ASC, Треть ASC, OrderDate ASC
OFFSET 1000 rows fetch first 100 rows only;


/*
4. Заказы поставщикам (Purchasing.Suppliers),
которые должны быть исполнены (ExpectedDeliveryDate) в январе 2013 года
с доставкой "Air Freight" или "Refrigerated Air Freight" (DeliveryMethodName)
и которые исполнены (IsOrderFinalized).
Вывести:
* способ доставки (DeliveryMethodName)
* дата доставки (ExpectedDeliveryDate)
* имя поставщика
* имя контактного лица принимавшего заказ (ContactPerson)

Таблицы: Purchasing.Suppliers, Purchasing.PurchaseOrders, Application.DeliveryMethods, Application.People.
*/


TODO: select DeliveryMethodName, ExpectedDeliveryDate,SupplierName,FullName as ContactPerson
from  Purchasing.PurchaseOrders ppo
      join Purchasing.Suppliers ps on ppo.SupplierID = ps.SupplierID
	  join Application.DeliveryMethods adm on adm.DeliveryMethodID = ps.DeliveryMethodID
	  join Application.People ap on ap.PersonID = ps.PrimaryContactPersonID
where (ExpectedDeliveryDate between '20130101' and '20130131') and
      (DeliveryMethodName like '%Air%') and (IsOrderFinalized = 1)

/*
5. Десять последних продаж (по дате продажи) с именем клиента и именем сотрудника,
который оформил заказ (SalespersonPerson).
Сделать без подзапросов.
*/
TODO: 
select top 10
OrderID,CustomerName,Fullname as SalesPerson
from sales.Orders so
join Application.People ap on so.SalespersonPersonID = ap.PersonID
join sales.Customers sc on sc.CustomerID = so.CustomerID
where OrderDate BETWEEN '20100101' AND '99990131'
order by orderid desc


/*
6. Все ид и имена клиентов и их контактные телефоны,
которые покупали товар "Chocolate frogs 250g".
Имя товара смотреть в таблице Warehouse.StockItems.
*/

TODO: 
select sol.OrderID, sol.StockItemID,so.CustomerID,sc.CustomerName,sc.PhoneNumber
FROM sales.OrderLines sol
join sales.orders so on sol.OrderID = so.OrderID
join sales.Customers sc on sc.CustomerID = so.CustomerID
where (Description like 'Chocolate frogs 250g')


/*
7. Посчитать среднюю цену товара, общую сумму продажи по месяцам
Вывести:
* Год продажи (например, 2015)
* Месяц продажи (например, 4)
* Средняя цена за месяц по всем товарам
* Общая сумма продаж за месяц

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

TODO: 
select 
 year(InvoiceDate) AS 'Год Продажи',
 month(InvoiceDate) as 'Месяц Продажи',
 avg(sil.unitprice) as 'AVG Price',
 sum(sil.Quantity * sil.unitprice) as 'СуммаПродаж'
 from Sales.Invoices si
 join sales.InvoiceLines sil on si.InvoiceID = sil.InvoiceID
 group by year(InvoiceDate), month(InvoiceDate) 
 ORDER BY year(InvoiceDate), month(InvoiceDate)
     

/*
8. Отобразить все месяцы, где общая сумма продаж превысила 10 000

Вывести:
* Год продажи (например, 2015)
* Месяц продажи (например, 4)
* Общая сумма продаж

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

TODO: 
select 
 year(InvoiceDate) AS 'Год Продажи',
 month(InvoiceDate) as 'Месяц Продажи',
 sum(sil.Quantity * sil.unitprice) as 'Общая сумма продаж'
 from Sales.Invoices si
 join sales.InvoiceLines sil on si.InvoiceID = sil.InvoiceID
 group by year(InvoiceDate), month(InvoiceDate) 
 ORDER BY year(InvoiceDate), month(InvoiceDate)
     

/*
9. Вывести сумму продаж, дату первой продажи
и количество проданного по месяцам, по товарам,
продажи которых менее 50 ед в месяц.
Группировка должна быть по году,  месяцу, товару.

Вывести:
* Год продажи
* Месяц продажи
* Наименование товара
* Сумма продаж
* Дата первой продажи
* Количество проданного

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

select 
year(InvoiceDate) AS 'Год Продажи',
month(InvoiceDate) as 'Месяц Продажи',
convert(nvarchar(100),Description,104) as 'Наименование товара',
 sum(sil.quantity*  sil.unitprice) as 'Сумма продаж',
 min(InvoiceDate) as 'Дата первой продажи',
 sum(sil.quantity) as 'Количество проданного'
 from Sales.Invoices si
 join sales.InvoiceLines sil on si.InvoiceID = sil.InvoiceID
 where Description is not null
 group by year(InvoiceDate), month(InvoiceDate) , Description
 ORDER BY year(InvoiceDate), month(InvoiceDate) , Description



-- ---------------------------------------------------------------------------
-- Опционально
-- ---------------------------------------------------------------------------
/*
Написать запросы 8-9 так, чтобы если в каком-то месяце не было продаж,
то этот месяц также отображался бы в результатах, но там были нули.
*/
