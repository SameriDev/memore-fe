# memore Widget Specifications (Future Development)

## Widget Overview

This document outlines the specifications for implementing **home screen widgets** - memore's signature feature that enables photos to appear directly on users' home screens. This is documented for **Phase 3** implementation after the core app is complete.

### Widget Philosophy

Widgets are the heart of memore's value proposition, providing **always-visible** photo sharing that creates surprise and delight throughout the day. They transform the home screen into a **live window** into friends' lives.

---

## 1. Widget Types & Specifications

### 1.1 Standard Friend Widget

#### Visual Design

```
┌─────────────────────────┐
│                         │
│     Friend's Photo      │ 4x2 widget grid
│                         │ (320dp x 160dp)
│                         │
│ Sarah J.    2h ago  💜  │ Metadata overlay
└─────────────────────────┘
```

**Design Specifications:**

- **Size**: 4x2 Android widget grid (320x160dp)
- **Corner Radius**: 12dp to match app design
- **Background**: White with 1dp gray border
- **Photo**: Full coverage with 12dp corner radius
- **Metadata Overlay**: Semi-transparent black (40% opacity)
- **Typography**: Roboto, white text with drop shadow

**Content Elements:**

- Friend's latest photo (full size background)
- Friend name (Label Medium, 14sp)
- Timestamp (Body Small, 12sp)
- Heart icon (16dp) indicating new photo

#### Widget States

**Loading State:**

- Gray skeleton background
- Animated pulse effect
- "Loading..." text centered

**Error State:**

- Light gray background with error icon
- "Tap to refresh" message
- Camera icon placeholder

**Empty State:**

- Soft gradient background
- "Add friends to see photos" message
- Plus icon for setup

### 1.2 Best Friend Widget

#### Visual Design

```
┌─────────────────────────┐
│                         │
│   Best Friend Photo     │ 4x2 widget grid
│                         │ Special golden accent
│                         │
│ ⭐ Mike C.  1h ago   💜  │ Star indicates BFF
└─────────────────────────┘
```

**Design Specifications:**

- **Size**: Same as standard widget (4x2 grid)
- **Special Accent**: Golden star (⭐) before name
- **Border**: 2dp golden border instead of gray
- **Priority**: Shows only photos from designated best friend

### 1.3 Crush Widget (Premium Feature)

#### Visual Design

```
┌─────────────────────────┐
│                         │
│     Crush Photo         │ 4x2 widget grid
│                         │ Pink accent theme
│                         │
│ 💕 Alex T.  30m ago  💜  │ Heart emoji indicator
└─────────────────────────┘
```

**Design Specifications:**

- **Size**: Same as standard widget (4x2 grid)
- **Special Accent**: Pink heart (💕) before name
- **Border**: 2dp pink border
- **Priority**: Shows only photos from designated crush

### 1.4 Friends Grid Widget

#### Visual Design

```
┌─────────────────────────┐
│  [Photo1] [Photo2]      │ 4x4 widget grid
│  [Photo3] [Photo4]      │ (320dp x 320dp)
│                         │
│  See All Friends        │ Link to main app
└─────────────────────────┘
```

**Design Specifications:**

- **Size**: 4x4 Android widget grid (320x320dp)
- **Layout**: 2x2 grid of friend photos
- **Photo Size**: 150x150dp each with 4dp spacing
- **Corner Radius**: 8dp for individual photos
- **Footer**: "See All Friends" link to open app

---

## 2. Android Widget Implementation

### 2.1 Widget Provider Class

