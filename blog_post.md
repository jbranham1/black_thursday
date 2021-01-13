## Iteration 4 Blog Post
### Introduction
Both the `most_sold_item_for_merchant` and `best_item_for_merchant` methods work in much the same way, with the main difference being the key piece of data returned - either a quantity sold, or revenue earned. That is to say, the objects involved and message path behind these `SalesAnalyst` methods are nearly identitical.

### Object model
Our objects are set up in a hierarchy with a `SalesEngine` at the top.  The Engine creates typed Repository objects, passing in `self` so the repositories can talk to the engine.

Each Repository object holds low-level items, namely `Merchant`, `Item`, and `InvoiceItem`. When a repository creates one of these objects it passes `self` into the object initialization so that the low-level object can talk to the repository.

### Setup - Where's the Data?
The objects we are interested in for`most_sold_item_for_merchant` and `best_item_for_merchant` are the `Merchant`, `Item`, and `InvoiceItem`. `InvoiceItem` is where the key pieces of data lie - quantity sold and unit price. However, to get to an `InvoiceItem` we have to know what `Item` to look for, and to know that we need to know which merchant we're dealing with. Both `SalesAnalyst` methods pass in a merchant_id, so that piece of data is given to us.

### Piece #1 - Merchant's Items
We decided that a Merchant should be responsible for finding it's own most sold and best items, so we designed it to hold a list of its own items. A Merchant calculates this by asking it's parent repository for a list of items. The parent is a `MerchantRepository` and forwards the same message to `SalesEngine`. SalesEngine then asks `ItemRepository` for a list of items for a the merchant's id. `ItemRepository` calculates the result and returns an array of `Item`s, which filters back through the call stack to the Merchant.

Now, the Merchant knows what items it sells.

### Piece #2a - Item Quantity
But having Items is not the end goal - we need to see how many items were sold and which ones were most profitable. We chose to have methods on the `Item` class for `quantity` and `revenue`.  Both of these methods send a message to `ItemRepository`, which forwards to `SalesEngine`. The Engine asks `InvoiceItemRepository` for a list of `InvoiceItem` objects for the given item_id, which filters back through the call stack to Item.

The `Item` now has a list of `InvoiceItems` and it searches through those records summing the quantity sold for each line item on the invoice.

Now, the Item knows how many of itself have been sold.

### Piece #2b - Item Revenue
The Item also can calculate the revenue gained from all of its sales. The path to find this information is the exact same as above, depending on the `InvoiceItem`s list. The only difference is that the `InvoiceItem`'s `quanity` and `unit_price` are multiplied together to get revenue for that line item.

Thus, the Item knows how much money it generated for all of its sales.

### Putting it Together - How Do we Start the Calculation?
With all the main pieces of data able to be calculated, everything needs to be set in motion. The impetus is that `SalesAnalyst` gets a call for `most_sold_item_for_merchant` or `best_item_for_merchant`. It forwards a message which gets sent to `SalesEngine`, then to `MerchantRepository` and finally to a `Merchant` instance.

The `Merchant` iterates through all of its `Item`s, finding the largest value for that item's `quantity` if it was asked for most sold items or `revenue` if it was asked for a best item.

The result is returned, filtering back up to `SalesAnalyst`.

### Final Thoughts
We realized that `InvoiceItem` should have a method to calculate it's own revenue. So, one change we might make is to move that calculation from `Item` to `InvoiceItem`. We also began considering which object should be responsible for summing quantity sold and revenue for a merchant's items, and want to pursue that thought and see if that logic could live somewhere other than `Item`.
