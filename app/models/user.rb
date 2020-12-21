# frozen_string_literal: true

class User < ApplicationRecord
  has_many :sessions, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum kind: { normal: 0, manager: 1, admin: 2 }
end
