#include "Transaction.h"

Transaction::Transaction() {
    _id = 0;
    _catId = 0;
    _description = "";
    _date = Date(1, 1, 2000);
    _amount = 0;
    _state = false;
}

Transaction::Transaction(int id, int catId, string description, Date date,
                         float amount, bool state) {
    _id = id;
    _catId = catId;
    _description = description;
    _date = date;
    _amount = amount;
    _state = state;
}