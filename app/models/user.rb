require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  has_and_belongs_to_many :roles
  has_one :profile
  belongs_to :preference

  has_many :user_messages, :foreign_key => 'receiver_id', :conditions => ["state != 'deleted'"]
  has_many :messages_received, :class_name => 'Message', :order => 'created_at desc', :source => :message,
    :through => :user_messages
  has_many :messages_sent, :class_name => 'Message', :foreign_key => 'sender_id', :order => 'created_at desc'

  accepts_nested_attributes_for :profile, :preference

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_presence_of     :email, :if => Proc.new{|u| u.is_admin_or_extenda?}
  validates_length_of       :email,    :within => 6..100, :if => Proc.new{|u| u.is_admin_or_extenda?} #r@a.wk
  validates_uniqueness_of   :email, :if => Proc.new{|u| u.is_admin_or_extenda?}
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message, :if => Proc.new{|u| u.is_admin_or_extenda?}
  

  validates_presence_of     :role_id

  named_scope :buyers, lambda { {:joins => :roles, :include => :profile, 
    :conditions => ["roles.title = 'national_buyer' OR roles.title = 'international_buyer'"] } }
  named_scope :exhibitors, lambda { {:joins => :roles, :include => :profile, 
    :conditions => ["roles.title = 'exhibitor'"] } }
  named_scope :no_admins, lambda { {:joins => :roles, :include => :profile, 
    :conditions => ["roles.title != 'admin' && roles.title != 'extenda'"], :order => 'profiles.company_name' } }

  attr_accessible :login, :email, :name, :password, :password_confirmation, :role_id, :profile_attributes, :preference_attributes, :preference_id

  # TimeLine Event
  fires :new_user_created, :on => :create, :secondary_subject => :main_role,
    :if => lambda { |user| !user.is_admin? && !user.is_extenda? }

  # Devuelve los eventos comunes, es decir no tienen actor a quien se dirige y los eventos concretos hacia él
  def timeline_events
    TimelineEvent.find(:all, :conditions => ["(actor_type = 'User' AND actor_id = ?) OR actor_type IS NULL", self.id],
      :limit => 10, :order => 'created_at desc')
  end
  
  def main_role
    self.roles.first
  end

  def unread_messages_count
    self.user_messages.count(:all, :conditions => {:state => 'unread'})
  end

  def set_master_preferences
    self.preference = Preference.first
  end

  def self.question_methods_for(*args, &block)
    attr_accessor *args

    args.each do |arg|
      define_method "is_#{arg}?" do
        eval yield
      end
    end
  end

  question_methods_for :admin, :exhibitor, :national_buyer, :international_buyer, :extenda do
    "self.roles.map(&:title).include?(arg.to_s)"
  end

  def is_buyer?
    self.is_national_buyer? or self.is_international_buyer?
  end

  def is_admin_or_extenda?
    self.is_admin? or self.is_extenda?
  end

  # Set role for user
  attr_accessor :role_id
  def role_id=(value)
    unless value.blank?
      self.roles.destroy_all unless self.roles.empty? # Only one role rules
      self.roles << Role.find(value)
    end
  end

  # Get role id for user
  def role_id
    self.roles.first.id unless self.roles.empty?
  end

  def role=(value)
    self.role_id = value.id 
  end

  def role
    self.roles.first
  end

  def meetings(date, days = 1)
    start_date = Date.new(date.year, date.month, date.day) 
    Meeting.find(:all, 
      :conditions => ['(host_id = ? or guest_id = ?) and starts_at between ? and ? and state = "accepted"', self.id, self.id, start_date, start_date + days])
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

  def password=(value)
    write_attribute :password, (value ? value.downcase : nil)
  end

end
