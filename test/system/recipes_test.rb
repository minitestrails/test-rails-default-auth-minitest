# test/system/recipes_test.rb
require "application_system_test_case"

class RecipesTest < ApplicationSystemTestCase
  test "visits the list" do
    visit recipes_url
    assert_selector "h1", text: "Recipes"
    assert_text recipes(:pancakes).title
  end

  test "visits the recipe detail" do
    recipe = recipes(:lentil_soup)
    visit recipe_url(recipe)
    assert_text recipe.title
  end

  test "creates a recipe" do
    sign_in_to_ui_as users(:alice)

    visit recipes_url
    click_on "New recipe"
    fill_in "Title", with: "Alice's salad"
    click_on "Create Recipe"

    assert_text "Alice's salad"
  end

  test "updates a recipe" do
    sign_in_to_ui_as users(:alice)

    visit recipe_url(recipes(:pancakes))
    assert_text recipes(:pancakes).title
    click_on "Edit this recipe"
    fill_in "Title", with: "Updated pancakes"
    click_on "Update Recipe"
    assert_text "Updated pancakes"
  end

  test "destroys a recipe" do
    sign_in_to_ui_as users(:alice)

    visit recipe_url(recipes(:pancakes))
    assert_text recipes(:pancakes).title
    accept_confirm { click_on "Destroy this recipe" }
    assert_text "Recipe was successfully destroyed"
    refute_text recipes(:pancakes).title
  end
end
