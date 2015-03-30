class Errors
  
  def self.xero_error(error_msg)
    input_string = error_msg
    str1_markerstring = "<Message>"
    str2_markerstring = "</Message>"
    tokens = error_msg.split("</Message>")
    error_msg = tokens[1].split("<Message>")[1]#[/#{str1_markerstring}(.*?)#{str2_markerstring}/m]
        # error_msg = error_msg.gsub! '=>[' , ' '
    # error_msg2 = error_msg.gsub! ']' , ''
    # if !error_msg2.nil?
      # error_msg2 = error_msg2.gsub! ':' , ''
      # error_msg2 = error_msg2.gsub! '"', ''
      # return error_msg2
    # end
    #return error_msg.gsub! '"', ''
    return error_msg
  end
  
  
  
end