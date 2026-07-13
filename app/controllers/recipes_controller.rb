class RecipesController < ApplicationController
  allow_unauthenticated_access only: %i[index show]
  before_action :set_recipe, only: %i[show edit update destroy]
  before_action :ensure_recipe_owner, only: %i[edit update destroy]

  def index
    @recipes = Recipe.order(created_at: :desc)
  end

  def show
  end

  def new
    @recipe = Recipe.new
  end

  def edit
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)

    if @recipe.save
      redirect_to @recipe, notice: "Recipe was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @recipe.update(recipe_params)
      redirect_to @recipe, notice: "Recipe was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @recipe.destroy
    redirect_to recipes_path,
                notice: "Recipe was successfully destroyed.",
                status: :see_other
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def ensure_recipe_owner
    return if @recipe.user == current_user

    redirect_to @recipe, alert: "You are not authorized to modify this recipe."
  end

  def recipe_params
    params.require(:recipe).permit(:title, :description, :servings, :prep_time)
  end
end