```kotlin
class memoreWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        appWidgetIds.forEach { widgetId ->
            updateWidget(context, appWidgetManager, widgetId)
        }
    }

    private fun updateWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        widgetId: Int
    ) {
        val views = RemoteViews(context.packageName, R.layout.widget_memore)

        // Get latest photo data
        val photoData = getLatestPhotoData(context, widgetId)

        if (photoData != null) {
            // Load photo into ImageView
            loadPhotoIntoWidget(context, views, photoData)

            // Update metadata
            views.setTextViewText(R.id.friend_name, photoData.friendName)
            views.setTextViewText(R.id.timestamp, photoData.timeAgo)

            // Set click listener to open app
            val intent = createAppIntent(context, photoData.photoId)
            val pendingIntent = PendingIntent.getActivity(
                context, 0, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_container, pendingIntent)
        } else {
            // Show empty state
            showEmptyState(views)
        }

        appWidgetManager.updateAppWidget(widgetId, views)
    }

    private fun loadPhotoIntoWidget(
        context: Context,
        views: RemoteViews,
        photoData: PhotoData
    ) {
        // Use Glide to load image into widget
        Glide.with(context)
            .asBitmap()
            .load(photoData.photoUrl)
            .transform(RoundedCorners(dpToPx(context, 12)))
            .into(object : CustomTarget<Bitmap>() {
                override fun onResourceReady(
                    resource: Bitmap,
                    transition: Transition<in Bitmap>?
                ) {
                    views.setImageViewBitmap(R.id.photo_image, resource)
                    AppWidgetManager.getInstance(context)
                        .updateAppWidget(photoData.widgetId, views)
                }

                override fun onLoadCleared(placeholder: Drawable?) {}
            })
    }
}
```

### 2.2 Widget Layout XML

```xml
<!-- res/layout/widget_memore.xml -->
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:id="@+id/widget_container"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    android:background="@drawable/widget_background"
    android:clickable="true">

    <FrameLayout
        android:layout_width="match_parent"
        android:layout_height="0dp"
        android:layout_weight="1">

        <ImageView
            android:id="@+id/photo_image"
            android:layout_width="match_parent"
            android:layout_height="match_parent"
            android:scaleType="centerCrop"
            android:background="@drawable/photo_placeholder" />

        <!-- Gradient overlay for text -->
        <LinearLayout
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:layout_gravity="bottom"
            android:background="@drawable/gradient_overlay"
            android:padding="12dp"
            android:orientation="horizontal">

            <TextView
                android:id="@+id/friend_name"
                android:layout_width="0dp"
                android:layout_height="wrap_content"
                android:layout_weight="1"
                android:textColor="#FFFFFF"
                android:textSize="14sp"
                android:textStyle="bold"
                android:shadowColor="#80000000"
                android:shadowDx="1"
                android:shadowDy="1"
                android:shadowRadius="2"
                android:text="Friend Name" />

            <TextView
                android:id="@+id/timestamp"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:textColor="#CCFFFFFF"
                android:textSize="12sp"
                android:shadowColor="#80000000"
                android:shadowDx="1"
                android:shadowDy="1"
                android:shadowRadius="2"
                android:text="2h ago"
                android:layout_marginStart="8dp" />

            <ImageView
                android:id="@+id/heart_icon"
                android:layout_width="16dp"
                android:layout_height="16dp"
                android:src="@drawable/ic_heart_purple"
                android:layout_marginStart="8dp"
                android:layout_gravity="center_vertical" />

        </LinearLayout>

    </FrameLayout>

</LinearLayout>
```

### 2.3 Widget Background Drawable

```xml
<!-- res/drawable/widget_background.xml -->
<shape xmlns:android="http://schemas.android.com/apk/res/android"
    android:shape="rectangle">

    <corners android:radius="12dp" />

    <solid android:color="#FFFFFF" />

    <stroke
        android:width="1dp"
        android:color="#E5E5E5" />

</shape>

<!-- res/drawable/gradient_overlay.xml -->
<shape xmlns:android="http://schemas.android.com/apk/res/android"
    android:shape="rectangle">

    <gradient
        android:startColor="#00000000"
        android:endColor="#66000000"
        android:angle="270" />

</shape>
```

### 2.4 Widget Configuration

```xml
<!-- res/xml/widget_info.xml -->
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:minWidth="250dp"
    android:minHeight="110dp"
    android:targetCellWidth="4"
    android:targetCellHeight="2"
    android:maxResizeWidth="320dp"
    android:maxResizeHeight="200dp"
    android:resizeMode="horizontal|vertical"
    android:widgetCategory="home_screen"
    android:initialLayout="@layout/widget_memore"
    android:configure="com.memore.app.WidgetConfigActivity"
    android:previewImage="@drawable/widget_preview"
    android:previewLayout="@layout/widget_memore"
    android:updatePeriodMillis="1800000"
    android:description="@string/widget_description" />
```

---

## 3. Widget Data Synchronization

### 3.1 Background Update Service

