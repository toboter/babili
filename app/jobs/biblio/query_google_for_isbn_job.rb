# https://www.googleapis.com/books/v1/volumes?q=isbn:9783447055475
# 
# def find_gvolume # auslagern in job
#   if ident_name == 'ISBN'
#     source = "https://www.googleapis.com/books/v1/volumes?q=isbn:"+ident_value.gsub(/[^0-9a-z ]/i, '')
#     resp = Net::HTTP.get_response(URI.parse(source))
#      data = JSON.parse(resp.body)
# 
#     if data && data["items"]
#       id = data["items"][0]["id"]
#       link = data["items"][0]["volumeInfo"]["canonicalVolumeLink"]
#       image = data["items"][0]["volumeInfo"].try(:[],'imageLinks').try(:[],'thumbnail')
#       description = data["items"][0]["volumeInfo"].try(:[],'description')
#       subject.update(g_volume_id: id, g_canonical_link: link, g_image_thumbnail: image, g_description: description )
#     end
#   end
# end