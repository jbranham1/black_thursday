I just thought of this outline:
- Where the data we need lives
- What obj handles the number crunching (should be Merchant?)
- how Merchant gets the data
- how Merchant calcs the result
- How the process starts:
  - SalesAnalyst recieves the message, forwards to the Merchant Repo, and then the Merchant Repo asks the Merchant to calculate the result.
Like...
Merchant has it's items and invoices, so it fills those.
Then it finds the invoice_items thru the instance vars.
Then it calculates the total quantity/revenue from that.
Which, IDR if that's exactly correct since an Item is responsible for finding it's invoice_items



# Blog Post

- SalesAnalyst, SalesEngine, MerchantRepository, Merchant
- Merchant holds best_item and most_sold_item
- To get these methods: Merchant holds a list of items for an instance of a Merchant.

- Merchant, MerchantRepository, SalesEngine, ItemRepository (find_by_merchant_id), Item
- Item holds revenue and quantity
- To get these methods: Item holds a list of invoice items for an instance of an Item

- Item, ItemRepository, SalesEngine, InvoiceItemRepository (find_by_item_id) to get the invoice's for that item ID



In order to get most sold item for merchant and best item for merchant, analyst needs to look at the merchant repository through the sales engine.

### Where does the data we need live?
* Item
  * Merchant will need to look into the item repository to find all items with the id of the merchant instance.
  * Path in order to get the items:
    * Merchant talks to MerchantRepository to get items by merchant id.
    * Merchant repository talks to SalesEngine to get the items by merchant id.
    * SalesEngine talks to ItemRepository (find_by_merchant_id) to find the items.
    * Item repository talks to Item to get each instance of the Item.
* InvoiceItem
  * Item will need to look into the invoice item repository to find all invoice items with the id of the item instance.
  * We need the quantity and unit price from the invoice items.
  * Path in order to get the invoice items:
    * Item talks to ItemRepository to get invoice items by item id.
    * ItemRepository talks to SalesEngine to get the invoice items by item id.
    * SalesEngine talks to InvoiceItemRepository (find_by_item_id) to get all invoice items for that item id.

### What object handles the number crunching?
* Item
  * Calculates the sum of the revenue and quantity for all invoice items with that item id.
* Merchant
  * Gets the item with the most revenue and quantity for that merchant id.
