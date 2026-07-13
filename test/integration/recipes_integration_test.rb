require "test_helper"

class RecipesIntegrationTest < ActionDispatch::IntegrationTest
  test "guest visits the list" do
    get recipes_url
    assert_response :success
    assert_match recipes(:pancakes).title, response.body
    assert_select "#recipes div[id^='recipe_']", count: Recipe.count
    assert_select "a", text: "New recipe", count: 0
  end

  test "guest visits a recipe details page" do
    get recipe_url(recipes(:pancakes))
    assert_response :success
    assert_select "a", text: "Edit this recipe", count: 0
  end

  test "guest is redirected when creating a recipe" do
    get new_recipe_url
    assert_redirected_to new_session_path

    assert_no_difference("Recipe.count") do
      post recipes_url, params: { recipe: { title: "Lentil soup" } }
    end

    assert_redirected_to new_session_path
  end

  test "creates a recipe" do
    sign_in_as users(:alice)

    get new_recipe_url
    assert_response :success

    assert_difference("Recipe.count", 1) do
      post recipes_url, params: { recipe: { title: "Lentil soup" } }
    end

    assert_redirected_to recipe_url(Recipe.last)
    assert_equal users(:alice), Recipe.last.user
    follow_redirect!
    assert_response :success
  end

  test "updates a recipe as the owner" do
    recipe = recipes(:pancakes)
    sign_in_as recipe.user

    get edit_recipe_url(recipe)
    assert_response :success

    patch recipe_url(recipe), params: { recipe: { title: "Extra fluffy pancakes" } }
    assert_redirected_to recipe_url(recipe)
    follow_redirect!
    assert_response :success
    assert_equal "Extra fluffy pancakes", recipe.reload.title
  end

  test "cannot update another user's recipe" do
    recipe = recipes(:pancakes)
    sign_in_as users(:bob)

    get edit_recipe_url(recipe)
    assert_redirected_to recipe_url(recipe)

    patch recipe_url(recipe), params: { recipe: { title: "Stolen pancakes" } }
    assert_redirected_to recipe_url(recipe)
    assert_equal "Pancakes", recipe.reload.title
  end

  test "destroys a recipe as the owner" do
    recipe = recipes(:lentil_soup)
    sign_in_as recipe.user

    assert_difference("Recipe.count", -1) do
      delete recipe_url(recipe)
    end
    assert_redirected_to recipes_url
  end

  test "cannot destroy another user's recipe" do
    recipe = recipes(:lentil_soup)
    sign_in_as users(:alice)

    assert_no_difference("Recipe.count") do
      delete recipe_url(recipe)
    end
    assert_redirected_to recipe_url(recipe)
  end

  test "does not create a recipe with invalid data" do
    sign_in_as users(:alice)

    get new_recipe_url
    assert_response :success

    assert_no_difference("Recipe.count") do
      post recipes_url, params: { recipe: { title: "" } }
    end

    assert_response :unprocessable_entity
    assert_match /prohibited this recipe from being saved/i, response.body
  end
end
