# test/integration/recipe_integration_test.rb
require "test_helper"

class RecipeIntegrationTest < ActionDispatch::IntegrationTest
  test "visits the list" do
    get recipes_url
    assert_response :success
    assert_select "#recipes div[id^='recipe_']", count: Recipe.count
  end

  test "visits the recipe detail" do
    get recipe_url(recipes(:pancakes))
    assert_response :success
    assert_match recipes(:pancakes).title, response.body
  end

  test "guest cannot create a recipe" do
    get new_recipe_url
    assert_redirected_to new_session_url

    assert_no_difference("Recipe.count") do
      post recipes_url, params: { recipe: { title: "Sneaky soup" } }
    end
    assert_redirected_to new_session_url
  end

  test "creates a recipe" do
    sign_in_as users(:alice)

    assert_difference("Recipe.count", 1) do
      post recipes_url, params: { recipe: { title: "Alice's salad" } }
    end

    recipe = Recipe.last
    assert_redirected_to recipe_url(recipe)
    assert_equal users(:alice), recipe.user
  end

  test "non-owner cannot update a recipe" do
    sign_in_as users(:bob)
    recipe = recipes(:pancakes)

    get edit_recipe_url(recipe)
    assert_redirected_to recipe_url(recipe)
    assert_equal "Pancakes", recipe.reload.title

    assert_no_difference("Recipe.count") do
      patch recipe_url(recipe), params: { recipe: { title: "Hacked pancakes" } }
    end
    assert_redirected_to recipe_url(recipe)
    assert_equal "Pancakes", recipe.reload.title
  end

  test "non-owner cannot destroy a recipe" do
    sign_in_as users(:bob)
    recipe = recipes(:pancakes)

    assert_no_difference("Recipe.count") do
      delete recipe_url(recipe)
    end
    assert_redirected_to recipe_url(recipe)
  end

  test "updates a recipe" do
    sign_in_as users(:alice)
    recipe = recipes(:pancakes)

    get edit_recipe_url(recipe)
    assert_response :success

    patch recipe_url(recipe), params: { recipe: { title: "Updated pancakes" } }
    assert_redirected_to recipe_url(recipe)
    follow_redirect!
    assert_match "Updated pancakes", response.body
  end

  test "destroys a recipe" do
    sign_in_as users(:alice)
    recipe = recipes(:pancakes)

    assert_difference("Recipe.count", -1) do
      delete recipe_url(recipe)
    end
    assert_redirected_to recipes_url
  end
end
