require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByCookieToken

  has_and_belongs_to_many :roles
  has_one :profile
  belongs_to :preference

  has_many :user_messages, :foreign_key => 'receiver_id'
  has_many :messages_received, :class_name => 'Message', :order => 'created_at desc', 
    :source => :message, :through => :user_messages
  has_many :messages_sent, :class_name => 'Message', :foreign_key => 'sender_id', 
    :order => 'created_at desc'

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_presence_of     :password
  validates_length_of       :password, :within => 6..40

  validates_presence_of     :email, :if => Proc.new{|u| u.is_admin_or_extenda?}
  validates_length_of       :email,    :within => 6..100, :if => Proc.new{|u| u.is_admin_or_extenda?} #r@a.wk
  validates_uniqueness_of   :email, :if => Proc.new{|u| u.is_admin_or_extenda?}
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message, :if => Proc.new{|u| u.is_admin_or_extenda?}
  
  validates_presence_of     :role_id

  named_scope :buyers, lambda { {:joins => :roles, :include => :profile, 
    :conditions => ["roles.title = 'national_buyer' OR roles.title = 'international_buyer'"] } }
  named_scope :exhibitors, lambda { {:joins => :roles, :include => :profile, 
    :conditions => ["roles.title = 'exhibitor'"] } }
  named_scope :extendas, lambda { {:joins => :roles, :include => :profile, 
    :conditions => ["roles.title = 'extenda'"] } }
  named_scope :no_admins, lambda { {:include => [:profile, :roles], 
    :conditions => ["roles.title != 'admin' AND roles.title != 'extenda'"], :order => 'profiles.company_name' } }
  named_scope :type, lambda {|type| {:joins => :roles, :include => :profile, 
    :conditions => ["roles.title = ?", type] , :order => "profiles.company_name" }}

  attr_accessible :login, :email, :name, :password, :password_confirmation, :role_id, :profile_attributes, :preference_attributes, :preference_id
  accepts_nested_attributes_for :profile, :preference

  # TimeLine Event #FIXME temporalmente desactivado
  # fires :new_user_created, :on => :create, :secondary_subject => :role,
  #   :if => lambda { |user| !user.is_admin? && !user.is_extenda? }

  def to_param
    "#{login}"
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
      self.roles = [] unless self.roles.empty? # Only one role rules
      self.roles << Role.find(value)
    end
  end


  # Get role id for user
  def role_id
    self.roles.first.id unless self.roles.empty?
  end

  # Simple accessor for role
  def role=(value)
    self.role_id = value.id 
  end

  def role
    self.roles.first
  end

  #Usuarios con los que nos vamos a reunir, se supone que nosotros somos un expositor por lo que somos los hosts
  #Método no usado todavía
  # def meetings_with
  #   User.find_by_sql("select u.id, u.login from users u where id IN (select m.guest_id from meetings m where m.host_id = #{self.id} 
  #                    AND m.state != 'canceled')")
  # end

  # /Simple
  def meetings(date, days = 1)
    start_date = Date.new(date.year, date.month, date.day) 
    Meeting.find(:all, 
      :conditions => ['(host_id = ? or guest_id = ?) and starts_at between ? and ? and state != "canceled"', 
        self.id, self.id, start_date, start_date + days], :order => 'starts_at')
  end

  def meetings_remaining(date)
    self.preference.meetings_number - self.meetings(date).length
  end

  # Devuelve los eventos comunes, es decir no tienen actor a quien se dirige y los eventos concretos hacia él
  def timeline_events
    TimelineEvent.find(:all, :conditions => ["(actor_type = 'User' AND actor_id = ?) OR actor_type IS NULL", 
      self.id], :limit => 3, :order => 'created_at desc', :include => [:subject, :secondary_subject])
  end
  
  def unread_messages_count
    self.user_messages.count(:all, :conditions => {:state => 'unread'})
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def authenticated?(password)
    self.password == password
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

  # No se usa ya, antes cuando se creaba el timeline si
  # def after_destroy
  #   TimelineEvent.find(:first, :conditions => {:subject_type => 'User', :subject_id => self.id}).destroy
  # end

  #Enviamos al email del usuario un resumen con sus citas para un día concreto
  def send_summary(date = Time.now.to_date)
    MeetingMailer.deliver_summary(self, date)
  end
end
