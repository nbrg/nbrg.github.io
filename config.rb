###
# Blog settings
###

# Time.zone = "UTC"

activate :blog do |blog|
  # This will add a prefix to all links, template references and source paths
  blog.prefix = "blog"

  blog.permalink = "{title}.html"
  # Matcher for blog source files
  # blog.sources = "{year}-{month}-{day}-{title}.html"
  # blog.taglink = "tags/{tag}.html"
  # blog.layout = "layout"
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.year_link = "{year}.html"
  # blog.month_link = "{year}/{month}.html"
  # blog.day_link = "{year}/{month}/{day}.html"
  blog.default_extension = ".md"

  blog.tag_template = "blog/tag.html"
  blog.calendar_template = "blog/calendar.html"

  # Enable pagination
  # blog.paginate = true
  # blog.per_page = 10
  # blog.page_link = "page/{num}"
end

activate :directory_indexes

page "/feed.xml", layout: false

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

ignore '/players/player.html'
data.players.each do |id,player|
  proxy "/players/#{id}.html", '/players/player.html', locals: {
    player: player,
  }
end

ignore '/staff/staff.html'
data.staff.each do |id,staff|
  proxy "/staff/#{id}.html", '/staff/staff.html', locals: {
    staff: staff,
  }, page: {
    title: "Staff: #{staff.name}",
  }
end

ignore '/teams/team.html'
ignore '/teams/lineup.html'
data.teams.each do |id,team|
  team.lineups.each do |year,lineup|
    proxy "/teams/#{id}/#{year}.html", '/teams/lineup.html', locals: {
      team: team,
      year: year,
      lineup: lineup,
    }
  end

  proxy "/teams/#{id}.html", '/teams/team.html', locals: {
    team: team,
  } 
end

ignore '/bouts/bout.html'
data.bouts.each do |bout|
  proxy "/bouts/#{bout.slug}.html", '/bouts/bout.html', locals: {
    bout: bout,
  }
end

ignore '/tournaments/tournament.html'
data.tournaments.each do |id,tournament|
  proxy "/tournaments/#{tournament.slug}.html", '/tournaments/tournament.html', locals: {
    tournament: tournament,
  }
end

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", layout: false
#
# With alternative layout
# page "/path/to/file.html", layout: :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
# activate :livereload

# Methods defined in the helpers block are available in templates
helpers do
  def page_title
    yield_content(:title) || current_page.metadata[:page]['title']
  end

  def tournaments
    data.tournaments.values.sort_by { |t| t.date.from }
  end

  def bouts_for_tournament(tournament)
    data.bouts.select { |b| b.tournament == tournament.slug }.sort_by(&:date)
  end
end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

# Build-specific configuration
configure :build do
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
