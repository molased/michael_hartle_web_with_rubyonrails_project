require 'spec_helper'

describe User do
  before {@user = User.new(name: "Example user", email: "user@example.com", password: "2312321")}
  subject {@user}
  it {should respond_to(:name)}
  it {should respond_to(:email)}
  it {should be_valid}
  
  describe "when name is not present" do
    before { @user.name = " "}
    it {should_not be_valid}
  end
  describe "when email is not present" do
    before {@user.email = " "}
    it {should_not be_valid}
  end
  
  describe "when name is too long" do
    before {@user.name = "a" * 51}
    it {should_not be_valid}
  end
  
  describe "when email address is not valid" do
    it "should be invalid" do
       addressess = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
       addressess.each do |invalid_address|
          @user.email = invalid_address
          expect(@user).not_to be_valid
       end  
    end
  end
  
  describe "whem emails addresses is valid" do
    it "should be valid" do
      addressess = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addressess.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end
  
  describe "when email should be unique" do
    before {
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    }
    it {should_not be_valid}
    
  end 
  
  describe "password encryption" do
    it {should_not be_blank}
  end
  
  describe "haspassword? method" do
    before {@user = User.create(name: "Example user", email: "user@example.com", password: "2312321")}
    it "should be true if the password match" do
      @user.has_password?(@user.password).should be_true
    end
    
  end
  describe "authenticate method" do
    before {@user = User.create(name: "Example user", email: "user@example.com", password: "2312321")}
    it "should return nil on email/password mismatch" do
      wrong_password_user = User.authenticate(@user.email,"wrong_password")
      wrong_password_user.should be_nil
    end
    it "should return nil on email with no user" do
      wrong_password_user = User.authenticate("no user",@user.password)
      wrong_password_user.should be_nil
    end
    it "should return user on email/password match" do
      wrong_password_user = User.authenticate(@user.email, @user.password)
      wrong_password_user.should == @user
    end
  end
  
end
