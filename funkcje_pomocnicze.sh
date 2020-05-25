#!/usr/bin/env python3

import datetime

# zwraca liste stringow w formacie:
# [ 'hh:mm', 'hh:mm+1' ]
# pierwsza wartosc to aktualna godzina utc
# druga, to o jedna minute pozniej
def getCurrentTimeUTC():
	utcDate = datetime.datetime.utcnow()
	utcDatePlusOneMinute = utcDate + datetime.timedelta(minutes = 1)
	
	dateStringFrom = ""
	dateStringTo = ""	
	
	hour = utcDate.hour
	minute = utcDate.minute
	if hour < 10:
		dateStringFrom = dateStringFrom + "0" + str(hour)
	else:
		dateStringFrom = dateStringFrom + str(hour)
	dateStringFrom = dateStringFrom + ":"
	if minute < 10:
		dateStringFrom = dateStringFrom + "0" + str(minute)
	else:
		dateStringFrom = dateStringFrom + str(minute)
		

	hour = utcDatePlusOneMinute.hour
	minute = utcDatePlusOneMinute.minute
	if hour < 10:
		dateStringTo = dateStringTo + "0" + str(hour)
	else:
		dateStringTo = dateStringTo + str(hour)
	dateStringTo = dateStringTo + ":"
	if minute < 10:
		dateStringTo = dateStringTo + "0" + str(minute)
	else:
		dateStringTo = dateStringTo + str(minute)

	return [dateStringFrom, dateStringTo]


print(getCurrentTimeUTC())


