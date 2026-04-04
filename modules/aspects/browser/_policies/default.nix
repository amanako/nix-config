# Reference: https://mozilla.github.io/policy-templates
{
  AutofillAddressEnabled = false;
  AutofillCreditCardEnabled = false;
  DisableFeedbackCommands = true;
  DisableFirefoxStudies = true;
  DisablePocket = true;
  DisableTelemetry = true;
  DisableFormHistory = true;
  DisablePasswordReveal = true;
  DontCheckDefaultBrowser = true;
  HardwareAcceleration = true;
  NoDefaultBookmarks = true;
  OfferToSaveLogins = false;
  EnableTrackingProtection = {
    Value = true;
    Locked = true;
    Cryptomining = true;
    Fingerprinting = true;
    EmailTracking = true;
  };
  EncryptedMediaExtensions = {
    Enabled = true;
    Locked = true;
  };
  ExtensionUpdate = false;
  PasswordManagerEnabled = false;
  PromptForDownloadLocation = true;
  StartDownloadsInTempDirectory = true;
  UserMessaging = {
    ExtensionRecommendations = false;
    FeatureRecommendations = false;
    UrlbarInterventions = false;
    SkipOnboarding = true;
    MoreFromMozilla = true;
    Locked = true;
  };
}
