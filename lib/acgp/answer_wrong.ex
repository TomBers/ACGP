defmodule AnswerWrong do
  @moduledoc false

  def game_state(user \\ "") do
    aw = get_question()

    %{
      active_user: user,
      question: aw.question,
      answer: aw.answer,
      winner: nil
    }
  end

  def get_questions(n) do
    GameUtils.get_n_unique_cards(n, &get_question/0)
  end

  def get_question do
    questions()
    |> Enum.random
  end

  def questions do
    [
      %{question: "A ____ atom in an atomic clock beats 9,192,631,770 times a second", answer: "cesium"},
      %{
        question: "A ____ generates temperatures five times hotter than those found on the sun's surface",
        answer: "lightning bolt"
      },
      %{question: "A ____ is a pact between a secular authority & the church", answer: "concordat"},
      %{question: "A ____ is the blue field behind the stars", answer: "canton"},
      %{question: "A ____ occurs when all the planets of the our Solar System line up", answer: "sysygy"},
      %{question: "A ____ razor removed from King Tut's Tomb was still sharp enough to be used", answer: "golden"},
      %{question: "A ____ takes 33 hours to crawl one mile", answer: "snail"},
      %{question: "A ____ women can get a divorce if her husband does not give her coffee", answer: "saudi arabian"},
      %{question: "A ____ written to celebrate a wedding is called a epithalamium", answer: "poem"},
      %{question: "A 'dybbuk' is an evil spirit in which folklore", answer: "jewish"},
      %{question: "A 'pigskin' is another name for a(n) ____", answer: "football"},
      %{question: "A 'sirocco' refers to a type of ____", answer: "wind"},
      %{question: "A \"double sheet bend\"is a type of what", answer: "knot"},
      %{
        question: "A 300,000 pound wedding dress made of platinum was once exhibited, and in the instructions from the designer was a warning. What was it",
        answer: "do not iron"
      },
      %{
        question: "A 41-gun salute is the traditional salute to announce a royal birth in ____",
        answer: "great britain"
      },
      %{question: "A bird in the hand is worth ____", answer: "two in the bush"},
      %{question: "A block of compressed coal dust used as fuel", answer: "briquette"},
      %{question: "A blockage in a pipe caused by a trapped bubble of air", answer: "airlock"},
      %{question: "A blunt thick needle for sewing with thick thread or tape", answer: "bodkin"},
      %{question: "A salt enema used to be given to children to rid them of ____", answer: "threadworms"},
      %{question: "A Saudi Arabian woman can get a divorce if her husband doesnt give her what", answer: "coffee"},
      %{question: "A Saudi Arabian women can get a divorce if her ____ doesn't give her coffee", answer: "husband"},
      %{question: "A scholar who studies the Marquis de Sade is called a Sadian not a ____", answer: "sadist"},
      %{question: "A scholar who studies the Marquis de Sade is called a what", answer: "sadian"},
      %{question: "A scroll is the symbol for which muse", answer: "clio"},
      %{
        question: "A sea wasp can kill a human in less than a minute, answer: what kind of creature is it",
        answer: "jellyfish"
      },
      %{question: "A sea with many islands", answer: "archipelago"},
      %{
        question: "A series of 15 radioactive elements in the periodic table (periodic law) with atomic numbers 89 through 103",
        answer: "actinide series"
      },
      %{question: "A severe skin abscess or a bright red jewel", answer: "carbuncle"},
      %{question: "A shadow of a four-dimensional object would have ____ dimensions", answer: "three"},
      %{question: "A shallow dish with a cover, answer: used for science specimens is a(n) ____", answer: "petri dish"},
      %{question: "A shark must keep ____ ____ to stay alive", answer: "moving forward"},
      %{
        question: "A ship due to leave port flies a 'Blue Peter'. What does the flag look like",
        answer: "blue rectangle with a white rectangular centre"
      },
      %{question: "A ships officer in charge of equipment and crew", answer: "boatswain"},
      %{question: "A short legged hunting dog", answer: "basset"},
      %{question: "A short thick post used for securing ropes on a quay", answer: "bollard"},
      %{question: "A short womens jacket without fastenings", answer: "bolero"},
      %{question: "A short, answer: traditionally sacred choral composition", answer: "motet"},
      %{question: "A shy retiring person is known as a shrinking what", answer: "violet"},
      %{question: "A silicate mineral, answer: heat resistant and insulating", answer: "asbestos"},
      %{question: "A similar earlier event is known as a", answer: "precedent"},
      %{question: "A simple form of slide projector", answer: "image lantern"},
      %{question: "A single sheeps ____ might well contain as many as 26 million fibres", answer: "fleece"},
      %{question: "A single sheeps fleece might well contain as many as ____ million fibres", answer: "26"},
      %{
        question: "A sizable ____ tree, answer: during the typical growing season, answer: gives off 28,000 gallons of moisture",
        answer: "oak"
      },
      %{
        question: "A sizable oak tree, answer: during the typical growing season, answer: gives off ____ gallons of moisture",
        answer: "28,000"
      },
      %{question: "Geography: ____ has two official national anthems", answer: "south africa"},
      %{
        question: "Geography: ____ in southern California is the lowest point in the United States at 282 feet below sea level. The highest point in the contiguous 48 states is also in California: Mount Whitney, answer: which is 14,491 feet above sea level",
        answer: "death valley"
      },
      %{
        question: "Geography: ____ in Wyoming, answer: the world-famous, answer: nearly vertical monolith rises 1,267 feet above the Belle Fourche River. Known by several northern plains tribes as Bears Lodge, answer: it is a sacred site of worship for many American Indians. Scientists are still undecided as to what exactly caused the natural wonder, answer: although they agree that it is the remnant of an ancient volcanic feature",
        answer: "devils tower"
      },
      %{question: "Geography: ____ includes the islands of New Britain and New Ireland", answer: "papua new guinea"},
      %{
        question: "Geography: ____ is 98 percent ice, answer: 2 percent barren rock. The average thickness of the ice sheet is 7,200 feet; this amounts to 90 percent of all the ice and 70 percent of all the fresh water in the world. If the ice cap were to melt, answer: the sea level would rise by an average of 230 feet",
        answer: "antarctica"
      },
      %{
        question: "Geography: ____ is a land with a lot of big creatures - it is home to the world's largest snake (the anaconda, answer: measuring up to 35 feet in length), answer: largest spider, answer: largest rodent (the capybara, answer: a sort of guinea pig the size of a police dog), answer: and the world's largest ant",
        answer: "brazil"
      },
      %{
        question: "Geography: ____ is derived from the Indian word Bhotanta, answer: meaning \"the edge of Tibet.\"It is located in Asia near the southern fringes of the eastern Himalayas",
        answer: "bhutan"
      },
      %{
        question: "Geography: ____ is home to the world's most remote weather station. Its Eureka weather station is 600 miles from the North Pole",
        answer: "canada"
      },
      %{question: "Geography: ____ is one-quarter the size of the state of Maine", answer: "israel"},
      %{
        question: "Geography: ____ is smaller than the state of Montana (116,304 square miles and 147,138 square miles, answer: respectively)",
        answer: "italy"
      },
      %{
        question: "Geography: ____ is the birthplace of many celebrities, answer: including David Birney, answer: Blair Brown, answer: Connie Chung, answer: Matt Frewer, answer: Goldie Hawn, answer: Al Gore, answer: John Heard, answer: Edward Hermann, answer: William Hurt, answer: John F. Kennedy, answer: Jr., answer: Michael Learned, answer: Roger Mudd, answer: Maury Povich, answer: Chita Rivera, answer: Pete Sampras, answer: and Peter Tork",
        answer: "washington, answer: d.c"
      },
      %{
        question: "Geography: ____ is the first and last city in the world to operate cable cars. Almost 100 other cities around the world have had cable cars, answer: but all have discontinued use. The cable cars began operation on August 2, answer: 1873. Designed by London born engineer Andrew Hallidie, answer: the cable cars are controlled by a subterranean loop that travels at a constant 9.5 miles per hour",
        answer: "san francisco"
      },
      %{
        question: "Geography: ____ is the fourth-largest island in the world. It is approximately the same size as the state of Texas",
        answer: "madagascar"
      },
      %{
        question: "Geography: ____ is the largest country in Africa. It has a population greater than 28,100,000",
        answer: "sudan"
      },
      %{question: "Geography: ____ is the largest French-speaking city in the Western Hemisphere", answer: "montreal"},
      %{
        question: "Geography: ____ is the largest Spanish-speaking country and the second-largest Roman Catholic nation in the world",
        answer: "mexico"
      },
      %{
        question: "Geography: ____ is the largest Western European country. Its area is slightly less than twice the size of Colorado",
        answer: "france"
      },
      %{
        question: "Geography: ____ is the most densely populated non-island region in the world, answer: with more than 1,970 humans per square mile",
        answer: "bangladesh"
      },
      %{
        question: "Geography: ____ is the only Central American country not bordering the Caribbean Sea",
        answer: "el salvador"
      },
      %{
        question: "Geography: ____ is the only country in the Middle East that does not have a desert",
        answer: "lebanon"
      },
      %{
        question: "Geography: ____ is the second smallest country in the world and the principality has four distinct divisions. (1.) La Condamine, answer: the business district. (2.) The Casino or Monte Carlo. (3.) Monaco-Ville which is on a rocky promontory and (4.) Fontvieille",
        answer: "monaco"
      },
      %{
        question: "Geography: ____ is the world's largest producer of cork. The country has regulations protecting cork trees dating back to 1320. During the 1920s and 1930s, answer: it became illegal to cut down the trees other than for essential thinning and removal of older non-producing trees",
        answer: "portugal"
      },
      %{question: "Geography: ____ itself was formed by the activity of undersea volcanoes", answer: "hawaii"},
      %{question: "Geography: ____ means \"land of the free.\"", answer: "thailand"},
      %{
        question: "Geography: ____ possesses more proven oil reserves than any country outside the Middle East",
        answer: "venezuela"
      },
      %{
        question: "Geography: ____ sits on the southern coast of France, answer: near the border with Italy, answer: and covers 0.73 square miles (approximately 1/2 the size of New York's Central Park)",
        answer: "monaco"
      },
      %{
        question: "Geography: ____ use wooden \"eyeglasses\"with narrow slits for eyepieces to protect their eyes from glare reflected by ice and snow",
        answer: "eskimos"
      },
      %{
        question: "Geography: ____ was admitted to the U.N. in May 1993, answer: making it the smallest country represented there",
        answer: "monaco"
      },
      %{
        question: "Geography: ____ was called the \"Gateway to the West\"in the 1800s because it served as a starting place for wagon train departures",
        answer: "st. louis"
      },
      %{
        question: "Geography: ____ was the first American city planned for a specific purpose. It was designed by Major Pierre Charles L'Enfant, answer: to be a beautiful city with wide streets and many trees. The district was originally a 10 miles square crossing the Potomac River into Virginia. The Virginia part of the district was given back to Virginia in 1846",
        answer: "washington, answer: d.c"
      },
      %{question: "Geography: ____ was the U.S. Confederacy's largest city", answer: "new orleans"},
      %{
        question: "Geography: ____, answer: Illinois was nicknamed the Windy City because of the excessive local bragging that accompanied the Columbian Exhibition of 1893. ____ has actually been rated as only the 16th breeziest city in America",
        answer: "chicago"
      },
      %{
        question: "Geography: ____, answer: in Russia, answer: is the largest city north of the Arctic Circle",
        answer: "murmansk"
      },
      %{
        question: "Geography: ____, answer: in the eastern West Indies, answer: is one of the world's most densely populated countries",
        answer: "barbados"
      },
      %{
        question: "Geography: ____, answer: of the southern Baja Peninsula, answer: was favored by early pirates because of its safe harbors",
        answer: "los cabos"
      },
      %{question: "Geography: \"Honolulu\"means ____", answer: "sheltered harbor"},
      %{
        question: "Geography: \"Oceania\"is a name for the thousands of islands in the central and southern ____. It is sometimes referred to as the South Seas",
        answer: "pacific ocean"
      },
      %{question: "Geography: \"Utah\"is from the Navajo word meaning ____", answer: "upper"},
      %{
        question: "Geography: 300,000 Chinese troops invaded a country in February of 1979, answer: what was the country?",
        answer: "Vietnam"
      },
      %{question: "Geography: 80% of the World`s fresh water is located in what country", answer: "canada"},
      %{question: "Geography: A Bajan is an inhabitiant of which island", answer: "barbados"},
      %{question: "Geography: A federation in SE Asia occupying the northern part of Borneo", answer: "malaysia"},
      %{question: "Geography: A member of a Bantu people living chiefly in South Africa", answer: "zulu"},
      %{question: "Geography: A patent on polyester was patented first in what country?", answer: "Briton"},
      %{question: "Geography: A ridge projecting laterally from a mountain or mountain range", answer: "spur"},
      %{question: "Geography: A small violent tropical storm or cyclone in the China seas", answer: "typhoon"},
      %{
        question: "Geography: A whirlpool below ____ iced over for the first time on record, answer: on March 25, answer: 1955",
        answer: "niagara falls"
      },
      %{question: "Geography: A wide indentation in a shoreline", answer: "bight"},
      %{
        question: "Geography: About 43 million years ago, answer: the Pacific plate took a northwest turn, answer: creating a bend where new upheavals initiated the Hawaiian Ridge. Major islands formed included Kauai, answer: 5.1 million years old, answer: Maui, answer: 1.3 million years old, answer: and ____, answer: a youngster at only 800,000 years old",
        answer: "hawaii"
      },
      %{question: "Geography: Abuja is the capital of ____", answer: "Nigeria"},
      %{question: "Geography: Acadia was the original name of which Canadian province", answer: "nova scotia"},
      %{question: "Geography: Acapulco is in which country?", answer: "Mexico"},
      %{
        question: "Geography: According to ____ historian Herodotus, answer: Egyptian men never became bald. The reason for this was that, answer: as children, answer: Egyptian males had their heads shaved, answer: and their scalps were continually exposed to the health-giving rays of the sun",
        answer: "greek"
      },
      %{question: "Words: Phobias: Fear of contracting poliomyelitis", answer: "poliosophobia"},
      %{question: "Words: Phobias: Fear of cooking", answer: "mageirocophobia"},
      %{question: "Words: Phobias: Fear of cosmic phenomenon", answer: "kosmikophobia"},
      %{question: "Words: Phobias: Fear of criticism", answer: "enosiophobia"},
      %{question: "Words: Phobias: Fear of crosses or the crucifix", answer: "staurophobia"},
      %{question: "Words: Phobias: Fear of crossing bridges", answer: "gephyrophobia"},
      %{question: "Words: Phobias: Fear of crossing the street", answer: "dromophobia"},
      %{question: "Words: Phobias: Fear of crowds or mobs", answer: "ochlophobia"},
      %{question: "Words: Phobias: Fear of crowds", answer: "enochlophobia"},
      %{question: "Words: Phobias: Fear of crystals or glass", answer: "crystallophobia"},
      %{question: "Words: Phobias: Fear of dancing", answer: "chorophbia"},
      %{question: "Words: Phobias: Fear of darkness", answer: "achluophobia"},
      %{question: "Words: Phobias: Fear of death or dead things", answer: "necrophobia"},
      %{question: "Words: Phobias: Fear of dining or dinner conversations", answer: "deipnophobia"},
      %{question: "Words: Phobias: Fear of dirt or contamination", answer: "molysmophobia"},
      %{question: "Words: Phobias: Fear of dirt", answer: "rupophobia"},
      %{question: "Words: Phobias: Fear of disease", answer: "pathophobia"},
      %{question: "Words: Phobias: Fear of disorder or untidiness", answer: "ataxophobia"},
      %{question: "Words: Phobias: Fear of fog", answer: "homichlophobia"},
      %{question: "Words: Phobias: Fear of fog", answer: "nebulaphobia"},
      %{question: "Words: Phobias: Fear of food or eating", answer: "sitophbia"},
      %{question: "Words: Phobias: Fear of foreign languages", answer: "xenoglossophobia"},
      %{question: "Words: Phobias: Fear of forests", answer: "hylophobia"},
      %{question: "Words: Phobias: Fear of freedom", answer: "eleutherophobia"},
      %{question: "Words: Phobias: Fear of Friday the 13th", answer: "paraskavedekatriaphobia"},
      %{question: "Words: Phobias: Fear of frogs", answer: "ranidaphobia"},
      %{question: "Words: Phobias: Fear of fur or skins of animals", answer: "doraphobia"},
      %{question: "Words: Phobias: Fear of gaiety", answer: "cherophobia"},
      %{question: "Words: Phobias: Fear of garlic", answer: "alliumphobia"},
      %{question: "Words: Phobias: Fear of German or German things", answer: "teutophobia"},
      %{question: "Words: Phobias: Fear of germs", answer: "verminophobia"},
      %{question: "Words: Phobias: Fear of getting wrinkles", answer: "rhytiphobia"},
      %{question: "Words: Phobias: Fear of ghosts", answer: "phasmophobia"},
      %{question: "Words: Phobias: Fear of glaring lights", answer: "photoaugliaphobia"},
      %{question: "Words: Phobias: Fear of glass", answer: "nelophobia"},
      %{question: "Words: Phobias: Fear of God or gods", answer: "zeusophobia"},
      %{question: "Words: Phobias: Fear of gods or religion", answer: "theophobia"},
      %{question: "Words: Phobias: Fear of going to bed", answer: "clinophobia"},
      %{question: "Words: Phobias: Fear of going to school", answer: "didaskaleinophobia"},
      %{question: "Words: Phobias: Fear of going to the doctor or of doctors", answer: "iatrophobia"},
      %{question: "Words: Phobias: Fear of gold", answer: "aurophobia"},
      %{question: "Words: Phobias: Fear of gravity", answer: "barophobia"},
      %{question: "Words: Phobias: Fear of Greek terms or complex scientific terminology", answer: "hellenologophobia"},
      %{question: "Words: Phobias: Fear of growing old", answer: "gerascophobia"},
      %{question: "Words: Phobias: Fear of hair", answer: "chaetophobia"},
      %{question: "Words: Phobias: Fear of Halloween", answer: "samhainophobia"}
    ]
  end

end
