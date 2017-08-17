require 'json'

file = File.read("script/people_rummager/people.json")
rs = JSON.parse(file)

file = File.read("script/people_rummager/people2.json")
rs2 = JSON.parse(file)

file = File.read("script/people_rummager/people3.json")
rs3 = JSON.parse(file)

peoplefile = Array.new #File.open("allpeopleslugs.txt", "a+")

rs["results"].each do |result|
  peoplefile << result["slug"]
end

rs2["results"].each do |result|
  peoplefile << result["slug"]
end
rs3["results"].each do |result|
  peoplefile << result["slug"]
end


#jslugs = File.read("allpeopleslugs.txt")

#puts peoplefile

not_in_rummager = Person.where.not(slug: peoplefile)

puts not_in_rummager.map(&:slug)
