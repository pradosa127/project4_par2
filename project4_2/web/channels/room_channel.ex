defmodule Chat.RoomChannel do
  use Phoenix.Channel
  require Logger

  @doc """
  Authorize socket to subscribe and broadcast events on this channel & topic

  Possible Return Values

  `{:ok, socket}` to authorize subscription for channel for requested topic

  `:ignore` to deny subscription/broadcast on this channel
  for the requested topic
  """
  def join("rooms:lobby", message, socket) do
    Process.flag(:trap_exit, true)
    # :timer.send_interval(5000, :ping)
    send(self, {:after_join, message})
    
   
    # send(self, {:tweet, message})
    IO.inspect "in join******"
    IO.inspect message
    socket = assign(socket,:ID, message["userID"])
    socket = assign(socket,:state,message["state"])
    socket = assign(socket,:nUser,message["nUsers"])
    :timer.send_interval(100, {:tweet})
    :timer.send_interval(100, {:searchHashTagOrMentions})
    :timer.send_interval(100, {:changeState})
    {:ok, socket}
  end

  def join("rooms:" <> _private_subtopic, _message, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_info({:after_join, msg}, socket) do
    broadcast! socket, "user:entered", %{user: msg["user"]}
    push socket, "join", %{status: "connected"}
    {:noreply, socket}
  end
  def handle_info(:ping, socket) do
    # push socket, "new:msg", %{user: "SYSTEM", body: "ping"}
    # str = GenServer.call :genMain,{:hello}
    #broadcast socket, "new:msg", %{user: "SYSTEM", body: "ping"}
    {:noreply, socket}
  end




  def handle_info({:tweet}, socket) do
    if socket.assigns[:state]==1 do
      tweetMsg = tweetMsgGenerator(100)
      userId=socket.assigns[:ID]
      GenServer.cast :gen_main,{:tweet, tweetMsg, userId, "tweet"}
      # IO.puts "tweeting"
    else
      # IO.puts "cnt tweet"  
    end
    {:noreply, socket}
  end

  def tweetMsgGenerator(nUsers) do
    if(nUsers>10) do
        #IO.puts "#{:rand.uniform(10)}"
        Enum.join(["#Hashtag",  :rand.uniform(10), " ", "@user", :rand.uniform(10)])
    else
        Enum.join(["#Hashtag",  :rand.uniform(nUsers), " ", "@user", :rand.uniform(nUsers)])
    end
  end 

  def handle_info({:searchHashTagOrMentions},socket) do
    # IO.puts "sendRepeatedTweets #{userId}"
    if socket.assigns[:state]==1 do
      list=[Enum.join(["#Hashtag",:rand.uniform(10)]),Enum.join(["@user",:rand.uniform(10)])]
      hashTagOrMention =Enum.at(list,:rand.uniform(2)-1)
      searchresult=GenServer.call :gen_main,{:searchHashTag, hashTagOrMention}
      # IO.inspect socket.assigns[:state]
      # GenServer.cast serverId,{:updateNoSearch}
    else  
      # IO.puts "cnt performsearch"
    end  
    {:noreply, socket}
  end

  def handle_info({:changeState},socket) do
    if socket.assigns[:state]==1 do
      socket=assign(socket,:state,0)
      GenServer.cast :gen_main,{:updateNoofdisconn,0}
    else
      socket=assign(socket,:state,1)  
      GenServer.cast :gen_main,{:updateNoofdisconn,1}
    end
      # IO.inspect socket.assigns[:state]
    {:noreply, socket}
  end


#   def handle_info(:changeState, [userId, tweetQueue, nUsers, retweetCount, followerMapSize, displayInterval, state,serverId]) do
#     #IO.puts "beforestate:: #{state}"
#       schedule(displayInterval+10)
#       if state == 0 do 
#            state=1
#           #  IO.puts "User#{userId} woke up"
#            newTweetQ = GenServer.call serverId, {:getTweetQ, userId}
#            GenServer.cast serverId,{:updateNoofDisconn,1}
#           #  if(newTweetQ==nil)do
#           #   IO.puts "nil fonksdakv.csdaadsfefhe.lkjfqelkf"
#           #   System.halt(0)
#           #  end
#       # IO.puts "#{inspect newTweetQ}"
#       else
#            state=0
#            GenServer.cast serverId,{:updateNoofDisconn,0}

#           #  IO.puts "User#{userId} sleeping"
#       end
#     #IO.puts "afterstate #{state}"
#     {:noreply,  [userId, newTweetQ, nUsers, retweetCount, followerMapSize, displayInterval, state,serverId]}
# end


  def terminate(reason, _socket) do
    Logger.debug"> leave #{inspect reason}"
    :ok
  end

  def handle_in("new:msg", msg, socket) do
    IO.puts "pradosa"
    IO.inspect msg["user"]
    {totalTweetCnt,reTweetcnt,searchCount,noOfdisConn}=GenServer.call :gen_main,{:diplaySimulatorOP}
    IO.inspect "#{totalTweetCnt}"
    broadcast! socket, "new:msg", %{user: msg["user"], body: msg["body"]}
    {:reply, {:ok, %{msg: msg["body"]}}, assign(socket, :user, msg["user"])}
  end



end
