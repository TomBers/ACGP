defmodule GameUtils do
  def get_n_unique_cards(n, pick_card_fn, existing_cards \\ []) do
    1..n
    |> Enum.reduce(existing_cards, fn _x, acc -> add_unique_card(acc, pick_card_fn) end)
  end

  def add_unique_card(deck, pick_card_fn) do
    card = pick_card_fn.()

    case card in deck do
      true -> add_unique_card(deck, pick_card_fn)
      false -> [card | deck]
    end
  end

  def get_name do
    [
      "Account",
      "Act",
      "Adjustment",
      "Advertisement",
      "Agreement",
      "Air",
      "Amount",
      "Amusement",
      "Animal",
      "Answer",
      "Apparatus",
      "Approval",
      "Argument",
      "Art",
      "Attack",
      "Attempt",
      "Attention",
      "Attraction",
      "Authority",
      "Back",
      "Balance",
      "Base",
      "Behavior",
      "Belief",
      "Birth",
      "Bit",
      "Bite",
      "Blood",
      "Blow",
      "Body",
      "Brass",
      "Bread",
      "Breath",
      "Brother",
      "Building",
      "Burn",
      "Burst",
      "Business",
      "Butter",
      "Canvas",
      "Care",
      "Cause",
      "Chalk",
      "Chance",
      "Change",
      "Cloth",
      "Coal",
      "Color",
      "Comfort",
      "Committee",
      "Company",
      "Comparison",
      "Competition",
      "Condition",
      "Connection",
      "Control",
      "Cook",
      "Copper",
      "Copy",
      "Cork",
      "Copy",
      "Cough",
      "Country",
      "Cover",
      "Crack",
      "Credit",
      "Crime",
      "Crush",
      "Cry",
      "Current",
      "Curve",
      "Damage",
      "Danger",
      "Daughter",
      "Day",
      "Death",
      "Debt",
      "Decision",
      "Degree",
      "Design",
      "Desire",
      "Destruction",
      "Detail",
      "Development",
      "Digestion",
      "Direction",
      "Discovery",
      "Discussion",
      "Disease",
      "Disgust",
      "Distance",
      "Distribution",
      "Division",
      "Doubt",
      "Drink",
      "Driving",
      "Dust",
      "Earth",
      "Edge",
      "Education",
      "Effect",
      "End",
      "Error",
      "Event",
      "Example",
      "Exchange",
      "Existence",
      "Expansion",
      "Experience",
      "Expert",
      "Fact",
      "Fall",
      "Family",
      "Father",
      "Fear",
      "Feeling",
      "Fiction",
      "Field",
      "Fight",
      "Fire",
      "Flame",
      "Flight",
      "Flower",
      "Fold",
      "Food",
      "Force",
      "Form",
      "Friend",
      "Front",
      "Fruit",
      "Glass",
      "Gold",
      "Government",
      "Grain",
      "Grass",
      "Grip",
      "Group",
      "Growth",
      "Guide",
      "Harbor",
      "Harmony",
      "Hate",
      "Hearing",
      "Heat",
      "Help",
      "History",
      "Hole",
      "Hope",
      "Hour",
      "Humor",
      "Ice",
      "Idea",
      "Impulse",
      "Increase",
      "Industry",
      "Ink",
      "Insect",
      "Instrument",
      "Insurance",
      "Interest",
      "Invention",
      "Iron",
      "Jelly",
      "Join",
      "Journey",
      "Judge",
      "Jump",
      "Kick",
      "Kiss",
      "Knowledge",
      "Land",
      "Language",
      "Laugh",
      "Low",
      "Lead",
      "Learning",
      "Leather",
      "Letter",
      "Level",
      "Lift",
      "Light",
      "Limit",
      "Linen",
      "Liquid",
      "List",
      "Look",
      "Loss",
      "Love",
      "Machine",
      "Man",
      "Manager",
      "Mark",
      "Market",
      "Mass",
      "Meal",
      "Measure",
      "Meat",
      "Meeting",
      "Memory",
      "Metal",
      "Middle",
      "Milk",
      "Mind",
      "Mine",
      "Minute",
      "Mist",
      "Money",
      "Month",
      "Morning",
      "Mother",
      "Motion",
      "Mountain",
      "Move",
      "Music",
      "Name",
      "Nation",
      "Need",
      "News",
      "Night",
      "Noise",
      "Note",
      "Number",
      "Observation",
      "Offer",
      "Oil",
      "Operation",
      "Opinion",
      "Order",
      "Organization",
      "Ornament",
      "Owner",
      "Page",
      "Pain",
      "Paint",
      "Paper",
      "Part",
      "Paste",
      "Payment",
      "Peace",
      "Person",
      "Place",
      "Plant",
      "Play",
      "Pleasure",
      "Point",
      "Poison",
      "Polish",
      "Porter",
      "Position",
      "Powder",
      "Power",
      "Price",
      "Print",
      "Process",
      "Produce",
      "Profit",
      "Property",
      "Prose",
      "Protest",
      "Pull",
      "Punishment",
      "Purpose",
      "Push",
      "Quality",
      "Question",
      "Rain",
      "Range",
      "Rate",
      "Ray",
      "Reaction",
      "Reading",
      "Reason",
      "Record",
      "Regret",
      "Relation",
      "Religion",
      "Representative",
      "Request",
      "Respect",
      "Rest",
      "Reward",
      "Rhythm",
      "Rice",
      "River",
      "Road",
      "Roll",
      "Room",
      "Rub",
      "Rule",
      "Run",
      "Salt",
      "Sand",
      "Scale",
      "Science",
      "Sea",
      "Seat",
      "Secretary",
      "Selection",
      "Self",
      "Sense",
      "Servant",
      "Sex",
      "Shade",
      "Shake",
      "Shame",
      "Shock",
      "Side",
      "Sign",
      "Silk",
      "Silver",
      "Sister",
      "Size",
      "Sky",
      "Sleep",
      "Slip",
      "Slope",
      "Smash",
      "Smell",
      "Smile",
      "Smoke",
      "Sneeze",
      "Snow",
      "Soap",
      "Society",
      "Son",
      "Song",
      "Sort",
      "Sound",
      "Soup",
      "Space",
      "Stage",
      "Start",
      "Statement",
      "Steam",
      "Steel",
      "Step",
      "Stitch",
      "Stone",
      "Stop",
      "Story",
      "Stretch",
      "Structure",
      "Substance",
      "Sugar",
      "Suggestion",
      "Summer",
      "Support",
      "Surprise",
      "Swim",
      "System",
      "Talk",
      "Taste",
      "Tax",
      "Teaching",
      "Tendency",
      "Test",
      "Theory",
      "Thing",
      "Thought",
      "Thunder",
      "Time",
      "Tin",
      "Top",
      "Touch",
      "Trade",
      "Transport",
      "Trick",
      "Trouble",
      "Turn",
      "Twist",
      "Unit",
      "Use",
      "Value",
      "Verse",
      "Vessel",
      "View",
      "Voice",
      "Walk",
      "War",
      "Wash",
      "Waste",
      "Water",
      "Wave",
      "Wax",
      "Way",
      "Weather",
      "Week",
      "Weight",
      "Wind",
      "Wine",
      "Winter",
      "Woman",
      "Wood",
      "Wool",
      "Word",
      "Work",
      "Wound",
      "Writing",
      "Year",
      "Angle",
      "Ant",
      "Apple",
      "Arch",
      "Arm",
      "Army",
      "Baby",
      "Bag",
      "Ball",
      "Band",
      "Basin",
      "Basket",
      "Bath",
      "Bed",
      "Bee",
      "Bell",
      "Berry",
      "Bird",
      "Blade",
      "Board",
      "Boat",
      "Bone",
      "Book",
      "Boot",
      "Bottle",
      "Box",
      "Boy",
      "Brain",
      "Brake",
      "Branch",
      "Brick",
      "Bridge",
      "Brush",
      "Bucket",
      "Bulb",
      "Button",
      "Cake",
      "Camera",
      "Card",
      "Carriage",
      "Cart",
      "Cat",
      "Chain",
      "Cheese",
      "Chess",
      "Chin",
      "Church",
      "Circle",
      "Clock",
      "Cloud",
      "Coat",
      "Collar",
      "Comb",
      "Cord",
      "Cow",
      "Cup",
      "Curtain",
      "Cushion",
      "Dog",
      "Door",
      "Drain",
      "Drawer",
      "Dress",
      "Drop",
      "Ear",
      "Egg",
      "Engine",
      "Eye",
      "Face",
      "Farm",
      "Feather",
      "Finger",
      "Fish",
      "Flag",
      "Floor",
      "Fly",
      "Foot",
      "Fork",
      "Fowl",
      "Frame",
      "Garden",
      "Girl",
      "Glove",
      "Goat",
      "Gun",
      "Hair",
      "Hammer",
      "Hand",
      "Hat",
      "Head",
      "Heart",
      "Hook",
      "Horn",
      "Horse",
      "Hospital",
      "House",
      "Island",
      "Jewel",
      "Kettle",
      "Key",
      "Knee",
      "Knife",
      "Knot",
      "Leaf",
      "Leg",
      "Library",
      "Line",
      "Lip",
      "Lock",
      "Map",
      "Match",
      "Monkey",
      "Moon",
      "Mouth",
      "Muscle",
      "Nail",
      "Neck",
      "Needle",
      "Nerve",
      "Net",
      "Nose",
      "Nut",
      "Office",
      "Orange",
      "Oven",
      "Parcel",
      "Pen",
      "Pencil",
      "Picture",
      "Pig",
      "Pin",
      "Pipe",
      "Plane",
      "Plate",
      "Plough",
      "Pocket",
      "Pot",
      "Potato",
      "Prison",
      "Pump",
      "Rail",
      "Rat",
      "Receipt",
      "Ring",
      "Rod",
      "Roof",
      "Root",
      "Sail",
      "School",
      "Scissors",
      "Screw",
      "Seed",
      "Sheep",
      "Shelf",
      "Ship",
      "Shirt",
      "Shoe",
      "Skin",
      "Skirt",
      "Snake",
      "Sock",
      "Spade",
      "Sponge",
      "Spoon",
      "Spring",
      "Square",
      "Stamp",
      "Star",
      "Station",
      "Stem",
      "Stick",
      "Stocking",
      "Stomach",
      "Store",
      "Street",
      "Sun",
      "Table",
      "Tail",
      "Thread",
      "Throat",
      "Thumb",
      "Ticket",
      "Toe",
      "Tongue",
      "Tooth",
      "Town",
      "Train",
      "Tray",
      "Tree",
      "Trousers",
      "Umbrella",
      "Wall",
      "Watch",
      "Wheel",
      "Whip",
      "Whistle",
      "Window",
      "Wing",
      "Wire",
      "Worm"
    ]
    |> Enum.random()
  end

  def get_id do
    1..1000 |> Enum.random()
  end

  def has_answered(usr, game_state) when is_map(usr) do
    Enum.any?(game_state.answered, fn ans -> ans.user == usr.name end)
  end

  def has_answered(usr, game_state) do
    Enum.any?(game_state.answered, fn ans -> ans.name == usr end)
  end

  def current_answer(user, game_state, category) do
    my_answers =
      game_state.answered
      |> Enum.find(%{answered: %{}}, fn ele -> ele.name == user end)

    ans = Map.get(my_answers.answered, category, "")
    ans
  end

  def is_active_user(nil, game_state) do
    false
  end

  def is_active_user(usr, game_state) when is_map(usr) do
    game_state.active_user == usr.name
  end

  def is_active_user(usr, game_state) do
    game_state.active_user == usr
  end

  def score(game_state, user) do
    Map.get(game_state.scores, user, 0)
  end
end
