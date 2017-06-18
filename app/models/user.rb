class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
	
	validates :username, uniqueness: true
	validate :username_in_one_word
	validates :username, :format => { with: /\A[a-zA-Z0-9]*\z/ , :message => 'no special characters, only letters and numbers' }
	has_many :posts
	before_create do |doc|
	  doc.api_key = doc.generate_api_key
	end

  attr_accessor :login
  def self.find_for_database_authentication warden_conditions
	  conditions = warden_conditions.dup
	  login = conditions.delete(:login)
	  where(conditions).where(["lower(username) = :value OR lower(email) = :value", {value: login.strip.downcase}]).first
	end

	protected

	# Attempt to find a user by it's email. If a record is found, send new
	# password instructions to it. If not user is found, returns a new user
	# with an email not found error.
	def self.send_reset_password_instructions attributes = {}
	  recoverable = find_recoverable_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
	  recoverable.send_reset_password_instructions if recoverable.persisted?
	  recoverable
	end

	def self.find_recoverable_or_initialize_with_errors required_attributes, attributes, error = :invalid
	  (case_insensitive_keys || []).each {|k| attributes[k].try(:downcase!)}

	  attributes = attributes.slice(*required_attributes)
	  attributes.delete_if {|_key, value| value.blank?}

	  if attributes.size == required_attributes.size
	    if attributes.key?(:login)
	      login = attributes.delete(:login)
	      record = find_record(login)
	    else
	      record = where(attributes).first
	    end
	  end

	  unless record
	    record = new

	    required_attributes.each do |key|
	      value = attributes[key]
	      record.send("#{key}=", value)
	      record.errors.add(key, value.present? ? error : :blank)
	    end
	  end
	  record
	end

	def self.find_record login
	  where(["username = :value OR email = :value", {value: login}]).first
	end

	def generate_api_key
	  loop do
	    token = SecureRandom.base64.tr('+/=', 'Qrt')
	    break token unless User.exists?(api_key: token)
	  end
	end

	private

	def username_in_one_word
	  if username.to_s.squish.split.size != 1
	    errors.add(:username, 'must be one word')
	  end
	end

	
end
