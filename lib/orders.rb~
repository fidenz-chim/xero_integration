require 'ostruct' 
class Orders
  
  def self.cancel_order(order,client)
      begin
        xeroObj = client.Invoice.all(:where => {:invoice_number => order[:id]}).first  
        if  xeroObj.nil? 
          return createResponse(0,"Cannot find the order "+order[:id]) 
        end 
        xeroObj.download_complete_record!
        xeroObj.status = 'VOIDED'
        if !xeroObj.save
          return createResponse(0,xeroObj.errors)
        end
     rescue Xeroizer::ApiException => e
       return createResponse(0,Errors.xero_error(e.message))
      
      rescue => e 
        return createResponse(0,e.message)
      end
    return createResponse(1,"Order Cancelled")
  end
  
  def self.createResponse(status,data)
    reply =  OpenStruct.new 
    reply.status = status
    reply.data = data
    return reply
  end
  
end