```kotlin
class WidgetUpdateService : JobIntentService() {

    companion object {
        private const val JOB_ID = 1000

        fun enqueueWork(context: Context, intent: Intent) {
            enqueueWork(context, WidgetUpdateService::class.java, JOB_ID, intent)
        }
    }

    override fun onHandleWork(intent: Intent) {
        when (intent.action) {
            "UPDATE_ALL_WIDGETS" -> updateAllWidgets()
            "UPDATE_FRIEND_WIDGET" -> updateFriendWidget(
                intent.getStringExtra("friendId") ?: ""
            )
            "NEW_PHOTO_RECEIVED" -> handleNewPhoto(
                intent.getSerializableExtra("photoData") as PhotoData
            )
        }
    }

    private fun updateAllWidgets() {
        val appWidgetManager = AppWidgetManager.getInstance(this)
        val widgetIds = appWidgetManager.getAppWidgetIds(
            ComponentName(this, memoreWidgetProvider::class.java)
        )

        val intent = Intent(this, memoreWidgetProvider::class.java).apply {
            action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, widgetIds)
        }
        sendBroadcast(intent)
    }

    private fun handleNewPhoto(photoData: PhotoData) {
        // Update specific friend's widget
        updateFriendWidget(photoData.friendId)

        // Show notification if widget is visible
        if (isWidgetVisible(photoData.friendId)) {
            showPhotoNotification(photoData)
        }
    }

    private fun isWidgetVisible(friendId: String): Boolean {
        // Check if widget for this friend is currently on home screen
        val widgetPrefs = getSharedPreferences("widget_prefs", MODE_PRIVATE)
        return widgetPrefs.getBoolean("widget_${friendId}_visible", false)
    }
}
```

### 3.2 Real-time Photo Updates

```kotlin
class PhotoUpdateReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            "com.memore.app.NEW_PHOTO" -> {
                val photoData = intent.getSerializableExtra("photoData") as PhotoData

                // Update widget immediately
                val updateIntent = Intent(context, WidgetUpdateService::class.java).apply {
                    action = "NEW_PHOTO_RECEIVED"
                    putExtra("photoData", photoData)
                }
                WidgetUpdateService.enqueueWork(context, updateIntent)
            }

            "com.memore.app.FRIEND_ONLINE" -> {
                val friendId = intent.getStringExtra("friendId")
                // Update widget with online status indicator
            }
        }
    }
}
```

### 3.3 Widget Data Storage

```kotlin
data class WidgetData(
    val widgetId: Int,
    val friendId: String,
    val widgetType: WidgetType,
    val lastPhotoUrl: String?,
    val lastPhotoTimestamp: Long,
    val friendName: String,
    val isActive: Boolean
)

enum class WidgetType {
    STANDARD,
    BEST_FRIEND,
    CRUSH,
    FRIENDS_GRID
}

class WidgetDataManager(private val context: Context) {

    private val database = Room.databaseBuilder(
        context,
        WidgetDatabase::class.java,
        "widget_db"
    ).build()

    suspend fun saveWidgetData(widgetData: WidgetData) {
        database.widgetDao().insertWidget(widgetData)
    }

    suspend fun getWidgetData(widgetId: Int): WidgetData? {
        return database.widgetDao().getWidget(widgetId)
    }

    suspend fun updatePhotoData(widgetId: Int, photoUrl: String, timestamp: Long) {
        database.widgetDao().updatePhoto(widgetId, photoUrl, timestamp)
    }

    suspend fun getAllActiveWidgets(): List<WidgetData> {
        return database.widgetDao().getAllActiveWidgets()
    }
}
```

---

## 4. Widget Configuration Activity

### 4.1 Widget Setup Flow

