require 'require_all'
require 'sinatra'
require 'json'
require 'active_support/core_ext/hash/indifferent_access'

require_all 'lib'


class XeroApp < Sinatra::Base
  
  post '/add_product' do
    
 
      content_type :json
      payload = JSON.parse(request.body.read).with_indifferent_access
      request_id = payload[:request_id]
      params = payload[:parameters]
      product = payload[:product]
      appid = params[:appid]
      secret = params[:secret]
      username = params[:username]
      password = params[:password]
      
      client = Xeroizer::PrivateApplication.new(appid, secret, "public/privatekey.pem")
      
      status = Products.add_product(product,params,client)
      if status.status == 0
        status 500
        { request_id: request_id, summary: status.data }.to_json + "\n" 
      else
        { product: status.data,request_id: request_id, summary: "success"}.to_json + "\n"
      end   
  end
  
  post '/update_product' do
    
 
      content_type :json
      payload = JSON.parse(request.body.read).with_indifferent_access
      request_id = payload[:request_id]
      params = payload[:parameters]
      product = payload[:product]
      appid = params[:appid]
      secret = params[:secret]
      username = params[:username]
      password = params[:password]
      
      client = Xeroizer::PrivateApplication.new(appid, secret, "public/privatekey.pem")
      
      status = Products.update_product(product,params,client)
      if status.status == 0
        status 500
        { request_id: request_id, summary: status.data }.to_json + "\n" 
      else
        { product: status.data,request_id: request_id, summary: "success"}.to_json + "\n"
      end   
  end
  
  post '/add_order' do
    
    begin
      content_type :json
      payload = JSON.parse(request.body.read).with_indifferent_access
      request_id = payload[:request_id]
      params = payload[:parameters]
      order = payload[:order]
      appid = params[:appid]
      secret = params[:secret]
      username = params[:username]
      password = params[:password]
      
      client = Xeroizer::PrivateApplication.new(appid, secret, "public/privatekey.pem")
      status = Invoices.add_or_update_order(order,params,client)
      if status.status == 0
        status 500
        { request_id: request_id, summary: status.data.inspect }.to_json + "\n" 
      else
        { order: status.data,request_id: request_id, summary: "success"}.to_json + "\n"
      end
    
    rescue => e
      return {request_id: request_id, summary: e.message}.to_json + "\n" 
    end
    
  end
  
  post '/update_order' do
    
    begin
      content_type :json
      payload = JSON.parse(request.body.read).with_indifferent_access
      request_id = payload[:request_id]
      params = payload[:parameters]
      order = payload[:order]
      appid = params[:appid]
      secret = params[:secret]
      username = params[:username]
      password = params[:password]
      
      client = Xeroizer::PrivateApplication.new(appid, secret, "public/privatekey.pem")
      status = Invoices.add_or_update_order(order,params,client)
      if status.status == 0
        status 500
        { request_id: request_id, summary: status.data.inspect }.to_json + "\n" 
      else
        { order: status.data,request_id: request_id, summary: "success"}.to_json + "\n"
      end
    
    rescue => e
      return {request_id: request_id, summary: e.message}.to_json + "\n" 
    end
    
  end
  
  post '/add_return' do
    
    begin
      content_type :json
      payload = JSON.parse(request.body.read).with_indifferent_access
      request_id = payload[:request_id]
      params = payload[:parameters]
      order = payload[:return]
      appid = params[:appid]
      secret = params[:secret]
      username = params[:username]
      password = params[:password]
      
      client = Xeroizer::PrivateApplication.new(appid, secret, "public/privatekey.pem")
      status = CreditNotes.add_or_update_credit_note(order,client)
      if status.status == 0
        status 500
        { request_id: request_id, summary: status.data.inspect }.to_json + "\n" 
      else
        { request_id: request_id, summary: "success"}.to_json + "\n"
      end
    
    rescue => e
      return {request_id: request_id, summary: e.message}.to_json + "\n" 
    end
    
  end
  
  post '/update_return' do
    
    begin
      content_type :json
      payload = JSON.parse(request.body.read).with_indifferent_access
      request_id = payload[:request_id]
      params = payload[:parameters]
      order = payload[:return]
      appid = params[:appid]
      secret = params[:secret]
      username = params[:username]
      password = params[:password]
      
      client = Xeroizer::PrivateApplication.new(appid, secret, "public/privatekey.pem")
      status = CreditNotes.add_or_update_credit_note(order,client)
      if status.status == 0
        status 500
        { request_id: request_id, summary: status.data.inspect }.to_json + "\n" 
      else
        { request_id: request_id, summary: "success"}.to_json + "\n"
      end
    
    rescue => e
      return {request_id: request_id, summary: e.message}.to_json + "\n" 
    end
    
  end
  
  post '/cancel_order' do
    
    begin
      content_type :json
      payload = JSON.parse(request.body.read).with_indifferent_access
      request_id = payload[:request_id]
      params = payload[:parameters]
      order = payload[:order]
      appid = params[:appid]
      secret = params[:secret]
      username = params[:username]
      password = params[:password]
      
      client = Xeroizer::PrivateApplication.new(appid, secret, "public/privatekey.pem")
      status = Orders.cancel_order(order,client)
      if status.status == 0
        status 500
        { request_id: request_id, summary: status.data }.to_json + "\n" 
      else
        { order: order,request_id: request_id, summary: status.data}.to_json + "\n"
      end 
    
    rescue => e
      return { product: status,request_id: request_id, summary: e.message}.to_json + "\n" 
    end
    
  end
  
  post '/get_products' do
    
    begin
      content_type :json
      payload = JSON.parse(request.body.read).with_indifferent_access
      request_id = payload[:request_id]
      params = payload[:parameters]
      order = payload[:order]
      appid = params[:appid]
      secret = params[:secret]
      username = params[:username]
      password = params[:password]
      
      client = Xeroizer::PrivateApplication.new(appid, secret, "public/privatekey.pem")
      
      status = Products.get_products(client,params)
      timestamp = {:timestamp => DateTime.now.to_datetime.iso8601}
      if status==false
        status 500
        { request_id: request_id, summary: "Error occurred",parameters: timestamp }.to_json + "\n" 
      else
        { product: status,parameters: timestamp,request_id: request_id, summary: "success"}.to_json + "\n" 
      end
    
    rescue => e
      return { product: status,request_id: request_id, summary: e.message}.to_json + "\n" 
    end
  end
  
  def code(username,password,id,secret)
    token = aclient(id,secret)
    pass =  token.password.get_token(username, password) 
    return pass
  end
    
    def redirect_uri
      redirect_uri  = 'http://mysite.com:9292/oauth/callback'
    end
    
    def site
      site          = "https://api.xero.com/api.xro/2.0/"
    end
    
    def aclient(id,secret)
      aclient = OAuth2::Client.new(id,secret, :site => site)
    end
    
    def tkn 
      tkn = nil
    end
  
end
