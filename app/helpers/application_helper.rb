module ApplicationHelper
  def full_title page_title
    base_title = t "web_name"
    page_title.empty? ? base_title : page_title + " | " + base_title
  end

  def gravatar_for user, size: 80
    gravatar_id = Digest::MD5.hexdigest user.email.downcase
    gravatar_url =
      "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
