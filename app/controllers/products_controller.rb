require 'net/http'
require 'net/https'
require 'uri'
require 'json'

class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    products = Product.all
    render json: {message: "ok", data: products}
    puts "hello"

  end

  def slackcallback
    products = Product.all
    render json: {message: "ok", data: products}
    puts "hellol;dska;fkladsl;"

  end 

  def home 
    render template: 'products/home'
  end

  def sendtoslack
    puts "-------------- hello"
    # curl -X POST -H 'Content-type: application/json' 
    # --data '{"text":"Allow me to reintroduce myself!"}' 
    # https://hooks.slack.com/services/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

    uri     = URI('https://hooks.slack.com/services/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')
    header  = {'Content-Type': 'application/json'}
    # msg = {text: 'roger that Kris'}
    

    msg = {
      text: "New request from the job board!",
      attachments:
      [{
          text: "Shall I go ahead and distribute it to this CO?",
          fallback: "You could be telling the computer exactly what it can do with a lifetime supply of chocolate.",
          color: "#3AA3E3",
          attachment_type: "default",
          callback_id: "select_simple_1234",
          actions:
            [
              {
                name: "approve",
                text: "I approve",
                type: "button",
                value: "approve"
              },
              {
                name: "deny",
                text: "I deny",
                type: "button",
                value: "deny"
              }              
            ]
      }]
    }
    https          = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl   = true

    request       = Net::HTTP::Post.new(uri.request_uri, header)
    request.body  = msg.to_json

    response = https.request(request)

    puts response.inspect

    # req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    # req.body = {text: 'roger roger'}.to_json
    # res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      # http.request(req)
    # end

  end  

  # GET /products/1
  # GET /products/1.json
  def show
    @products = Product.find(params[:id])
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.fetch(:product, {})
    end
end
