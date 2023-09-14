#include "Date.h"

#include <ctime>
#include <iostream>

int Date::getDay() { return _day; }
int Date::getMonth() { return _month; }
int Date::getYear() { return _year; }
void Date::setDay(int day) { _day = day; }
void Date::setMonth(int month) { _month = month; }
void Date::setYear(int year) { _year = year; }
Date::Date() {
    time_t t = time(NULL);
    struct tm *f = localtime(&t);
    _day = (*f).tm_mday;     // Indirecciona f y accede a tm_mday
    _month = f->tm_mon + 1;  // Indirecciona f y accede a tm_mon
    _year = f->tm_year + 1900;
    _dayWeek = f->tm_wday;
}
Date::Date(int day, int month, int year) {
    setDay(day);
    setMonth(month);
    setYear(year);
    _dayWeek = -1;
}
std::string Date::toString() {
    std::string valueToReturn;
    valueToReturn = std::to_string(_day) + "/" + std::to_string(_month) + "/" +
                    std::to_string(_year);
    return valueToReturn;
}
std::string Date::getDayName() {
    std::string names[7] = {"Domingo", "Lunes",   "Martes", "Miercoles",
                            "Jueves",  "Viernes", "Sabado"};
    if (_dayWeek >= 0 && _dayWeek <= 6) {
        return names[_dayWeek];
    }
    return "";
}