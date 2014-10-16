namespace :import do
  desc "imports user data from a csv file"
  task :users => :environment do
    require 'csv'
    CSV.foreach('importData/users.csv') do |row|
      provider = row[0]
      uid = row[1]
      name = row[2]
      email = uid
      password = "password"
      puts row.inspect
      puts "Provider: ", provider,"uid: ",uid,"Name: ",name, "email", email
      @user = User.create(provider: provider, uid: uid, name: name, encrypted_password: password, email: email)
      @user.save!(options={validate: false})
      puts "user.provider = ", @user.provider
    end
  end
  desc "imports tags from a csv file"
  task :loadTags => :environment do
    require 'csv'
    lastTag = ''
    CSV.foreach('importData/DesmmHashTags2014_10_16.csv') do |row|

      tag = row[0]

      label = row[1]

      solrfield = row[2]
      solrfield = "Unclassified" if solrfield.nil?

      index_value = row[3]

      print "Category: ", solrfield,"  tag: ",tag, "  label: ", label, "  value: ", index_value
      puts ""
      if tag != lastTag
        @tag = Tag.create(category: solrfield, tag: tag, label: label)
        @tag.save!(options={validate: false})
      end
      #@tag does this have theid in the @tag object ?
      print "tag_id = ", @tag.id
      puts
      @solr = SolrMapping.create(solrfield: solrfield, solrvalue: index_value, tag_id: @tag.id)
      @solr.save!(options={validate: false})
      print "solr.id = ", @solr.id
      puts
      lastTag = tag
    end
  end

end