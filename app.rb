require 'sinatra'
require 'sinatra/contrib/all'

require_relative 'models/transaction'
require_relative 'models/budget'



get '/' do
  @overbudget = Budget.find_all.first.overbudget?
  @budget_stats = Budget.find_all.first.spend_stats
  @transactions = Transaction.find_all
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
  @transactions = Category.find(params[:id]).list_all
  erb :category
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
