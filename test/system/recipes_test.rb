require "application_system_test_case"

# TODO: Uncomment tests when adding tests for the authenticated users in a new branch.
class RecipesTest < ApplicationSystemTestCase
  test "visits the list" do
    visit recipes_url
    assert_selector "h1", text: "Recipes"
    assert_text recipes(:pancakes).title
  end

  test "shows a recipe" do
    recipe = recipes(:lentil_soup)
    visit recipe_url(recipe)
    assert_text recipe.title
  end

  # test "creates a recipe" do
  #   visit new_recipe_url
  #   assert_selector "h1", text: "New recipe"
  #   fill_in "Title", with: "Test tacos"
  #   click_on "Create Recipe"
  #   assert_text "Test tacos"
  # end

  # test "updates a recipe" do
  #   recipe = recipes(:pancakes)
  #   visit edit_recipe_url(recipe)
  #   assert_selector "h1", text: "Edit recipe"
  #   fill_in "Title", with: "Extra fluffy pancakes"
  #   click_on "Update Recipe"
  #   assert_text "Extra fluffy pancakes"
  # end

  # test "destroys a recipe" do
  #   recipe = recipes(:lentil_soup)
  #   visit recipe_url(recipe)
  #   accept_confirm do
  #     click_on "Destroy this recipe"
  #   end
  #   assert_no_text recipe.title
  # end
end
