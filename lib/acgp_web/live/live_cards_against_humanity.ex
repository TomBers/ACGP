defmodule AcgpWeb.LiveCardsAgainstHumanity do
  use Phoenix.LiveView

  alias AcgpWeb.Presence

  defp topic(id), do: "room:#{id}"

  def mount(_something, %{"id" => room}, socket) do
    prefix = get_name()
    uid = get_id()

    name = "#{prefix}_#{uid}"

    Presence.track_presence(
      self(),
      topic(room),
      name,
      %{
        name: name,
        score: 0,
        is_card_czar: false,
      }
    )

    AcgpWeb.Endpoint.subscribe(topic(room))


    {:ok,
      assign(socket,
        room: room,
        my_name: name,
        current_guesses: [],
        answer_cards: CardsAgainstHumanity.get_answer_cards(10),
        question_card: "",
        users: Presence.list_presences(topic(room)) )}
  end

  def handle_info(%{event: "presence_diff", payload: payload}, socket) do
    {:noreply, socket |> assign(users: Presence.list_presences(topic(socket.assigns.room)))}
  end

  def handle_event("winner", %{"user" => user}, socket) do
    user_details = socket.assigns.users |> Enum.filter(fn(usr) -> usr.name == socket.assigns.my_name end) |> List.first
    Presence.update_presence(self(), topic(socket.assigns.room), socket.assigns.my_name, %{name: socket.assigns.my_name, score: user_details.score, is_card_czar: false})
    AcgpWeb.Endpoint.broadcast_from(self(), topic(socket.assigns.room), "winner", %{winner: user})

    question = CardsAgainstHumanity.get_board_card()
    AcgpWeb.Endpoint.broadcast_from(self(), topic(socket.assigns.room), "synchronize", %{question_card: question})
    {:noreply, assign(socket, question_card: question)}
  end

  def handle_info(%{event: "winner", payload: %{winner: user}}, socket) do
    if user == socket.assigns.my_name do
      user_details = socket.assigns.users |> Enum.filter(fn(usr) -> usr.name == user end) |> List.first
      Presence.update_presence(self(), topic(socket.assigns.room), socket.assigns.my_name, %{name: socket.assigns.my_name, score: user_details.score + 1, is_card_czar: true})
    end
    {:noreply, socket |> assign(current_guesses: [])}
  end

  def handle_event("answer", %{"answer" => answer, "user" => user}, socket) do
    new_guesses = [%{answer: answer, user: user} | socket.assigns.current_guesses]
    AcgpWeb.Endpoint.broadcast_from(self(), topic(socket.assigns.room), "new_guesses", %{new_guesses: new_guesses})
    {:noreply, socket |> assign(current_guesses: new_guesses)}
  end

  def handle_info(%{event: "new_guesses", payload: %{new_guesses: new_guesses}}, socket) do
    {:noreply, assign(socket, current_guesses: new_guesses)}
  end

  def handle_event("start_game", _params, socket) do
    Presence.update_presence(self(), topic(socket.assigns.room), socket.assigns.my_name, %{name: socket.assigns.my_name, score: 0, is_card_czar: true})
    question = CardsAgainstHumanity.get_board_card()
    AcgpWeb.Endpoint.broadcast_from(self(), topic(socket.assigns.room), "synchronize", %{question_card: question})
    {:noreply, assign(socket, question_card: question, card_czar: true)}
  end

  def handle_info(%{event: "synchronize", payload: %{question_card: question}}, socket) do
    {:noreply, assign(socket, question_card: question, current_guesses: [])}
  end

  def am_I_czar(my_name, users) do
    ur = users |> Enum.filter(fn(usr) -> usr.name == my_name end) |> List.first
    ur.is_card_czar
  end

  def get_name do
    ["Account","Act","Adjustment","Advertisement","Agreement","Air","Amount","Amusement","Animal","Answer","Apparatus","Approval","Argument","Art","Attack","Attempt","Attention","Attraction","Authority","Back","Balance","Base","Behavior","Belief","Birth","Bit","Bite","Blood","Blow","Body","Brass","Bread","Breath","Brother","Building","Burn","Burst","Business","Butter","Canvas","Care","Cause","Chalk","Chance","Change","Cloth","Coal","Color","Comfort","Committee","Company","Comparison","Competition","Condition","Connection","Control","Cook","Copper","Copy","Cork","Copy","Cough","Country","Cover","Crack","Credit","Crime","Crush","Cry","Current","Curve","Damage","Danger","Daughter","Day","Death","Debt","Decision","Degree","Design","Desire","Destruction","Detail","Development","Digestion","Direction","Discovery","Discussion","Disease","Disgust","Distance","Distribution","Division","Doubt","Drink","Driving","Dust","Earth","Edge","Education","Effect","End","Error","Event","Example","Exchange","Existence","Expansion","Experience","Expert","Fact","Fall","Family","Father","Fear","Feeling","Fiction","Field","Fight","Fire","Flame","Flight","Flower","Fold","Food","Force","Form","Friend","Front","Fruit","Glass","Gold","Government","Grain","Grass","Grip","Group","Growth","Guide","Harbor","Harmony","Hate","Hearing","Heat","Help","History","Hole","Hope","Hour","Humor","Ice","Idea","Impulse","Increase","Industry","Ink","Insect","Instrument","Insurance","Interest","Invention","Iron","Jelly","Join","Journey","Judge","Jump","Kick","Kiss","Knowledge","Land","Language","Laugh","Low","Lead","Learning","Leather","Letter","Level","Lift","Light","Limit","Linen","Liquid","List","Look","Loss","Love","Machine","Man","Manager","Mark","Market","Mass","Meal","Measure","Meat","Meeting","Memory","Metal","Middle","Milk","Mind","Mine","Minute","Mist","Money","Month","Morning","Mother","Motion","Mountain","Move","Music","Name","Nation","Need","News","Night","Noise","Note","Number","Observation","Offer","Oil","Operation","Opinion","Order","Organization","Ornament","Owner","Page","Pain","Paint","Paper","Part","Paste","Payment","Peace","Person","Place","Plant","Play","Pleasure","Point","Poison","Polish","Porter","Position","Powder","Power","Price","Print","Process","Produce","Profit","Property","Prose","Protest","Pull","Punishment","Purpose","Push","Quality","Question","Rain","Range","Rate","Ray","Reaction","Reading","Reason","Record","Regret","Relation","Religion","Representative","Request","Respect","Rest","Reward","Rhythm","Rice","River","Road","Roll","Room","Rub","Rule","Run","Salt","Sand","Scale","Science","Sea","Seat","Secretary","Selection","Self","Sense","Servant","Sex","Shade","Shake","Shame","Shock","Side","Sign","Silk","Silver","Sister","Size","Sky","Sleep","Slip","Slope","Smash","Smell","Smile","Smoke","Sneeze","Snow","Soap","Society","Son","Song","Sort","Sound","Soup","Space","Stage","Start","Statement","Steam","Steel","Step","Stitch","Stone","Stop","Story","Stretch","Structure","Substance","Sugar","Suggestion","Summer","Support","Surprise","Swim","System","Talk","Taste","Tax","Teaching","Tendency","Test","Theory","Thing","Thought","Thunder","Time","Tin","Top","Touch","Trade","Transport","Trick","Trouble","Turn","Twist","Unit","Use","Value","Verse","Vessel","View","Voice","Walk","War","Wash","Waste","Water","Wave","Wax","Way","Weather","Week","Weight","Wind","Wine","Winter","Woman","Wood","Wool","Word","Work","Wound","Writing","Year","Angle","Ant","Apple","Arch","Arm","Army","Baby","Bag","Ball","Band","Basin","Basket","Bath","Bed","Bee","Bell","Berry","Bird","Blade","Board","Boat","Bone","Book","Boot","Bottle","Box","Boy","Brain","Brake","Branch","Brick","Bridge","Brush","Bucket","Bulb","Button","Cake","Camera","Card","Carriage","Cart","Cat","Chain","Cheese","Chess","Chin","Church","Circle","Clock","Cloud","Coat","Collar","Comb","Cord","Cow","Cup","Curtain","Cushion","Dog","Door","Drain","Drawer","Dress","Drop","Ear","Egg","Engine","Eye","Face","Farm","Feather","Finger","Fish","Flag","Floor","Fly","Foot","Fork","Fowl","Frame","Garden","Girl","Glove","Goat","Gun","Hair","Hammer","Hand","Hat","Head","Heart","Hook","Horn","Horse","Hospital","House","Island","Jewel","Kettle","Key","Knee","Knife","Knot","Leaf","Leg","Library","Line","Lip","Lock","Map","Match","Monkey","Moon","Mouth","Muscle","Nail","Neck","Needle","Nerve","Net","Nose","Nut","Office","Orange","Oven","Parcel","Pen","Pencil","Picture","Pig","Pin","Pipe","Plane","Plate","Plough","Pocket","Pot","Potato","Prison","Pump","Rail","Rat","Receipt","Ring","Rod","Roof","Root","Sail","School","Scissors","Screw","Seed","Sheep","Shelf","Ship","Shirt","Shoe","Skin","Skirt","Snake","Sock","Spade","Sponge","Spoon","Spring","Square","Stamp","Star","Station","Stem","Stick","Stocking","Stomach","Store","Street","Sun","Table","Tail","Thread","Throat","Thumb","Ticket","Toe","Tongue","Tooth","Town","Train","Tray","Tree","Trousers","Umbrella","Wall","Watch","Wheel","Whip","Whistle","Window","Wing","Wire","Worm"]
    |> Enum.random
  end

  def get_id do
    1..1000 |> Enum.random
  end

end
