require 'test_helper'

class ProductIngredientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product_ingredient = product_ingredients(:one)
  end

  test "should get index" do
    get product_ingredients_url
    assert_response :success
  end

  test "should get new" do
    get new_product_ingredient_url
    assert_response :success
  end

  test "should create product_ingredient" do
    assert_difference('ProductIngredient.count') do
      post product_ingredients_url, params: { product_ingredient: {  } }
    end

    assert_redirected_to product_ingredient_url(ProductIngredient.last)
  end

  test "should show product_ingredient" do
    get product_ingredient_url(@product_ingredient)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_ingredient_url(@product_ingredient)
    assert_response :success
  end

  test "should update product_ingredient" do
    patch product_ingredient_url(@product_ingredient), params: { product_ingredient: {  } }
    assert_redirected_to product_ingredient_url(@product_ingredient)
  end

  test "should destroy product_ingredient" do
    assert_difference('ProductIngredient.count', -1) do
      delete product_ingredient_url(@product_ingredient)
    end

    assert_redirected_to product_ingredients_url
  end
end
