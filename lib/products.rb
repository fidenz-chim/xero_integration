require 'ostruct' 

class Products
  
  def self.add_product(product,params,client)
    begin 
      reply =  OpenStruct.new
       
      xeroObj = client.Item.build(:code => product[:sku])        
        xeroObj.description = product[:description]
        sales = xeroObj.build_sales_detail(:account_code => params[:Account_Code])
        sales.unit_price = product[:price]
        
        
      if !xeroObj.save
        return createResponse(0,xeroObj.errors)  
      end 
      rescue Xeroizer::ApiException => e
       return createResponse(0,Errors.xero_error(e.message))
       
     rescue => e 
        return createResponse(0,e.message)
      end
      return createResponse(1,product)
  end
  
  def self.update_product(product,params,client)
    begin 
      if  !product.has_key?('sku')
        return createResponse(0,"sku value required") 
      end            
      xeroObj = client.Item.all(:where => {:code => product[:sku]}).first    
      if  xeroObj.nil? 
        return createResponse(0,"Cannot find the product "+product[:sku]) 
      end
      xeroObj.description = product[:description]
      xeroObj.sales_details.unit_price = product[:price]
      xeroObj.sales_details.account_code = params[:Account_Code]
        
      if !xeroObj.save
        return createResponse(0,xeroObj.errors)  
      end  
     rescue => e 
        return createResponse(0,e.message)
      end
      return createResponse(1,product)
  end
  
  def self.get_products(client,params)
    arr = Array.new
      parsed_time = params[:timestamp]#DateTime.strptime(params[:timestamp],'%Y/%m/%d %H:%M:%S')
      xeroObj = client.Item.all
      xeroObj.each do |product|
        if !xeroObj.nil? #&& product.updated_at.to_datetime.iso8601>parsed_time
          arr<< product
        end
      end
    return createWombatProduct(arr,client)
  end
  
  def self.createWombatProduct(products,client)
    obj = products.map do |product|
      {
      :id => product.code,
      :sku => product.code,
      :description => product.description,
      :price => product.sales_details.unit_price
      }
    end
    
    return obj   
  end
  
  def self.createResponse(status,data)
    reply =  OpenStruct.new 
    reply.status = status
    reply.data = data
    return reply
  end
  
end

