require 'ostruct' 
class Invoices
  def self.add_or_update_order(order,params,client)
    begin
      invoice = nil
      if !order.has_key?('email')
        return createResponse(0,"Email Required")
      end
      if !order.has_key?('status')
        return createResponse(0,"Status Required")
      end
      
      invoice = client.Invoice.first(:where => {:invoice_number => order[:id]})
      if invoice.nil?
        invoice = client.Invoice.build(:type => 'ACCREC')
      else
        invoice.download_complete_record!
      end      
        invoice.invoice_number = order[:id]
        invoice.status = set_status(order[:status])
        invoice.sub_total = order[:totals][:item]
        invoice.total = order[:totals][:order]
        invoice.total_tax = order[:totals][:tax]
        #invoice.currency_code = order[:currency],
        invoice.date = order[:placed_on].to_time
        invoice.due_date = order[:placed_on].to_time
        
        contact = client.Contact.all(:where => {:email_address => order[:email]}).first
        if contact.nil?
          contact = client.Contact.build(:name => order[:email],
          :first_name => order[:billing_address][:firstname],
          :last_name => order[:billing_address][:lastname],
          :email_address => order[:email]
          )
          if order.has_key?('billing_address')
            ad = contact.add_address(:type => 'STREET')
               ad.line1 = order[:billing_address][:address1]
               ad.line2 = order[:billing_address][:address2]
               ad.city = order[:billing_address][:city]
               ad.region = order[:billing_address][:state]
               ad.postal_code = order[:billing_address][:zipcode]
               ad.country = order[:billing_address][:country]
               
             phone = contact.add_phone(:phone_type => 'DEFAULT')
             phone.number = order[:billing_address][:phone]
               
              if !contact.save
                return createResponse(0,contact.errors)
              end
           end
           if order.has_key?('shipping_address')
            ad = contact.add_address(:type => 'POBOX')
               ad.line1 = order[:shipping_address][:address1]
               ad.line2 = order[:shipping_address][:address2]
               ad.city = order[:shipping_address][:city]
               ad.region = order[:shipping_address][:state]
               ad.postal_code = order[:shipping_address][:zipcode]
               ad.country = order[:shipping_address][:country]
               
              if !contact.save
                return createResponse(0,contact.errors)
              end
           end
           invoice.contact=contact
        else
          contact.download_complete_record!
          contact.name = order[:email]
          contact.first_name = order[:billing_address][:firstname]
          contact.last_name = order[:billing_address][:lastname]
          contact.email_address = order[:email]
          if order.has_key?('billing_address')
            ad = contact.add_address(:type => 'STREET')
               ad.line1 = order[:billing_address][:address1]
               ad.line2 = order[:billing_address][:address2]
               ad.city = order[:billing_address][:city]
               ad.region = order[:billing_address][:state]
               ad.postal_code = order[:billing_address][:zipcode]
               ad.country = order[:billing_address][:country]
             phone = contact.add_phone(:phone_type => 'DEFAULT')
             phone.number = order[:billing_address][:phone]
            contact.save
          end
          if order.has_key?('shipping_address')
            ad = contact.add_address(:type => 'POBOX')
               ad.line1 = order[:shipping_address][:address1]
               ad.line2 = order[:shipping_address][:address2]
               ad.city = order[:shipping_address][:city]
               ad.region = order[:shipping_address][:state]
               ad.postal_code = order[:shipping_address][:zipcode]
               ad.country = order[:shipping_address][:country]
            contact.save
          end
          invoice.contact = contact
          # if !invoice.save
            # return createResponse(0,invoice.errors)
          # end
        end
        
        if order.has_key?('line_items')
          lineitems = order[:line_items]
          lineitems.each do |item|
          invoice.add_line_item(
            :item_code => item[:product_id],
            :description => item[:name],
            :quantity => item[:quantity],
            :unit_amount => item[:price],
            :tax_type => "OUTPUT",
            :account_code => "200"
            )
          end
        end  
          
        if order.has_key?('status') and order[:status]=='completed' and order.has_key?('payments')
          invoice.add_payment(:amount => order[:payments][:amount])
          invoice.add_payment(:reference => order[:payments][:number])
          invoice.add_payment(:date => order[:placed_on])
          invoice.add_line_item.(:account_code =>params[:Payment_Code])
        end     
        
        if !invoice.save
          return createResponse(0,invoice.errors)  
        end 
        return createResponse(1,invoice)
      rescue Xeroizer::ApiException => e
       return createResponse(0,Errors.xero_error(e.message))
      end
  end  
  
  def self.createResponse(status,data)
    reply =  OpenStruct.new 
    reply.status = status
    reply.data = data
    return reply
  end  
  
  def self.set_status(status)
    if status=='complete'
      status = 'AUTHORISED'
    else
      status = 'SUBMITTED'
    end
  end
  def self.set_payment(payment)
    if payment=='completed'
      payment = 'paid'
    else
      payment = 'unpaid'
    end
  end
end