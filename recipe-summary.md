# Review of collaborator objects

A typical area of confusion when starting to learn object-oriented design is how two classes work with each other. For example, say one object, like a `Recipe`, has an instance variable that is an array of other objects like `Ingredients`s.

Here are a couple of questions that trip people up:
* How do we pass `Ingredient` objects to a particular `Recipe`?
* How do we call `Ingredient` methods inside the `Recipe` class?

Let's look at the first example.

## Passing `Ingredient` objects to a `Recipe`

```ruby
class Recipe
  attr_reader :name, :instructions, :ingredients

  def initialize(name, instructions, ingredients = [])
    @name = name
    @instructions = instructions
    @ingredients = ingredients
  end

  # ...
end

class Ingredient
  attr_reader :name, :quantity

  def initialize(name, quantity)
    @name = name
    @quantity = quantity
  end

  # ...
end
```

We've got these two classes. Now let's say we create a `Recipe` and an `Ingredient` object and pass the ingredient to the recipe.

```ruby
recipe = Recipe.new("cereal", "Pour milk and cereal into bowl.")
ingredient = Recipe.new("Cheerios", "1 cup")

recipe.ingredients << ingredient
```

Above, `recipe.ingredients` returns an array. In this case, since we haven't added any ingredients to the recipe yet, it will return an empty array.

We can call any array methods, such as `.each` or `.pop`, on this `recipe.ingredients` array, so we can add an ingredient to the array using the `<<` method:

```ruby
recipe.ingredients << ingredient
```

What trips people up sometimes is that nowhere in the `Recipe` class are we referencing the `Ingredient` class specifically.  How does `Recipe` know that that `@ingredients` array contains `Ingredient` objects?

The answer: It doesn't. We could pass in hashes, arrays, strings, etc. into that `@ingredients` array. But we probably shouldn't.

## Calling `Ingredient` methods inside the `Recipe` class

Say we want a `summary` method that we can call on `Recipe` that will print out something like this:

```no-highlight
Name: popcorn
Instructions: Pop the popcorn. Add oil and salt. A lot of salt.
Ingredients:
- 1/4 cup popcorn
- 1 tbsp flax seed oil
- entire shaker salt
```

We might write the method like this:

```ruby
class Recipe
  # ...

  def summary
    str = "Name: #{name}\n"\
      "Instructions: #{instructions}\n"\
      "Ingredients:\n"

    ingredients.each do |ingredient|
      # call the Ingredient's `summary` method
      str += "- #{ingredient.summary}\n"
    end

    str
  end
end
```

We want to be able to iterate over each ingredient in the `@ingredients` array and call the `Ingredient`'s own `.summary` method, which might look like this:

```ruby
class Ingredient
  # ...

  def summary
    "#{quantity} #{name}"
  end
end
```

So now we've got two summary methods - one for `Recipe` objects and one for`Ingredient` objects.  How does it know which one to call?

When we call a method on an object, Ruby checks to see what type of object it is:

If the object is a `Recipe` object, it will first go to the  `Recipe` class and look for an instance method called `summary`. When it finds it, it will call that method.

[Aside: If our `Recipe` class didn't have a `summary` method, it would then look for a `summary` method in some other places (we can talk about that later), and if it ultimately doesn't find a `summary` method, will return a `noMethodError`.]

If we call `.summary` on an `Ingredient` object, as we do inside the `.each` loop in our `Recipe#summary` method, Ruby sees that that object is an `Ingredient` and goes to look for a `summary` method in the `Ingredient` class.

[Aside:  If we accidentally put a hash inside our recipe's `@ingredients` array, Ruby will look for `summary` method in the `Hash` class.  Not finding it, it'll return a `noMethodError`.]

