# RECIPE

class Recipe
  attr_reader :name, :instructions, :ingredients

  def initialize(name, instructions, ingredients = [])
    @name = name
    @instructions = instructions
    @ingredients = ingredients
  end

  def summary
    str = "Name: #{name}\n"\
      "Instructions: #{instructions}\n"\
      "Ingredients:\n"

    ingredients.each do |ingredient|
      str += "- #{ingredient.summary}\n"
    end

    str
  end
end

# INGREDIENT

class Ingredient
  attr_reader :name, :quantity

  def initialize(name, quantity)
    @name = name
    @quantity = quantity
  end

  def summary
    "#{quantity} #{name}"
  end
end
