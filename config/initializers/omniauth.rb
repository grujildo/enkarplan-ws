Rails.application.config.middleware.use OmniAuth::Builder do  
  provider :twitter, 'vn0P9OB9K5B8huH0OjOyow', 'UwSJegDEFtt5Lvmxw6SFDEF169Zos3J3XXHNoNCfQ'
  provider :facebook, '150890465103117', 'c2044360dae67497d7eb981aff8f5fe1'
  provider :google_oauth2, '324167693738.apps.googleusercontent.com', 'hrzx6vsY83Vji0FyL3ayjqU3'
  provider :identity
end  