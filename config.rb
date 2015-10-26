###
# Blog settings
###

# Time.zone = "UTC"

activate :blog do |blog|
  # This will add a prefix to all links, template references and source paths
  blog.prefix = "blog"

  # Matcher for blog source files
  # blog.sources = "{year}-{month}-{day}-{title}.html"
  # blog.taglink = "tags/{tag}.html"
  blog.layout = "blog-post"
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
  # blog.per_page = 3
  # blog.page_link = "page/{num}"
end

class GameMapper < ContentfulMiddleman::Mapper::Base
  def map(context, entry)
    super
    against = entry.against
    context.slug = "#{entry.datetime.strftime('%Y-%m-%d')}-nbrg-vs-#{against.nickname}".downcase
  end
end

activate :contentful do |f|
  f.space = {
    website: 'woqj76ijzwsc'
  }
  f.access_token = ENV['contentful_access_token']
  f.cda_query = {
    include: 2,
    limit: 1000
  }
  f.content_types = {
    game: {
      id: 'GwKw7RBbEq00EeKw2KYiK',
      mapper: GameMapper
    },
    league: '5LCZ0WqZ7qsiiuAqYGi6qe',
    member: '6vGfQlnZC00aYeuWEW4MMO',
    photo: '3ZWZ13o8HSAGUM6KWKwEMm',
    photographer: '2noUTFTyrGGEaqCiIKoKK0',
    sponsor: '39dTz3KNpm8SAAoyWCSCKC',
    team: '3yGKYOVrZY8kGu4SKSoaye',
    tournament: '31CyTyGhMQ8wiyAU2ks6SU',
    venue: '26QoxGy4wUKQQOcEoiqAGk'
  }
end

activate :google_analytics do |ga|
  ga.tracking_id = 'UA-53595551-1'
  ga.development = false
  ga.minify = true
end

activate :deploy do |deploy|
  deploy.method = :git
  deploy.branch = 'master'
  deploy.build_before = true
end

activate :directory_indexes
activate :autoprefixer
activate :sitemap do |sitemap|
  sitemap.gzip = false
  sitemap.hostname = 'http://' + `cat source/CNAME`.chomp
end

page "/feed.xml", layout: false

###
# Page options, layouts, aliases and proxies
###

ignore '/members/member.html'
data.website.member.values.each do |member|
  proxy "/members/#{member.slug}.html", '/members/member.html', locals: {
    member: member,
  }
end

ignore '/teams/team.html'
ignore '/teams/lineup.html'
data.website.team.each do |_,team|
  proxy "/teams/#{team.slug}.html", '/teams/lineup.html', layout: 'one-column', locals: {
    team: team
  }
end

ignore '/bouts/bout.html'
data.website.game.each do |id,bout|
  proxy "/bouts/#{bout.slug}.html", '/bouts/bout.html', locals: {
    bout: bout,
  }
end

ignore '/tournaments/tournament.html'
data.website.tournament.each do |id,tournament|
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
  def markdown(content)
    Tilt['markdown'].new { content }.render
  end

  def page_title
    yield_content(:title) || current_page.metadata[:page]['title']
  end

  def article_class
    current_page.metadata[:page]['article_class'] || ''
  end

  def tournaments
    data.website.tournament.values.sort_by { |t| t.from }
  end

  def bouts
    data.website.game.values
  end

  def upcoming_bouts
    bouts.select { |b| b.datetime >= Date.today }.sort_by(&:datetime)
  end

  def past_bouts
    bouts.select { |b| b.datetime < Date.today }.sort_by(&:datetime).reverse
  end

  def bouts_for_tournament(tournament)
    bouts.select { |b| b.tournament && b.tournament.id == tournament.id }.sort_by(&:datetime)
  end

  def bout_by_slug(slug)
    bouts.select { |b| b.slug == slug }.first
  end

  def datetime_tag(date, format='%-d %b, %Y at %l:%M%P')
    "<time datetime=\"#{date.strftime('%FT%T')}\">#{date.strftime(format)}</time>"
  end

  def date_tag(date)
    datetime_tag(date, '%-d %b, %Y')
  end

  def time_tag(date)
    datetime_tag(date, '%l:%M%P')
  end

  def lineups_for_player(player)
    id = player.is_a?(String) ? player : player.slug
    lineups = []
    data.teams.each { |team_id,team|
      team['lineups']
        .select { |lu_id,lu| lu['players'].include? id }
        .each { |lu_id,_| lineups << [team_id,lu_id] }
    }
    lineups
  end

  def photo_path(img)
    if img.is_a? String
      data.website.photo.values.select { |p| p.title == img }.first.photo.url
    else
      img.photo.url
    end
  end

  def photograph(name)
    photo = if name.is_a? String
      data.website.photo.values.select { |p| p.title == name }.first
    else
      # is a photo
      name
    end
    raise "Unrecognised photo #{name}" unless photo
    partial '_photograph', locals: { image: name, photo: photo, photographer: photo.photographer }
  end

  def hostname
    'http://' + `cat source/CNAME`.chomp
  end
end

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

# Build-specific configuration
configure :build do
  activate :minify_css
  activate :minify_javascript
end
