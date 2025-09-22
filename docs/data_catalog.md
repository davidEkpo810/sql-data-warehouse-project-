# Data Dictionary for Gold Layer
*Overview*
The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases. It consists of dimension tables and fact tables for specific business metrics.

You can add more content below this header, such as:

*Tables*
- *Dimension Tables*
    - #gold_dim_customers
    - #gold_dim_products
- *Fact Tables*
    - #gold_fact_sales

*Table Details*

*Table 1: gold_dim_customer*
    **Purpose:** Stores customer details enriched with demographic and geographic data.
    
| Column Name | Data Type | Description |
| --- | --- | --- |
| customer_key | INT | surrogate key uniquely identifying each customer record in the dimension table |
| customer_id | INT | unique numerical identifier assigned to each customer |
| customer_number | NVARCHAR(50) | Alphanumeric identifier representing the customer, used for tracking and referencing |
| first_name | NVARCHAR(50) | customer's firstname|
| last_name | NVARCHAR(50)| customer's lastname |
| country | NVARCHAR(50) | The country of residence of customer (e.g. 'Australia')|
| marital_status | NVARCHAR(50) | The marital status of the customer (e.g. 'Married','Single') |
| gender | NVARCHAR(50)  | The gender of customer (e.g. 'Male', 'Female', 'n/a' |
| birthdate | DATE | The date of birth of the customer, formatted as YYYY-MM-DD (e.g., 2021-06-04) |
| create_date | DATE | The date and time when the customer record was created in the system |


*Table 2: gold_dim_product*
    **Purpose:** Provides information about product and attributes.
    
| Column Name | Data Type | Description |
| --- | --- | --- |
| product_key | INT | surrogate key uniquely identifying each customer record in the product dimension table |
| product_id | INT | A unique identifier assigned to the product for internal trackinga nd referencing |
| product_number | NVARCHAR(50) | A structured alphanumeric code representing the product, often used for categorization |
| product_name | NVARCHAR(50) | Descriptive name of the product, including key details such as type, color, size |
| category_id | NVARCHAR(50) | A unique identifier for the products category, linking to its high-level classification |
| category | NVARCHAR(50) | The broader classification of the product (e.g., Bikes, Components) |
| subcategory | NVARCHAR(50) | A more detailed classification of the product within the category, such as product type |
| maintenance | NVARCHAR(50) | Indicates whether the product requires maintenance (e.g., 'Yes', 'NO'). |
| Cost | INT | The cost or base price of the product, measured in monetary units  |
| product_line | NVARCHAR(50) | The specific product line or series to which the product belongs (e.g., Road, Mountain). |
| start_date | DATE | The date when the prpduct became available for sale or use |


*Table 3: gold_fact_sales*
    **Purpose:** Provides information about product and attributes.
    
| Column Name | Data Type | Description |
| --- | --- | --- |
| order_number | NVARCHAR(50) | A unique alphanueric identifier for each sales order (e.g., 'SO54496') |
| product_key | INT | Surrogate key linking the order to the product dimension table |
| customer_key | INT | Surrogate key linking the order to the customer dimension table |
| order_date | DATE | The date when the order was placed |
| shipping_date| DATE | The date when the order was shipped to the customer |
| due_date | DATE | The date when the order payment was due |
| sales_amount | INT | The total monetary value of the sale for the line item, in whole currency units (e.g., 25) |
| quantity | INT | The number of units of the product ordered for the kine item (e.g., 1) |
| price | INT | The price per unit of the product for thr line item, in whole currency units (e.g., 25) |
