from modules import secret      as sc 

# test get_secret
s = sc.get_secret("Yahoo-Blob-SAS-Token", "1")
print("none" if s == None else s) # none

