require 'spec_helper'

describe PasswordReset do
  
  it { should validate_presence_of(:identifier) }
  
  describe "validations" do
    it "requires the presence of a user" do
      subject = described_class.new(:identifier => 'eli')
      subject.errors_on(:user).should == ['was not found']
    end
    
    it "requires that the matching user have an email address" do
      user    = FactoryGirl.create(:user, :username => 'eli', :email => nil)
      subject = described_class.new(:identifier => 'eli')
      
      subject.errors_on(:user).should == ['must have an email address']
    end
  end
  
  describe "attributes" do
    it "allows mass assignment" do
      subject = described_class.new(:identifier => 'foo')
      subject.identifier.should == 'foo'
    end
  end
  
  describe "#user" do
    it "is nil by default" do
      subject.user.should be_nil
    end
    
    it "returns the user with a matching username" do
      user = FactoryGirl.create(:user, :username => 'eli')
      subject = described_class.new(:identifier => 'eli')
      
      subject.user.should == user
    end
    
    it "returns the user with a matching email address" do
      user = FactoryGirl.create(:user, :email => 'eli@viget.com')
      subject = described_class.new(:identifier => 'eli@viget.com')
      
      subject.user.should == user
    end
  end
  
  describe "#save" do
    # * does nothing if the request is invalid
    # * generate the token for the user?
    # * sends an email to the user with instructions
    it "does not send an email if the request is invalid" do
      PasswordResetMailer.should_receive(:password_reset).never
      subject.save
    end
    
    it "returns false when the request is invalid" do
      subject.save.should be(false)
    end

    context "when the request is valid" do
      let!(:user)  { FactoryGirl.create(:user, :username => 'eli', :email => 'eli@viget.com', :password_reset_token => nil) }
      let(:mailer) { double('password reset mailer') }
      
      subject      { described_class.new(:identifier => 'eli') }

      it "generates a token for the user" do
        expect { subject.save }.to change { user.reload.password_reset_token }.from(nil)
      end

      it "sends an email" do
        mailer.should_receive(:deliver)
        PasswordResetMailer.stub(:password_reset).with(user).and_return(mailer)

        subject.save
      end

      it "returns true when successful" do
        mailer.stub(:deliver)
        PasswordResetMailer.stub(:password_reset).with(user).and_return(mailer)

        subject.save.should be(true)
      end
      
      it "saves the password_reset_sent_at time" do
        subject.save
        user.reload.password_reset_sent_at.should_not be_nil
      end
    end
    
  end
  
  describe "#edit" do
    
    context "when there is a valid user" do
      let!(:user) { FactoryGirl.create(:user, :username => 'eli', :email => 'eli@viget.com', :password_reset_token => "fake_reset_token") }
      subject     { described_class.new(:user => user) }
      
      it "should know who the user is" do
        subject.user.should == user
      end
    end
        
  end
  
  describe "#update" do
    let!(:user)  { FactoryGirl.create(:user, :username => 'eli', :email => 'eli@viget.com', :password_reset_token => "fake_reset_token") }
    subject      { described_class.new(:existing_user => user) }
    let(:params) { {:password => "new_password", :password_confirmation => "new_password"} }
    
    context "expired?" do

      it "should return true for expired password_resets" do
        user.update_attributes(:password_reset_sent_at => 3.hours.ago)
        subject.expired?.should == true
      end

      it "should return false for a 'fresh' password_reset" do
        user.update_attributes(:password_reset_sent_at => 1.hour.ago)
        subject.expired?.should == false
      end
    end
    
    context "update_attributes" do
      it "returns false if request is blank" do
        subject.update_attributes.should == false
      end

      it "returns true if request is valid" do
        subject.update_attributes(params).should == true
      end

      it "returns false if confirmation does not match" do
        params[:password_confirmation] = "not_a_match"
        subject.update_attributes(params).should == false
      end

      it "actually updates the user" do
        subject.update_attributes(params)
        user.reload.authenticate("new_password").should == user
      end

      it "should reset the password_reset_token to nil if success" do
        subject.update_attributes(params)
        user.password_reset_token.should == nil
      end
    end
  end
  
end