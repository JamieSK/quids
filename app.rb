require 'sinatra'
require 'sinatra/contrib/all'
require 'date'

require_relative 'models/transaction'
require_relative 'models/budget'

Transaction.delete_empties

get '/' do
  redirect '/index/0'
end

get '/index/:transaction' do
  @budget = Budget.find_all.first
  @transactions = Transaction.group_by_day(Transaction.find_all)
  @transaction = Transaction.find(params[:transaction]) unless params[:transaction].to_i == 0
  erb :index
end

get '/add' do
  @budget = Budget.find_all.first
  @transactions = Transaction.group_by_day(Transaction.find_all)
  erb :add, :layout => :layout do
    erb :index
  end
end

post '/add' do
  Transaction.new(Transaction.options_from_form(params)).save
  redirect '/'
end

get '/category/:id/:transaction' do
  @budget = Budget.find_all.first
  @category = Category.find(params[:id])
  @transactions = Transaction.group_by_day(Category.find(params[:id]).list_all)
  @transaction = Transaction.find(params[:transaction]) unless params[:transaction].to_i == 0
  erb :category, :layout => :layout do
    erb :index
  end
end

get '/merchant/:id/:transaction' do
  @budget = Budget.find_all.first
  @merchant = Merchant.find(params[:id]).name
  @transactions = Transaction.group_by_day(Merchant.find(params[:id]).list_all)
  @transaction = Transaction.find(params[:transaction]) unless params[:transaction].to_i == 0
  erb :merchant, :layout => :layout do
    erb :index
  end
end

get '/delete/:id' do
  transaction = Transaction.find(params[:id])
  transaction.delete
  redirect '/'
end

get '/update/:id' do
  @budget = Budget.find_all.first
  @transactions = Transaction.group_by_day(Transaction.find_all)
  @transaction = Transaction.find(params[:id])
  erb :update, :layout => :layout do
    erb :index
  end
end

post '/update/:id' do
  transaction = Transaction.new(Transaction.options_from_form(params))
  transaction.update
  redirect '/'
end

get '/month/:month/:transaction' do
  @budget = Budget.find_all.first
  @month = params[:month]
  @transactions = Transaction.group_by_month(Transaction.find_all)[@month]
  @transactions = Transaction.group_by_day(@transactions)
  @transaction = Transaction.find(params[:transaction]) unless params[:transaction].to_i == 0
  erb :month, :layout => :layout do
    erb :index
  end
end

post '/budget' do
  budget = Budget.find_all.first
  budget.cash_max = params[:budget]
  budget.update
  redirect '/'
end

get '/:id' do
  redirect "/index/#{params[:id]}"
end