```kotlin
class WidgetConfigActivity : AppCompatActivity() {

    private lateinit var binding: ActivityWidgetConfigBinding
    private var appWidgetId = AppWidgetManager.INVALID_APPWIDGET_ID

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Get widget ID from intent
        appWidgetId = intent.getIntExtra(
            AppWidgetManager.EXTRA_APPWIDGET_ID,
            AppWidgetManager.INVALID_APPWIDGET_ID
        )

        if (appWidgetId == AppWidgetManager.INVALID_APPWIDGET_ID) {
            finish()
            return
        }

        binding = ActivityWidgetConfigBinding.inflate(layoutInflater)
        setContentView(binding.root)

        setupUI()
        loadFriends()
    }

    private fun setupUI() {
        binding.toolbar.setNavigationOnClickListener { finish() }

        binding.widgetTypeGroup.setOnCheckedChangeListener { _, checkedId ->
            updateWidgetPreview(getSelectedWidgetType(checkedId))
        }

        binding.saveButton.setOnClickListener {
            saveWidgetConfiguration()
        }
    }

    private fun loadFriends() {
        // Load user's friends from database
        lifecycleScope.launch {
            val friends = friendRepository.getFriends()

            val adapter = FriendSelectionAdapter(friends) { selectedFriend ->
                updateFriendSelection(selectedFriend)
            }

            binding.friendsList.adapter = adapter
        }
    }

    private fun saveWidgetConfiguration() {
        val selectedFriend = getSelectedFriend()
        val widgetType = getSelectedWidgetType()

        if (selectedFriend == null) {
            showError("Please select a friend")
            return
        }

        lifecycleScope.launch {
            // Save widget configuration
            val widgetData = WidgetData(
                widgetId = appWidgetId,
                friendId = selectedFriend.id,
                widgetType = widgetType,
                lastPhotoUrl = selectedFriend.lastPhotoUrl,
                lastPhotoTimestamp = System.currentTimeMillis(),
                friendName = selectedFriend.name,
                isActive = true
            )

            widgetDataManager.saveWidgetData(widgetData)

            // Update the widget
            val appWidgetManager = AppWidgetManager.getInstance(this@WidgetConfigActivity)
            memoreWidgetProvider().onUpdate(
                this@WidgetConfigActivity,
                appWidgetManager,
                intArrayOf(appWidgetId)
            )

            // Return result
            val resultValue = Intent().apply {
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            }
            setResult(RESULT_OK, resultValue)
            finish()
        }
    }
}
```

### 4.2 Widget Preview Component

```xml
<!-- Widget configuration preview layout -->
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    android:padding="16dp">

    <TextView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Widget Preview"
        android:textSize="18sp"
        android:textStyle="bold"
        android:layout_marginBottom="16dp" />

    <!-- Widget preview that matches actual widget size -->
    <FrameLayout
        android:layout_width="250dp"
        android:layout_height="110dp"
        android:layout_gravity="center_horizontal"
        android:layout_marginBottom="24dp">

        <include layout="@layout/widget_memore"
            android:layout_width="match_parent"
            android:layout_height="match_parent" />

    </FrameLayout>

    <TextView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Choose Widget Type"
        android:textSize="16sp"
        android:textStyle="bold"
        android:layout_marginBottom="12dp" />

    <RadioGroup
        android:id="@+id/widgetTypeGroup"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:layout_marginBottom="24dp">

        <RadioButton
            android:id="@+id/standardWidget"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:text="Standard Friend Widget"
            android:checked="true" />

        <RadioButton
            android:id="@+id/bestFriendWidget"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:text="⭐ Best Friend Widget" />

        <RadioButton
            android:id="@+id/crushWidget"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:text="💕 Crush Widget (Premium)" />

    </RadioGroup>

    <TextView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Select Friend"
        android:textSize="16sp"
        android:textStyle="bold"
        android:layout_marginBottom="12dp" />

    <androidx.recyclerview.widget.RecyclerView
        android:id="@+id/friendsList"
        android:layout_width="match_parent"
        android:layout_height="0dp"
        android:layout_weight="1" />

    <Button
        android:id="@+id/saveButton"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:text="Add Widget"
        android:layout_marginTop="16dp"
        android:enabled="false" />

</LinearLayout>
```

---

## 5. Widget Performance Optimization

### 5.1 Image Caching Strategy

