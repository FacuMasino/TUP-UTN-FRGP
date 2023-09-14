#pragma once
#include <string>

#include "Date.h"


class Transaction {
    Transaction();
    Transaction(int id, int catId, char* description, Date date, float amount,
                bool state);
    int getId() { return _id; }
    int getCatId() { return _catId; }
    string getDescription() { return _description; }
    Date getDate() { return _date; }
    float getAmount() { return _amount; }
    bool getState() { return _state; }

private:
    int _id, _catId;
    string _description[30];
    Date _date;
    float _amount;
    bool _state;
};