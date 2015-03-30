require 'ostruct' 
class CreditNotes
  
  def self.add_or_update_credit_note(note,client)
    
    begin
      if !note.has_key?('status')
          return createResponse(0,"status required")
        end
        if !note.has_key?('date')
          return createResponse(0,"date required")
        end
        if !note.has_key?('updated_at')
          return createResponse(0,"updated_at field required")
        end
        if !note.has_key?('email')
          return createResponse(0,"email required")
        end
      creditNote = client.CreditNote.first(:where => {:credit_note_number => note[:id]})
      if creditNote.nil?
        creditNote = client.CreditNote.build(:type => 'ACCRECCREDIT')
      else
        creditNote.download_complete_record!
      end
      creditNote.date = note[:date].to_time
      creditNote.line_amount_types = 'Exclusive'
      contact = client.Contact.all(:where => {:email_address => note[:email]}).first
      if !contact.nil?
        creditNote.contact = contact
      end
      # creditNote.total = note[:order_totals][:total]
      # creditNote.total_tax = note[:order_totals][:tax]
      # creditNote.sub_total = note[:order_totals][:item]
      creditNote.updated_date_utc = note[:updated_at].to_time
      creditNote.fully_paid_on_date = note[:updated_at].to_time
      creditNote.date = note[:updated_at].to_time
      creditNote.status = note[:status].upcase
      creditNote.credit_note_number = note[:id]
      creditNote.currency_code = note[:currency]
      
      invoice = client.Invoice.first(:where => {:invoice_number => note[:order_id]})
      if invoice.nil?
        return createResponse(0,"Cannot find the invoice for invoice id "+note[:order_id].to_s)
      end
      invoice.download_complete_record!
      
      if note.has_key?('inventory_units')
            lineitems = note[:inventory_units]
            lineitems.each do |item|
            creditNote.add_line_item(
              :item_code => item[:product_id],
              :description => item[:name],
              :quantity => item[:quantity],
              :unit_amount => item[:price],
              :tax_type => "OUTPUT",
              :account_code => "200"
              )
            end
          end 
      
      alloc = creditNote.add_allocation(:invoice => invoice)
      alloc.applied_amount = note[:amount]
      if !creditNote.save
        return createResponse(0,creditNote.errors)
      end
    rescue Xeroizer::ApiException => e
       return createResponse(0,Errors.xero_error(e.message))
      end
    return createResponse(1,creditNote)
  end
  
  def self.createResponse(status,data)
    reply =  OpenStruct.new 
    reply.status = status
    reply.data = data
    return reply
  end 
end