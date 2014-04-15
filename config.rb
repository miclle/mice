###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###

activate :syntax

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
# configure :development do
#   activate :livereload
# end

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

# set :fonts_dir,  "fonts"

set :build_dir, "docs"

configure :development do
  set :debug_assets, true
end

# Build-specific configuration
configure :build do
  set :debug_assets, false
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

# after_configuration do
#   sprockets.append_path 'vendor/assets/stylesheets'
#   sprockets.append_path 'vendor/assets/javascripts'
#   sprockets.append_path 'vendor/assets/images'
# end


# # https://github.com/middleman/middleman/issues/55#issuecomment-28456419
# # Find all the files in `./source/` that compile into static HTML
# pages = Dir.glob("./source/*.html*")

# pages.each do |page_path|

#   # Get each page's filename (not including the extensions)
#   page = page_path.match(/.\/source\/([^\.]*)\..*/).captures[0]

#   # Set the layout for your pages
#   page  "/#{page}/*"#, :layout => :page

#   # Make requests to / load the content at /page.html.any.extension
#   proxy "/#{page}/index.html", "/#{page}.html", :ignore => true

# end