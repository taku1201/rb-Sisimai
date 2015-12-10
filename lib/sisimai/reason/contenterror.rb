module Sisimai
  module Reason
    # Sisimai::Reason::ContentError checks the bounce reason is "contenterror" 
    # or not This class is called only Sisimai::Reason class.
    #
    # This is the error that a destination mail server has rejected email due to 
    # header format of the email like the following. Sisimai will set "contenterror"
    # to the reason of email bounce if the value of Status: field in a bounce email 
    # is "5.6.*".
    module ContentError
      # Imported from p5-Sisimail/lib/Sisimai/Reason/ContentError.pm
      class << self
        def text; return 'contenterror'; end

        # Try to match that the given text and regular expressions
        # @param    [String] argv1  String to be matched with regular expressions
        # @return   [True,False]    false: Did not match
        #                           true: Matched
        def match(argv1)
          return nil unless argv1
          regex = %r{(?>
             improper[ ]use[ ]of[ ]8-bit[ ]data[ ]in[ ]message[ ]header
            |message[ ](?:
               header[ ]size,[ ]or[ ]recipient[ ]list,[ ]exceeds[ ]policy[ ]limit
              |mime[ ]complexity[ ]exceeds[ ]the[ ]policy[ ]maximum
              )
            |routing[ ]loop[ ]detected[ ][-][-][ ]too[ ]many[ ]received:[ ]headers
            |this[ ]message[ ]contains?[ ](?:
               invalid[ ]MIME[ ]headers
              |improperly[-]formatted[ ]binary[ ]content
              |text[ ]that[ ]uses[ ]unnecessary[ ]base64[ ]encoding
              )
            )
          }xi

          return true if argv1 =~ regex
          return false
        end

        def true; return nil; end

      end
    end
  end
end
