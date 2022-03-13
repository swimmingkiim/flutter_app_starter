final Map<String, dynamic> config = {
  'api': {
    'BASE_URL': 'https://api.flutter_app_starter.example.com',
    'KEY': {'TOKEN': '', 'REFRESH_TOKEN': ''}
  },
  'auth': {
    'apple': {'UID': 'APPLE_UID_KEY'},
    'google': {'UID': 'GOOGLE_UID_KEY'}
  },
  'cloud': {
    'common': {
      'DRIVE_BACKUP_DIR_PARENT': 'appDataFolder',
      'DRIVE_BACKUP_FILE_NAME': 'flutter_app_starter__backup',
      'DRIVE_BACKUP_FILE_EXT': 'json',
    },
    'apple': {'ICLOUD_CONTAINER_ID': 'iCloud.com.example.flutter_app_starter'},
    'google': {}
  },
  'payment': {
    'SUBSCRIPTION_ID': 'com.example.flutter_app_starter.monthly_subscription',
    'TEST_ACCOUNT': 'flutter_app_starter@example.com',
  }
};
