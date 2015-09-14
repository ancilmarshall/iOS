# App Life Cycle

- **OperationsBackgroundingExcercise**: UW3 Exercise - Backgrounding an App, KVO and NSNotifications

# Notes

Always take out backgroundtask and fill in the expiration handler at the same time. If we leave the background, then we must end the background task and invalidate the token. The expiration handler does this automoatically if the job is completed while in the background.

Work in the background should be down an a background thread. Thus instantiate an NSOperationQueue (which is by default a background thread) and add tasks to this that perform the needed work.



