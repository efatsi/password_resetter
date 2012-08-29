module MakingHelper
  
  def make_comment(content = "This is a primary comment")
    fill_in 'Content', :with => content
    click_on 'Add Comment'
  end
  
  def make_article
    fill_in 'Title', :with => 'Example Page'
    fill_in 'Link', :with => 'example.com'
    click_on 'Create Article'
  end
  
  def click_on_article(article_name, link = "0 comments")
    article_node = all('table tbody tr td').detect {|n| n.text.include?(article_name) && n.text.include?(link)}
    article_node.click_link "#{link}"
  end
  
  def click_on_comment(context)
    comment_node = all('div comment').detect { |n| n.text.include?(context) }
    comment_node.click_link "link"
  end
  
end