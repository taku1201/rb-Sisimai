require 'spec_helper'
require 'sisimai/message'

describe Sisimai::Message do
  cn = Sisimai::Message
  sf = './set-of-emails/mailbox/mbox-0'

  mailastext = File.open(sf).read
  messageobj = cn.new(data: mailastext)

  describe 'class method' do
    describe '.new' do
      it('returns Sisimai::Message object') { expect(messageobj).to be_a cn }
      example('#header returns Hash') { expect(messageobj.header).to be_a Hash }
      example('#ds returns Array') { expect(messageobj.ds).to be_a Array }
      example('#rfc822 returns Hash') { expect(messageobj.rfc822).to be_a Hash }
      example('#from returns String') { expect(messageobj.from).to be_a String }
    end
  end

  describe 'instance method' do
    describe '#ds' do
      it('returns Array') { expect(messageobj.ds).to be_a Array }
      messageobj.ds.each do |e|
        example('spec is String') { expect(e['spec']).to be_a String }
        example('spec is "SMTP"') { expect(e['spec']).to be == 'SMTP' }
        example('recipient is String') { expect(e['recipient']).to be_a String }
        example('recipient includes "@"') { expect(e['recipient']).to match(/\A.+[@].+[.].+\z/) }
        example('status is String') { expect(e['status']).to match(/\A\d[.]\d[.]\d+\z/) }
        example('command is String') { expect(e['command']).to be_a String }
        example('date is String') { expect(e['date']).to be_a String }
        example('date size > 0') { expect(e['date'].size).to be > 0 }
        example('diagnosis is String') { expect(e['diagnosis']).to be_a String }
        example('diagnosis size > 0') { expect(e['diagnosis'].size).to be > 0 }
        example('action is String') { expect(e['action']).to be_a String }
        example('action size > 0') { expect(e['action'].size).to be > 0 }
        example('rhost is String') { expect(e['rhost']).to be_a String }
        example('rhost is a hostname') { expect(e['rhost']).to match(/\A.+[.].+\z/) }
        example('lhost is String') { expect(e['lhost']).to be_a String }
        example('lhost is a hostname') { expect(e['lhost']).to match(/\A.+[.].+\z/) }

        example('agent is String') { expect(e['agent']).to be_a String }
        example('agent is Sendmail') { expect(e['agent']).to be == 'Sendmail' }
      end
    end

    describe '#header' do
      ['content-type', 'to', 'subject', 'date', 'from', 'message-id'].each do |e|
        example(e + 'header is String') { expect(messageobj.header[e]).to be_a String }
        example(e + 'header has a size') { expect(messageobj.header[e].size).to be > 0 }
      end
      example('received header is Array') { expect(messageobj.header['received']).to be_a Array }
    end

    describe '#rfc822' do
      %w|return-path to subject date from message-id|.each do |e|
        example(e + 'header is String') { expect(messageobj.rfc822[e]).to be_a String }
        example(e + 'header has a size') { expect(messageobj.rfc822[e].size).to be > 0 }
      end
    end
  end

end
