class User
  attr_accessor :name
  @@all = []

  def initialize(name)
    @name = name

    @@all << self
  end

  def self.all
    @@all
  end

  def recipes
    RecipeCard.all.select do |recipecard|
      recipecard.user == self
    end.map do |recipecard|
      recipecard.recipe
    end
  end

  def allergens
    Allergen.all.select do |allergy|
      allergy.user == self
    end.map do |allergy|
      allergy.ingredient
    end
  end

  def add_recipe_card(recipe, date, rating)
    # new_recipe = Recipe.new('oreo cake')
    RecipeCard.new("#{recipe.name} recipe", date, rating, recipe, self)
  end

  def declare_allergen(ingredient)
    Allergen.new("#{ingredient.name} allergy", ingredient, self)
  end

  # - `User#top_three_recipes`
  # should return the top three highest rated recipes for this user.
  def top_three_recipes
    top_three = []

    sorted_cards = RecipeCard.all.sort do |x, y|
      x.rating <=> y.rating
    end

    3.times do
      top_three << sorted_cards.pop
    end

    top_three
  end

  def most_recent_recipe
    recipes.pop
  end

  #User safe_recipes should return all recipes that do not contain ingredients the user is allergic to
  def safe_recipes
    safe_list = []

    RecipeIngredient.all.each do |recipeingredient|
        safe_list << recipeingredient.recipe unless allergens.include?(recipeingredient.ingredient)
      end
    safe_list
  end
end
