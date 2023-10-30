
# Fix typos or ID NAs
ned$partyfacts_id[ned$party_abbreviation == "SLP-UP"] <- 6183
ned$partyfacts_id[ned$party_abbreviation == "PATRIOTIC"] <- 3918 # https://partyfacts.herokuapp.com/data/partycodes/3918/
ned$partyfacts_id[ned$party_abbreviation == "FOR PRIME MINISTER"] <- 3918 # eu_ned_joint_codebook.pdf
ned$partyfacts_id[ned$party_abbreviation == "THE ONLY OPTION"] <- 3918 # eu_ned_joint_codebook.pdf
ned$partyfacts_id[ned$party_abbreviation == "EVEN STRONGER ISTRIA"] <- 3918 # eu_ned_joint_codebook.pdf
ned$partyfacts_id[ned$party_abbreviation == "MSZP-PARBESZED"] <- 1408 # https://en.wikipedia.org/wiki/Hungarian_Socialist_Party https://en.wikipedia.org/wiki/Dialogue_%E2%80%93_The_Greens%27_Party 
ned$partyfacts_id[ned$party_abbreviation == "AP!"] <- 8393 
ned$partyfacts_id[ned$party_abbreviation == "NATIONAL ASSOCIATION 'FOR LITHUANIA IN LITHUANIA' (LITHUANIAN CENTRE PARTY, LITHUANIAN SOCIAL DEMOCRATIC UNION, COALITION OF NATIONAL UNION AND THE NATIONAL UNITY UNION)"] <- 8257 
ned$partyfacts_id[ned$party_abbreviation == "UNION OF LITHUANIAN PEASANTS AND PEOPLES"] <- 1490 # Disputable
ned$partyfacts_id[ned$party_abbreviation == "KUKURIKU"] <- 2522
ned$partyfacts_id[ned$party_abbreviation == "KO"] <- 9122 # https://partyfacts.herokuapp.com/data/partycodes/9122/
ned$partyfacts_id[ned$party_abbreviation == "PAMETNO-ZA GRAD"] <- 7336 # https://partyfacts.herokuapp.com/data/partycodes/7336/
ned$partyfacts_id[ned$party_abbreviation == "HDZ-HDS"] <- 1431 # eu_ned_joint_codebook.pdf
ned$partyfacts_id[ned$party_abbreviation == "HDSSB-HKS"] <- 2347 # eu_ned_joint_codebook.pdf
ned$partyfacts_id[ned$party_abbreviation == "ANTI-CORRUPTION COALITION OF KRISTUPAS KRIVICKAS AND NAGLIS PUTEIKIS"] <- 5455 # eu_ned_joint_codebook.pdf and https://en.wikipedia.org/wiki/2016_Lithuanian_parliamentary_election
ned$partyfacts_id[ned$party_abbreviation == "ZL"] <- 9091 # https://partyfacts.herokuapp.com/data/partycodes/9091/
ned$partyfacts_id[ned$party_abbreviation == "DSB-BDF"] <- 1195 # eu_ned_joint_codebook.pdf
ned$partyfacts_id[ned$party_abbreviation == "ZIVI ZID-PH-AM"] <- 4867 # eu_ned_joint_codebook.pdf
ned$partyfacts_id[ned$party_abbreviation == "HSP AS-HCSP"] <- 253 # eu_ned_joint_codebook.pdf
ned$partyfacts_id[ned$party_abbreviation == "ABC-MOVEMENT 21"] <- 3187 # eu_ned_joint_codebook.pdf
