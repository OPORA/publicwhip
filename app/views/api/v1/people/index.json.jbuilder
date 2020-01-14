if params[:api] == Settings.api_secret 
json.array! @people, partial: "show", as: :person
else
json.array! @people, partial: "person", as: :person
end


