import ManagedSettings
import ManagedSettingsUI
import UIKit

/// Xcode'da Runner projesine "Shield Configuration Extension" hedefi olarak
/// eklenecek örnek kaynak (bkz. paket README'si). Kısıtlı bir uygulama
/// açıldığında sistemin gösterdiği kalkan ekranını Fanus kimliğiyle özelleştirir.
class FanusShieldConfigurationExtension: ShieldConfigurationDataSource {
  override func configuration(shielding application: Application) -> ShieldConfiguration {
    ShieldConfiguration(
      backgroundBlurStyle: .systemMaterial,
      backgroundColor: UIColor(red: 0.06, green: 0.47, blue: 0.43, alpha: 1),
      icon: UIImage(systemName: "circle.hexagongrid.fill"),
      title: ShieldConfiguration.Label(text: "Fanus: Odak sürüyor", color: .white),
      subtitle: ShieldConfiguration.Label(
        text: "Bu uygulama odak oturumu bitene kadar kısıtlı.",
        color: .white
      ),
      primaryButtonLabel: ShieldConfiguration.Label(text: "Tamam", color: .white),
      primaryButtonBackgroundColor: UIColor.white.withAlphaComponent(0.2)
    )
  }

  override func configuration(
    shielding application: Application,
    in category: ActivityCategory
  ) -> ShieldConfiguration {
    configuration(shielding: application)
  }
}