```kotlin
class WidgetImageCache {

    companion object {
        private const val CACHE_SIZE = 50 * 1024 * 1024 // 50MB
        private const val MAX_WIDGET_IMAGES = 20
    }

    private val memoryCache = LruCache<String, Bitmap>(CACHE_SIZE)

    fun getBitmap(url: String): Bitmap? {
        return memoryCache.get(url)
    }

    fun putBitmap(url: String, bitmap: Bitmap) {
        if (getBitmap(url) == null) {
            memoryCache.put(url, bitmap)
        }
    }

    fun preloadWidgetImages(widgetData: List<WidgetData>) {
        widgetData.forEach { widget ->
            widget.lastPhotoUrl?.let { url ->
                if (getBitmap(url) == null) {
                    loadImageAsync(url)
                }
            }
        }
    }

    private fun loadImageAsync(url: String) {
        Thread {
            try {
                val bitmap = Glide.with(context)
                    .asBitmap()
                    .load(url)
                    .transform(RoundedCorners(dpToPx(12)))
                    .submit()
                    .get()

                putBitmap(url, bitmap)
            } catch (e: Exception) {
                // Handle loading error
            }
        }.start()
    }
}
```

### 5.2 Battery Optimization

```kotlin
class WidgetUpdateScheduler {

    companion object {
        private const val UPDATE_INTERVAL_ACTIVE = 15 * 60 * 1000L // 15 minutes
        private const val UPDATE_INTERVAL_BACKGROUND = 60 * 60 * 1000L // 1 hour
    }

    fun scheduleUpdate(context: Context, isAppActive: Boolean) {
        val interval = if (isAppActive) UPDATE_INTERVAL_ACTIVE else UPDATE_INTERVAL_BACKGROUND

        val workRequest = PeriodicWorkRequestBuilder<WidgetUpdateWorker>(
            interval, TimeUnit.MILLISECONDS
        )
        .setConstraints(
            Constraints.Builder()
                .setRequiredNetworkType(NetworkType.CONNECTED)
                .setRequiresBatteryNotLow(true)
                .build()
        )
        .build()

        WorkManager.getInstance(context)
            .enqueueUniquePeriodicWork(
                "widget_updates",
                ExistingPeriodicWorkPolicy.REPLACE,
                workRequest
            )
    }

    fun cancelScheduledUpdates(context: Context) {
        WorkManager.getInstance(context).cancelUniqueWork("widget_updates")
    }
}

class WidgetUpdateWorker(context: Context, workerParams: WorkerParameters) :
    CoroutineWorker(context, workerParams) {

    override suspend fun doWork(): Result {
        return try {
            // Update all active widgets
            val widgetDataManager = WidgetDataManager(applicationContext)
            val activeWidgets = widgetDataManager.getAllActiveWidgets()

            activeWidgets.forEach { widget ->
                updateWidget(widget)
            }

            Result.success()
        } catch (e: Exception) {
            Result.retry()
        }
    }

    private suspend fun updateWidget(widgetData: WidgetData) {
        // Fetch latest photo for friend
        val latestPhoto = photoRepository.getLatestPhotoFromFriend(widgetData.friendId)

        if (latestPhoto != null && latestPhoto.timestamp > widgetData.lastPhotoTimestamp) {
            // Update widget with new photo
            widgetDataManager.updatePhotoData(
                widgetData.widgetId,
                latestPhoto.url,
                latestPhoto.timestamp
            )

            // Trigger widget update
            val intent = Intent(applicationContext, memoreWidgetProvider::class.java).apply {
                action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, intArrayOf(widgetData.widgetId))
            }
            applicationContext.sendBroadcast(intent)
        }
    }
}
```

---

## 6. Widget Analytics & Monitoring

### 6.1 Widget Usage Analytics

```kotlin
class WidgetAnalytics {

    fun trackWidgetAdded(widgetType: WidgetType, friendId: String) {
        FirebaseAnalytics.getInstance(context).logEvent("widget_added", bundleOf(
            "widget_type" to widgetType.name,
            "friend_id" to friendId,
            "timestamp" to System.currentTimeMillis()
        ))
    }

    fun trackWidgetClicked(widgetId: Int, photoId: String?) {
        FirebaseAnalytics.getInstance(context).logEvent("widget_clicked", bundleOf(
            "widget_id" to widgetId,
            "photo_id" to photoId,
            "timestamp" to System.currentTimeMillis()
        ))
    }

    fun trackWidgetUpdateSuccess(widgetId: Int, updateDuration: Long) {
        FirebaseAnalytics.getInstance(context).logEvent("widget_update_success", bundleOf(
            "widget_id" to widgetId,
            "update_duration_ms" to updateDuration,
            "timestamp" to System.currentTimeMillis()
        ))
    }

    fun trackWidgetUpdateFailure(widgetId: Int, errorType: String) {
        FirebaseAnalytics.getInstance(context).logEvent("widget_update_failure", bundleOf(
            "widget_id" to widgetId,
            "error_type" to errorType,
            "timestamp" to System.currentTimeMillis()
        ))
    }

    fun trackWidgetRemoved(widgetId: Int, reason: String) {
        FirebaseAnalytics.getInstance(context).logEvent("widget_removed", bundleOf(
            "widget_id" to widgetId,
            "removal_reason" to reason,
            "timestamp" to System.currentTimeMillis()
        ))
    }
}
```

