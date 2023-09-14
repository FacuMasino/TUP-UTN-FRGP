#pragma once

#pragma once
#include <string>

class Date {
public:
    int getDay();
    int getMonth();
    int getYear();
    std::string getDayName();
    void setDay(int day);
    void setMonth(int month);
    void setYear(int year);
    Date();
    Date(int day, int month, int year);
    std::string toString();

private:
    int _day, _month, _year;
    int _dayWeek;
};