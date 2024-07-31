# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"
Rails.application.config.assets.precompile += %w( custom/apply_voucher.js jquery_ujs.js jquery.min.js custom/toggle_comment.js custom/sidebar_selected.js custom/toggle_description.js homepage.scss cart.scss admin_base.scss admin.scss product.css custom.css base.scss controllers/hello_controller.js controllers/index.js controllers/banner_countdown.js controllers/slider.js controllers/vouchers_controller.js custom/menu.js)

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