### 6.2 Performance Monitoring

```kotlin
class WidgetPerformanceMonitor {

    private val performanceCollector = FirebasePerformance.getInstance()

    fun trackUpdatePerformance(widgetId: Int, operation: suspend () -> Unit) {
        val trace = performanceCollector.newTrace("widget_update_$widgetId")

        trace.start()
        val startTime = System.currentTimeMillis()

        try {
            runBlocking { operation() }

            val duration = System.currentTimeMillis() - startTime
            trace.putMetric("update_duration_ms", duration)
            trace.putAttribute("status", "success")

        } catch (e: Exception) {
            trace.putAttribute("status", "failure")
            trace.putAttribute("error_type", e.javaClass.simpleName)

            // Report to Crashlytics
            FirebaseCrashlytics.getInstance().recordException(e)

        } finally {
            trace.stop()
        }
    }

    fun trackImageLoadingPerformance(url: String, operation: suspend () -> Bitmap?) {
        val trace = performanceCollector.newTrace("widget_image_load")

        trace.start()
        trace.putAttribute("image_url_hash", url.hashCode().toString())

        val startTime = System.currentTimeMillis()

        try {
            val result = runBlocking { operation() }

            val duration = System.currentTimeMillis() - startTime
            trace.putMetric("load_duration_ms", duration)

            if (result != null) {
                trace.putAttribute("status", "success")
                trace.putMetric("image_size_bytes", result.byteCount.toLong())
            } else {
                trace.putAttribute("status", "failure")
            }

        } catch (e: Exception) {
            trace.putAttribute("status", "error")
            trace.putAttribute("error_type", e.javaClass.simpleName)

        } finally {
            trace.stop()
        }
    }
}
```

---

## 7. Widget Security & Privacy

### 7.1 Widget Content Security

```kotlin
class WidgetSecurityManager {

    fun validateWidgetAccess(widgetId: Int, userId: String): Boolean {
        // Verify user owns this widget
        val widgetData = widgetDataManager.getWidgetData(widgetId)
        return widgetData?.userId == userId
    }

    fun sanitizeWidgetContent(photoData: PhotoData): PhotoData {
        return photoData.copy(
            // Remove sensitive metadata
            location = null,
            exifData = null,
            // Ensure photo URL is from trusted domain
            photoUrl = if (isTrustedUrl(photoData.photoUrl)) photoData.photoUrl else null
        )
    }

    private fun isTrustedUrl(url: String): Boolean {
        val trustedDomains = listOf(
            "firebasestorage.googleapis.com",
            "storage.googleapis.com"
        )

        return trustedDomains.any { domain ->
            url.contains(domain)
        }
    }

    fun encryptWidgetData(data: String): String {
        val cipher = Cipher.getInstance("AES/GCM/NoPadding")
        cipher.init(Cipher.ENCRYPT_MODE, getWidgetEncryptionKey())

        val encryptedBytes = cipher.doFinal(data.toByteArray())
        return Base64.encodeToString(encryptedBytes, Base64.DEFAULT)
    }

    private fun getWidgetEncryptionKey(): SecretKey {
        val keyAlias = "widget_encryption_key"
        val keyGenerator = KeyGenerator.getInstance("AES")
        keyGenerator.init(256)

        return keyGenerator.generateKey()
    }
}
```

### 7.2 Privacy Controls

