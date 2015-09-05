# Networking
- **NetworkingDemo**: UW3 -  Ephemeral, foreground NSURLSession, with data task. Handles network string encoding conversions.
- **NetworkingExercise**: UW3 Exercise - Constructing an NSMutableRequst. Using NSNotifications.
- **NSURLComponentsDemo** UW3 -  NSURLComponent and NSURLQueryItem.
- **BackgroundDownloadDemo** UW3 - Downloading in the Background while App is Backgrounded, Suspended and awaken up into the Background

# Notes

I find that it is important to realize that the background network transfer is just a network activity that is handled by the system on behalf of the app. It is not the same as backgrounding an app or running on a background thread. (Backgrounding and app is handled differently, and a background queue is used when setting the NSURLSession for the background activity.) To do this you use a background configuration when setting up the session. You can still run the app in the foreground, but if you truely want to run in the background for real, you have other methods to implement when the system calls your app. The document states that the background activity only continues when the app is terminated normally by the system (low memory etc), but in the class demo, the professor killed the app manually and the download appeared to continue. 

Here is a note from the URL Loading System Programming Guide, that is worth remembering for Background Transfers, which can be tricky: 

>In iOS, when a background transfer completes or requires credentials, if your app is no longer running, iOS automatically relaunches your app in the background and calls the application:handleEventsForBackgroundURLSession:completionHandler: method on your app’s UIApplicationDelegate object. This call provides the identifier of the session that caused your app to be launched. Your app should store that completion handler, create a background configuration object with the same identifier, and create a session with that configuration object. The new session is automatically reassociated with ongoing background activity. Later, when the session finishes the last background download task, it sends the session delegate a URLSessionDidFinishEventsForBackgroundURLSession: message. Your session delegate should then call the stored completion handler. If any task completed while your app was suspended, the delegate’s URLSession:downloadTask:didFinishDownloadingToURL: method is then called with the task and the URL for the newly downloaded file associated with it.

You call the completion handler on the main treaad, and you do this when you are complete with the NSURLSession task or if there is an error condition. This lets the system know you are complete and it can finish the background process.

There are also three delegate protocols in play when handling backgrounded transfers. The UIApplicationDelegate, NSURLSessionDownloadDelegate and the NSURLSessionDelegate. 

The UIApplicationDelegate calls
```Objective-C
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler;
```

This function is called by the system when it wakes up our app into the background to handle some background url session. The system actually passes us the completion handler so that we can call it when we are finished, which in turn calls the system to let it know we are finished. Its a hook back into the system.

The NSURLSessionDownloadDelegate calls

``` Objective-C
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location;

```
This function gets called when the download task is complete. Here we must move the data from the temporary url to a permanent location in the app's container. This can be called in the background or foreground.


The NSURLSessionDelegate calls

``` Objective-C
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session;
```

This is a regular event that happens when the background url session is complete Here we need to call the completion handler that was passed to us by the system so that the system knows we are finished handling the background events. The system can then complete it's own tasks, and wrap up the background session stuff. Note that this is when all the events for this session is complete, ie. it could be several download tasks which are handled by the download delegate.


### Other notes from class
Upload tasks is a subclass of data tasks, and is an exception to the fact that data tasks can only run when the app is in the foreground. In other words, and upload task can run either in the foreground or when the app is backgrounded.



