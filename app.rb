require 'sinatra'
require 'sinatra/contrib/all'
require 'date'

require_relative 'models/transaction'
require_relative 'models/budget'



get '/' do
  @overbudget = Budget.find_all.first.overbudget?
  @budget_stats = Budget.find_all.first.spend_stats
  @transactions = Transaction.group_by_day(Transaction.find_all)
  erb :index
end

get '/add' do
  @overbudget = Budget.find_all.first.overbudget?
  @budget_stats = Budget.find_all.first.spend_stats
  erb :add
end

post '/add' do
  Transaction.new(Transaction.options_from_form(params)).save
  redirect '/'
end

get '/category/:id' do
  @overbudget = Budget.find_all.first.overbudget?
  @budget_stats = Budget.find_all.first.spend_stats
  @category = Category.find(params[:id]).name
  @transactions = Transaction.group_by_day(Category.find(params[:id]).list_all)
  erb :category, :layout => :layout do
    erb :index
  end
end

get '/merchant/:id' do
  @overbudget = Budget.find_all.first.overbudget?
  @budget_stats = Budget.find_all.first.spend_stats
  @merchant = Merchant.find(params[:id]).name
  @transactions = Transaction.group_by_day(Merchant.find(params[:id]).list_all)
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
  @overbudget = Budget.find_all.first.overbudget?
  @budget_stats = Budget.find_all.first.spend_stats
  @transaction = Transaction.find(params[:id])
  erb :update
end

post '/update/:id' do
  transaction = Transaction.new(Transaction.options_from_form(params))
  transaction.update
  redirect '/'
end

get '/month/:month' do
  @overbudget = Budget.find_all.first.overbudget?
  @budget_stats = Budget.find_all.first.spend_stats
  @month = params[:month]
  @transactions = Transaction.group_by_month(Transaction.find_all)[@month]
  @transactions = Transaction.group_by_day(@transactions)
  erb :month, :layout => :layout do
    erb :index
  end
end