```kotlin
class WidgetPrivacyManager {

    fun shouldShowPhotoInWidget(photoData: PhotoData, widgetSettings: WidgetSettings): Boolean {
        // Check privacy settings
        if (!widgetSettings.showPrivatePhotos && photoData.isPrivate) {
            return false
        }

        // Check if user is in Do Not Disturb mode
        if (isDoNotDisturbActive() && !widgetSettings.overrideDoNotDisturb) {
            return false
        }

        // Check time-based restrictions
        if (!isWithinAllowedHours(widgetSettings)) {
            return false
        }

        // Check content appropriateness
        if (photoData.contentWarning && !widgetSettings.showContentWarnings) {
            return false
        }

        return true
    }

    private fun isDoNotDisturbActive(): Boolean {
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE)
            as NotificationManager

        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            notificationManager.currentInterruptionFilter !=
                NotificationManager.INTERRUPTION_FILTER_ALL
        } else {
            false
        }
    }

    private fun isWithinAllowedHours(settings: WidgetSettings): Boolean {
        val currentHour = Calendar.getInstance().get(Calendar.HOUR_OF_DAY)
        return currentHour in settings.allowedStartHour..settings.allowedEndHour
    }
}

data class WidgetSettings(
    val showPrivatePhotos: Boolean = false,
    val overrideDoNotDisturb: Boolean = false,
    val allowedStartHour: Int = 7,
    val allowedEndHour: Int = 22,
    val showContentWarnings: Boolean = false,
    val blurSensitiveContent: Boolean = true
)
```

---

## 8. Widget Testing Strategy

### 8.1 Widget UI Testing

```kotlin
@RunWith(AndroidJUnit4::class)
class WidgetUITest {

    @get:Rule
    val activityRule = ActivityTestRule(WidgetTestActivity::class.java)

    @Test
    fun testWidgetDisplaysPhotoCorrectly() {
        // Setup test data
        val testPhotoUrl = "https://test.com/photo.jpg"
        val testFriendName = "Test Friend"
        val testTimestamp = "2h ago"

        // Create widget with test data
        val widgetData = createTestWidgetData(testPhotoUrl, testFriendName, testTimestamp)

        // Verify widget displays correct information
        onView(withId(R.id.friend_name))
            .check(matches(withText(testFriendName)))

        onView(withId(R.id.timestamp))
            .check(matches(withText(testTimestamp)))

        onView(withId(R.id.photo_image))
            .check(matches(isDisplayed()))
    }

    @Test
    fun testWidgetClickOpensApp() {
        // Click widget
        onView(withId(R.id.widget_container))
            .perform(click())

        // Verify app opens
        intended(hasComponent(MainActivity::class.java.name))
    }

    @Test
    fun testWidgetHandlesEmptyState() {
        // Create widget with no photo data
        val emptyWidgetData = createEmptyWidgetData()

        // Verify empty state is shown
        onView(withId(R.id.empty_state_container))
            .check(matches(isDisplayed()))

        onView(withText("Add friends to see photos"))
            .check(matches(isDisplayed()))
    }
}
```

### 8.2 Widget Performance Testing

```kotlin
@RunWith(AndroidJUnit4::class)
class WidgetPerformanceTest {

    @Test
    fun testWidgetUpdatePerformance() {
        val startTime = System.currentTimeMillis()

        // Trigger widget update
        updateWidget(testWidgetId)

        val endTime = System.currentTimeMillis()
        val updateDuration = endTime - startTime

        // Assert update completes within reasonable time
        assertTrue("Widget update took too long: ${updateDuration}ms",
                  updateDuration < 2000) // 2 seconds max
    }

    @Test
    fun testMemoryUsageWithMultipleWidgets() {
        val initialMemory = getMemoryUsage()

        // Create multiple widgets
        repeat(10) {
            createTestWidget()
        }

        val finalMemory = getMemoryUsage()
        val memoryIncrease = finalMemory - initialMemory

        // Assert reasonable memory usage
        assertTrue("Memory usage too high: ${memoryIncrease}MB",
                  memoryIncrease < 50) // 50MB max increase
    }

    private fun getMemoryUsage(): Long {
        val runtime = Runtime.getRuntime()
        return (runtime.totalMemory() - runtime.freeMemory()) / 1024 / 1024 // MB
    }
}
```

This comprehensive widget specification provides the foundation for implementing memore's signature home screen widget feature in a future development phase, complete with technical implementation details, security considerations, and testing strategies.
