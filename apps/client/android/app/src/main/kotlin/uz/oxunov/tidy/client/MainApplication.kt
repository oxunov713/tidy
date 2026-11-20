package uz.oxunov.tidy.client

import android.app.Application
import com.yandex.mapkit.MapKitFactory

class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        // Without a key the map stays grey but the rest of the app works.
        if (BuildConfig.YANDEX_MAPKIT_KEY.isNotEmpty()) {
            MapKitFactory.setApiKey(BuildConfig.YANDEX_MAPKIT_KEY)
        }
    }
}
