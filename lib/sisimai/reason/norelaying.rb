module Sisimai
  module Reason
    # Sisimai::Reason::NoRelaying checks the bounce reason is "norelaying" or not.
    # This class is called only Sisimai::Reason class.
    #
    # This is the error that SMTP connection rejected with error message "Relaying
    # Denied". This reason does not exist in any version of bounceHammer.
    #
    #    ... while talking to mailin-01.mx.example.com.:
    #    >>> RCPT To:<kijitora@example.org>
    #    <<< 554 5.7.1 <kijitora@example.org>: Relay access denied
    #    554 5.0.0 Service unavailable
    module NoRelaying
      # Imported from p5-Sisimail/lib/Sisimai/Reason/NoRelaying.pm
      class << self
        def text; return 'norelaying'; end
        def description
          return 'Email rejected with error message "Relaying Denied"'
        end

        # Try to match that the given text and regular expressions
        # @param    [String] argv1  String to be matched with regular expressions
        # @return   [True,False]    false: Did not match
        #                           true: Matched
        def match(argv1)
          return nil unless argv1
          regex = %r{(?>
             Insecure[ ]Mail[ ]Relay
            |mail[ ]server[ ]requires[ ]authentication[ ]when[ ]attempting[ ]to[ ]
              send[ ]to[ ]a[ ]non-local[ ]e-mail[ ]address    # MailEnable
            |not[ ]allowed[ ]to[ ]relay[ ]through[ ]this[ ]machine
            |relay[ ](?:
               access[ ]denied
              |denied
              |not[ ]permitted
              )
            |relaying[ ]denied  # Sendmail
            |that[ ]domain[ ]isn[']t[ ]in[ ]my[ ]list[ ]of[ ]allowed[ ]rcpthost
            |Unable[ ]to[ ]relay[ ]for
            )
          }ix

          return true if argv1 =~ regex
          return false
        end

        # Whether the message is rejected by 'Relaying denied'
        # @param    [Sisimai::Data] argvs   Object to be detected the reason
        # @return   [True,False]            true: Rejected for "relaying denied"
        #                                   false: is not
        # @see http://www.ietf.org/rfc/rfc2822.txt
        def true(argvs)
          return nil unless argvs
          return nil unless argvs.is_a? Sisimai::Data

          currreason = argvs.reason || ''
          reexcludes = %r/\A(?:securityerror|systemerror|undefined)\z/

          if currreason.size > 0
            # Do not overwrite the reason
            return false if currreason =~ reexcludes
          else
            # Check the value of Diagnosic-Code: header with patterns
            return true if Sisimai::Reason::NoRelaying.match(argvs.diagnosticcode)
          end
        end

      end
    end
  end
end



