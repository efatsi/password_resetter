require 'spec_helper'

describe PasswordReset do

  it { should validate_presence_of(:identifier) }


  describe "attributes" do
    it "allows mass assignment" do
      subject = described_class.new(:identifier => 'foo')
      subject.identifier.should == 'foo'
    end
  end


  describe "#match_identifier?" do
    it "is nil by default" do
      subject.user.should be_nil
    end

    it "returns the user with a matching username" do
      user = FactoryGirl.create(:user, :username => 'eli')
      subject = described_class.new(:identifier => 'eli')
      subject.match_identifier?
      subject.user.should == user
    end

    it "returns the user with a matching email address" do
      user = FactoryGirl.create(:user, :email => 'eli@viget.com')
      subject = described_class.new(:identifier => 'eli@viget.com')
      subject.match_identifier?
      subject.user.should == user
    end

    it "returns false without a user match" do
      subject = described_class.new(:identifier => 'totally_fake')
      subject.match_identifier?.should be(false)
    end
  end

  describe "#send_password_reset" do

    context "when the request is valid" do
      # * generates token
      # * saves present time
      # * sends an email to the user with instructions
      
      let(:user)  { FactoryGirl.create(:user, :username => 'eli', :email => 'eli@viget.com') }
      let(:mailer) { double('password reset mailer') }
      subject      { described_class.create(:user => user) }
      
      before do
        PasswordResetMailer.stub(:password_reset).with(user).and_return(mailer)
        mailer.stub(:deliver).and_return(true) # so the email doesn't actually get called
      end
      
      it "generates a reset_token" do
        expect{ subject.send_password_reset }.to change{ subject.reset_token }.from(nil)
      end
          
      it "saves the present time" do
        expect{ subject.send_password_reset }.to change{ subject.reset_sent_at }.from(nil)
      end
      
      it "sends an email" do
        mailer.should_receive(:deliver)
        subject.send_password_reset
      end      
    end
  end
  
  describe "#update_user_password" do
    let(:user)  { FactoryGirl.create(:user, :username => 'eli', :email => 'eli@viget.com') }
    subject     { described_class.create(:user => user) }
    
    context "when passwords are blank" do

      it "should return false for blank password" do
        subject.update_user_password("", "secret").should be(false)
      end        
                 
      it "should return false for blank password_confirmation" do
        subject.update_user_password("secret", "").should be(false)
      end        

      it "should return false for blank both" do
        subject.update_user_password("", "").should be(false)
      end      
    end
    
    context "when passwords don't match" do
      
      it "should return false" do
        subject.update_user_password("does_not", "match").should be(false)
      end
    end
    
    context "when passwords are valid" do
      
      it "should return true" do
        subject.update_user_password("new_secret", "new_secret").should be(true)
      end
      
      it "should change the password of the user" do
        expect{ subject.update_user_password("asdf", "asdf") }.to change{ User.authenticate("eli", "asdf") }.from(false).to(user)
      end
    end
  end
  
  describe "#expired?" do
    
    it "should return true if > 2 hours have passed" do
      subject.update_attributes(:reset_sent_at => 3.hours.ago)
      subject.expired?.should be(true)
    end
    
    it "should return false if < 2 hours have passed" do
      subject.update_attributes(:reset_sent_at => 2.hours.ago + 1.minute)
      subject.expired?.should be(false)      
    end
  end
  
  describe "#delete_existing" do
    let(:user)  { FactoryGirl.create(:user, :username => 'eli', :email => 'eli@viget.com') }
    before do
      @pr1 = PasswordReset.create(:user => user, :identifier => 'filler')
    end
    
    it "should do nothing if another PasswordReset does not exist" do
      expect{ @pr1.delete_existing }.to_not change{ PasswordReset.count }
    end
    
    it "should delete an existing PasswordReset if one exists" do
      @pr2 = PasswordReset.create(:user => user, :identifier => 'filler')
      expect{ @pr2.delete_existing }.to change{ PasswordReset.count }.by(-1)
    end
    
  end

end
