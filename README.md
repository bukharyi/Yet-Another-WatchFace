# Yet-Another-WatchFace
Watch Face application for Garmin Fenix 5[X][Plus], D2, Forerunner 245[M]/645[M]/935/945, Mk1, MARQ1 smartwatch

# Description
Please, leave your comments, bug reports and ideas on Garmin Forum:
https://forums.garmin.com/developer/connect-iq/f/showcase/7485/watchface-yet-another-watchface

This simple configurable digital face has:

- Time (this is a watchface, after all)
- Current City Name, based on GPS. You have to get GPS coordinates to update the city if location has been changed
- Current Date and Week Day
- Battery Level
- Actual Weather in current location, Temperature (C|F), Perception probability and Wind(kn|m/s)
- Current Time in one addition timezone (DST will be calculated automatically)
- Actual Currency Exchange Rate, between two out of 47 currencies. Updates once in 60 min if internet connection is available
- Pulse
- Distance (km, miles, steps)
- Floors climbed

Configure all the watch face options via the Garmin Connect mobile app:
Open Garmin Connect Mobile. Touch More, Garmin Devices, (your device), Connect IQ Apps, Watch Faces, (select YA-WatchFace), Settings.


# Changelog

### version 0.9.112
- add alarm and message count at the separate field
- add support D2, Forerunner 245[M]/645[M]/935/945, Mk1, MARQ1
- fix issue with updated exchange api

### version 0.9.97 
- red battery level if it less 20%
- add calories and altimeter
- add combined steps and floors  
- fix minor issues

### version 0.9.90
- displaying counts of notifications and messages has been added
- fix round numbers displaying issue

### version 0.9.87
- add floors climbed 
- ability to set what to display in fields, in settings 

### version 0.9.76
- add support Forerunner 935 

### version 0.9.65
- Optimization data displaying

### version 0.9.61 
- Option to disable display seconds has been added
- AM/PM has support has been added
- Too long city/country name issue fixed
- TWD currency has been added
- battery consumption when pulse is displayed has been optimized 