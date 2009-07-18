require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  attr_accessor :role_id

  has_and_belongs_to_many :roles
  has_one :profile
  has_many :messages_received, :class_name => 'Message', :foreign_key => 'receiver_id'
  has_many :messages_sent, :class_name => 'Message', :foreign_key => 'sender_id'

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  attr_accessible :login, :email, :name, :password, :password_confirmation, :location_id, :role_id

  def self.question_methods_for(*args, &block)
    attr_accessor *args

    args.each do |arg|
      define_method "is_#{arg}?" do
        eval yield
      end
    end
  end

  question_methods_for :admin, :exhibitor, :buyer do
    "self.roles.map(&:title).include?(arg.to_s)"
  end

  question_methods_for :national, :international do
    "self.location == arg.to_s"
  end

  # Generate a list of locations from CONFIG for select
  def self.locations
    CONFIG[:location].map{|l| [l[1], l[0]]}
  end

  # Get location of user
  def location
    CONFIG[:location][self.location_id] if self.location_id
  end

  def role_id=(id)
    self.roles.destroy_all if self.roles.length > 0 # Only one role rules
    self.roles << Role.find(id)
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  protected
    


end
