require "csv"
require_relative "classes"

# Create our Recipe and Ingredient objects
# and print out summaries for each recipe

recipes = []

CSV.foreach("recipe_ingredients.csv", headers: true, header_converters: :symbol) do |row|
  recipe = recipes.find { |recipe| recipe.name == row[:recipe_name] }

  if recipe.nil?
    recipe = Recipe.new(row[:recipe_name], row[:instructions])
    recipes << recipe
  end

  ingredient = Ingredient.new(row[:ingredient], row[:quantity])

  # here's where we're populating the recipe's @ingredients array
  # with actual recipe objects.  If ingredient were a hash instead of
  # an Ingredient object, our Recipe#summary method would break
  recipe.ingredients << ingredient
end

# now we've created 3 recipe objects and ingredient objects belonging to them.

recipes.each do |recipe|
  puts recipe.summary + "\n"
end
