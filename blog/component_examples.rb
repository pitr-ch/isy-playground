class Article
  include DataMapper::Resource
  # ...
end

class Articles # descendant of a Component
  attr_reader :articles

  # form for new article or editing one
  attr_reader :form
  
  class Widget < ::Widget

    # Erector's method. Place where all rendering starts in Widget.
    def content      
      # if form is set, it's rendered. #component returns Articles' instance
      widget component.form if component.form
      # renders the articles' list
      render_articles
      # renders link to 'Create new article'
      link_to 'Create new article' do
        # this block is evaluated inside Articles' instance 
        # when link 'Create new article' is clicked
        self.form = ask ArticleForm.new(articles_component, Article.new) do |answer|
          # this block is evaluated inside Articles' instance
          # when method #ansver! is called inside self.form

          # answer is a new and valid article
          answer.save
          self.form = nil
        end
      end
    end

    def render_articles
      #...
    end
  end
end


class Component
  def ask(component, &block)
    component.set_answer(self, block)
  end

  def answering!(to_whom, &block)
    @asker, @askers_callback = to_whom, block
  end

  def answer!(answer)    
    @asker.instance_exec answer, &@askers_callback
  end
end

class ArticleForm # descendant of a Component
  
  def initialize(parent, article)
    super(parent)
    @article = article
  end

  class Widget
    def content
      render_form

      link_to 'Save' do
        # this block is evaluated inside ArticleForm's instance
        # when link 'Save' is clicked
        # form data is automaticaly send and assigned to article
        if article.valid?
          answer!(article)
        else
          # let the ArticleForm's instance know that it needs
          # to be rerendered to show validations' error
          change!
        end
      end
    end

    link_to 'Cancel' do
      answer!(nil)
    end

    def render_form
      # renders the article's form
    end
  end
end

class ArticleComponent
  attr_reader :article
end

class ArticleRow < ArticleComponent
  class Widget

    def content
      render_cells
      link_to 'Edit' do
        self.form = ask ArticleForm.new(articles_component, article) do |answer|
          answer.save if answer
          self.form = nil
        end
      end
      link_to 'Delete' do
        article.destroy
      end
    end

  end
end


class Hammer::Component

  # ve widgetu listu prispecku
  link_to "novy prispevek" do
    # component je odkaz na komponentu tohoto widgetu
    # komp. list prispevku ma volitelneho potomka form_component
    # ask vytvori novou komponentu a ulozi do ni komu ma poslat ansver
    #   blok se provede po obdrzeni odpovedi v kontextu tazajici se komponenty
    component.form_component = ask PrispevekForm, args_for_initializer do
      # vezme neulozeny prispevek a ulozi ho do db,
      #   prida pripadne nejake vazby podle kontextu listu prispevku
      add_prispevek(prispevek)
    end
  end

  
end