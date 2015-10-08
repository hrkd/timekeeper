json.array!(@works) do |work|
  json.extract! work, :id
  json.url work_url(work, format: :json)
end
