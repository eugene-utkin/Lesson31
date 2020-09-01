#encoding: utf-8

require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
#require 'pony'

set :database, {adapter: "sqlite3", database: "barbershop.db"}

class Client < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 3 }
  validates :phone, presence: true
  validates :datestamp, presence: true
  validates :color, presence: true
end

class Barber < ActiveRecord::Base
end

class Message < ActiveRecord::Base
end

before do
	@barbers = Barber.all
  
end

get '/' do
	erb :index			
end

get '/visit' do
  @c = Client.new
        erb :visit
end

post '/visit' do
        
        @c = Client.new params[:client]
        if @c.save
          erb "<h2>Спасибо, вы записались!</h2>"
        else
          @error = @c.errors.full_messages.first
          erb :visit
        end

end

get '/contacts' do
        erb :contacts
end

post '/contacts' do
        @mail = params[:mail]
        @letter = params[:letter]
        Message.create :from => @mail, :message => @letter



        hh = {  :mail => 'Пустая почта!',
                        :letter => 'Вы не ввели сообщение!'}

        @error = hh.select {|key,_| params[key] == ""}.values.join("<br />")


        if @error != ''
                return erb :contacts
        end

        #Pony.mail(:to => 'mistergrib@mail.ru',
  #:via => :smtp,
  #:via_options => {
   # :address              => 'smtp.mail.ru',
   # :port                 => '587',
   # :enable_starttls_auto => true,
   # :user_name            => 'mistergrib',
   # :password             => 'mnog',
   # :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
   # :domain               => "localhost.localdomain" # the HELO domain provided by the client to the server
 # }, :from => "#{@mail}", :subject => "New client!", :body => "#{@letter}")

        @title = "Спасибо за обратную связь!"
        @message = "Мы внимательно изучим ваше послание и дадим ответ на почту #{@mail}."

        erb :message
end

get '/barber/:id' do
  @barber = Barber.find(params[:id])
  erb :barber
end

get '/showusers' do
  @client = Client.order('created_at DESC')
  erb :showusers
end

get '/client/:id' do
  @client = Client.find(params[:id])
  erb :client
end