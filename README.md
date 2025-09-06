# MyLogger

MyLogger is improved fork of [Flogs](https://pub.dev/packages/f_logs) package developed in flutter that provides quick & simple logging solution. <br>
All logs are saved into DB which can be exported as a text file.

Overview
--------

MyLogger is written in Dart.<br> 
Logs are saved into Sembast database which can be exported into document directory and uploaded into server. 

Logs are helpful when developer wants to analyze user activities within the app. 
Many times we want to log a set of data to analyze certain activity. 
For example: 
- Location (GPS Coordinates), 
- Device info, 
- Network requests 
- etc.. 

This helps us to quickly identify and fix issues that are hard to debug when app is in the production. <br>
MyLogger provide functionality for log these data sets into database and fetch it by different filters.


Features
--------

1. Log messages by various levels (DEBUG, TRACE, INFO, WARNING, ERROR, SEVERE, FATAL) 
2. Save logs into database                                                            
3. Export logs into file                                                              
4. Fetch or delete logs easily                                                        
5. Log filtering support                                                              
6. Custom timestamps support                                                          
7. Custom data type logging support                                                   
8. Custom log format support                                                          
9. Encryption support                                                                 
                

Use this package as a library
-----------------------------

**1. Depend on it**

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  my_logger: ^1.1.0
```

**2. Install it**

You can install packages from the command line:

with Flutter

```bash
$ flutter packages get
```

Alternatively, your editor might support flutter packages get. Check the docs for your editor to learn more.

**3. Import it**

Now in your Dart code, you can use:

```dart
import 'package:my_logger/logger.dart';
```

How to use
----------

Log files are exported on storage directory so it's very important to add these permissions to your project's manifest file first.

**Android**
```
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```
**iOS**
```
<key>NSPhotoLibraryAddUsageDescription</key>
<string>MyLogger would like to save photos from the app to your gallery</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>MyLogger would like to access your photo gallery for uploading images to the app</string>
```

To save logs, simply call any of the method mentioned below:


```dart 
    MyLogger.trace("My trace log"); 

    MyLogger.debug("My debug log");

    MyLogger.info("My info log");

    MyLogger.warning("My warning log");

    MyLogger.error("My error log");

    MyLogger.severe("My severe log");

    MyLogger.fatal("My fatal log");

    MyLoggerlog(
      className: "HomePage",
      methodName: "_buildRow1",
      text: "My severe log with exception and stacktrace",
      type: LogLevel.SEVERE, 
      exception: Exception("This is an Exception!"),
      stacktrace: StackTrace.current,
    );

    MyLoggerlog(
      className: "HomePage",
      methodName: "_buildRow1",
      text: "My severe log with dataLogType",
      type: LogLevel.SEVERE,
      dataLogType: DataLogType.DEVICE,
    );
```


Available Methods
-----------------
MyLogger provide many other methods for save, filter or fetch logs. Below is list of all this methods:


**Get logs:**

```dart 
MyLogger.logs.getAll();   // Get all saved logs
MyLogger.logs.getLastHour();   // Get all saved logs for last hour

// Get logs by LogFilter:
MyLogger.logs.getByFilter(
  LogFilter(
    startDateTime: DateTime(2019), 
    endDateTime: DateTime(2020), 
    dataLogsType: [DataLogType.NETWORK],
    logLevels: [LogLevel.ERROR, LogLevel.WARNING],
  ),  
);

// LogFilters also have some named constructors:
MyLogger.logs.getByFilter(LogFilter.last24Hours());
```

**Write logs:**

```dart 
MyLogger.logs.write(Log log);  // Save your own Log object
```

**Delete logs:**

```dart 
MyLogger.logs.deleteAll();   // Delete all saved logs
MyLogger.logs.deleteLastHour();   // Delete all saved logs for last hour

// Delete logs by LogFilter:
MyLogger.logs.deleteByFilter(
  LogFilter(
    startDateTime: DateTime(2019), 
    endDateTime: DateTime(2020), 
    dataLogsType: [DataLogType.NETWORK],
    logLevels: [LogLevel.ERROR, LogLevel.WARNING],
  ),  
);

```

**Export logs:**

```dart 
File fileExport = await MyLogger.logs.export(
  fileName: "export-all-logs",
  exportType: FileType.TXT,
  filter: LogFilter.last24Hours(),
);
```


**Change configuration:**

```dart 
    LogConfig config = MyLogger.config
      ..outputFormat = "{{level}} {{time}} - {{message}}"
      ..dataLogTypeValues = DataLogType.values
      ..encryption = EncryptionType.XXTEA
      ..encryptionKey = encryptionKey
      ..timestampFormat = TimestampFormat.DEFAULT;

    MyLogger.applyConfig(config);
```

